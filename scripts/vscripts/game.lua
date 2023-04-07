if Game == nil then
	Game = {}
end
local public = Game

function public:init(bReload)
	do -- 提前加载
		local t = require("mechanics/dialog_events")
		if type(t) == "table" then
			_G["DialogEvents"] = t
			if type(t.init) == "function" then
				t:init(bReload)
			end
		end
	end

	if not bReload then
		self.iDifficulty = 2 -- 游戏难度
		self.iMode = 1 -- 游戏模式
		self.tPlayerCourier = {}
		self.tHeroSelection = {}
	end

	self.tTeamBase = self.tTeamBase or {}
	self.tLosedTeam = self.tLosedTeam or {}

	self.hReservoirs = {}
	for k, v in pairs(KeyValues.ReservoirsKv) do
		self.hReservoirs[k] = CWeightPool(v)
	end
	---@type table<string, CWeightPool>
	self.hPools = {}
	for k, v in pairs(KeyValues.PoolsKv) do
		self.hPools[k] = CWeightPool(v)
	end
	for sItemName, tData in pairs(KeyValues.ItemsKv) do
		if type(tData) == "table" then
			local iRarity = tonumber(tData.Rarity)
			if iRarity ~= nil then
				if _G[tData.CustomItemType] == CUSTOM_ITEM_TYPE_EQUIPMENT and self.hPools["item_equipment_level_" .. iRarity] ~= nil then
					self.hPools["item_equipment_level_" .. iRarity]:Add(sItemName, 1)
				elseif _G[tData.CustomItemType] == CUSTOM_ITEM_TYPE_ABILITY_BOOK and self.hPools["item_ability_book_level_" .. iRarity] ~= nil then
					self.hPools["item_ability_book_level_" .. iRarity]:Add(sItemName, 1)
				end
			end
		end
	end

	for sAbilityName, tData in pairs(KeyValues.AbilitiesKv) do
		if type(tData) == "table" then
			if tData.CustomAbilityType and _G[tData.CustomAbilityType] == CUSTOM_ABILITY_TYPE_TALENT then
				self.hPools["ability_talent"]:Add(sAbilityName, 1)
			end
		end
	end
	-- 信使随机池
	self.hPools["courier"] = CWeightPool()
	for k, v in pairs(KeyValues.CouriersKV) do
		self.hPools["courier"]:Add(k, 1)
	end

	---记录玩家连接信息
	self.tPlayerInfo = {}

	GameEvent("npc_spawned", Dynamic_Wrap(public, "OnNPCSpawned"), public)
	GameEvent("custom_npc_first_spawned", Dynamic_Wrap(public, "OnNPCFirstSpawned"), public)
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	GameEvent("entity_killed", Dynamic_Wrap(public, "OnEntityKilled"), public)
	GameEvent("dota_player_gained_level", Dynamic_Wrap(public, "OnPlayerLevelUp"), public)
	GameEvent("dota_player_learned_ability", Dynamic_Wrap(public, "OnPlayerLearnedAbility"), public)
	GameEvent("player_connect_full", Dynamic_Wrap(public, "OnPlayerConnectFull"), public)

	GameEvent("trigger_start_touch", Dynamic_Wrap(public, "OnTriggerStartTouch"), public)
	GameEvent("trigger_end_touch", Dynamic_Wrap(public, "OnTriggerEndTouch"), public)

	-- CustomUIEvent("upgrade_item", Dynamic_Wrap(public, "OnUpgradeItem"), public)
	CustomUIEvent("difficulty_selected", Dynamic_Wrap(public, "OnDifficultySelected"), public)
	CustomUIEvent("hero_selected", Dynamic_Wrap(public, "OnHeroSelected"), public)
	CustomUIEvent("talent_selection", Dynamic_Wrap(public, "OnTalentSelection"), public)
	CustomUIEvent("swap_abilities", Dynamic_Wrap(public, "OnSwapAbilities"), public)
	CustomUIEvent("delete_ability", Dynamic_Wrap(public, "OnDeleteAbility"), public)
	CustomUIEvent("active_glyph", Dynamic_Wrap(public, "OnActiveGlyph"), public)
	CustomUIEvent("active_scan", Dynamic_Wrap(public, "OnActiveScan"), public)
end

-- 获取游戏难度
function public:GetDifficulty()
	return self.iDifficulty
end

-- 获取游戏模式
function public:GetMode()
	return self.iMode
end

-- 遍历有玩家的队伍
function public:EachTeamsWithPlayer(funcCallBack)
	for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_7, 1 do
		local iPlayerCount = PlayerResource:GetPlayerCountForTeam(iTeamNumber)
		if iPlayerCount > 0 then
			if type(funcCallBack) == "function" then
				if funcCallBack(iTeamNumber) == true then
					break
				end
			end
		end
	end
end

-- 遍历正在游戏的队伍
function public:EachTeamsInGaming(funcCallBack)
	return self:EachTeamsWithPlayer(function(iTeamNumber)
		local iPlayerCount = PlayerResource:GetPlayerCountForTeam(iTeamNumber)
		local bAbandoned = true
		for i = 1, iPlayerCount, 1 do
			local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, i)
			if PlayerResource:GetConnectionState(iPlayerID) ~= DOTA_CONNECTION_STATE_ABANDONED then
				bAbandoned = false
				break
			end
		end
		if not bAbandoned and not self:IsTeamLosed(iTeamNumber) then
			if type(funcCallBack) == "function" then
				return funcCallBack(iTeamNumber)
			end
		end
	end)
end

-- 遍历正在游戏的玩家，funcCallBack(iTeamNumber, iPlayerID)
function public:EachPlayersInGaming(funcCallBack)
	return self:EachTeamsInGaming(function(iTeamNumber)
		local iPlayerCount = PlayerResource:GetPlayerCountForTeam(iTeamNumber)
		for i = 1, iPlayerCount, 1 do
			local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, i)
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				if type(funcCallBack) == "function" then
					if funcCallBack(iTeamNumber, iPlayerID) == true then
						return true
					end
				end
			end
		end
	end)
