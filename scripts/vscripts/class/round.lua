if CRound == nil then
	---@class CRound
	CRound = class({})
end
local public = CRound

---@param iRoundNumber number
---@param params table
---@param hExternal Rounds
function public:constructor(iRoundNumber, params, hExternal)
	self.hExternal = hExternal

	self.iRoundNumber = iRoundNumber

	---@type CSpawner[]
	self.tSpawners = {}
	local sSpawnerGroupID = params.SpawnerGroupID
	if sSpawnerGroupID and sSpawnerGroupID ~= "" then
		sSpawnerGroupID = string.gsub(sSpawnerGroupID, " ", "")
		local t = string.split(sSpawnerGroupID, "|")
		local w = CWeightPool({})
		for _, s in pairs(t) do
			local a = string.split(s, "#")
			w:Add(a[1], tonumber(a[2]) or 1)
		end
		sSpawnerGroupID = w:Random()

		local tSpawnerGroupData = KeyValues.SpawnerGroupKvs[sSpawnerGroupID]
		if tSpawnerGroupData then
			self.sSpawnerGroupID = sSpawnerGroupID

			self.sRoundTitle = tSpawnerGroupData.SpawnerGroupTitle or string.format("Round_%d", iRoundNumber)
			self.sRoundDescription = tSpawnerGroupData.SpawnerGroupDescription

			for k, v in pairs(tSpawnerGroupData) do
				if type(v) == "table" and v.NPCName then
					local hSpawner = CSpawner(k, v, self)
					self.tSpawners[k] = hSpawner
				end
			end

			for _, hSpawner in pairs(self.tSpawners) do
				hSpawner:PostLoad(self.tSpawners)
			end
		end
	else
		self.sRoundTitle = string.format("Round_%d", iRoundNumber)
	end

	self.bPrecached = false
	self.bTimedRound = tonumber(params.TimedRound or 0) ~= 0
	self.fTimedRoundDuration = tonumber(params.TimedRoundDuration or 60)
	self.fPrepareRoundTime = tonumber(params.PrepareRoundTime or 0)
	self.fNextRoundTime = tonumber(params.NextRoundTime or 0)
	self.sSoundName = params.SoundName
	self.sRoundType = params.RoundType
	self.iNPCSpawnedUnits = 0
end

function public:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
	tOverrideData = {}
	local tKV = KeyValues.UnitsKv[sUnitName]
	if tKV ~= nil then
		tOverrideData.CustomStatusHealth = tonumber(tKV.CustomStatusHealth) or tOverrideData.CustomStatusHealth
		tOverrideData.Armor = tonumber(tKV.Armor) or tOverrideData.Armor
		tOverrideData.AttackDamage = tonumber(tKV.AttackDamage) or tOverrideData.AttackDamage
	end
	tOverrideData.CustomStatusHealth = tOverrideData.CustomStatusHealth
	tOverrideData.Armor = tOverrideData.Armor
	tOverrideData.AttackDamage = tOverrideData.AttackDamage
	return self.hExternal:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
end

function public:Precache()
	if self.bPrecached == true then
		return
	end

	for _, hSpawner in pairs(self.tSpawners) do
		hSpawner:Precache()
	end

	self.bPrecached = true
end

function public:Prepare()
end

function public:Begin()
	self.tEnemiesRemaining = {}
	self.tEventHandles = {
		ListenToGameEvent("npc_spawned", Dynamic_Wrap(public, "OnNPCSpawned"), self),
		ListenToGameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), self),
	}

	self.iCoreUnitsTotal = 0
	self.fRoundStartTime = GameRules:GetGameTime()

	for _, hSpawner in pairs(self.tSpawners) do
		hSpawner:Begin()
		self.iCoreUnitsTotal = self.iCoreUnitsTotal + hSpawner:GetTotalUnitsToSpawn()
	end
	self.iCoreUnitsKilled = 0

	GameTimer(0, function()
		local bIsSpawnerFinished = true
		for _, hSpawner in pairs(self.tSpawners) do
			if not hSpawner:IsFinishedSpawning() then
				bIsSpawnerFinished = false
				hSpawner:Think()
			end
		end

		if not bIsSpawnerFinished then
			return 0
		end
	end)
	if self.sSoundName then
		Game:EachPlayer(function(iPlayerID)
			EmitSoundOnClient(self.sSoundName, PlayerResource:GetPlayer(iPlayerID))
		end)
	end
