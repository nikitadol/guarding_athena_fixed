if Task == nil then
	---@module Task
	Task = class({})
end
local public = Task

function public:init(bReload)
	if not bReload then
		---@type table<number, PlayerTask>
		self.tPlayerTasks = {}
		---@type table<string, CDOTA_BaseNPC>
		self.tTaskNpc = {}

		---@class PlayerTask 玩家任务数据结构
		---@field tInProgress table<string, InProgressTask> 进行中的任务
		---@field tComplete table<string, boolean> 完成的任务
		--
		---@class InProgressTask 进行中的任务
		---@field tStageProgress table<string, number> 完成情况
		--
		---@class TaskData 任务数据结构
		---@field UnlockType string 解锁类型
		---@field UnlockName string 解锁名
		---@field TaskStage table<string, TaskStageData> 任务需求
		---@field TaskReward table<string, TaskRewardData> 任务奖励
		---@field AutoComplete string 自动完成
		--
		---@class TaskStageData 任务需求数据结构
		---@field TaskStageType string 需求类型
		---@field TaskStageTarget string 需求目标
		---@field TaskStageCount string 需求数量
		---@field TaskPosition string 可选目标位置例如：6656,-6464,393
		--
		---@class TaskRewardData 任务奖励数据结构
		---@field TaskRewardType string 奖励类型
		---@field TaskRewardName string 奖励内容
	end

	NPC.tNPCs = {}
	NPC:UpdateNetTables()
	for sUnitName, tUnitData in pairs(KeyValues.NpcTaskKv) do
		if self.tTaskNpc[sUnitName] == nil then
			local hSpawnEnt = Entities:FindByName(nil, "npc_" .. sUnitName)
			if IsValid(hSpawnEnt) then
				local hNPC = NPC:CreateNPC(sUnitName, hSpawnEnt:GetAbsOrigin(), -1)
				if IsValid(hNPC) then
					hNPC:SetForwardVector(hSpawnEnt:GetForwardVector())
					hNPC:ChangeTeam(DOTA_TEAM_GOODGUYS)
					self.tTaskNpc[sUnitName] = hNPC
				end
			end
		else
			self.tTaskNpc[sUnitName]:RemoveSelf()
			local hSpawnEnt = Entities:FindByName(nil, "npc_" .. sUnitName)
			if IsValid(hSpawnEnt) then
				local hNPC = NPC:CreateNPC(sUnitName, hSpawnEnt:GetAbsOrigin(), -1)
				if IsValid(hNPC) then
					hNPC:SetForwardVector(hSpawnEnt:GetForwardVector())
					hNPC:ChangeTeam(DOTA_TEAM_GOODGUYS)
					self.tTaskNpc[sUnitName] = hNPC
				end
			end
		end
	end
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("dota_item_picked_up", Dynamic_Wrap(public, "OnItemPickedUp"), public)
	GameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), public)
	CustomUIEvent("task_remove", Dynamic_Wrap(public, "OnTaskRemove"), public)
	CustomUIEvent("task_mark", Dynamic_Wrap(public, "OnTaskMark"), public)
end
---@private
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("common", "player_tasks", self.tPlayerTasks)
end

