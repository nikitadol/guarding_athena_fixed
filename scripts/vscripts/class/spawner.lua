if CSpawner == nil then
	---@class CSpawner
	CSpawner = class({})
end
local public = CSpawner

---@param sName string
---@param params table
---@param hGameRound CRound
function public:constructor(sName, params, hGameRound)
	self.hGameRound = hGameRound
	self.tDependentSpawners = {}

	self.sChampionNPCClassName = params.ChampionNPCName or ""
	self.sGroupWithUnit = params.GroupWithUnit or ""
	self.sName = sName
	self.sNPCClassName = params.NPCName or ""
	self.sSpawnerName = params.SpawnerName or ""
	self.sSneakySpawnerName = params.SneakySpawnerName or ""
	self.sWaitForUnit = params.WaitForUnit or ""

	self.iChampionBonusLevel = tonumber(params.ChampionBonusLevel or 0)
	self.iChampionMax = tonumber(params.ChampionMax or 1)
	self.iChampionIntervalMax = tonumber(params.ChampionIntervalMax or 999)
	self.fChampionBonusModelScale = tonumber(params.ChampionBonusModelScale or 1)
	self.iCreatureLevel = tonumber(params.CreatureLevel or 0)
	self.iTotalUnitsToSpawn = tonumber(params.TotalUnitsToSpawn or 0)
	self.iUnitsPerSpawn = tonumber(params.UnitsPerSpawn or 1)

	self.fChampionChance = tonumber(params.ChampionChance or 0)
	self.fInitialWait = tonumber(params.WaitForTime or 0)
	self.fSpawnInterval = tonumber(params.SpawnInterval or 0)

	self.bOffsetSpawn = tonumber(params.OffsetSpawn or 0) ~= 0
	self.bIsSneaky = tonumber(params.IsSneaky or 0) ~= 0

	self._SpawnGroup = {}
end

function public:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
	return self.hGameRound:GetPrecreateEnemyOverrideData(sUnitName, tOverrideData)
end

function public:PostLoad(tSpawners)
	self.hWaitForUnit = tSpawners[self.sWaitForUnit]
	if self.sWaitForUnit ~= "" and not self.hWaitForUnit then
		print(self.sName .. " has a wait for unit " .. self.sWaitForUnit .. " that is missing from the round data.")
	elseif self.hWaitForUnit then
		table.insert(self.hWaitForUnit.tDependentSpawners, self)
	end

	self.hGoupWithUnit = tSpawners[self.sGroupWithUnit]
	if self.sGroupWithUnit ~= "" and not self.hGoupWithUnit then
		print(self.sName .. " has a group with unit " .. self.sGroupWithUnit .. " that is missing from the round data.")
	elseif self.hGoupWithUnit then
		table.insert(self.hGoupWithUnit.tDependentSpawners, self)
	end
end

function public:Precache()
	local tKV = KeyValues.UnitsKv[self.sNPCClassName]
	if tKV ~= nil then
		PrecacheUnitByNameAsync(self.sNPCClassName, function(sg) table.insert(self._SpawnGroup, sg) end)
	else
		local hUnitPool = Game.hPools[self.sNPCClassName]
		if hUnitPool ~= nil then
			hUnitPool:Each(function(sUnitName)
				local tKV = KeyValues.UnitsKv[sUnitName]
				if tKV ~= nil then
					PrecacheUnitByNameAsync(sUnitName, function(sg) table.insert(self._SpawnGroup, sg) end)
				end
			end)
		end
	end

	local tKV = KeyValues.UnitsKv[self.sChampionNPCClassName]
	if tKV ~= nil then
		PrecacheUnitByNameAsync(self.sChampionNPCClassName, function(sg) table.insert(self._SpawnGroup, sg) end)
	else
		local hUnitPool = Game.hPools[self.sChampionNPCClassName]
		if hUnitPool ~= nil then
			hUnitPool:Each(function(sUnitName)
				local tKV = KeyValues.UnitsKv[sUnitName]
				if tKV ~= nil then
					PrecacheUnitByNameAsync(sUnitName, function(sg) table.insert(self._SpawnGroup, sg) end)
				end
			end)
		end
	end