end

-- 队伍失败
function public:IsTeamLosed(iTeamNumber)
	return self.tLosedTeam[iTeamNumber] == true
end
function public:MakeTeamLose(iTeamNumber)
	GameRules:MakeTeamLose(iTeamNumber)
	self.tLosedTeam[iTeamNumber] = true
end

-- 遍历玩家
function public:EachPlayer(iTeamNumber, funcCallBack)
	if type(iTeamNumber) == "function" then
		funcCallBack = iTeamNumber
		self:EachTeamsWithPlayer(function(iTeamNumber)
			for n = 1, PlayerResource:GetPlayerCountForTeam(iTeamNumber), 1 do
				local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, n)
				if PlayerResource:IsValidPlayerID(iPlayerID) then
					if type(funcCallBack) == "function" then
						if funcCallBack(iPlayerID, iTeamNumber, n) == true then
							return true
						end
					end
				end
			end
		end)
	else
		for n = 1, PlayerResource:GetPlayerCountForTeam(iTeamNumber), 1 do
			local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, n)
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				if type(funcCallBack) == "function" then
					if funcCallBack(iPlayerID, iTeamNumber, n) == true then
						break
					end
				end
			end
		end
	end
end
-- 遍历所有玩家的英雄
function public:EachPlayerHero(funcCallBack)
	self:EachPlayer(function(iPlayerID, iTeamNumber, n)
		if type(funcCallBack) == "function" then
			local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if IsValid(hHero) and funcCallBack(hHero, iPlayerID) == true then
				return true
			end
		end
	end)
end
--将steamid转为playerid
function public:SteamID2PlayerID(sPlayerSteamID)
	local iReturnPlayerID = -1
	sPlayerSteamID = tostring(sPlayerSteamID)
	self:EachPlayer(function(iPlayerID)
		local _sPlayerSteamID = tostring(PlayerResource:GetSteamID(iPlayerID))
		if _sPlayerSteamID == sPlayerSteamID then
			iReturnPlayerID = iPlayerID
			return true
		end
	end)
	return iReturnPlayerID
end
-- 获取玩家数量
function public:GetPlayerCount(iTeamNumber)
	local n = 0

	if iTeamNumber == nil then
		self:EachPlayer(function(iPlayerID)
			n = n + 1
		end)
	else
		self:EachPlayer(iTeamNumber, function(iPlayerID)
			n = n + 1
		end)
	end

	return n
end
-- 获取有效玩家数量
function public:GetValidPlayerCount(iTeamNumber)
	local n = 0

	if iTeamNumber == nil then
		self:EachPlayer(function(iPlayerID)
			local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if IsValid(hHero) then
				n = n + 1
			end
		end)
	else
		self:EachPlayer(iTeamNumber, function(iPlayerID)
			local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if IsValid(hHero) then
				n = n + 1
			end
		end)
	end

	return n
end
-- 获取玩家在队伍的位置
function public:GetNthByPlayerID(iTeamNumber, iPlayerID)
	local n = -1
	if iPlayerID == nil then
		iPlayerID = iTeamNumber
		self:EachPlayer(function(_iPlayerID, _, _n)
			if _iPlayerID == iPlayerID then
				n = _n
				return true
			end
		end)
	else
		self:EachPlayer(iTeamNumber, function(_iPlayerID, _, _n)
			if _iPlayerID == iPlayerID then
				n = _n
				return true
			end
		end)
	end
	return n
end

---获取坐标，参量s可以为实体名字，也可以填以逗号分隔开的坐标
---@return Vector
function public:GetOriginByString(s)
	local hEntity = Entities:FindByName(nil, s)
	if IsValid(hEntity) then
		return hEntity:GetAbsOrigin()
	else
		s = string.gsub(s, "%s", "")
		local a = string.split(s, ",")
		if #a == 3 then
			if tonumber(a[1]) ~= nil and tonumber(a[2]) ~= nil and tonumber(a[3]) ~= nil then
				return Vector(tonumber(a[1]), tonumber(a[2]), tonumber(a[3]))
			end
		end
	end
end

-- 仅抽奖堆
function public:DrawReservoirOnly(sReservoirName)
	if self.hReservoirs[sReservoirName] == nil then
		return
	end

	return self.hReservoirs[sReservoirName]:Random()
end

-- 抽奖堆
function public:DrawReservoir(sReservoirName)
	if self.hReservoirs[sReservoirName] == nil then
		return
	end

	local sPoolName = self.hReservoirs[sReservoirName]:Random()

	return self:DrawPool(sPoolName)
end

-- 抽奖池
function public:DrawPool(sPoolName)
	if self.hPools[sPoolName] == nil then
		return
	end

	return self.hPools[sPoolName]:Random()
end

