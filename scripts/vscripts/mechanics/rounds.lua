if Rounds == nil then
	---回合管理模块
	---@module Rounds
	Rounds = class({})
end
local public = Rounds

ROUND_STATE_PREPARE = 0
ROUND_STATE_START = 1
ROUND_STATE_END = 2

function public:init(bReload)
	if not bReload then
		self:InitRounds()
		self.tPlayerExtraEnemies = {}
		self.bFirstRoundPrepared = false
		self.bPause = false
	end
	self.tRandomSpawnsList = {
		{
			sSpawnerName = "enemy_spawner",
		},
	}
	self.tRandomSneakySpawnsList = deepcopy(self.tRandomSpawnsList)

	self.iRoundNumber = self.iRoundNumber or 1
	self.iRoundState = self.iRoundState or ROUND_STATE_PREPARE

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("custom_round_state_change", Dynamic_Wrap(public, "OnRoundStateChange"), public)
	CustomUIEvent("next_round", Dynamic_Wrap(public, "OnNextRound"), public)
	GameTimerEvent(0, Dynamic_Wrap(public, "OnThink"), public)

	TimerEvent(0.5, function()
		self:UpdateNetTables()
		return 0.5
	end)

	if GameRules:IsCheatMode() then
		GameEvent("player_chat", Dynamic_Wrap(public, "OnPlayerChat"), public)

		Convars:RegisterCommand("debug_kill_creeps", function(cmd)
			if self.hCurrentRound ~= nil then
				self.hCurrentRound:ClearUnits()
			end
		end, "Kill all creeps.", FCVAR_CHEAT)
		Convars:RegisterCommand("debug_round_change", function(cmd, iRoundNumber)
			self:_SetNextRound(tonumber(iRoundNumber))
		end, "round change.", FCVAR_CHEAT)
		Convars:RegisterCommand("debug_round_change_immediately", function(cmd, iRoundNumber)
			self:_DemoStartRound(tonumber(iRoundNumber))
		end, "round change immediately.", FCVAR_CHEAT)
		Convars:RegisterCommand("debug_round_reroll", function(cmd)
			self:InitRounds()
		end, "round reroll.", FCVAR_CHEAT)
		Convars:RegisterCommand("debug_skip", function(cmd)
			if self.fPrepTimeEnd ~= nil then
				self.fPrepTimeEnd = GameRules:GetGameTime()
				self:_ThinkPrepTime()
			elseif self.hCurrentRound ~= nil then
				self.hCurrentRound:ClearUnits()
				self:_RoundFinished()
			end
		end, "skip waiting.", FCVAR_CHEAT)
	end
end

function public:InitRounds()
	---@type table<any, CRound>
	self.tRounds = {}
	if KeyValues.RoundKvs then
		for sRoundName, tRoundData in pairs(KeyValues.RoundKvs) do
			local iRoundNumber = tonumber(tRoundData.RoundNumber)
			if iRoundNumber ~= nil then
				local hRound = CRound(iRoundNumber, tRoundData, self)
				table.insert(self.tRounds, hRound)
			end
		end
	end
	table.sort(self.tRounds, function(a, b)
		return a:GetRoundNumber() < b:GetRoundNumber()
	end)

	if GameRules:IsCheatMode() then
		if Demo ~= nil and Demo.m_tRoundInfo ~= nil then
			Demo.m_tRoundInfo = {}
			for i, hRound in pairs(self.tRounds) do
				Demo.m_tRoundInfo[i] = {
					round_title = hRound:GetRoundTitle(),
					round_description = hRound:GetRoundDescription(),
				}
			end
			Demo:UpdateSettings()
		end
	end
end

function public:UpdateNetTables()
	local t = {}

	t.round_number = self.iRoundNumber
	t.round_state = self.iRoundState
	t.prep_time = self.fPrepTime
	t.prep_time_end = self.fPrepTimeEnd

	t.timed_round = 0

	if self.hCurrentRound then
		if self.hCurrentRound:IsTimedRound() then
			t.timed_round = 1

			t.timed_round_duration = self.hCurrentRound:GetRoundDuration()
			t.timed_round_duration_end = self.hCurrentRound:GetRoundDurationEnd()
		end
	end

	CustomNetTables:SetTableValue("common", "round_data", t)
