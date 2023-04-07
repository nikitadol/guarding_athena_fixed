if SpecialSpawner == nil then
	---特殊进攻
	SpecialSpawner = class({})
end
local public = SpecialSpawner

function public:init(bReload)
	if not bReload then
		self.tUnitList = {}
	end
	self.tSpawnerData = LoadKeyValues("scripts/npc/kv/gameplay/special_rush.kv")
	GameEvent("custom_round_state_change", Dynamic_Wrap(public, "OnRoundStateChange"), public)
end
---开始一个特殊仅供
function public:StartRush(sRushName)
	local tData = self.tSpawnerData[sRushName]
	if type(tData) == "table" then
		if tData.Pool == nil then
			tData.Pool = CWeightPool(tData.UnitPool)
		end
		local flEndTime
		if tData.flDuration then
			flEndTime = GameRules:GetGameTime() + tData.flDuration - (50 / GameRules:GetCustomGameDifficulty())
		end
		GameTimer(0, function()
			if flEndTime == nil or GameRules:GetGameTime() < flEndTime then
				for sSpawnerName, _ in pairs(tData.Spawner) do
					local vPosition = Game:GetOriginByString(sSpawnerName)
					local fSpawnOffset = tData.fSpawnOffset or 0
					local sUnitName = tData.Pool:Random()
					local hUnit = CreateUnitByNameWithNewData(sUnitName, vPosition + RandomVector(RandomFloat(0, fSpawnOffset)), true, nil, nil, ENEMY_TEAM, Game:GetPrecreateEnemyOverrideData(sUnitName))
					hUnit:SetGoalEntity(Game.tTeamBase[DOTA_TEAM_GOODGUYS])
					hUnit:AddNewModifier(hUnit, nil, "modifier_original_health_bar", nil)
				end
				if tData.flInterval then
					return tData.flInterval
				end
			end
		end)
		Notification:Upper({
			message = sRushName
		})
		if tData.sSoundName then
			Game:EachPlayer(function(iPlayerID)
				EmitSoundOnClient(tData.sSoundName, PlayerResource:GetPlayer(iPlayerID))
			end)
		end
	end
end
--------------------------------------------------------------------------------
-- 事件
--------------------------------------------------------------------------------
---@param tEvents {round_number:number,round_state:number}
function public:OnRoundStateChange(tEvents)
	for sRushName, tSpawnData in pairs(self.tSpawnerData) do
		if tSpawnData.iRound == tEvents.round_number and tEvents.round_state == ROUND_STATE_END then
			self:StartRush(sRushName)
		end
	end
end

return public