-- 传送
function public:Teleport(hUnit, sEntityName)
	if HasTeleportDisable(hUnit) then
		ErrorMessage(hUnit:GetPlayerOwnerID(), "error_not_teleport")
		return
	end
	local vPosition = self:GetOriginByString(sEntityName)
	if vPosition ~= nil then
		local vColor = Vector(255, 255, 255)

		local vStartPosition = hUnit:GetAbsOrigin()
		local iStartParticleID = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iStartParticleID, 0, vStartPosition)
		ParticleManager:SetParticleControl(iStartParticleID, 2, vColor)

		hUnit:Interrupt()
		FindClearSpaceForUnit(hUnit, vPosition, true)
		ProjectileManager:ProjectileDodge(hUnit)

		FireGameEvent("custom_teleport", {
			entindex = hUnit:entindex(),
			point_name = sEntityName,
		})

		local vEndPosition = hUnit:GetAbsOrigin()
		local iEndParticleID = ParticleManager:CreateParticle("particles/items2_fx/teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iEndParticleID, 0, vEndPosition)
		ParticleManager:SetParticleControl(iEndParticleID, 1, vEndPosition)
		ParticleManager:SetParticleControl(iEndParticleID, 2, vColor)
		ParticleManager:SetParticleControlEnt(iEndParticleID, 3, hUnit, PATTACH_ABSORIGIN, nil, hUnit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iEndParticleID, 4, Vector(0, 0, 0))
		ParticleManager:SetParticleControl(iEndParticleID, 5, vEndPosition)

		CenterCameraOnUnit(hUnit:GetPlayerOwnerID(), hUnit)

		GameTimer(0.1, function()
			ParticleManager:DestroyParticle(iStartParticleID, false)
			ParticleManager:DestroyParticle(iEndParticleID, false)
			if IsValid(hUnit) then
				EmitSoundOnLocationWithCaster(vStartPosition, "Portal.Hero_Disappear", hUnit)
				EmitSoundOnLocationWithCaster(vEndPosition, "Portal.Hero_Appear", hUnit)
			end
		end)
	end
end

-- 获取预创建单位的覆盖数据，以此计算游戏模式和难度带来的影响，可以传已经被覆盖过的数据
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

	do -- 根据难度调整数值
		local tData = self:GetDifficultyFactorData(sUnitName)
		-- local tData = DIFFICULTY_ALL_ENEMY_SETTINGS[Clamp(self:GetDifficulty(), 1, #DIFFICULTY_ALL_ENEMY_SETTINGS)]
		tOverrideData.CustomStatusHealth = tOverrideData.CustomStatusHealth * RandomFloat(1, tData.flMaxHealthFactor) * tData.flDifficultyFactor * tData.flWaveFactor ^ Rounds:GetRoundNumber()
		tOverrideData.Armor = tOverrideData.Armor * RandomFloat(1, tData.flMaxArmorFactor) * tData.flDifficultyFactor * tData.flWaveFactor ^ Rounds:GetRoundNumber()
		tOverrideData.AttackDamage = tOverrideData.AttackDamage * RandomFloat(1, tData.flMaxDamageFactor) * tData.flDifficultyFactor * tData.flWaveFactor ^ Rounds:GetRoundNumber()
		-- local tData = DIFFICULTY_ALL_ENEMY_SETTINGS[Clamp(self:GetDifficulty(), 1, #DIFFICULTY_ALL_ENEMY_SETTINGS)]
		-- tOverrideData.CustomStatusHealth = tOverrideData.CustomStatusHealth * (1 + (tonumber(tData[SETTING_EXTRA_HEALTH]) or 0) * 0.01)
		-- tOverrideData.Armor = tOverrideData.Armor * (1 + (tonumber(tData[SETTING_EXTRA_ARMOR]) or 0) * 0.01)
		-- tOverrideData.AttackDamage = tOverrideData.AttackDamage * (1 + (tonumber(tData[SETTING_EXTRA_ATTACK_DAMAGE]) or 0) * 0.01)
		tOverrideData.DamageReduction = SubtractionMultiplicationPercentage(tOverrideData.DamageReduction, tonumber(tData[SETTING_DAMAGE_REDUCTION]) or 0)
	end

	return tOverrideData
end

function public:GetDifficultyFactorData(sUnitName)
	local iDifficulty = self:GetDifficulty()
	local bIsNeutralUnitType = false
	if KeyValues.UnitsKv[sUnitName].IsNeutralUnitType then
		bIsNeutralUnitType = KeyValues.UnitsKv[sUnitName].IsNeutralUnitType == 1
	end
	return {
		flMaxDamageFactor = iDifficulty * 0.2 + 1.2,
		flMaxArmorFactor = iDifficulty * 0.2 + 1.2,
		flMaxHealthFactor = iDifficulty * 0.2 + 1.2,
		flDifficultyFactor = bIsNeutralUnitType and 1 or 1.5 ^ iDifficulty,
		flWaveFactor = bIsNeutralUnitType and 1 or 1 + 0.01 * iDifficulty,
		flEliteFactor = 1 + 0.01 * iDifficulty,
	}
end

---通过一个名字（物品名字、水池名字或水库名字）获取一个随机物品
---@param sName string 名字（物品名字、水池名字或水库名字）
---@param iPlayerID number 玩家ID，可选填，填写后会处理一些玩家特殊处理
---@return string
function public:GetRandomItemNameByName(sName, iPlayerID)
	if type(KeyValues.ItemsKv[sName]) == "table" then
		return sName
	else
		local sItemName = self:DrawReservoir(sName) or self:DrawPool(sName)

		if PlayerResource:IsValidPlayerID(iPlayerID) then
			-- 聚魂灯提高掉宝品质
			self:EachPlayer(function(iPlayerID, iTeamNumber, n)
				local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
				if Items:IsDevouredItem(hHero, "item_5_056") then
					local iRarity = tonumber(Items:GetRarity(sItemName))
					if iRarity ~= nil and iRarity < 3 then
						if Items:IsEquipmentType(sItemName) then
							sItemName = self:DrawPool("item_equipment_level_" .. tostring(iRarity + 1))
						elseif Items:IsAbilityBookType(sItemName) then
							sItemName = self:DrawPool("item_ability_book_level_" .. tostring(iRarity + 1))
						end
					end
					return true
				end
			end)
		end

		if type(KeyValues.ItemsKv[sItemName]) == "table" then
			return sItemName
		end
	end
end

--[[	监听
]]
--
-- 自定义事件：custom_npc_first_spawned
function public:OnNPCSpawned(tEvents)
	local hSpawnedUnit = EntIndexToHScript(tEvents.entindex)
	if not IsValid(hSpawnedUnit) then return end

	if hSpawnedUnit:GetUnitName() ~= "npc_dota_thinker" then
		if not hSpawnedUnit:HasAbility("unit_state") then
			hSpawnedUnit:AddAbility("unit_state")
		end
	end

	if not hSpawnedUnit.bIsNotFirstSpawn then
		hSpawnedUnit:SetPhysicalArmorBaseValue(0)
		hSpawnedUnit:SetBaseMagicalResistanceValue(0)
		hSpawnedUnit:SetBaseMaxHealth(10000)
		hSpawnedUnit:SetMaxHealth(10000)
		hSpawnedUnit:SetHealth(10000)
		hSpawnedUnit:SetBaseManaRegen(0)
		hSpawnedUnit:SetBaseHealthRegen(0)
		hSpawnedUnit:SetMaximumGoldBounty(0)
		hSpawnedUnit:SetMinimumGoldBounty(0)
		hSpawnedUnit:SetDeathXP(0)

		hSpawnedUnit.bIsNotFirstSpawn = true
		FireGameEvent("custom_npc_first_spawned", { entindex = hSpawnedUnit:entindex() })
	else
		if hSpawnedUnit:IsHero() then
			FireModifierEvent(MODIFIER_EVENT_ON_REBORN, {
				unit = hSpawnedUnit,
			}, hSpawnedUnit)
			if not hSpawnedUnit:GetContext("IsReincarnating") then
				self:Teleport(hSpawnedUnit, "back_point")
			end
		end
	end
end

function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()

	-- 游戏初始化
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then

	end
	-- 选择英雄
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local hBaseTargetInfo = Entities:FindByName(nil, "athena")
		if IsValid(hBaseTargetInfo) then
			local vPosition = hBaseTargetInfo:GetAbsOrigin()
			local vForward = hBaseTargetInfo:GetForwardVector()
			local hBase = CreateUnitByName("athena", vPosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
			if not IsValid(hBase) then
				return
			end
			-- hBase:SetControllableByPlayer(0, true)
			hBase:SetForwardVector(vForward)
			self.tTeamBase[DOTA_TEAM_GOODGUYS] = hBase
			CustomNetTables:SetTableValue("common", "scan_data", {
				level = self.tTeamBase[DOTA_TEAM_GOODGUYS]:GetLevel(),
				max_level = ATHENA_MAX_LEVEL,
				cost = ATHENA_UPGRADE_BASE_GOLD + (self.tTeamBase[DOTA_TEAM_GOODGUYS]:GetLevel() - 1) * ATHENA_UPGRADE_GOLD_PER_LEVEL,
			})
			hBase:SetUnitCanRespawn(true)
			hBase:AddNewModifier(hBase, nil, "modifier_base", nil)
			for i = 0, hBase:GetAbilityCount() - 1, 1 do
				local hAbility = hBase:GetAbilityByIndex(i)
				if IsValid(hAbility) and hAbility ~= hBase:GetDummyAbility() then
					hAbility:SetLevel(0)
					if hAbility:GetToggleState() then
						hAbility:ToggleAbility()
					end
					if hAbility:GetAutoCastState() then
						hAbility:ToggleAutoCast()
					end
					hBase:RemoveModifierByName(hAbility:GetIntrinsicModifierName() or "")
				end
			end
			hBase:StartGesture(ACT_DOTA_IDLE)
			hBase:FindAbilityByName("athena_heal"):SetLevel(1)
			hBase:FindAbilityByName("athena_guard"):SetLevel(1)
		end
		local t = {}
		self:EachPlayer(function(iPlayerID, iTeamNumber, n)
			t[iPlayerID] = {
				iPossibleDifficulty = self.iDifficulty,
				iPossibleMode = self.iMode,
			}
		end)
		self.tHeroSelection = {
			fEndTime = GameRules:GetGameTime() + HERO_SELECTION_TIME,
			tPlayerSelection = t,
		}
		CustomNetTables:SetTableValue("common", "hero_selection", self.tHeroSelection)

		GameTimer(HERO_SELECTION_TIME, function()
			self:EachPlayer(function(iPlayerID, iTeamNumber, n)
				if not PlayerResource:HasSelectedHero(iPlayerID) then
					local hPlayer = PlayerResource:GetPlayer(iPlayerID)
					if IsValid(hPlayer) then
						hPlayer:MakeRandomHeroSelection()
					end
				end
			end)
		end)
	end
	-- 策略时间
	if state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	end
	-- 准备阶段
	if state == DOTA_GAMERULES_STATE_PRE_GAME then
		if type(self.tHeroSelection) == "table" and type(self.tHeroSelection.tPlayerSelection) == "table" then
			local tDifficultySelection = {}
			for iPlayerID, tData in pairs(self.tHeroSelection.tPlayerSelection) do
				tDifficultySelection[tData.iPossibleDifficulty] = (tDifficultySelection[tData.iPossibleDifficulty] or 0) + 1
			end
			local iMax
			local iResultDifficulty
			for iDifficulty, i in pairs(tDifficultySelection) do
				if iMax == nil or i > iMax or (i == iMax and iResultDifficulty > iDifficulty) then
					iMax = i
					iResultDifficulty = iDifficulty
				end
			end
			print("难度结果：", iResultDifficulty, iMax)

			if iResultDifficulty ~= nil then
				self.iDifficulty = iResultDifficulty
			end
			self:EachPlayer(function(iPlayerID, iTeamNumber, n)
				PlayerData:ModifyGold(iPlayerID, DIFFICULTY_INIT_GOLD[self.iDifficulty])
			end)
			GameRules:SetCustomGameDifficulty(self.iDifficulty)
		end
	end
	-- 游戏开始
	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SetTimeOfDay(0.26)
		-- 每秒事件
		GameTimer(1, function()
			-- 自动接任务
			self:EachPlayer(function(iPlayerID, iTeamNumber, n)
				Task:StartTask(iPlayerID, "KillPracticer")
			end)
			local iHour = GetDayTime()
			FireGameEvent("custom_time_event", {
				tick_time = 1,
			})
			FireModifierEvent(MODIFIER_EVENT_ON_TICK_TIME, {
				tick_time = 1,
			})
			return 1
		end)
		-- 每分事件
		GameTimer(60, function()
			FireGameEvent("custom_time_event", {
				tick_time = 60,
			})
			FireModifierEvent(MODIFIER_EVENT_ON_TICK_TIME, {
				tick_time = 60,
			})
			return 60
		end)
	end
end

function public:OnNPCFirstSpawned(tEvents)
	---@type CDOTA_BaseNPC
	local hSpawnedUnit = EntIndexToHScript(tEvents.entindex)
	if not IsValid(hSpawnedUnit) then return end

	if hSpawnedUnit:GetUnitName() == "npc_dota_thinker" then
		return
	end

	local tData = KeyValues.UnitsKv[hSpawnedUnit:GetUnitName()]
	if tData ~= nil and tData.Modifiers ~= nil and tData.Modifiers ~= "" then
		local tList = string.split(string.gsub(tData.Modifiers, " ", ""), "|")
		for i, sModifierName in pairs(tList) do
			hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), sModifierName, nil)
		end
	end
	if tData ~= nil and tData.SpawnModifier ~= nil and tData.SpawnModifier ~= "" then
		hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), tData.SpawnModifier, nil)
	end

	if tonumber(KeyValues:GetUnitData(hSpawnedUnit, "IsCustomNPC")) ~= 1 and hSpawnedUnit:GetClassname() ~= "ent_dota_halloffame" then
		hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), "modifier_common", nil)
		if hSpawnedUnit:IsRealHero() then
			hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), "modifier_attribute", nil)
		end
	else
		hSpawnedUnit:SetHasInventory(true)
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:AddItemByName("item_dialog_event")
		hSpawnedUnit:SetHasInventory(false)
	end

	if hSpawnedUnit:IsRealHero() and not hSpawnedUnit:IsIllusion() and not hSpawnedUnit:IsSummoned() then
		hSpawnedUnit:AddPermanentAttribute(CUSTOM_ATTRIBUTE_GOLD_PER_SEC, DIFFICULTY_GOLD_TICK[self.iDifficulty])
		local iPlayerID = hSpawnedUnit:GetPlayerOwnerID()
		if not IsValid(self.tPlayerCourier[iPlayerID]) then
			local sCourierIndex = self:DrawPool("courier")
			local tData = {
				MapUnitName = "npc_courier",
				Model = KeyValues.CouriersKV[sCourierIndex].Model,
				teamnumber = hSpawnedUnit:GetTeamNumber(),
				vscripts = "units/common.lua",
				iOwnerIndex = hSpawnedUnit:entindex(),
				IsSummoned = "1",
				CustomStatusHealth = 1000
			}
			local hCourier = hSpawnedUnit:SummonUnit("npc_courier", GetRespawnPosition() + RandomVector(150), true, nil, tData)
			-- local hCourier = CreateUnitFromTable(tData, GetRespawnPosition() + RandomVector(150))
			-- local hCourier = CreateUnitByName("npc_courier", GetRespawnPosition() + RandomVector(150), true, hSpawnedUnit, hSpawnedUnit, hSpawnedUnit:GetTeamNumber())
			hCourier:SetControllableByPlayer(hSpawnedUnit:GetPlayerOwnerID(), true)
			self.tPlayerCourier[iPlayerID] = hCourier
			hCourier:AddNewModifier(hCourier, nil, "modifier_courier", nil)
			if not hCourier:HasItemInInventory("item_back") then
				hCourier:AddItemByName("item_back")
			end
			if not hCourier:HasItemInInventory("item_training") then
				hCourier:AddItemByName("item_training")
			end
			-- 创建信使特效
			local AmbientParticle = KeyValues.CouriersKV[sCourierIndex].AmbientParticle
			if KeyValues.CouriersKV[sCourierIndex].AmbientParticle then
				local iAttachType = AssetModifiers.ATTACH_TYPE[AmbientParticle.attach_type]
				local iParticleID = ParticleManager:CreateParticle(AmbientParticle.system, iAttachType, hCourier)
				if AmbientParticle.control_points then
					for i, tControlPoint in pairs(AmbientParticle.control_points) do
						ParticleManager:SetParticleControlEnt(iParticleID, tonumber(tControlPoint.control_point_index), hCourier, AssetModifiers.ATTACH_TYPE[tControlPoint.attach_type], tControlPoint.attachment, hCourier:GetAbsOrigin(), false)
					end
				end
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
		self.tPlayerCourier[iPlayerID]:SetOwner(hSpawnedUnit)

		-- hSpawnedUnit:SetStashEnabled(false)
		hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), "modifier_hero_attribute", nil)
		-- 孤胆英雄
		if Game:GetPlayerCount(DOTA_TEAM_GOODGUYS) == 1 then
			hSpawnedUnit:AddNewModifier(hSpawnedUnit, hSpawnedUnit:GetDummyAbility(), "modifier_singlehero", nil)
		end
		-- hSpawnedUnit:SetAbilityPoints(0)
		if not hSpawnedUnit:HasItemInInventory("item_back") then
			hSpawnedUnit:AddItemByName("item_back")
		end
		if not hSpawnedUnit:HasItemInInventory("item_training") then
			hSpawnedUnit:AddItemByName("item_training")
		end
		if not hSpawnedUnit:HasItemInInventory("item_hercules_1") then
			hSpawnedUnit:AddItemByName("item_hercules_1")
		end
		local hAbility = hSpawnedUnit:GetAbilityByIndex(0)
		hAbility:SetLevel(1)

		----------------------------------------游戏内容相关----------------------------------------
		-- 道具
		EachPlayerGameplay(iPlayerID, function(tItemData)
			if tItemData.ItemName == "potion" then	-- 药水礼包
				local clarity = CreateItem("item_clarity1", nil, self.tPlayerCourier[iPlayerID])
				local salve = CreateItem("item_salve1", niil, self.tPlayerCourier[iPlayerID])
				self.tPlayerCourier[iPlayerID]:AddItem(clarity)
				self.tPlayerCourier[iPlayerID]:AddItem(salve)
				clarity:SetCurrentCharges(30)
				salve:SetCurrentCharges(30)
			end
		end)
		-- 特效
		EachEquippedParticles(iPlayerID, function(tItemData)
			-- 清除旧的
			if hSpawnedUnit.ParticleModifier then
				if type(hSpawnedUnit.ParticleModifier) == "number" then
					ParticleManager:DestroyParticle(hSpawnedUnit.ParticleModifier, false)
				else
					hSpawnedUnit.ParticleModifier:Destroy()
				end
			end
			if tItemData.ItemName == "wing_01" then	-- 金色翅膀
				if hSpawnedUnit:GetUnitName() == "npc_dota_hero_nevermore" then
					hSpawnedUnit.ParticleModifier = ParticleManager:CreateParticle("particles/wings/wing_sf_goldsky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hSpawnedUnit)
				else
					hSpawnedUnit.ParticleModifier = ParticleManager:CreateParticle("particles/skills/wing_sky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hSpawnedUnit)
				end
			end
			local Asset = GetItemInfo(tItemData.ItemName).Asset
			if Asset then
				hSpawnedUnit.ParticleModifier = hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, Asset, nil)
			end
		end)
		-- 皮肤
		local tSkinData = GetEquippedSkin(iPlayerID, hSpawnedUnit:GetUnitName())
		if tSkinData then
			hSpawnedUnit.gift = true	--待完善
			-- 新方法
			hSpawnedUnit:GameTimer(0.1, function()
				-- AssetModifiers:ReplaceWearables(tItemData.ItemName, heroEntity)
				hSpawnedUnit:AddNewModifier(hSpawnedUnit, nil, "modifier_" .. tSkinData.ItemName, nil)
			end)
		end
		-- 宠物
		local tCourierData = GetEquippedCourier(iPlayerID)
		if tCourierData then
			hSpawnedUnit:GameTimer(1, function()
				hSpawnedUnit.pet = NewPet(tCourierData.ItemName, hSpawnedUnit, tonumber(tCourierData.Experience))
			end)
		end
		-- 其他
		-- local tOther = EachPlayerOther(iPlayerID, function(tItemData)
		-- 	if tItemData.ItemName == "vip" then
		-- 		CustomUI:DynamicHud_Create(iPlayerID, "VipParticleBackGround", "file://{resources}/layout/custom_game/custom_hud/vip_particle.xml", nil)
		-- 	end
		-- end)
	end
end

function public:OnEntityKilled(tEvents)
	local hKilledUnit = EntIndexToHScript(tEvents.entindex_killed)
	if not IsValid(hKilledUnit) then return end

	if hKilledUnit:GetUnitName() == "zeus_reborn" and not IsInToolsMode() then
		Notification:Upper({
			message = "宙斯炸了，60秒后退出游戏。",
		})
		GameTimer(60, function()
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		end)
		if IsDedicatedServer() then
			Game:EachPlayer(function(iPlayerID)
				local hPlayer = PlayerResource:GetPlayer(iPlayerID)
				if IsValid(hPlayer) then
					print("game_over win: player", iPlayerID)
					player:game_over(iPlayerID, true)
				end
			end)
		end
	end

	local hKiller = EntIndexToHScript(tEvents.entindex_attacker)
	local iBountyPlayerID = -1
	if IsValid(hKiller) and hKiller ~= hKilledUnit then
		iBountyPlayerID = tonumber(hKilledUnit.iKillerPlayerID) or -1
		if iBountyPlayerID == -1 then
			iBountyPlayerID = hKiller:GetPlayerOwnerID()
		end
	end

	if iBountyPlayerID ~= -1 then
		local iGold = (tonumber(KeyValues:GetUnitData(hKilledUnit, "BountyGold")) or 0) * (1 + GetPlayerKillGoldPercent(iBountyPlayerID) * 0.01)
		if iGold > 0 then
			PlayerData:ModifyGold(iBountyPlayerID, iGold)
			SendOverheadEventMessage(PlayerResource:GetPlayer(iBountyPlayerID), OVERHEAD_ALERT_GOLD, hKilledUnit, iGold, hKilledUnit:GetPlayerOwner())
		end

		local iCrystal = tonumber(KeyValues:GetUnitData(hKilledUnit, "BountyCrystal")) or 0
		if iCrystal > 0 then
			PlayerData:ModifyCrystal(iBountyPlayerID, iCrystal)

			local hPlayer = PlayerResource:GetPlayer(iBountyPlayerID)
			if IsValid(hPlayer) then
				local iParticleID = ParticleManager:CreateParticleForPlayer("particles/generic_gameplay/lasthit_crystal_local.vpcf", PATTACH_CUSTOMORIGIN, nil, hPlayer)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, hKilledUnit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hKilledUnit:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iParticleID)

				local iNumber = math.ceil(iCrystal)
				local vColor = Vector(215, 160, 229)
				local fDuration = 2
				local iParticleID = ParticleManager:CreateParticleForPlayer("particles/msg_fx/msg_goldbounty.vpcf", PATTACH_CUSTOMORIGIN, nil, hPlayer)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hKilledUnit, PATTACH_OVERHEAD_FOLLOW, nil, hKilledUnit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(0, iNumber, 0))
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(fDuration, #tostring(iNumber) + 1, 0))
				ParticleManager:SetParticleControl(iParticleID, 3, vColor)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end

		local iScore = GetPlayerKillScore(iBountyPlayerID)
		if iScore > 0 then
			PlayerData:ModifyScore(iBountyPlayerID, iScore)
		end

		local hHero = PlayerResource:GetSelectedHeroEntity(iBountyPlayerID)
		if IsValid(hHero) then
			if hHero:GetLevel() < (hHero:GetRebornTimes() + 1) * 100 then
				local iXP = (tonumber(KeyValues:GetUnitData(hKilledUnit, "BountyXP")) or 0) * (1 + GetPlayerExperienceGainPercent(iBountyPlayerID) * 0.01)
				if iXP > 0 then
					FireGameEvent("custom_exp_change", {
						entindex = hHero:entindex()
					})
					hHero:AddExperience(iXP, DOTA_ModifyXP_Unspecified, false, false)
				end
			end
		end

		-- 击杀掉落
		for i = 1, 10 do
			local sKey = "DropItem" .. tostring(i)
			local s = KeyValues:GetUnitData(hKilledUnit, sKey)
			if type(s) == "string" then
				s = string.gsub(s, "%s", "")
				local a = string.split(s, ",")
				-- particles/items_fx/general_item_drop_lvl_5.vpcf
				local fChance = tonumber(a[1]) or 0
				local sName = a[2]
				local bNoExtraChance = a[3] == "false"
				if not bNoExtraChance then
					fChance = fChance * (1 + GetPlayerDropChancePercent(iBountyPlayerID) * 0.01)
				end
				if RandomFloat(0, 100) <= fChance then
					local sItemName = self:GetRandomItemNameByName(sName, iBountyPlayerID)
					if sItemName ~= nil then
						local vPosition = hKilledUnit:GetAbsOrigin() + RandomVector(RandomInt(0, 50))
						-- local hPhysicalItem = Items:DropItem(-1, sItemName, vPosition)
						local hItem = CreateItem(sItemName, nil, nil)
						local drop = CreateItemOnPositionSync(hKilledUnit:GetAbsOrigin(), hItem)
						local bAutoCast = KeyValues.ItemsKv[sItemName].ItemCastOnPickup == 1
						hItem:LaunchLoot(bAutoCast, 200, 0.75, vPosition)
						-- if IsValid(hPhysicalItem) then
						-- 	local sRarity = Items:GetRarity(sItemName)
						-- 	if sRarity then
						-- local iParticleID = ParticleManager:CreateParticle("particles/items_fx/general_item_drop_lvl_" .. sRarity .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, hPhysicalItem)
						-- ParticleManager:ReleaseParticleIndex(iParticleID)
						-- 	end
						-- end
					end
				end
			end
		end
	end

	if self.tTeamBase[DOTA_TEAM_GOODGUYS] == hKilledUnit then
		if IsInToolsMode() then
			Notification:Combat({
				message = "家炸了，但是你活下来了。",
			})
			return
		end
		Notification:Upper({
			message = "雅典娜炸了，60秒后退出游戏。",
		})
		GameTimer(60, function()
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end)
	end
end

---监听玩家英雄升级
---@param tEvents {player:number,player_id:number,PlayerID:number,game_event_listener:number,game_event_name:number,hero_entindex:number,level:number,splitscreenplayer:number}
function public:OnPlayerLevelUp(tEvents)
	local iLevel = tEvents.level
	local hHero = EntIndexToHScript(tEvents.hero_entindex)
	---额外成长
	if hHero:IsRealHero() then
		hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, GetBonusStrengthGain(hHero))
		hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_AGILITY, GetBonusAgilityGain(hHero))
		hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT, GetBonusIntellectGain(hHero))
		-- hHero:SetAbilityPoints(0)
	end
	if hHero:GetLevel() % 100 == 0 and hHero:GetLevel() ~= 500 then
		Task:StartTask(tEvents.player_id, "Reborn")
		if hHero._RebornParticle == nil then
			local iParticleID = ParticleManager:CreateParticleForPlayer("particles/econ/events/spring_2021/teleport_end_spring_2021.vpcf", PATTACH_CUSTOMORIGIN, nil, PlayerResource:GetPlayer(tEvents.player_id))
			ParticleManager:SetParticleControl(iParticleID, 0, Vector(6656, -6464, 393))
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(6656, -6464, 393))
			hHero._RebornParticle = iParticleID
		end
	end

	-- 1-8技能给技能点，之后每3级给一个技能点
	local iTotalPoints = hHero:GetAbilityPoints() + default(hHero._iAbilityPointsUsed, 0)
	if ((iLevel < 8 and iLevel or 8) + math.modf(math.max(0, iLevel - 8) / 3)) > iTotalPoints then
		hHero:SetAbilityPoints(hHero:GetAbilityPoints() + 1)
	elseif ((iLevel < 8 and iLevel or 8) + math.modf(math.max(0, iLevel - 8) / 3)) < iTotalPoints then
		hHero:SetAbilityPoints(hHero:GetAbilityPoints() - 1)
	end
