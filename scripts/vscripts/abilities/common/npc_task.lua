---@class npc_task: eom_ability
npc_task = eom_ability({})
function npc_task:GetIntrinsicModifierName()
	return "modifier_npc_task"
end
function npc_task:QueryTask(hUnit)
	if self.tTaskList and #self.tTaskList > 0 then
		local iPlayerID = hUnit:GetPlayerOwnerID()
		if iPlayerID ~= -1 and PlayerResource:IsValidPlayerID(iPlayerID) and hUnit:IsRealHero() then
			local bNoTask = true
			for i = 1, #self.tTaskList do
				local tTaskData = self.tTaskList[i]
				local sTaskName = tTaskData
				local bRepeat = false
				if type(sTaskName) == "table" then
					bRepeat = tTaskData.bRepeat
					sTaskName = tTaskData.sTaskName
				end
				local iState = Task:GetPlayerTaskState(iPlayerID, sTaskName)
				if iState == TASK_STATE_TYPE_NONE then
					Task:StartTask(iPlayerID, sTaskName)
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "display_dialog", { entindex = self:GetCaster():entindex(), text = ("TaskDialog_" .. sTaskName .. "_Accept") })
					bNoTask = false
					break
				elseif iState == TASK_STATE_TYPE_PROGRESS then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "display_dialog", { entindex = self:GetCaster():entindex(), text = ("TaskDialog_" .. sTaskName .. "_Inprogress") })
					bNoTask = false
					break
				elseif iState == TASK_STATE_TYPE_FINISH then
					-- 领取奖励
					Task:GiveTaskRewards(iPlayerID, sTaskName)
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "display_dialog", { entindex = self:GetCaster():entindex(), text = ("TaskDialog_" .. sTaskName .. "_Finish") })
					if bRepeat then
						Task:RemoveTask(iPlayerID, sTaskName)
					end
					bNoTask = false
					break
				elseif iState == TASK_STATE_TYPE_RECEIVED then
					-- 遍历下一个
				elseif iState == TASK_STATE_TYPE_LOCK then
					-- 遍历下一个
				end
			end
			if bNoTask then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "display_dialog", { entindex = self:GetCaster():entindex(), text = ("TaskDialog_NoTask") })
			end
			local bRemoveMark = true
			for i = #self.tTaskList, 1, -1 do
				local tTaskData = self.tTaskList[i]
				local sTaskName = tTaskData
				local bRepeat = false
				if type(sTaskName) == "table" then
					bRepeat = tTaskData.bRepeat
					sTaskName = tTaskData.sTaskName
				end
				local iState = Task:GetPlayerTaskState(iPlayerID, sTaskName)
				if iState ~= TASK_STATE_TYPE_RECEIVED then
					bRemoveMark = false
				else
					if bRepeat then
						bRemoveMark = false
					end
				end
			end
			if bRemoveMark then
				ParticleManager:DestroyParticle(self:GetCaster():FindModifierByName("modifier_npc_task").iParticleID, false)
			end
		end
	end
end

---@class npc_task_bh: eom_ability 赏金任务
npc_task_bh = eom_ability({
	tTaskList = {
		"KillKoboldLord",
		"KillHellBeast",
		"KillAcientGolem",
	}
}, nil, npc_task)

---@class npc_task_cuihua: eom_ability 翠花任务
npc_task_cuihua = eom_ability({
	tTaskList = {
		"KillFireDemon",
	}
}, nil, npc_task)

---@class npc_task_bajie: eom_ability 八戒任务
npc_task_bajie = eom_ability({
	tTaskList = {
		"Trial",
	}
}, nil, npc_task)

---@class npc_task_bearzky: eom_ability 熊战士任务
npc_task_bearzky = eom_ability({
	tTaskList = {
		"Bearzky_Zombie",
		"Bearzky_SandKing",
	}
}, nil, npc_task)

---@class npc_task_beaverknight: eom_ability 海狸骑士任务
npc_task_beaverknight = eom_ability({
	tTaskList = {
		{ sTaskName = "Beaverknight_Ogre", bRepeat = true },
	}
}, nil, npc_task)
----------------------------------------Modifier----------------------------------------
---@class modifier_npc_task : eom_modifier
modifier_npc_task = eom_modifier({
	Name = "modifier_npc_task",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_npc_task:GetAuraRadius()
	return 400
end
function modifier_npc_task:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_npc_task:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
function modifier_npc_task:OnCreated()
	if IsServer() then
		self.iParticleID = ParticleManager:CreateParticle("particles/map/quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_npc_task_buff : eom_modifier
modifier_npc_task_buff = eom_modifier({
	Name = "modifier_npc_task_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_npc_task_buff:OnCreated(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		hAbility:QueryTask(self:GetParent())
	end
end