end

function public:End()
	for _, iID in pairs(self.tEventHandles) do
		StopListeningToGameEvent(iID)
	end
	self.tEventHandles = {}

	for _, hSpawner in pairs(self.tSpawners) do
		hSpawner:End()
	end
end

function public:Think()
	-- for _, hSpawner in pairs(self.tSpawners) do
	-- 	hSpawner:Think()
	-- end
end

function public:OnNPCSpawned(tEvents)
	local hSpawnedUnit = EntIndexToHScript(tEvents.entindex)
	if not IsValid(hSpawnedUnit) or hSpawnedUnit:IsPhantom() or hSpawnedUnit:IsPhantomBlocker() or hSpawnedUnit:GetClassname() == "npc_dota_thinker" or hSpawnedUnit:GetUnitName() == "" then
		return
	end

	hSpawnedUnit:GameTimer(0, function()
		if not hSpawnedUnit:IsOutOfGame() then
			table.insert(self.tEnemiesRemaining, hUnit)
		end
	end)
end

function public:OnEntityKilled(tEvents)
	local hKilledUnit = EntIndexToHScript(tEvents.entindex_killed or -1)
	if not IsValid(hKilledUnit) or hKilledUnit:IsPhantom() or hKilledUnit:IsPhantomBlocker() or hKilledUnit:GetClassname() == "npc_dota_thinker" or hKilledUnit:GetUnitName() == "" then
		return
	end

	self:RemoveEnemy(hKilledUnit)

	if hKilledUnit.iDefendingTeamNumber then
		self.iCoreUnitsKilled = self.iCoreUnitsKilled + 1
	end
end

function public:ClearUnits()
	if self.tEnemiesRemaining then
		for i, hUnit in pairs(self.tEnemiesRemaining) do
			if IsValid(hUnit) then
				hUnit:MakeIllusion()
				hUnit:AddNoDraw()
				hUnit:Remove()
			end
		end
	end
end

function public:IsFinished()
	if self.bTimedRound and self.fRoundStartTime then
		if self:GetEnemiesRemainingUnits() == 0 then
			return true
		end
		if (GameRules:GetGameTime() - self.fRoundStartTime) >= self.fTimedRoundDuration then
			return true
		else
			return false
		end
	end

	return true
end

function public:IsTimedRound()
	return self.bTimedRound
end

function public:GetRoundNumber()
	return self.iRoundNumber
end

function public:GetRoundDurationEnd()
	if self.bTimedRound and self.fRoundStartTime then
		return self.fRoundStartTime + self.fTimedRoundDuration
	end
	return -1
end

function public:GetRoundDuration()
	if self.bTimedRound then
		return self.fTimedRoundDuration
	end
	return -1
end

function public:GetNextRoundTime()
	return self.fNextRoundTime
end

function public:GetPrepareRoundTime()
	return self.fPrepareRoundTime
end

function public:ChooseRandomSpawnInfo()
	return self.hExternal:ChooseRandomSpawnInfo()
end

function public:ChooseRandomSneakySpawnInfo()
	return self.hExternal:ChooseRandomSneakySpawnInfo()
end

function public:RemoveEnemy(hUnit)
	for i = #self.tEnemiesRemaining, 1, -1 do
		local _hUnit = self.tEnemiesRemaining[i]
		if not IsValid(_hUnit) or not _hUnit:IsAlive() or _hUnit == hUnit then
			table.remove(self.tEnemiesRemaining, i)
		end
	end
end

function public:GetEnemiesRemainingUnits()
	if self.tEnemiesRemaining then
		for i = #self.tEnemiesRemaining, 1, -1 do
			local hUnit = self.tEnemiesRemaining[i]
			if not IsValid(hUnit) or not hUnit:IsAlive() then
				table.remove(self.tEnemiesRemaining, i)
			end
		end
		return #self.tEnemiesRemaining
	end
	return 0
end

function public:GetTotalUnits()
	return self.iCoreUnitsTotal
end

function public:GetTotalUnitsKilled()
	return self.tCoreUnitsKilled
end

function public:GetRoundTitle()
	return self.sRoundTitle
end

function public:GetRoundDescription()
	return self.sRoundDescription
end