---开始一个任务
function public:StartTask(iPlayerID, sTaskName)
	if Task:GetPlayerTaskState(iPlayerID, sTaskName) == TASK_STATE_TYPE_RECEIVED then
		Task:RemoveTask(iPlayerID, sTaskName)
	end
	if Task:GetPlayerTaskState(iPlayerID, sTaskName) == TASK_STATE_TYPE_NONE then
		if self.tPlayerTasks[iPlayerID] == nil then
			self.tPlayerTasks[iPlayerID] = {
				tInProgress = {},
				tComplete = {}
			}
		end
		local tTaskInfo = self:GetTaskInfo(sTaskName)
		if tTaskInfo.AutoComplete ~= 1 then
			Notification:CombatToPlayer(iPlayerID, {
				message = "Combat_StartTask",
				string_taskname = "TaskTitle_" .. sTaskName
			})
		end
		local tPlayerTask = {
			tStageProgress = {}
		}
		-- 初始化数量
		if tTaskInfo.TaskStage then
			for sIndex, tTaskStageInfo in pairs(tTaskInfo.TaskStage) do
				tPlayerTask.tStageProgress[sIndex] = 0
				-- 小地图标记
				if tTaskStageInfo.TaskPosition then
					local vPosition = Game:GetOriginByString(tTaskStageInfo.TaskPosition)
					GameRules:ExecuteTeamPing(DOTA_TEAM_GOODGUYS, vPosition.x, vPosition.y, nil, 0)
					local iParticleID = ParticleManager:CreateParticle("particles/ui_mouseactions/international2020/ping_world_questionmarks.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
					ParticleManager:SetParticleControl(iParticleID, 7, Vector(1, 0.7, 0))
					ParticleManager:ReleaseParticleIndex(iParticleID)
				end
			end
		end
		self.tPlayerTasks[iPlayerID].tInProgress[sTaskName] = tPlayerTask
		-- table.insert(self.tPlayerTasks[iPlayerID].tInProgress, tPlayerTask)
		self:UpdateNetTables()
	end
end
---完成任务
function public:FinishTask(iPlayerID, sTaskName)
	self.tPlayerTasks[iPlayerID].tInProgress[sTaskName] = nil
	self.tPlayerTasks[iPlayerID].tComplete[sTaskName] = TASK_STATE_TYPE_FINISH
end
---给予任务奖励
function public:GiveTaskRewards(iPlayerID, sTaskName)
	local tTaskInfo = self:GetTaskInfo(sTaskName)
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	self.tPlayerTasks[iPlayerID].tComplete[sTaskName] = TASK_STATE_TYPE_RECEIVED
	if tTaskInfo.TaskReward then
		for sIndex, tTaskRewardInfo in pairs(tTaskInfo.TaskReward) do
			local sName = tTaskRewardInfo.TaskRewardName
			local funcEachReward = function(func)
				sName = string.gsub(sName, "%s", "")
				local a = string.split(sName, "|")
				for k, _s in pairs(a) do
					local _a = string.split(_s, ",")
					local sRewardName = _a[1]
					local iAmount = tonumber(_a[2]) or 1
					if func(sRewardName, iAmount) == true then
						return true
					end
				end
			end
			if _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_ITEM then
				funcEachReward(function(sRewardName, iAmount)
					for i = 1, iAmount, 1 do
						local sItemName = Game:GetRandomItemNameByName(sRewardName)
						if sItemName then
							Notification:Combat({
								message = "TaskRewardItem",
								player_id = iPlayerID,
								string_taskname = "TaskTitle_" .. sTaskName,
								string_itemname = sItemName,
							})

							local hItem = CreateItem(sItemName, nil, hHero)
							if IsValid(hItem) and not Items:TryGiveItem(hHero, hItem) then
								Items:DropItem(iPlayerID, hItem, hHero:GetAbsOrigin())
							end
						end
					end
				end)
			elseif _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_SCEPTER then
				hHero:AddItemByName("item_" .. hHero:GetUnitName())
			elseif _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_REBORN then
				if hHero:HasModifier("modifier_reborn") then
					local hModifier = hHero:FindModifierByName("modifier_reborn")
					hModifier:SetStackCount(math.min(4, hModifier:GetStackCount() + 1))
				else
					if hHero:IsAlive() then
						hHero:AddNewModifier(hHero, nil, "modifier_reborn", nil)
					else
						hHero:GameTimer(hHero:GetRespawnTime() + 1, function()
							hHero:AddNewModifier(hHero, nil, "modifier_reborn", nil)
						end)
					end
				end
				if hHero._RebornParticle then
					ParticleManager:DestroyParticle(hHero._RebornParticle, false)
					hHero._RebornParticle = nil
				end
				local hRelay = Entities:FindByName(nil, "gate_demon_relay")
				hRelay:Trigger(hRelay, hHero)
				hHero:EmitSound("Hero_FacelessVoid.TimeWalk")
				if hHero:GetUnitName() == "npc_dota_hero_monkey_king" then
					hHero:SetSkin(hModifier:GetStackCount())
					local hModel = hHero:FirstMoveChild()
					while hModel ~= nil do
						if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() == "models/items/monkey_king/monkey_king_arcana_head/mesh/monkey_king_arcana.vmdl" then
							hModel:SetSkin(hModifier:GetStackCount())
							break
						end
						hModel = hModel:NextMovePeer()
					end
				end
			elseif _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_ATTRIBUTE then
				funcEachReward(function(sRewardName, iAmount)
					hHero:AddPermanentAttribute(sRewardName, iAmount)
				end)
			elseif _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_RESOURCE then
				funcEachReward(function(sRewardName, iAmount)
					if _G[sRewardName] == CUSTOM_RESOURCE_TYPE_GOLD then
						PlayerData:ModifyGold(iPlayerID, iAmount)
					elseif _G[sRewardName] == CUSTOM_RESOURCE_TYPE_CRYSTAL then
						PlayerData:ModifyCrystal(iPlayerID, iAmount)
					elseif _G[sRewardName] == CUSTOM_RESOURCE_TYPE_SCORE then
						PlayerData:ModifyScore(iPlayerID, iAmount)
					elseif _G[sRewardName] == CUSTOM_RESOURCE_TYPE_EXP then
						hHero:AddExperience(iAmount, DOTA_ModifyXP_Unspecified, false, false)
					else
						hHero:AddPermanentAttribute(sRewardName, iAmount)
					end
				end)
			elseif _G[tTaskRewardInfo.TaskRewardType] == TASK_REWARD_TYPE_MODIFIER then
				funcEachReward(function(sRewardName, iAmount)
					hHero:AddNewModifier(hHero, hHero:GetDummyAbility(), sRewardName, nil)
				end)
			end
		end
	end
	self:UpdateNetTables()
end
---检查并给予任务阶段进度
function public:CheckTaskStageProgress(iPlayerID, iStageType, sStageTarget, iChanged)
	if iPlayerID ~= -1 and PlayerResource:IsValidPlayerID(iPlayerID) then
		local tPlayerTasks = self.tPlayerTasks[iPlayerID]
		if type(tPlayerTasks) == "table" then
			for sTaskName, tPlayerTask in pairs(tPlayerTasks.tInProgress) do
				local bAllFinished = true
				local tTaskInfo = self:GetTaskInfo(sTaskName)
				if tTaskInfo.TaskStage then
					for sIndex, tTaskStageInfo in pairs(tTaskInfo.TaskStage) do
						if _G[tTaskStageInfo.TaskStageType] == iStageType and string.find(sStageTarget, tTaskStageInfo.TaskStageTarget) then
							tPlayerTask.tStageProgress[sIndex] = math.min(tPlayerTask.tStageProgress[sIndex] + iChanged, tTaskStageInfo.TaskStageCount)
						end
						if tPlayerTask.tStageProgress[sIndex] < tTaskStageInfo.TaskStageCount then
							bAllFinished = false
						end
					end
				end
				if bAllFinished then
					self:FinishTask(iPlayerID, sTaskName)
					if tTaskInfo.AutoComplete == 1 then
						GameTimer(2, function()
							self:GiveTaskRewards(iPlayerID, sTaskName)
						end)
					end
				end
			end
		end
		self:UpdateNetTables()
	end
end
---获取任务状态
function public:GetPlayerTaskState(iPlayerID, sTaskName)
	local iState = TASK_STATE_TYPE_NONE
	if iPlayerID ~= -1 and PlayerResource:IsValidPlayerID(iPlayerID) then
		local tPlayerTasks = self.tPlayerTasks[iPlayerID]
		if type(tPlayerTasks) == "table" then
			for _sTaskName, tPlayerTask in pairs(tPlayerTasks.tInProgress) do
				if _sTaskName == sTaskName then
					iState = TASK_STATE_TYPE_PROGRESS
					break
				end
			end
			for _sTaskName, _iState in pairs(tPlayerTasks.tComplete) do
				if _sTaskName == sTaskName then
					iState = _iState
					break
				end
			end
		end
	end
	local tTaskInfo = self:GetTaskInfo(sTaskName)
	if tTaskInfo.UnlockType and _G[tTaskInfo.UnlockType] == TASK_UNLOCK_TYPE_TASK and self:GetPlayerTaskState(iPlayerID, tTaskInfo.UnlockName) ~= TASK_STATE_TYPE_RECEIVED then
		iState = TASK_STATE_TYPE_LOCK
	end
	return iState
end
---获取任务数据
---@return TaskData
function public:GetTaskInfo(sTaskName)
	return KeyValues.TasksKv[sTaskName]
end
---移除任务
---@return TaskData
function public:RemoveTask(iPlayerID, sTaskName)
	self.tPlayerTasks[iPlayerID].tInProgress[sTaskName] = nil
	self.tPlayerTasks[iPlayerID].tComplete[sTaskName] = nil
	self:UpdateNetTables()
end

--------------------------------------------------------------------------------
-- 监听
--------------------------------------------------------------------------------
function public:OnEntityKilled(tEvents)
	local hKilledUnit = EntIndexToHScript(tEvents.entindex_killed)
	if not IsValid(hKilledUnit) then return end

	local hKiller = EntIndexToHScript(tEvents.entindex_attacker or -1)
	if IsValid(hKiller) then
		local iPlayerID = hKiller:GetPlayerOwnerID()
		if iPlayerID then
			self:CheckTaskStageProgress(iPlayerID, TASK_STAGE_TYPE_KILL, hKilledUnit:GetUnitName(), 1)
		end
	end
end

function public:OnItemPickedUp(tEvents)
	local iPlayerID = tEvents.PlayerID
	local sItemName = tEvents.itemname
	if type(KeyValues.ItemsKv[sItemName]) == "table" then
		self:CheckTaskStageProgress(iPlayerID, "TASK_STAGE_TYPE_PICK", sItemName, 1)
	end
end

function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_HERO_SELECTION then

	end
	if iState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for sUnitName, tUnitData in pairs(KeyValues.NpcTaskKv) do
			if self.tTaskNpc[sUnitName] == nil then
				local hSpawnEnt = Entities:FindByName(nil, "npc_" .. sUnitName)
				if IsValid(hSpawnEnt) then
					local hNPC = NPC:CreateNPC(sUnitName, hSpawnEnt:GetAbsOrigin(), -1)
					if IsValid(hNPC) then
						hNPC:SetForwardVector(hSpawnEnt:GetForwardVector())
						hNPC:ChangeTeam(DOTA_TEAM_GOODGUYS)
						self.tTaskNpc[sUnitName] = hNPC
					end
				end
			else
				self.tTaskNpc[sUnitName]:RemoveSelf()
				local hSpawnEnt = Entities:FindByName(nil, "npc_" .. sUnitName)
				if IsValid(hSpawnEnt) then
					local hNPC = NPC:CreateNPC(sUnitName, hSpawnEnt:GetAbsOrigin(), -1)
					if IsValid(hNPC) then
						hNPC:SetForwardVector(hSpawnEnt:GetForwardVector())
						hNPC:ChangeTeam(DOTA_TEAM_GOODGUYS)
						self.tTaskNpc[sUnitName] = hNPC
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------
-- UI事件
--------------------------------------------------------------------------------
function public:OnTaskRemove(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	self:RemoveTask(iPlayerID, tEvents.taskname)
end
function public:OnTaskMark(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local sTaskName = tEvents.taskname
	local tTaskInfo = self:GetTaskInfo(sTaskName)
	-- 初始化数量
	if tTaskInfo.TaskStage then
		for sIndex, tTaskStageInfo in pairs(tTaskInfo.TaskStage) do
			if tTaskStageInfo.TaskPosition then
				local vPosition = Game:GetOriginByString(tTaskStageInfo.TaskPosition)
				GameRules:ExecuteTeamPing(DOTA_TEAM_GOODGUYS, vPosition.x, vPosition.y, nil, 0)
				local iParticleID = ParticleManager:CreateParticle("particles/ui_mouseactions/international2020/ping_world_questionmarks.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
				ParticleManager:SetParticleControl(iParticleID, 7, Vector(1, 0.7, 0))
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
	end
end
return public