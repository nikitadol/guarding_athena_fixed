if NeutralSpawners == nil then
	---中立刷怪器
	---@module NeutralSpawners
	---@field tSpawnerData NeutralSpawnerUnit[] 刷新数据表
	---@field tUnitList table<number, number> 怪物列表，key为单位index，value为单位来源tSpawnerData表的索引
	NeutralSpawners = class({})

	---@class NeutralSpawnerUnit 单位数据
	---@field sNPCClassName string 单位名
	---@field fWaitForTime number 等待时间
	---@field fEliteChance number 精英几率
	---@field sEliteName number 精英名
	---@field iTotalUnitsToSpawn number 总计刷新数量
	---@field fSpawnInterval number 刷新间隔
	---@field sSpawnerName string 刷新位置
	---@field fSpawnOffset number 刷新随机偏移半径
	---@field vForwardVector Vector 面向
	---@field bGrowUp boolean 是否成长
	---@field iLevel number 当前等级
	---@field tUnitRemaining table 记录刷出的单位
	---@field fNextSpawnTime number | nil
end
local public = NeutralSpawners

function public:init(bReload)
	if not bReload then
		self.tUnitList = {}
		self.tSpawnerData = {}
		for sNeutralSpawnerName, tData in pairs(KeyValues.NeutralSpawnersKvs) do
			local t = {}
			for k, v in pairs(tData) do
				if type(v) == "table" and v.NPCName then
					local tData = {
						sNPCClassName = v.NPCName or "",
						fWaitForTime = tonumber(v.WaitForTime) or 0,
						fEliteChance = tonumber(v.EliteChance) or 0,
						sEliteName = v.EliteName or "",
						iTotalUnitsToSpawn = tonumber(v.TotalUnitsToSpawn) or 0,
						fSpawnInterval = tonumber(v.SpawnInterval) or 0,
						sSpawnerName = v.SpawnerName or "",
						fSpawnOffset = tonumber(v.SpawnOffset) or 0,
						vForwardVector = v.ForwardVector and Game:GetOriginByString(v.ForwardVector) or nil,
						bGrowUp = false,
						iLevel = 1,
						tUnitRemaining = {}
					}
					if v.GrowUp ~= nil and v.GrowUp == 1 then
						tData.bGrowUp = true
					end
					table.insert(self.tSpawnerData, tData)
				end
			end
		end
	end


	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), public)
end
---获取等级
function public:GetLevel(sNPCName)
	for i, v in ipairs(self.tSpawnerData) do
		if v.sNPCClassName == sNPCName then
			return v.iLevel
		end
	end
end
function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for index, tData in ipairs(self.tSpawnerData) do
			local sNPCClassToSpawn = tData.sNPCClassName
			local iCount = tData.iTotalUnitsToSpawn
			if type(sNPCClassToSpawn) == "string" and sNPCClassToSpawn ~= "" and type(iCount) == "number" and iCount > 0 then
				local vPosition = Game:GetOriginByString(tData.sSpawnerName)
				if vPosition ~= nil then
					GameTimer(tData.fWaitForTime, function()
						if #tData.tUnitRemaining == 0 then
							for i = 1, iCount, 1 do
								local fSpawnOffset = tData.fSpawnOffset or 0
								local sUnitName = sNPCClassToSpawn
								if tData.fEliteChance and tData.sEliteName and RollPercentage(tData.fEliteChance) then
									sUnitName = tData.sEliteName
								end
								local hUnit = CreateUnitByNameWithNewData(sUnitName, vPosition + RandomVector(RandomFloat(0, fSpawnOffset)), true, nil, nil, ENEMY_TEAM, Game:GetPrecreateEnemyOverrideData(sUnitName))
								hUnit:AddNewModifier(hUnit, nil, "modifier_neutral", nil)
								if tData.bGrowUp then
									hUnit:CreatureLevelUp(tData.iLevel - 1)
									tData.iLevel = tData.iLevel + 1
								end
								if IsValid(hUnit) then
									if tData.vForwardVector then
										hUnit:SetForwardVector(tData.vForwardVector)
									else
										hUnit:SetForwardVector(RandomVector(1))
									end
									table.insert(tData.tUnitRemaining, hUnit)
									self.tUnitList[hUnit:entindex()] = index
								end
							end
						end
						return tData.fSpawnInterval
					end)
				end
			end
		end
	end
end

function public:OnEntityKilled(tEvents)
	local hKilledUnit = EntIndexToHScript(tEvents.entindex_killed)
	if not IsValid(hKilledUnit) then return end

	local index = self.tUnitList[tEvents.entindex_killed]
	if index ~= nil then
		local tData = self.tSpawnerData[index]
		self.tUnitList[tEvents.entindex_killed] = nil
		ArrayRemove(tData.tUnitRemaining, hKilledUnit)
	end
end

return public