end

function public:Think()
	local bIsFinishedSpawning = self:IsFinishedSpawning()
	if bIsFinishedSpawning then
		self:CheckEnemiesRemaining()
	end

	if not self.fNextSpawnTime then
		return
	end

	if GameRules:GetGameTime() >= self.fNextSpawnTime then
		self:_DoSpawn()
		for _, s in pairs(self.tDependentSpawners) do
			s:ParentSpawned(self)
		end

		if bIsFinishedSpawning then
			self.fNextSpawnTime = nil
		else
			self.fNextSpawnTime = self.fNextSpawnTime + self.fSpawnInterval
		end
	end
end

function public:Begin()
	self.iUnitsSpawned = 0
	self.iChampionsSpawned = 0

	self.sFindSpawnerName = self.sSpawnerName
	self.sSneakyFindSpawnerName = self.sSneakySpawnerName

	if self.hWaitForUnit ~= nil or self.hGoupWithUnit ~= nil then
		self.fNextSpawnTime = nil
	else
		self.fNextSpawnTime = GameRules:GetGameTime() + self.fInitialWait
	end
end

function public:End()
	for k, v in pairs(self._SpawnGroup) do
		UnloadSpawnGroupByHandle(v)
	end
	self._SpawnGroup = {}
end

function public:_GetSpawnerName()
	if self.hGoupWithUnit then
		return self.hGoupWithUnit:_GetSpawnerName()
	else
		return self.sFindSpawnerName
	end
end

function public:_GetSneakySpawnerName()
	if self.hGoupWithUnit then
		return self.hGoupWithUnit:_GetSneakySpawnerName()
	else
		return self.sSneakyFindSpawnerName
	end
end

function public:_UpdateRandomSpawn()
	local tSpawnInfo = self.hGameRound:ChooseRandomSpawnInfo()
	if tSpawnInfo == nil then
		print(string.format("Failed to get random spawn info for spawner %s.", self.sName))
		return
	end

	self.sFindSpawnerName = tSpawnInfo.sSpawnerName
end

function public:_UpdateRandomSneakySpawn()
	local tSpawnInfo = self.hGameRound:ChooseRandomSneakySpawnInfo()
	if tSpawnInfo == nil then
		print(string.format("Failed to get random spawn info for spawner %s.", self.sName))
		return
	end

	self.sSneakyFindSpawnerName = tSpawnInfo.sSpawnerName
end

