if Training == nil then
	---@module Training
	---@field tPlayerTraining table<number, PlayerTraining> 玩家数据
	Training = class({})

	---@class PlayerTraining
	---@field bInTraining boolean 是否在练功房里
	---@field iTrainingLevel number 怪物等级
	---@field tTrainers array<int, int> 怪物表
end

TRAINING_ORIGIN = {
	Vector(-3840, 3840, 192),
	Vector(-3840, 5376, 192),
	Vector(-5376, 3840, 192),
	Vector(-5376, 5376, 192),
}

local public = Training

function public:init(bReload)
	if not bReload then
		self.tTrainingData = {}
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("custom_time_event", Dynamic_Wrap(public, "OnTimeEvent"), public)
end

function public:RemoveTraining(index)
	for k, iUnitEntIndex in pairs(self.tTrainingData[index].tTrainers) do
		local hUnit = EntIndexToHScript(iUnitEntIndex)
		if IsValid(hUnit) then
			hUnit:ForceKill(false)
		end
	end
	self.tTrainingData[index].tTrainers = {}
end

function public:HasUnitInTraining(index)
	local tTargets = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, TRAINING_ORIGIN[index], nil, 730, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for i = #tTargets, 1, -1 do
		if not self:IsPositionInTrainingRoom(index, tTargets[i]:GetAbsOrigin()) then
			table.remove(tTargets, i)
		end
	end
	return tTargets
end

---判断位置是否再练功房
---@param index number 填指定玩家ID或填-1遍历所有玩家
---@param vPosition Vector 位置
function public:IsPositionInTrainingRoom(index, vPosition)
	local vTrainingRoom = StringToVector(self.tTrainingData[index].sPosition)
	local tPolygon = {
		vTrainingRoom + Vector(-512, 512),
		vTrainingRoom + Vector(512, 512),
		vTrainingRoom + Vector(512, -512),
		vTrainingRoom + Vector(-512, -512),
	}
	return IsPointInPolygon(vPosition, tPolygon)
end

-------------------------------------------------------------------------------------------------------------
function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		for index, vPosition in ipairs(TRAINING_ORIGIN) do
			self.tTrainingData[index] = {
				iTrainingLevel = 1,
				tTrainers = {},
				sPosition = VectorToString(vPosition),
			}
		end
	end
end

function public:OnTimeEvent(tEvents)
	local fTickTime = tEvents.tick_time
	if fTickTime == 1 then
		for index, tData in ipairs(self.tTrainingData) do
			local tTargets = self:HasUnitInTraining(index)
			if #tTargets > 0 then
				local hHero = tTargets[1]
				local iPlayerID = hHero:GetPlayerOwnerID()
				local bIsAllDead = true
				for i = #tData.tTrainers, 1, -1 do
					local hUnit = EntIndexToHScript(tData.tTrainers[i])
					if not IsValid(hUnit) then
						table.remove(tData.tTrainers, i)
					elseif hUnit:IsAlive() then
						bIsAllDead = false
					end
				end
				if bIsAllDead then
					local vPosition = StringToVector(tData.sPosition)
					if vPosition ~= nil and vPosition ~= vec3_zero then
						for i = 1, TRAINER_AMOUNT + GetModifierProperty(hHero, EOM_MODIFIER_PROPERTY_GOLD_MONSTER_BONUS), 1 do
							local tOverrideData = {}
							if Rounds:GetRoundNumber() > 1 then
								tOverrideData = Game:GetPrecreateEnemyOverrideData(TRAINER_UNIT_NAME, {
									CustomStatusHealth = KeyValues.UnitsKv["wave_" .. Rounds:GetRoundNumber() - 1].CustomStatusHealth * (1 / ((300 - Rounds:GetRoundNumber() * 2) * 0.01)),
									AttackDamage = KeyValues.UnitsKv["wave_" .. Rounds:GetRoundNumber() - 1].AttackDamage * (20 + Rounds:GetRoundNumber()) * 0.01,
									Armor = KeyValues.UnitsKv["practicer"].Armor,
									BountyGold = KeyValues.UnitsKv["wave_" .. Rounds:GetRoundNumber() - 1].BountyGold,
								})
							end
							local hUnit = CreateUnitByNameWithNewData(TRAINER_UNIT_NAME, vPosition, true, nil, nil, ENEMY_TEAM, tOverrideData)
							if IsValid(hUnit) then
								hUnit.iKillerPlayerID = iPlayerID
								hUnit:AddNewModifier(hUnit, nil, "modifier_original_health_bar", nil)
								table.insert(tData.tTrainers, hUnit:entindex())
							end
						end
					end
				end
			else
				self:RemoveTraining(index)
			end
		end
	end
end

return public