end


function public:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not Demo:IsCreepsEnabled() or self.bPause then
			return 0
		end

		if self.fPrepTimeEnd ~= nil then
			self:_ThinkPrepTime()
		elseif self.hCurrentRound ~= nil then
			self.hCurrentRound:Think()
			if self.hCurrentRound:IsFinished() then
				self:_RoundFinished()
			end
		end
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		if self.hCurrentRound ~= nil then
			self:_RoundFinished()
		end
		return nil
	end
	return 0
end

function public:_ThinkPrepTime()
	if GameRules:GetGameTime() >= self.fPrepTimeEnd then
		self.fPrepTimeEnd = nil

		if self.iRoundNumber > #self.tRounds then
			return false
		end

		---@type CRound
		self.hCurrentRound = self.tRounds[self.iRoundNumber]
		self.iRoundState = ROUND_STATE_START
		self.hCurrentRound:Begin()
		FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })

		self:UpdateNetTables()
		return
	end

	if self.tRounds[self.iRoundNumber] then
		self.tRounds[self.iRoundNumber]:Precache()
	end
end

function public:_SetNextRound(iRoundNumber)
	if self.hCurrentRound == nil then
		self:_DemoStartRound(iRoundNumber)
	else
		self.iNextRoundNumber = iRoundNumber
	end
end

function public:_DemoStartRound(iRoundNumber)
	if self.hCurrentRound ~= nil then
		self.hCurrentRound:ClearUnits()
		self.hCurrentRound:End(true)
		self.iRoundState = ROUND_STATE_END
		FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })
	end

	self:_RefreshPlayers()

	self.iRoundNumber = iRoundNumber
	self.fPrepTime = 1
	self.fPrepTimeEnd = GameRules:GetGameTime() + self.fPrepTime
	self.iRoundState = ROUND_STATE_PREPARE
	if self.tRounds[self.iRoundNumber] and (self.iRoundNumber ~= 1 or self.bFirstRoundPrepared == false) then
		if self.iRoundNumber == 1 and self.bFirstRoundPrepared == false then
			self.bFirstRoundPrepared = true
		end
		self.tRounds[self.iRoundNumber]:Prepare()
	end
	FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })

	self.iNextRoundNumber = nil
	self.hCurrentRound = nil

	self:UpdateNetTables()
end

function public:_RoundFinished()
	self.iRoundState = ROUND_STATE_END
	self.hCurrentRound:End(true)
	FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })

	self:_RefreshPlayers()

	if self.iNextRoundNumber ~= nil then
		self.iRoundNumber = self.iNextRoundNumber
	else
		self.iRoundNumber = self.iRoundNumber + 1
	end
	self.fPrepTime = self.tRounds[self.iRoundNumber] and self.tRounds[self.iRoundNumber]:GetPrepareRoundTime() or PRE_GAME_TIME
	self.fPrepTimeEnd = GameRules:GetGameTime() + self.fPrepTime
	self.iRoundState = ROUND_STATE_PREPARE
	if self.tRounds[self.iRoundNumber] and (self.iRoundNumber ~= 1 or self.bFirstRoundPrepared == false) then
		if self.iRoundNumber == 1 and self.bFirstRoundPrepared == false then
			self.bFirstRoundPrepared = true
		end
		self.tRounds[self.iRoundNumber]:Prepare()
	end
	FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })

	self.iNextRoundNumber = nil
	self.hCurrentRound = nil

	self:UpdateNetTables()
end

function public:GetRoundState()
	return self.iRoundState
end

function public:GetRoundNumber()
	return self.iRoundNumber
end

function public:_RefreshPlayers()
end