end
---监听玩家升级技能
---@param tEvents {player:number,abilityname:string,PlayerID:number,game_event_listener:number,game_event_name:number,splitscreenplayer:number}
function public:OnPlayerLearnedAbility(tEvents)
	local hHero = PlayerResource:GetSelectedHeroEntity(tEvents.PlayerID)
	hHero._iAbilityPointsUsed = default(hHero._iAbilityPointsUsed, 0) + 1
end

---监听玩家连接并处罚自定义玩家出生于连接事件
---@param tEvents {game_event_name: string, PlayerID: number, index: number, game_event_listener: number, userid: number, splitscreenplayer: number}
function public:OnPlayerConnectFull(tEvents)
	if self.tPlayerInfo[tEvents.PlayerID] == nil then
		FireGameEvent("custom_player_first_spawned", { PlayerID = tEvents.PlayerID, userid = tEvents.userid })
	else
		FireGameEvent("custom_player_reconnect", { PlayerID = tEvents.PlayerID, userid = tEvents.userid })
	end
	self.tPlayerInfo[tEvents.PlayerID] = {
		PlayerID = tEvents.PlayerID,
		userid = tEvents.userid,
	}
end

---OnTriggerStartTouch
---@param event {trigger_name: string, activator_entindex: short, caller_entindex: short}
function public:OnTriggerStartTouch(event)
	local hUnit = EntIndexToHScript(event.activator_entindex)
	local hTriggerEntity = EntIndexToHScript(event.caller_entindex)
	-- 传送到转生
	if hTriggerEntity:GetName() == "hero_reborn" and hUnit:IsRealHero() then
		if Task:GetPlayerTaskState(hUnit:GetPlayerOwnerID(), "Reborn") == TASK_STATE_TYPE_PROGRESS then
			Game:Teleport(hUnit, "6080,6920,384")
		end
	end