function public:_DoSpawn()
	local iUnitsToSpawn = math.min(self.iUnitsPerSpawn, self.iTotalUnitsToSpawn - self.iUnitsSpawned)

	local iChampionsSpawnedThisInterval = 0

	if iUnitsToSpawn <= 0 then
		return
	elseif self.iUnitsSpawned == 0 then
		print(string.format("Started spawning %s at %.2f", self.sName, GameRules:GetGameTime()))
	end

	EmitGlobalSound("Tutorial.Quest.complete_01")

	if self.bIsSneaky == false then
		if self.sSpawnerName == "" then
			self:_UpdateRandomSpawn()
		end
	else
		if self.sSneakySpawnerName == "" then
			self:_UpdateRandomSneakySpawn()
		end
	end

	local sSpawnerName = nil
	if self.bIsSneaky == false then
		sSpawnerName = self:_GetSpawnerName()
	else
		sSpawnerName = self:_GetSneakySpawnerName()
	end
	if not sSpawnerName == "" then return end

	for iUnit = 1, iUnitsToSpawn, 1 do
		local bIsChampion = RollPercentage(self.fChampionChance)
		if self.iChampionsSpawned >= self.iChampionMax or iChampionsSpawnedThisInterval >= self.iChampionIntervalMax then
			bIsChampion = false
		end

		local sNPCClassToSpawn
		local tKV = KeyValues.UnitsKv[self.sNPCClassName]
		if tKV ~= nil then
			sNPCClassToSpawn = self.sNPCClassName
		else
			local hUnitPool = Game.hPools[self.sNPCClassName]
			if hUnitPool ~= nil then
				sNPCClassToSpawn = hUnitPool:Random()
			end
		end

		if bIsChampion and self.sChampionNPCClassName ~= "" then
			local tKV = KeyValues.UnitsKv[self.sChampionNPCClassName]
			if tKV ~= nil then
				sNPCClassToSpawn = self.sChampionNPCClassName
			else
				local hUnitPool = Game.hPools[self.sChampionNPCClassName]
				if hUnitPool ~= nil then
					sNPCClassToSpawn = hUnitPool:Random()
				end
			end
		end
		local tKV = KeyValues.UnitsKv[sNPCClassToSpawn]
		if tKV == nil then
			break
		end
		local hEntSpawner = Entities:FindByName(nil, sSpawnerName)
		if not IsValid(hEntSpawner) then
			break
		end
		local vPlayerSpawnLocation = hEntSpawner:GetAbsOrigin()

		local hEntUnit = CreateUnitByNameWithNewData(sNPCClassToSpawn, vPlayerSpawnLocation, true, nil, nil, ENEMY_TEAM, self:GetPrecreateEnemyOverrideData(sNPCClassToSpawn))
		if not IsValid(hEntUnit) then
			break
		end
		hEntUnit:SetForwardVector(hEntSpawner:GetForwardVector())
		if hEntUnit:IsCreature() then
			if self.iCreatureLevel > 0 then
				hEntUnit:CreatureLevelUp(self.iCreatureLevel - hEntUnit:GetLevel())
			end

			if bIsChampion then
				hEntUnit:CreatureLevelUp(self.iChampionBonusLevel)
				hEntUnit:SetChampion(true)
				hEntUnit:AddNewModifier(hEntUnit, nil, "modifier_champion", nil)
				if self.sChampionNPCClassName == "" then
					hEntUnit:SetModelScale(hEntUnit:GetModelScale() + self.fChampionBonusModelScale)
				end
			end
		end
		if GameRules:GetCustomGameDifficulty() >= 3 and string.find(sNPCClassToSpawn, "wave_") then
			if RollPercentage(GameRules:GetCustomGameDifficulty() * 2) then
				hEntUnit:AddNewModifier(hEntUnit, nil, "modifier_elite", nil)
			end
		end

		hEntUnit:SetGoalEntity(hEntSpawner)

		hEntUnit.iDefendingTeamNumber = PLAYER_TEAM

		hEntUnit:SetDeathXP(0)
		hEntUnit:SetMaximumGoldBounty(0)
		hEntUnit:SetMinimumGoldBounty(0)
		if type(self.hGameRound.Spawner_OnUnitSpawned) == "function" then
			self.hGameRound:Spawner_OnUnitSpawned(self, hEntUnit, PLAYER_TEAM)
		end

		if bIsChampion then
			self.iChampionsSpawned = self.iChampionsSpawned + 1
			iChampionsSpawnedThisInterval = iChampionsSpawnedThisInterval + 1
		else
			hEntUnit:AddNewModifier(hEntUnit, nil, "modifier_wave", nil)
		end

		self.iUnitsSpawned = self.iUnitsSpawned + 1
	end
end

function public:ParentSpawned(hParentSpawner)
	if hParentSpawner == self.hGoupWithUnit then
		-- Make sure we use the same spawn location as hParentSpawner.
		self:_DoSpawn()
	elseif hParentSpawner == self.hWaitForUnit then
		if hParentSpawner:IsFinishedSpawning() and self.fNextSpawnTime == nil then
			self.fNextSpawnTime = hParentSpawner.fNextSpawnTime + self.fInitialWait
		end
	end
end

function public:IsFinishedSpawning()
	return (self.iUnitsSpawned >= self.iTotalUnitsToSpawn) or (self.hGoupWithUnit ~= nil)
end

function public:CheckEnemiesRemaining()
	local iEnemiesRemaining = self.hGameRound:GetRemainingUnits()

	if self:IsFinishedSpawning() and iEnemiesRemaining <= 5 then
		-- self.hGameRound:ApplyVisionToRemainingEnemies()
	end
end

function public:GetTotalUnitsToSpawn()
	return self.iTotalUnitsToSpawn
end