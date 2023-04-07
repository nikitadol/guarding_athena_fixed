if AbilityUpgrades == nil then
	AbilityUpgrades = class({})
end

local public = AbilityUpgrades

-- 技能升级操作方式
ABILITY_UPGRADES_OP_ADD = 1
ABILITY_UPGRADES_OP_MUL = 2

ABILITY_UPGRADES_TYPE_SPECIAL_VALUE = 1 -- 修改技能数值
ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY = 2 -- 修改技能数值附加值
ABILITY_UPGRADES_TYPE_STATS = 3 -- 修改属性
ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS = 4 -- 给技能添加新效果，并且附带新键值（或覆盖原键值）
ABILITY_UPGRADES_TYPE_ADD_ABILITY = 5 -- 增加技能

UPGRADES_KEY_DATA = 1
UPGRADES_KEY_CACHED_RESULT = 2

-- 可以添加的属性
ABILITY_UPGRADES_STATS_LIST = {
	"auto_mana_regen"							, -- 魔法恢复
	"auto_mana"									, -- 魔法
	"auto_bonus_kill"							, -- 额外杀敌
	"auto_fishing_crit_chance"					, -- 钓鱼暴击几率
	"auto_physical_damage_again_pct"			, -- 物理伤害再次提升
	"auto_magical_damage_directly_pct"			, -- 法术伤害直接提升
	"auto_crit_damage_again_pct"				, -- 暴击伤害再次提升
	"auto_damage_outgoing_pct"					, -- 所有伤害
	"auto_resource_pct"							, -- 资源获取
	"auto_movespeed_pct"						, -- 移动速度提升
	"auto_health_regen_pct"						, -- 生命回复
	"auto_health"								, -- 生命
	"auto_magical_damage_again_pct"				, -- 法术伤害再次提升
	"auto_magical_crit_damage_again_pct"		, -- 法术暴击伤害再次提升
	"auto_magical_lifesteal_pct"				, -- 法术吸血
	"auto_magical_damage_pct"					, -- 法术伤害
	"auto_magical_crit_chance"					, -- 法暴几率
	"auto_magical_crit_damage"					, -- 法暴伤害
	"auto_gold_per_sec"							, -- 每秒金币
	"auto_health_per_sec"						, -- 每秒生命
	"auto_soul_per_sec"							, -- 每秒灵魂值
	"auto_kill_per_sec"							, -- 每秒杀敌数
	"auto_attack_per_sec"						, -- 每秒攻击
	"auto_armor_per_sec"						, -- 每秒护甲
	"auto_all_attribute_per_sec"				, -- 每秒全属性
	"auto_health_per_min"						, -- 每分钟生命
	"auto_intellect_per_min"					, -- 每分钟智力
	"auto_attack_damage_pct_per_min"			, -- 每分钟攻击伤害
	"auto_magical_damage_pct_per_min"			, -- 每分钟法术伤害
	"auto_all_attribute_per_min"				, -- 每分钟全属性
	"auto_final_damage_pct"						, -- 最终增伤
	"auto_crit_chance"							, -- 暴击几率
	"auto_crit_damage"							, -- 暴击伤害
	"auto_strength"								, -- 力量
	"auto_agility"								, -- 敏捷
	"auto_intellect"							, -- 智力
	"auto_attack_rate"							, -- 攻击间隔
	"auto_evade"								, -- 闪避
	"auto_attack_damage_again_pct"				, -- 攻击造成的伤害再次提升
	"auto_attackspeed"							, -- 攻击速度`
	"auto_attackrange"							, -- 攻击距离
	"auto_attack_health"						, -- 攻击生命
	"auto_attack_attack"						, -- 攻击攻击
	"auto_attack_lifesteal"						, -- 攻击吸血
	"auto_attack_armor_reduce_pct"				, -- 攻击减甲的效果提升
	"auto_attack_armor_reduce"					, -- 攻击减甲
	"auto_attack_all_attribute"					, -- 攻击全属性
	"auto_attack_damage_pct"					, -- 攻击伤害
	"auto_attack"								, -- 攻击
	"auto_drop_chance"							, -- 掉宝加成
	"auto_dig_crit_chance"						, -- 挖宝暴击几率
	"auto_armor"								, -- 护甲
	"auto_respawn_time"							, -- 复活时间
	"auto_damage_incoming_pct"					, -- 受到的伤害
	"auto_cleave_radius"						, -- 分裂范围
	"auto_cleave_damage"						, -- 分裂伤害
	"auto_cooldown_reduction"					, -- 冷却缩减
	"auto_all_lifesteal"						, -- 全能吸血
	"auto_all_attribute"						, -- 全属性
	"auto_damage_ignore"						, -- 伤害忽视
	"auto_final_damage_reduce_pct"				, -- 伤害减免
	"auto_avoid_chance"							, -- 伤害免伤
}

-- 特殊属性的计算公式
ABILITY_UPGRADES_STATS_SETTLE = {
	["bonus_evasion"] = SubtractionMultiplicationPercentage,
	["bonus_status_resist"] = SubtractionMultiplicationPercentage,
	["bonus_debuff_amplify"] = AdditionMultiplicationPercentage,
}

-- 压缩字符串列表
local zip_list = {
	"type",
	"unit_name",
	"ability_name",
	"pre_ability_upgrade",
	"value",
	"special_value_name",
	"special_value_property",
	"operator",
	"values",
	"description",
	"level",
	"max_count",
	"pools_type",
	"rarity",
}

local aPropertyNames = {
	"LinkedSpecialBonus",
	"LinkedSpecialBonusField",
	"LinkedSpecialBonusOperation",
	"CalculateSpellDamageTooltip",
	"RequiresScepter",
	"levelkey",
	"_str",
	"_int",
	"_agi",
	"_all",
	"_attack_damage",
	"_attack_speed",
	"_health",
	"_armor",
	"_magical_armor",
	"_mana",
	"_max",
	"_min",
	"_move_speed",
}

function public:init(bReload)
	if not bReload then
	end

	if IsServer() then
		self.tAbilityUpgrades = {}
		for k, v in pairs(KeyValues.AbilityUpgradesKvs) do
			local t = deepcopy(v)
			t.type = _G[t.type]
			if t.operator ~= nil then
				t.operator = _G[t.operator]
			end
			if type(t.value) == "number" then
				t.value = Round(t.value, 5)
			end
			local tAbilitySpecial = t.AbilitySpecial
			if type(tAbilitySpecial) == "table" then
				t.values = {}
				for _, tSpecial in pairs(tAbilitySpecial) do
					local key
					local bOnlyValue = true
					for _k, _v in pairs(tSpecial) do
						if TableFindKey(aPropertyNames, _k) == nil and _k ~= "var_type" then
							key = _k
							if type(_v) == "number" then
								t.values[key] = {
									value = Round(_v, 5),
								}
							else
								t.values[key] = {
									value = _v,
								}
							end
							break
						end
					end
					for _k, _v in pairs(tSpecial) do
						if TableFindKey(aPropertyNames, _k) ~= nil then
							bOnlyValue = false
							if type(_v) == "number" then
								t.values[key][_k] = Round(_v, 5)
							else
								t.values[key][_k] = _v
							end
						end
					end
					if bOnlyValue then
						t.values[key] = t.values[key].value
					end
				end
			end
			t.AbilitySpecial = nil
			t.id = k
			self.tAbilityUpgrades[k] = t
		end

		GameEvent("custom_entity_removed", Dynamic_Wrap(public, "OnEntityRemoved"), public)

		CustomUIEvent("ability_upgrades_reward_selection", Dynamic_Wrap(public, "OnAbilityUpgradesRewardSelection"), public)

		if GameRules:IsCheatMode() then
			CustomUIEvent("demo_remove_ability_upgrade_by_index", function(iEventSourceIndex, tEvents)
				local iPlayerID = tEvents.PlayerID
				local hUnit = EntIndexToHScript(tEvents.entindex)
				if IsValid(hUnit) and hUnit:IsControllableByAnyPlayer() then
					-- print(tEvents.index)
					self:RemoveAbilityUpgradesByIndex(hUnit, tEvents.index)
				end
			end)
			Convars:RegisterCommand("debug_draw_ability_upgrades", function(cmd, iEntIndex, sPoolsType)
				self:DrawAbilityUpgrades(EntIndexToHScript(tonumber(iEntIndex)), sPoolsType)
			end, "draw ability upgrades.", FCVAR_CHEAT)
		end
	end
end

function public:UpdateDrawAbilityUpgradesNetTable(hUnit)
	assert(IsServer())

	local sKeys = CustomNetTables:GetAllTableKeys("ability_upgrades_selection")

	for i = #sKeys, 1, -1 do
		local iEntIndex = tonumber(sKeys[i])
		if not IsValid(EntIndexToHScript(iEntIndex)) then
			CustomNetTables:SetTableValue("ability_upgrades_selection", sKeys[i], {})
		end
	end

	if IsValid(hUnit) then
		if hUnit.tDrawAbilityUpgradesList == nil or #hUnit.tDrawAbilityUpgradesList == 0 then
			CustomNetTables:SetTableValue("ability_upgrades_selection", tostring(hUnit:entindex()), {})
		else
			CustomNetTables:SetTableValue("ability_upgrades_selection", tostring(hUnit:entindex()), hUnit.tDrawAbilityUpgradesList)
		end
	end
end

function public:UpdateAbilityUpgradesNetTables(hUnit, tData)
	assert(IsServer())

	local tKeys = CustomNetTables:GetAllTableKeys("ability_upgrades_list")

	for i = #tKeys, 1, -1 do
		local iEntIndex = tonumber(tKeys[i])
		if not IsValid(EntIndexToHScript(iEntIndex)) then
			CustomNetTables:SetTableValue("ability_upgrades_list", tKeys[i], nil)
			CustomNetTables:SetTableValue("ability_upgrades_result", tKeys[i], nil)
		end
	end

	if IsValid(hUnit) then
		if tData == nil then
			CustomNetTables:SetTableValue("ability_upgrades_list", tostring(hUnit:entindex()), nil)
			CustomNetTables:SetTableValue("ability_upgrades_result", tostring(hUnit:entindex()), nil)
		else
			local tUpgrades = tData[UPGRADES_KEY_DATA]
			local str = json.encode(self:zip(tUpgrades))
			str = string.gsub(str, "null", "*")
			CustomNetTables:SetTableValue("ability_upgrades_list", tostring(hUnit:entindex()), { json = str })
			-- print(#str)
			local tCachedResult = tData[UPGRADES_KEY_CACHED_RESULT]
			CustomNetTables:SetTableValue("ability_upgrades_result", tostring(hUnit:entindex()), { json = json.encode(tCachedResult) })
			-- print(#(json.encode(tCachedResult)))
		end
	end
end

function public:GetUnitAbilityUpgradesList(hUnit, sPoolsType, sRarity)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return {}
	end

	if hUnit.tAbilityUpgradesCount == nil then
		hUnit.tAbilityUpgradesCount = {}
	end

	local list = {}
	local sUnitName = hUnit:GetUnitName()
	for sID, tData in pairs(self.tAbilityUpgrades) do
		-- TODO:移除技能池限制
		-- if tData.pools_type ~= sPoolsType then
		-- 	goto continue
		-- end
		if tData.rarity ~= sRarity then
			goto continue
		end
		if tData.pre_ability_upgrade ~= nil then
			local bool = parse_conditional(tData.pre_ability_upgrade, function(str)
				local b = string.find(str, "!") == nil
				str = string.gsub(str, "!", "")
				local a = string.split(str, ",")
				local id
				local count
				if #a == 1 then
					id = str
					count = 1
				else
					id = tostring(a[1])
					count = tonumber(a[2])
				end
				if type(hUnit.tAbilityUpgradesCount[id]) == "number" and hUnit.tAbilityUpgradesCount[id] >= count then
					return b
				end
				return not b
			end)
			if not bool then
				goto continue
			end
		end

		local iMaxCount = tonumber(tData.max_count)
		local iMaxCount = (iMaxCount ~= nil and iMaxCount > 0) and iMaxCount or math.huge
		if type(hUnit.tAbilityUpgradesCount[sID]) == "number" and hUnit.tAbilityUpgradesCount[sID] >= iMaxCount then
			goto continue
		end

		if tData.unit_name ~= nil and tData.unit_name ~= sUnitName then
			goto continue
		end
		if tData.type ~= ABILITY_UPGRADES_TYPE_ADD_ABILITY and tData.ability_name ~= nil and not hUnit:HasAbility(tData.ability_name) then
			goto continue
		end
		if tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS then
			if self:HasAbilityMechanicsUpgrade(hUnit, tData.ability_name, tData.description) then
				goto continue
			end
		end
		if tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY then
			if hUnit:HasAbility(tData.ability_name) then
				goto continue
			end
		end

		table.insert(list, shallowcopy(tData))
		:: continue ::
	end

	return list
end

function public:DrawAbilityUpgrades(hUnit, sPoolsType)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return
	end

	-- 如果有未选择的升级，存起来
	if hUnit.tDrawAbilityUpgradesList ~= nil and #hUnit.tDrawAbilityUpgradesList > 0 then
		-- local tData = GetRandomElement(hUnit.tDrawAbilityUpgradesList)
		-- if tData ~= nil then
		-- 	self:AddAbilityUpgrades(hUnit, tData.id)
		-- end
		hUnit.tDrawAbilityUpgradesListSave = hUnit.tDrawAbilityUpgradesListSave or {}
		table.insert(hUnit.tDrawAbilityUpgradesListSave, hUnit.tDrawAbilityUpgradesList)
	end

	local sRarity = Game:DrawPool("ability_upgrades_" .. sPoolsType)

	hUnit.tDrawAbilityUpgradesList = {}

	local list = self:GetUnitAbilityUpgradesList(hUnit, sPoolsType, sRarity)
	if #list > 0 then
		local iCount = 3

		for i = 1, iCount, 1 do
			local tData = GetRandomElement(list)
			local iAttempts = 0
			local iMaxAttempts = 16
			while TableFindKey(hUnit.tDrawAbilityUpgradesList, tData) ~= nil and iAttempts < iMaxAttempts do
				tData = GetRandomElement(list)
				iAttempts = iAttempts + 1
			end
			if TableFindKey(hUnit.tDrawAbilityUpgradesList, tData) == nil then
				table.insert(hUnit.tDrawAbilityUpgradesList, tData)
			end
		end
	end

	self:UpdateDrawAbilityUpgradesNetTable(hUnit)
end

function public:AddAbilityUpgrades(hUnit, sID)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end

	if hUnit.tAbilityUpgradesCount == nil then
		hUnit.tAbilityUpgradesCount = {}
	end

	local tData = self.tAbilityUpgrades[sID]

	if type(tData) ~= "table" then return false end

	local iMaxCount = tonumber(tData.max_count)
	local iMaxCount = (iMaxCount ~= nil and iMaxCount > 0) and iMaxCount or math.huge
	if hUnit.tAbilityUpgradesCount[sID] == nil then
		hUnit.tAbilityUpgradesCount[sID] = 0
	end
	if iMaxCount <= hUnit.tAbilityUpgradesCount[sID] then
		return false
	end

	local bSuccess = false
	if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
		bSuccess = self:AddSpecialValueUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY then
		bSuccess = self:AddSpecialValuePropertyUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_STATS then
		bSuccess = self:AddStatsUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS then
		bSuccess = self:AddAbilityMechanicsUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY then
		bSuccess = self:AddNewAbilityUpgrade(hUnit, tData)
	end

	if bSuccess then
		hUnit.tAbilityUpgradesCount[sID] = hUnit.tAbilityUpgradesCount[sID] + 1
	end

	return bSuccess
end

function public:RemoveAbilityUpgrades(hUnit, sID)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end

	if hUnit.tAbilityUpgradesCount == nil then
		hUnit.tAbilityUpgradesCount = {}
	end

	local tData = self.tAbilityUpgrades[sID]

	if type(tData) ~= "table" then return false end

	local iMaxCount = tonumber(tData.max_count)
	local iMaxCount = (iMaxCount ~= nil and iMaxCount > 0) and iMaxCount or math.huge
	if hUnit.tAbilityUpgradesCount[sID] == nil or hUnit.tAbilityUpgradesCount[sID] <= 0 then
		return false
	end

	local bSuccess = false
	if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
		bSuccess = self:RemoveSpecialValueUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY then
		bSuccess = self:RemoveSpecialValuePropertyUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_STATS then
		bSuccess = self:RemoveStatsUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS then
		bSuccess = self:RemoveAbilityMechanicsUpgrade(hUnit, tData)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY then
		bSuccess = self:RemoveNewAbilityUpgrade(hUnit, tData)
	end

	if bSuccess then
		hUnit.tAbilityUpgradesCount[sID] = hUnit.tAbilityUpgradesCount[sID] - 1
	end

	return true
end

function public:RemoveAbilityUpgradesByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end

	if hUnit.tAbilityUpgradesCount == nil then
		hUnit.tAbilityUpgradesCount = {}
	end

	local tUpgrades = hUnit.tAbilityUpgrades
	if type(tUpgrades) ~= "table" then return false end

	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]

	if type(tData) ~= "table" then return false end

	local sID = tData.id
	if hUnit.tAbilityUpgradesCount[sID] == nil or hUnit.tAbilityUpgradesCount[sID] <= 0 then
		return false
	end

	local bSuccess = false
	if tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE then
		bSuccess = self:RemoveSpecialValueUpgradeByIndex(hUnit, iIndex)
	elseif tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY then
		bSuccess = self:RemoveSpecialValuePropertyUpgradeByIndex(hUnit, iIndex)
	elseif tData.type == ABILITY_UPGRADES_TYPE_STATS then
		bSuccess = self:RemoveStatsUpgradeByIndex(hUnit, iIndex)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS then
		bSuccess = self:RemoveAbilityMechanicsUpgradeByIndex(hUnit, iIndex)
	elseif tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY then
		bSuccess = self:RemoveNewAbilityUpgradeByIndex(hUnit, iIndex)
	end

	if bSuccess then
		hUnit.tAbilityUpgradesCount[sID] = hUnit.tAbilityUpgradesCount[sID] - 1
	end

	return true
end

function public:zip(tData)
	local T = {
		[1] = zip_list,
	}
	for k, v in pairs(tData) do
		local t = { n = #zip_list }
		for i = 1, #T[1], 1 do
			t[i] = v[T[1][i]]
		end
		table.insert(T, t)
	end
	return T
end

function public:EnsureAbilityUpgradeTable(hUnit)
	if hUnit.tAbilityUpgrades == nil then
		hUnit.tAbilityUpgrades = {}
	end
	if hUnit.tAbilityUpgrades[UPGRADES_KEY_DATA] == nil then
		hUnit.tAbilityUpgrades[UPGRADES_KEY_DATA] = {}
	end
	if hUnit.tAbilityUpgrades[UPGRADES_KEY_CACHED_RESULT] == nil then
		hUnit.tAbilityUpgrades[UPGRADES_KEY_CACHED_RESULT] = {
			[ABILITY_UPGRADES_TYPE_SPECIAL_VALUE] = {},
			[ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY] = {},
			[ABILITY_UPGRADES_TYPE_STATS] = {},
			[ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS] = {},
			[ABILITY_UPGRADES_TYPE_ADD_ABILITY] = {},
		}
	end
	-- if not hUnit:HasModifier("modifier_ability_upgrades") then
	-- 	hUnit:AddNewModifier(hUnit, hUnit:GetDummyAbility(), "modifier_ability_upgrades", nil)
	-- end
end

function public:GetCachedResult(hUnit)
	if not IsValid(hUnit) then return end

	local tCachedResult
	if IsServer() then
		self:EnsureAbilityUpgradeTable(hUnit)

		tCachedResult = hUnit.tAbilityUpgrades[UPGRADES_KEY_CACHED_RESULT]
	else
		if hUnit.tCachedResult == nil then
			hUnit.tCachedResult = {}
		end
		if hUnit.tCachedResult[GetFrameCount()] == nil then
			hUnit.tCachedResult = {}

			local t = CustomNetTables:GetTableValue("ability_upgrades_result", tostring(hUnit:entindex()))
			if t == nil or t.json == nil then
				return
			end
			tCachedResult = json.decode(t.json)

			hUnit.tCachedResult[GetFrameCount()] = tCachedResult
		else
			tCachedResult = hUnit.tCachedResult[GetFrameCount()]
		end
	end
	return tCachedResult
end

--[[	例子：
	tData = {
		type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE, -- 必填
		description = "arc_lightning_cooldown_percent", -- 可不填
		ability_name = "arc_lightning", -- 必填
		special_value_name = "cooldown", -- 必填
		operator = ABILITY_UPGRADES_OP_MUL, -- 可不填，缺省值: ABILITY_UPGRADES_OP_ADD
		value = -12, -- 必填，如果为0也会报错，ABILITY_UPGRADES_OP_MUL情况下填的是百分比数值，不能化为实数表示
	}
]]
--
function public:_UpdateSpecialValueUpgrades(tUpgrades, sAbilityName, sSpecialValueName, iOperator)
	local tAllSpecialValueCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_SPECIAL_VALUE]

	if tAllSpecialValueCachedResult[sAbilityName] == nil then
		tAllSpecialValueCachedResult[sAbilityName] = {}
	end
	if tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName] == nil then
		tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName] = {}
	end

	local tSpecialValueCachedResult = tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName]

	local fResult = 0
	for _, _tData in ipairs(tUpgrades[UPGRADES_KEY_DATA]) do
		if _tData["type"] == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE and _tData["ability_name"] == sAbilityName and _tData["special_value_name"] == sSpecialValueName and _tData["operator"] == iOperator then
			if iOperator == ABILITY_UPGRADES_OP_ADD then
				fResult = fResult + _tData["value"]
			elseif iOperator == ABILITY_UPGRADES_OP_MUL then
				fResult = AdditionMultiplicationPercentage(fResult, _tData["value"])
			end
		end
	end

	tSpecialValueCachedResult[iOperator] = fResult
end
function public:AddSpecialValueUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	tData.id = DoUniqueString('id')

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	table.insert(tUpgrades[UPGRADES_KEY_DATA], tData)

	self:_UpdateSpecialValueUpgrades(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:UpdateSpecialValueUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	self:_UpdateSpecialValueUpgrades(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveSpecialValueUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	for i = #tUpgrades[UPGRADES_KEY_DATA], 1, -1 do
		local _tData = tUpgrades[UPGRADES_KEY_DATA][i]
		if tData.id == _tData.id then
			table.remove(tUpgrades[UPGRADES_KEY_DATA], i)
			break
		end
	end

	self:_UpdateSpecialValueUpgrades(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveSpecialValueUpgradeByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end
	local tUpgrades = hUnit.tAbilityUpgrades
	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]
	if not (
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	(tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	table.remove(tUpgrades[UPGRADES_KEY_DATA], iIndex)

	self:_UpdateSpecialValueUpgrades(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end

function public:GetSpecialValueUpgrade(hUnit, sAbilityName, sSpecialValueName, iOperator)
	if not IsValid(hUnit) then return 0 end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return 0
	end
	local tAllSpecialValueCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_SPECIAL_VALUE]
	if tAllSpecialValueCachedResult == nil or tAllSpecialValueCachedResult[sAbilityName] == nil or tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName] == nil then
		return 0
	end

	return tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName][iOperator] or 0
end

function public:CalcSpecialValueUpgrade(hUnit, sAbilityName, sSpecialValueName, fValue)
	return (fValue + self:GetSpecialValueUpgrade(hUnit, sAbilityName, sSpecialValueName, ABILITY_UPGRADES_OP_ADD)) * (1 + self:GetSpecialValueUpgrade(hUnit, sAbilityName, sSpecialValueName, ABILITY_UPGRADES_OP_MUL) * 0.01)
end

--[[	例子：
	tData = {
		type = ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY, -- 必填
		description = "arc_lightning_damage_int", -- 可不填
		ability_name = "arc_lightning", -- 必填
		special_value_name = "damage", -- 必填
		special_value_property = "_int", -- 必填
		operator = ABILITY_UPGRADES_OP_ADD, -- 可不填，缺省值: ABILITY_UPGRADES_OP_ADD
		value = 1, -- 必填，如果为0也会报错，ABILITY_UPGRADES_OP_MUL情况下填的是百分比数值，不能化为实数表示
	}
]]
--
function public:_UpdateSpecialValuePropertyUpgrade(tUpgrades, sAbilityName, sSpecialValueName, sSpecialValueProperty, iOperator)
	local tAllSpecialValuePropertyCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY]

	if tAllSpecialValuePropertyCachedResult[sAbilityName] == nil then
		tAllSpecialValuePropertyCachedResult[sAbilityName] = {}
	end
	if tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName] == nil then
		tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName] = {}
	end
	if tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty] == nil then
		tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty] = {}
	end

	local tSpecialValuePropertyCachedResult = tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty]

	local fResult = 0
	for _, _tData in ipairs(tUpgrades[UPGRADES_KEY_DATA]) do
		if _tData["type"] == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY and _tData["ability_name"] == sAbilityName and _tData["special_value_name"] == sSpecialValueName and _tData["special_value_property"] == sSpecialValueProperty and _tData["operator"] == iOperator then
			if iOperator == ABILITY_UPGRADES_OP_ADD then
				fResult = fResult + _tData["value"]
			elseif iOperator == ABILITY_UPGRADES_OP_MUL then
				fResult = AdditionMultiplicationPercentage(fResult, _tData["value"])
			end
		end
	end

	tSpecialValuePropertyCachedResult[iOperator] = fResult
end
---添加修改技能数值附加值升级
function public:AddSpecialValuePropertyUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	type(tData.special_value_property) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	tData.id = DoUniqueString('id')

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	table.insert(tUpgrades[UPGRADES_KEY_DATA], tData)

	self:_UpdateSpecialValuePropertyUpgrade(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["special_value_property"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
---更新修改技能数值附加值升级
function public:UpdateSpecialValuePropertyUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	type(tData.special_value_property) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	self:_UpdateSpecialValuePropertyUpgrade(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["special_value_property"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)
end
function public:RemoveSpecialValuePropertyUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	type(tData.special_value_property) == "string"
	and
	(tData.operator == nil or tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	if tData["operator"] == nil then
		tData["operator"] = ABILITY_UPGRADES_OP_ADD
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	for i = #tUpgrades[UPGRADES_KEY_DATA], 1, -1 do
		local _tData = tUpgrades[UPGRADES_KEY_DATA][i]
		if tData.id == _tData.id then
			table.remove(tUpgrades[UPGRADES_KEY_DATA], i)
			break
		end
	end

	self:_UpdateSpecialValuePropertyUpgrade(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["special_value_property"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveSpecialValuePropertyUpgradeByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end
	local tUpgrades = hUnit.tAbilityUpgrades
	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]
	if not (
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY
	and
	type(tData.ability_name) == "string"
	and
	type(tData.special_value_name) == "string"
	and
	type(tData.special_value_property) == "string"
	and
	(tData.operator == ABILITY_UPGRADES_OP_ADD or tData.operator == ABILITY_UPGRADES_OP_MUL)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	table.remove(tUpgrades[UPGRADES_KEY_DATA], iIndex)

	self:_UpdateSpecialValuePropertyUpgrade(tUpgrades, tData["ability_name"], tData["special_value_name"], tData["special_value_property"], tData["operator"])

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:GetSpecialValuePropertyUpgrade(hUnit, sAbilityName, sSpecialValueName, sSpecialValueProperty, iOperator)
	if not IsValid(hUnit) then return 0 end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return 0
	end
	local tAllSpecialValuePropertyCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY]
	if tAllSpecialValuePropertyCachedResult == nil or tAllSpecialValuePropertyCachedResult[sAbilityName] == nil or tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName] == nil or tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty] == nil then
		return 0
	end

	return tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty][iOperator] or 0
end

function public:CalcSpecialValuePropertyUpgrade(hUnit, sAbilityName, sSpecialValueName, sSpecialValueProperty, fValue)
	return (fValue + self:GetSpecialValuePropertyUpgrade(hUnit, sAbilityName, sSpecialValueName, sSpecialValueProperty, ABILITY_UPGRADES_OP_ADD)) * (1 + self:GetSpecialValuePropertyUpgrade(hUnit, sAbilityName, sSpecialValueName, sSpecialValueProperty, ABILITY_UPGRADES_OP_MUL) * 0.01)
end

--[[	例子：
	tData = {
		type = ABILITY_UPGRADES_TYPE_STATS, -- 必填
		description = "cooldown_percent", -- 可不填
		special_value_name = "cooldown", -- 必填，必须为ABILITY_UPGRADES_STATS_LIST表里的值
		value = -12, -- 必填，如果为0也会报错
	}
]]
--
function public:_UpdateStatsUpgrade(tUpgrades, sSpecialValueName)
	local tAllStatsCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_STATS]

	local funcSettle = ABILITY_UPGRADES_STATS_SETTLE[sSpecialValueName]
	local fResult = 0
	if funcSettle ~= nil then
		fResult = funcSettle()
	end
	for _, _tData in ipairs(tUpgrades[UPGRADES_KEY_DATA]) do
		if _tData["type"] == ABILITY_UPGRADES_TYPE_STATS and _tData["special_value_name"] == sSpecialValueName then
			if funcSettle ~= nil then
				fResult = funcSettle(fResult, _tData["value"])
			else
				fResult = fResult + _tData["value"]
			end
		end
	end
	tAllStatsCachedResult[sSpecialValueName] = fResult

end
function public:AddStatsUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_STATS
	and
	(type(tData.special_value_name) == "string" and TableFindKey(ABILITY_UPGRADES_STATS_LIST, tData.special_value_name) ~= nil)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	table.insert(tUpgrades[UPGRADES_KEY_DATA], tData)

	return hUnit:BonusesChangedProc(function()
		self:_UpdateStatsUpgrade(tUpgrades, tData["special_value_name"])

		self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

		return true
	end)
end
function public:RemoveStatsUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_STATS
	and
	(type(tData.special_value_name) == "string" and TableFindKey(ABILITY_UPGRADES_STATS_LIST, tData.special_value_name) ~= nil)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	for i = #tUpgrades[UPGRADES_KEY_DATA], 1, -1 do
		local _tData = tUpgrades[UPGRADES_KEY_DATA][i]
		if tData.id == _tData.id then
			table.remove(tUpgrades[UPGRADES_KEY_DATA], i)
			break
		end
	end

	return hUnit:BonusesChangedProc(function()
		self:_UpdateStatsUpgrade(tUpgrades, tData["special_value_name"])

		self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

		return true
	end)
end
function public:RemoveStatsUpgradeByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end
	local tUpgrades = hUnit.tAbilityUpgrades
	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]
	if not (
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_STATS
	and
	(type(tData.special_value_name) == "string" and TableFindKey(ABILITY_UPGRADES_STATS_LIST, tData.special_value_name) ~= nil)
	and
	(type(tData.value) == "number" and tData.value ~= 0)
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local tUpgrades = hUnit.tAbilityUpgrades

	table.remove(tUpgrades[UPGRADES_KEY_DATA], iIndex)

	return hUnit:BonusesChangedProc(function()
		self:_UpdateStatsUpgrade(tUpgrades, tData["special_value_name"])

		self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

		return true
	end)
end
function public:GetStatsUpgrade(hUnit, sSpecialValueName)
	if not IsValid(hUnit) then return 0 end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return 0
	end
	local tAllStatsCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_STATS]
	if tAllStatsCachedResult == nil then
		return 0
	end
	return tAllStatsCachedResult[sSpecialValueName] or 0
end

--[[	例子：
	tData = {
		type = ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS, -- 必填
		description = "arc_lightning_paralysis", -- 必填
		ability_name = "arc_lightning", -- 必填
		values = { -- 可不填，附带的数据，用于有些需要读取数据的效果
			-- 简单写法
			key = value, -- key值可以为新键，也可以为原键，这样就会覆盖原值。
			-- 详细写法
			key = {
				value = "5 2 3 4", -- value可以填单等级的number类型，或者填多等级的string类型，多个等级之间用字符" "空格分开
				..., -- 这里可以填一些额外值，和kv里的AbilitySpecial一样，例如：_int = "0.1 0.2 0.3", CalculateSpellDamageTooltip = 1, RequiresScepter = 1
			}, 
		},
	}
]]
--
function public:AddAbilityMechanicsUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS
	and
	type(tData.description) == "string"
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	if self:HasAbilityMechanicsUpgrade(hUnit, tData.ability_name, tData.description) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	table.insert(tUpgrades[UPGRADES_KEY_DATA], tData)

	local tAllAbilityMechanicsCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]

	local sAbilityName = tData["ability_name"]
	local sDescription = tData["description"]
	if tAllAbilityMechanicsCachedResult[sAbilityName] == nil then
		tAllAbilityMechanicsCachedResult[sAbilityName] = {}
	end
	local tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName]

	local tValues = {}
	if type(tData.values) == "table" then
		for k, v in pairs(tData.values) do
			local t = {
				value = {}
			}

			if type(v) == "number" then
				table.insert(t.value, v)
			elseif type(v) == "string" then
				local s = string.split(v, " ")
				if s then
					for i = 1, #s, 1 do
						table.insert(t.value, tonumber(s[i]))
					end
				end
			elseif type(v) == "table" then
				for _k, _v in pairs(v) do
					if _k == "value" then
						if type(_v) == "number" then
							table.insert(t.value, _v)
						elseif type(_v) == "string" then
							local s = string.split(_v, " ")
							if s then
								for i = 1, #s, 1 do
									table.insert(t.value, tonumber(s[i]))
								end
							end
						end
					else
						t[_k] = _v
					end
				end
			end

			tValues[k] = t
		end
	end

	tAbilityMechanicsCachedResult[sDescription] = tValues

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveAbilityMechanicsUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS
	and
	type(tData.description) == "string"
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	if not self:HasAbilityMechanicsUpgrade(hUnit, tData.ability_name, tData.description) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	for i = #tUpgrades[UPGRADES_KEY_DATA], 1, -1 do
		local _tData = tUpgrades[UPGRADES_KEY_DATA][i]
		if tData.id == _tData.id then
			table.remove(tUpgrades[UPGRADES_KEY_DATA], i)
			break
		end
	end

	local tAllAbilityMechanicsCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]

	local sAbilityName = tData["ability_name"]
	local sDescription = tData["description"]
	if tAllAbilityMechanicsCachedResult[sAbilityName] == nil then
		tAllAbilityMechanicsCachedResult[sAbilityName] = {}
	end
	local tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName]

	tAbilityMechanicsCachedResult[sDescription] = nil

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveAbilityMechanicsUpgradeByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end
	local tUpgrades = hUnit.tAbilityUpgrades
	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]
	if not (
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS
	and
	type(tData.description) == "string"
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	if not self:HasAbilityMechanicsUpgrade(hUnit, tData.ability_name, tData.description) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	table.remove(tUpgrades[UPGRADES_KEY_DATA], iIndex)

	local tAllAbilityMechanicsCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]

	local sAbilityName = tData["ability_name"]
	local sDescription = tData["description"]
	if tAllAbilityMechanicsCachedResult[sAbilityName] == nil then
		tAllAbilityMechanicsCachedResult[sAbilityName] = {}
	end
	local tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName]

	tAbilityMechanicsCachedResult[sDescription] = nil

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end

function public:HasAbilityMechanicsUpgrade(hUnit, sAbilityName, sDescription)
	if not IsValid(hUnit) then return false end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return false
	end
	local tAllAbilityMechanicsCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]
	if tAllAbilityMechanicsCachedResult == nil or tAllAbilityMechanicsCachedResult[sAbilityName] == nil or tAllAbilityMechanicsCachedResult[sAbilityName][sDescription] == nil then
		return false
	end

	return true
end

function public:GetAbilityMechanicsUpgradeLevelSpecialValue(hUnit, sAbilityName, sKey, iLevel)
	if not IsValid(hUnit) then return nil end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return nil
	end
	local tAllAbilityMechanicsCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]
	if tAllAbilityMechanicsCachedResult == nil or tAllAbilityMechanicsCachedResult[sAbilityName] == nil then
		return nil
	end
	local tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName]
	for sDescription, tValues in pairs(tAbilityMechanicsCachedResult) do
		local aValue = tValues[sKey]
		if aValue ~= nil and aValue.value ~= nil then
			return aValue.value[Clamp(iLevel + 1, 1, #aValue.value)]
		end
	end

	return nil
end

function public:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hUnit, sAbilityName, sKey, iLevel, sAddedKey)
	if not IsValid(hUnit) then return nil end

	local tCachedResult = self:GetCachedResult(hUnit)
	if tCachedResult == nil then
		return nil
	end
	local tAllAbilityMechanicsCachedResult = tCachedResult[ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS]
	if tAllAbilityMechanicsCachedResult == nil or tAllAbilityMechanicsCachedResult[sAbilityName] == nil then
		return nil
	end
	local tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName]
	for sDescription, tValues in pairs(tAbilityMechanicsCachedResult) do
		local aValue = tValues[sKey]
		if aValue ~= nil and aValue[sAddedKey] ~= nil then
			if type(aValue[sAddedKey]) == "number" then
				return aValue[sAddedKey]
			elseif type(aValue[sAddedKey]) == "string" then
				local aValues = vlua.split(tostring(aValue[sAddedKey]), " ")
				if aValues and #aValues > 0 and aValues[Clamp(iLevel + 1, 1, #aValues.value)] then
					return tonumber(aValues[Clamp(iLevel + 1, 1, #aValues.value)])
				end
			end
		end
	end

	return nil
end

--[[	例子：
	tData = {
		type = ABILITY_UPGRADES_TYPE_ADD_ABILITY, -- 必填
		description = "arc_lightning_paralysis", -- 可不填
		ability_name = "arc_lightning", -- 必填
		level = 1, -- 选填，默认1
	}
]]
--
function public:AddNewAbilityUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local sAbilityName = tData["ability_name"]

	if hUnit:HasAbility(sAbilityName) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	local hAbility = hUnit:AddAbility(sAbilityName)
	if IsValid(hAbility) then
		table.insert(tUpgrades[UPGRADES_KEY_DATA], tData)

		hAbility:SetLevel(tonumber(tData.level) or 1)

		local tAllNewAbilityCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ADD_ABILITY]

		tAllNewAbilityCachedResult[sAbilityName] = hAbility:entindex()
	else
		return false
	end

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveNewAbilityUpgrade(hUnit, tData)
	assert(IsServer())
	if not (
	IsValid(hUnit)
	and
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local sAbilityName = tData["ability_name"]

	if not hUnit:HasAbility(sAbilityName) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	local tAllNewAbilityCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ADD_ABILITY]

	local iAbilityIndex = tAllNewAbilityCachedResult[sAbilityName]
	if type(iAbilityIndex) == "number" then
		local hAbility = EntIndexToHScript(iAbilityIndex)
		if IsValid(hAbility) then
			for i = #tUpgrades[UPGRADES_KEY_DATA], 1, -1 do
				local _tData = tUpgrades[UPGRADES_KEY_DATA][i]
				if tData.id == _tData.id then
					table.remove(tUpgrades[UPGRADES_KEY_DATA], i)
					break
				end
			end

			hUnit:RemoveAbilityByHandle(hAbility)
		else
			return false
		end
	else
		return false
	end

	tAllNewAbilityCachedResult[sAbilityName] = nil

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end
function public:RemoveNewAbilityUpgradeByIndex(hUnit, iIndex)
	assert(IsServer())
	if not (IsValid(hUnit)) then
		return false
	end
	local tUpgrades = hUnit.tAbilityUpgrades
	local tData = tUpgrades[UPGRADES_KEY_DATA][iIndex]
	if not (
	type(tData) == "table"
	and
	tData.type == ABILITY_UPGRADES_TYPE_ADD_ABILITY
	and
	type(tData.ability_name) == "string"
	) then
		return false
	end

	self:EnsureAbilityUpgradeTable(hUnit)

	local sAbilityName = tData["ability_name"]

	if not hUnit:HasAbility(sAbilityName) then
		return false
	end

	local tUpgrades = hUnit.tAbilityUpgrades

	local tAllNewAbilityCachedResult = tUpgrades[UPGRADES_KEY_CACHED_RESULT][ABILITY_UPGRADES_TYPE_ADD_ABILITY]

	local iAbilityIndex = tAllNewAbilityCachedResult[sAbilityName]
	if type(iAbilityIndex) == "number" then
		local hAbility = EntIndexToHScript(iAbilityIndex)
		if IsValid(hAbility) then
			table.remove(tUpgrades[UPGRADES_KEY_DATA], iIndex)

			hUnit:RemoveAbilityByHandle(hAbility)
		else
			return false
		end
	else
		return false
	end

	tAllNewAbilityCachedResult[sAbilityName] = nil

	self:UpdateAbilityUpgradesNetTables(hUnit, tUpgrades)

	return true
end

--[[	监听事件
]]
--
function public:OnEntityRemoved(tEvents)
	if IsClient() then return end
	self:UpdateAbilityUpgradesNetTables(EntIndexToHScript(tEvents.entindex), nil)
end

--[[	UI事件
]]
--
function public:OnAbilityUpgradesRewardSelection(iEventSourceIndex, tEvents)
	if IsClient() then return end
	local iPlayerID = tEvents.PlayerID
	local hUnit = EntIndexToHScript(tEvents.entindex or -1)
	local key = tonumber(tEvents.key)
	if IsValid(hUnit) and hUnit:GetMainControllingPlayer() == iPlayerID and type(hUnit.tDrawAbilityUpgradesList) == "table" then
		local tData = hUnit.tDrawAbilityUpgradesList[key]
		if tData ~= nil then
			self:AddAbilityUpgrades(hUnit, tData.id)
			-- 如果有存起来的升级，更新
			if hUnit.tDrawAbilityUpgradesListSave and hUnit.tDrawAbilityUpgradesListSave[1] then
				hUnit.tDrawAbilityUpgradesList = hUnit.tDrawAbilityUpgradesListSave[1]
				table.remove(hUnit.tDrawAbilityUpgradesListSave, 1)
			else
				hUnit.tDrawAbilityUpgradesList = nil
			end
			self:UpdateDrawAbilityUpgradesNetTable(hUnit)
		end
	end
end

return public