function public:ChooseRandomSpawnInfo()
	if #self.tRandomSpawnsList == 0 then
		error("Attempt to choose a random spawn, but no random spawns are specified in the data.")
		return nil
	end

	return self.tRandomSpawnsList[RandomInt(1, #self.tRandomSpawnsList)]
end

function public:ChooseRandomSneakySpawnInfo()
	if #self.tRandomSneakySpawnsList == 0 then
		error("Attempt to choose a random sneaky spawn, but no random sneaky spawns are specified in the data.")
		return nil
	end

	return self.tRandomSneakySpawnsList[RandomInt(1, #self.tRandomSneakySpawnsList)]
end

function public:PasueRound(flDuration)
	-- self.bPause = true
	-- if flDuration then
	-- 	GameTimer("Round", flDuration, function()
	-- 		self.bPause = false
	-- 	end)
	-- end
	self.fPrepTimeEnd = self.fPrepTimeEnd + flDuration
end

function public:GetDifficulty()
	return Game:GetDifficulty()
end

function public:GetValidPlayerCount(iTeamNumber)
	return Game:GetValidPlayerCount(iTeamNumber)
end

function public:GetTeamBase(iTeamNumber)
	return Game:GetTeamBase(iTeamNumber)
end

function public:MakeTeamLose(iTeamNumber)
	return Game:MakeTeamLose(iTeamNumber)
end

function public:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
	local tKV = KeyValues.UnitsKv[sUnitName]
	if type(tKV) ~= "table" then
		return
	end

	if tOverrideData == nil then
		tOverrideData = {}
		tOverrideData.CustomStatusHealth = tonumber(tKV.CustomStatusHealth) or 1
		tOverrideData.Armor = tonumber(tKV.Armor) or 0
		tOverrideData.AttackDamage = tonumber(tKV.AttackDamage) or 0
		tOverrideData.DamageReduction = tonumber(tKV.DamageReduction) or 0
	else
		tOverrideData = deepcopy(tOverrideData)
		tOverrideData.CustomStatusHealth = (tonumber(tOverrideData.CustomStatusHealth) or tonumber(tKV.CustomStatusHealth)) or 1
		tOverrideData.Armor = (tonumber(tOverrideData.Armor) or tonumber(tKV.Armor)) or 0
		tOverrideData.AttackDamage = (tonumber(tOverrideData.AttackDamage) or tonumber(tKV.AttackDamage)) or 0
		tOverrideData.DamageReduction = (tonumber(tOverrideData.DamageReduction) or tonumber(tKV.DamageReduction)) or 0
	end

	return Game:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
end

function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.fPrepTime = self.tRounds[self.iRoundNumber] and self.tRounds[self.iRoundNumber]:GetPrepareRoundTime() or PRE_GAME_TIME
		self.fPrepTimeEnd = GameRules:GetGameTime() + self.fPrepTime
		self.iRoundState = ROUND_STATE_PREPARE
		if self.tRounds[self.iRoundNumber] and (self.iRoundNumber ~= 1 or self.bFirstRoundPrepared == false) then
			if self.iRoundNumber == 1 and self.bFirstRoundPrepared == false then
				self.bFirstRoundPrepared = true
			end
			self.tRounds[self.iRoundNumber]:Prepare()
		end
		FireGameEvent("custom_round_state_change", { round_number = self.iRoundNumber, round_state = self.iRoundState })
		self:UpdateNetTables()
	end
end

---@param tEvents {round_number:number,round_state:number}
function public:OnRoundStateChange(tEvents)
	FireModifierEvent(MODIFIER_EVENT_ON_ROUND_STATE_CHANGE, {
		round_number = tEvents.round_number,
		round_state = tEvents.round_state,
	})
end

function public:OnPlayerChat(tEvents)
	local iPlayerID = tEvents.playerid
	local sText = string.lower(tEvents.text)
	local bTeamOnly = tEvents.teamonly == 1
	if sText == "-showcreepcount" then
		local tGameEvent = {}
		tGameEvent["teamnumber"] = -1
		tGameEvent["message"] = "<panel class='OutpostIcon'/>单位数量：" .. tostring(#self.tCreeps) .. ""
		FireGameEvent("dota_combat_event_message", tGameEvent)
	end
end
function public:OnNextRound(iEventSourceIndex, tEvents)
	self:_SetNextRound(tonumber(self.iRoundNumber))
end

return public