end
---OnTriggerEndTouch
---@param event {trigger_name: string, activator_entindex: short, caller_entindex: short}
function public:OnTriggerEndTouch(event)
	local hUnit = EntIndexToHScript(event.activator_entindex)
	local hTriggerEntity = EntIndexToHScript(event.caller_entindex)
	if hUnit ~= nil then
	end
end

--[[	UI事件
]]
function public:OnDifficultySelected(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local iDifficulty = tEvents.difficulty
	if type(self.tHeroSelection) == "table" and type(self.tHeroSelection.tPlayerSelection) == "table" and type(self.tHeroSelection.tPlayerSelection[iPlayerID]) == "table" then
		self.tHeroSelection.tPlayerSelection[iPlayerID].iPossibleDifficulty = iDifficulty
		CustomNetTables:SetTableValue("common", "hero_selection", self.tHeroSelection)
	end
end
function public:OnHeroSelected(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local sUnitName = tEvents.unit_name
	PlayerResource:GetPlayer(iPlayerID):SetSelectedHero(sUnitName)
	-- PlayerResource:ReplaceHeroWith(iPlayerID, sUnitName, 0, 0)
end
--
function public:OnTalentSelection(iEventSourceIndex, tEvents)
	if IsClient() then return end
	local iPlayerID = tEvents.PlayerID
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local sTalentName = tEvents.ability_name
	hHero:AddAbility(sTalentName, 1)
	hHero:SwapAbilities("talent", sTalentName, false, true)
	hHero:RemoveAbility("talent")
	CustomNetTables:SetTableValue("selection", "talent" .. iPlayerID, {})
end

function public:OnSwapAbilities(iEventSourceIndex, tEvents)
	local hAbility1 = EntIndexToHScript(tEvents.ability_index_1)
	local hAbility2 = EntIndexToHScript(tEvents.ability_index_2)
	if IsValid(hAbility1) and IsValid(hAbility2) then
		local hCaster = hAbility1:GetCaster()
		local _hCaster = hAbility2:GetCaster()
		if IsValid(hCaster) and IsValid(_hCaster) and hCaster == _hCaster then
			hCaster:SwapAbilities(hAbility1:GetAbilityName(), hAbility2:GetAbilityName(), not hAbility1:IsHidden(), not hAbility2:IsHidden())
		end
	end
end

function public:OnDeleteAbility(iEventSourceIndex, tEvents)
	local hAbility = EntIndexToHScript(tEvents.ability_index)
	if IsValid(hAbility) then
		print(hAbility:GetAbilityName(), tEvents.ability_index)
		local hCaster = hAbility:GetCaster()
		if IsValid(hCaster) then
			for i = 1, 4 do
				local sEmptyAbilityName = "empty_" .. i
				if not hCaster:HasAbility(sEmptyAbilityName) then
					hCaster:AddAbility(sEmptyAbilityName)
					hCaster:SwapAbilities(hAbility:GetAbilityName(), sEmptyAbilityName, false, true)
					hCaster:RemoveAbilityByHandle(hAbility)
					break
				end
			end
		end
	end
end

function public:OnActiveGlyph(iEventSourceIndex, tEvents)
	CustomNetTables:SetTableValue("common", "glyph_cooldown", {
		fStartTime = GameRules:GetGameTime(),
		fEndTime = GameRules:GetGameTime() + GLYPH_COOLDOWN,
	})
	self.tTeamBase[DOTA_TEAM_GOODGUYS]:AddNewModifier(self.tTeamBase[DOTA_TEAM_GOODGUYS], nil, "modifier_base_invulnerable", { duration = 60 })
end

function public:OnActiveScan(iEventSourceIndex, tEvents)
	local hBase = self.tTeamBase[DOTA_TEAM_GOODGUYS]
	local iPlayerID = tEvents.PlayerID
	if hBase:GetLevel() < ATHENA_MAX_LEVEL then
		local iCost = ATHENA_UPGRADE_BASE_GOLD + (hBase:GetLevel() - 1) * ATHENA_UPGRADE_GOLD_PER_LEVEL
		if PlayerData:GetGold(iPlayerID) >= iCost then
			PlayerData:ModifyGold(iPlayerID, -iCost)
			hBase:CreatureLevelUp(1)
			hBase:FindModifierByName("modifier_base"):ForceRefresh()
			CustomNetTables:SetTableValue("common", "scan_data", {
				level = hBase:GetLevel(),
				max_level = ATHENA_MAX_LEVEL,
				cost = iCost,
			})
			EmitSoundForPlayer("General.Buy", iPlayerID)
			local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if IsValid(hHero) then
				local iValue = RandomInt(10, 50 + hBase:GetLevel()) / 10
				hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, iValue)
				Notification:Combat({
					message = "Combat_TowerUpgrade",
					player_id = iPlayerID,
					int_value = iValue
				})
			end
			local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10.vpcf", PATTACH_ABSORIGIN_FOLLOW, hBase)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			hBase:EmitSound("ui.badge_levelup")
		else
			ErrorMessage(iPlayerID, "dota_hud_error_not_enough_gold")
		end
	end
end

return public