require("abilities/ability_base_ai")
require("abilities/eom_ability")
--------------------------------------------------------------------------------
-- 双端
--------------------------------------------------------------------------------
----------------------------------------Global----------------------------------------
if _G.SAVE_TABLE == nil then
	_G.SAVE_TABLE = {}
end
---保存一个值，返回key用来读取
---@param value any
---@return string
function CommonSave(key, value)
	local _key = default(key, DoUniqueString("Save"))
	_G.SAVE_TABLE[_key] = value
	return _key
end
---读取一个值
function CommonLoad(key)
	return _G.SAVE_TABLE[key]
end
function Save(table, key, value)
	if type(table) ~= "table" then return end
	table.abilitydata = table.abilitydata or {}
	table.abilitydata[key] = value
end
function Load(table, key)
	if type(table) ~= "table" then return end
	table.abilitydata = table.abilitydata or {}
	return table.abilitydata[key]
end
---存储物品modifier
function SaveItemModifier(hModifier)
	local sName = hModifier:GetName()
	local hParent = hModifier:GetParent()
	local t = Load(hParent, sName) or {}
	table.insert(t, hModifier)
	Save(hParent, sName, t)
end
---移除物品modifier
function RemoveItemModifier(hModifier)
	local sName = hModifier:GetName()
	local hParent = hModifier:GetParent()
	local t = Load(hParent, sName) or {}
	ArrayRemove(t, hModifier)
	Save(hParent, sName, t)
end
---获取物品modifier表
function LoadItemModifiers(hModifier)
	local sName = hModifier:GetName()
	local hParent = hModifier:GetParent()
	return Load(hParent, sName) or {}
end
---是否为第一个物品modifier
function IsFirstItemModifier(hModifier)
	local t = LoadItemModifiers(hModifier)
	return t[1] == hModifier
end
---通过物品modifier名字获取物品modifier表
function LoadItemModifiersByName(hParent, sName)
	return Load(hParent, sName) or {}
end
---判断是否有物品modifier
function HasItemModifier(hParent, sName)
	local t = LoadItemModifiersByName(hParent, sName)
	return #t > 0
end
-- 获取技能的特殊键值
function GetAbilityNameLevelSpecialValueFor(sAbilityName, sKey, iLevel)
	local tAbilityKeyValues = KeyValues.AbilitiesKv[sAbilityName] or KeyValues.ItemsKv[sAbilityName]
	if tAbilityKeyValues ~= nil then
		if tAbilityKeyValues.AbilitySpecial ~= nil then
			for sIndex, tData in pairs(tAbilityKeyValues.AbilitySpecial) do
				if tData[sKey] ~= nil then
					local aValues = vlua.split(tostring(tData[sKey]), " ")
					if aValues and #aValues > 0 and aValues[math.min(iLevel + 1, #aValues)] then
						return tonumber(aValues[math.min(iLevel + 1, #aValues)])
					end
				end
			end
		end
	end
	return 0
end
-- 获取技能的特殊键值的附属值
function GetAbilityNameLevelSpecialAddedValueFor(sAbilityName, sKey, iLevel, sAddedKey)
	local tAbilityKeyValues = KeyValues.AbilitiesKv[sAbilityName] or KeyValues.ItemsKv[sAbilityName]
	if type(tAbilityKeyValues) == "table" then
		if type(tAbilityKeyValues.AbilitySpecial) == "table" then
			for sIndex, tData in pairs(tAbilityKeyValues.AbilitySpecial) do
				if tData[sKey] ~= nil and tData[sAddedKey] ~= nil then
					local aValues = vlua.split(tostring(tData[sAddedKey]), " ")
					if aValues and #aValues > 0 then
						local sV = aValues[math.min(iLevel + 1, #aValues)]
						if sV ~= nil then
							local nV = tonumber(sV)
							if nV ~= nil then
								return nV
							else
								return sV
							end
						end
					end
				end
			end
		end
	end
end
----------------------------------------CDOTA_BaseNPC----------------------------------------
local BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC

---目标是否是友军
function BaseNPC:IsFriendly(hTarget)
	if IsValid(self) and IsValid(hTarget) then
		return self:GetTeamNumber() == hTarget:GetTeamNumber()
	end
end
function BaseNPC:GetAttackDamage()
	return GetAttackDamage(self)
end
function BaseNPC:GetMoveSpeed()
	return self:GetMoveSpeedModifier(self:GetBaseMoveSpeed(), false)
end
function BaseNPC:GetArmor()
	return GetArmor(self)
end
function BaseNPC:GetBaseStrength()
	if self:IsHero() then
		return GetBaseStrength(self)
	end
	return 0
end
function BaseNPC:GetStrength()
	if self:IsHero() then
		return GetStrength(self)
	end
	return 0
end
function BaseNPC:GetBaseAgility()
	if self:IsHero() then
		return GetBaseAgility(self)
	end
	return 0
end
function BaseNPC:GetAgility()
	if self:IsHero() then
		return GetAgility(self)
	end
	return 0
end
function BaseNPC:GetBaseIntellect()
	if self:IsHero() then
		return GetBaseIntellect(self)
	end
	return 0
end
function BaseNPC:GetIntellect()
	if self:IsHero() then
		return GetIntellect(self)
	end
	return 0
end
function BaseNPC:GetAllStats()
	if self:IsHero() then
		return self:GetStrength() + self:GetAgility() + self:GetIntellect()
	end
	return 0
end
function BaseNPC:GetPrimaryStats()
	if self:IsHero() then
		if KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_STRENGTH" then
			return self:GetStrength()
		elseif KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_AGILITY" then
			return self:GetAgility()
		elseif KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_INTELLECT" then
			return self:GetIntellect()
		end
	end
	return 0
end
---获取最大的属性类型
function BaseNPC:GetMaximalStatsType()
	local iStrength = self:GetStrength()
	local iAgility = self:GetAgility()
	local iIntellect = self:GetIntellect()
	if iStrength > iAgility and iStrength > iIntellect then
		return DOTA_ATTRIBUTE_STRENGTH
	elseif iAgility > iStrength and iAgility > iIntellect then
		return DOTA_ATTRIBUTE_AGILITY
	elseif iIntellect > iStrength and iIntellect > iAgility then
		return DOTA_ATTRIBUTE_INTELLECT
	end
end
function BaseNPC:GetAbilityNameSpecialValueFor(sAbilityName, sKey)
	local hAbility = self:FindAbilityByName(sAbilityName)
	if IsValid(hAbility) then
		return hAbility:GetSpecialValueFor(sKey)
	end
	return 0
end
---单位是否在冲刺
function BaseNPC:IsDash()
	return self:HasModifier("modifier_dash")
end
---单位是否在击退
function BaseNPC:IsKnockback()
	return self:HasModifier("modifier_knockback_custom")
end
----------------------------------------CDOTA_BaseNPC_Hero----------------------------------------
local BaseNPC_Hero = IsServer() and CDOTA_BaseNPC_Hero or C_DOTA_BaseNPC_Hero
function BaseNPC_Hero:GetBaseStrength()
	return GetBaseStrength(self)
end
function BaseNPC_Hero:GetStrength()
	return GetStrength(self)
end
function BaseNPC_Hero:GetBaseAgility()
	return GetBaseAgility(self)
end
function BaseNPC_Hero:GetAgility()
	return GetAgility(self)
end
function BaseNPC_Hero:GetBaseIntellect()
	return GetBaseIntellect(self)
end
function BaseNPC_Hero:GetIntellect()
	return GetIntellect(self)
end
function BaseNPC_Hero:GetAllStats()
	return self:GetStrength() + self:GetAgility() + self:GetIntellect()
end
function BaseNPC_Hero:GetPrimaryAttribute()
	return _G[KeyValues:GetUnitData(self, "AttributePrimary")]
end
function BaseNPC_Hero:GetPrimaryStats()
	if KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_STRENGTH" then
		return self:GetStrength()
	elseif KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_AGILITY" then
		return self:GetAgility()
	elseif KeyValues:GetUnitData(self, "AttributePrimary") == "DOTA_ATTRIBUTE_INTELLECT" then
		return self:GetIntellect()
	end
end
---获取最大的属性类型
function BaseNPC_Hero:GetMaximalStatsType()
	local iStrength = self:GetStrength()
	local iAgility = self:GetAgility()
	local iIntellect = self:GetIntellect()
	if iStrength > iAgility and iStrength > iIntellect then
		return DOTA_ATTRIBUTE_STRENGTH
	elseif iAgility > iStrength and iAgility > iIntellect then
		return DOTA_ATTRIBUTE_AGILITY
	elseif iIntellect > iStrength and iIntellect > iAgility then
		return DOTA_ATTRIBUTE_INTELLECT
	end
end
----------------------------------------CDOTABaseAbility----------------------------------------
local BaseAbility = IsServer() and CDOTABaseAbility or C_DOTABaseAbility

local tAddedValues = {
	_str = "GetStrength",
	_agi = "GetAgility",
	_int = "GetIntellect",
	_all = "GetAllStats",
	_primary = "GetPrimaryStats",
	_attack_damage = "GetAttackDamage",
	_attack_speed = "GetAttackSpeed",
	_health = "GetCustomMaxHealth",
	_mana = "GetMaxMana",
	_armor = "GetArmor",
	_move_speed = "GetMoveSpeed",
}

if BaseAbility.GetLevelSpecialValueFor_Engine == nil then
	---@private
	BaseAbility.GetLevelSpecialValueFor_Engine = BaseAbility.GetLevelSpecialValueFor
end
---获取技能等级键值，使用指定单位来计算附加数值
function BaseAbility:GetLevelSpecialValueForUnit(sKey, iLevel, hCaster, bNoAdded)
	if not IsValid(self) then
		return 0
	end
	if bNoAdded == nil then
		bNoAdded = false
	end
	if iLevel == -1 then
		iLevel = self:GetLevel() - 1
	end
	local value = self:GetLevelSpecialValueFor_Engine(sKey, iLevel)
	if IsValid(hCaster) then
		-- 基础值
		value = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialValue(hCaster, self:GetName(), sKey, iLevel) or value
		value = AbilityUpgrades:CalcSpecialValueUpgrade(hCaster, self:GetName(), sKey, value)
		if not bNoAdded then
			-- 遍历获得附加值
			for k, v in pairs(tAddedValues) do
				local factor = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, iLevel, k) or (GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, iLevel, k) or 0)
				factor = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, k, factor)
				if factor ~= 0 and type(hCaster[v]) == "function" then
					local addedValue = hCaster[v](hCaster)
					addedValue = addedValue or 0
					value = value + tonumber(addedValue) * factor
					-- 最终结果值不小于
					local min = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, iLevel, "_min") or GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, iLevel, "_min")
					if type(min) == "number" then
						min = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, "_min", min)
						value = math.max(value, min)
					end
					-- 最终结果值不大于
					local max = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, iLevel, "_max") or GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, iLevel, "_max")
					if type(max) == "number" then
						max = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, "_max", max)
						value = math.min(value, max)
					end
				end
			end
		end
	end
	return value
end
---获取技能等级键值
function BaseAbility:GetLevelSpecialValueFor(sKey, iLevel)
	return self:GetLevelSpecialValueForUnit(sKey, iLevel, self:GetCaster())
end
---获取技能等级键值，无附加数值
function BaseAbility:GetLevelSpecialValueNoAdded(sKey, iLevel)
	return self:GetLevelSpecialValueForUnit(sKey, iLevel, self:GetCaster(), true)
end
---获取技能等级键值的附属值
function BaseAbility:GetLevelSpecialAddedValueFor(sKey, iLevel, sAddedKey)
	if not IsValid(self) then
		return
	end
	if iLevel == -1 then
		iLevel = self:GetLevel() - 1
	end
	return GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, iLevel, sAddedKey)
end
if BaseAbility.GetSpecialValueFor_Engine == nil then
	---@private
	BaseAbility.GetSpecialValueFor_Engine = BaseAbility.GetSpecialValueFor
end
---获取技能键值，使用指定单位来计算附加数值
function BaseAbility:GetSpecialValueForUnit(sKey, hCaster, bNoAdded)
	if not IsValid(self) then
		return 0
	end
	if bNoAdded == nil then
		bNoAdded = false
	end
	local value = self:GetSpecialValueFor_Engine(sKey)
	if IsValid(hCaster) then
		value = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialValue(hCaster, self:GetName(), sKey, self:GetLevel() - 1) or value
		value = AbilityUpgrades:CalcSpecialValueUpgrade(hCaster, self:GetName(), sKey, value)
		if not bNoAdded then
			for k, v in pairs(tAddedValues) do
				local factor = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, self:GetLevel() - 1, k) or GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, self:GetLevel() - 1, k) or 0
				factor = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, k, factor)

				if factor ~= 0 and type(hCaster[v]) == "function" then
					local addedValue = hCaster[v](hCaster)
					addedValue = addedValue or 0
					value = value + tonumber(addedValue) * factor
					local min = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, self:GetLevel() - 1, "_min") or GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, self:GetLevel() - 1, "_min")
					if type(min) == "number" then
						min = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, "_min", min)
						value = math.max(value, min)
					end
					local max = AbilityUpgrades:GetAbilityMechanicsUpgradeLevelSpecialAddedValue(hCaster, self:GetName(), sKey, self:GetLevel() - 1, "_max") or GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, self:GetLevel() - 1, "_max")
					if type(max) == "number" then
						max = AbilityUpgrades:CalcSpecialValuePropertyUpgrade(hCaster, self:GetName(), sKey, "_max", max)
						value = math.min(value, max)
					end
				end
			end
		end
	end
	return value
end
---获取技能键值
function BaseAbility:GetSpecialValueFor(sKey)
	return self:GetSpecialValueForUnit(sKey, self:GetCaster())
end
---获取技能键值，无附加数值
function BaseAbility:GetSpecialValueNoAdded(sKey)
	return self:GetSpecialValueForUnit(sKey, self:GetCaster(), true)
end
---获取技能键值的附属值
function BaseAbility:GetSpecialAddedValueFor(sKey, sAddedKey)
	if not IsValid(self) then
		return
	end
	return GetAbilityNameLevelSpecialAddedValueFor(self:GetName(), sKey, self:GetLevel() - 1, sAddedKey)
end
---获取稀有度
function BaseAbility:GetRarity()
	if self:IsItem() then
		return Items:GetRarity(self:GetAbilityName())
	else
		local tKV = KeyValues.AbilitiesKv[self:GetAbilityName()]
		if type(tKV) == "table" and tKV.Rarity ~= nil then
			return tostring(tKV.Rarity)
		end
	end
	return nil
end

----------------------------------------CDOTA_Buff----------------------------------------
---获取技能当前等级的键值
---@param szName 键名
---@return number
function CDOTA_Buff:GetAbilitySpecialValueFor(szName)
	if not IsValid(self:GetAbility()) then
		return self[szName] or 0
	end
	return self:GetAbility():GetSpecialValueFor(szName)
end

---获取技能特定等级的键值
---@param szName 键名
---@param iLevel 技能等级
---@return number
function CDOTA_Buff:GetAbilityLevelSpecialValueFor(szName, iLevel)
	if not IsValid(self:GetAbility()) then
		return self[szName] or 0
	end
	return self:GetAbility():GetLevelSpecialValueFor(szName, iLevel)
end

---获取技能等级
function CDOTA_Buff:GetAbilityLevel()
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) then
		return 0
	end
	return hAbility:GetLevel()
end

if CDOTA_Buff.IncrementStackCount_Engine == nil then
	---@private
	CDOTA_Buff.IncrementStackCount_Engine = CDOTA_Buff.IncrementStackCount
end
---增加modifier叠层
---@param iStackCount 可选层数
function CDOTA_Buff:IncrementStackCount(iStackCount)
	if iStackCount == nil then
		self:IncrementStackCount_Engine()
	else
		self:SetStackCount(self:GetStackCount() + iStackCount)
	end
end

---减少modifier叠层
---@param iStackCount 可选层数
if CDOTA_Buff.DecrementStackCount_Engine == nil then
	---@private
	CDOTA_Buff.DecrementStackCount_Engine = CDOTA_Buff.DecrementStackCount
end
function CDOTA_Buff:DecrementStackCount(iStackCount)
	if iStackCount == nil then
		self:DecrementStackCount_Engine()
	else
		self:SetStackCount(self:GetStackCount() - iStackCount)
	end
end

---获取技能名
function CDOTA_Buff:GetAbilityName()
	return self:GetAbility():GetAbilityName()
end

---是否吞噬入体
function CDOTA_Buff:IsDevoured()
	return not self:GetParent():HasItemInInventory(self:GetAbility():GetAbilityName())
end

--------------------------------------------------------------------------------
-- 客户端
--------------------------------------------------------------------------------
if IsClient() then
end

--------------------------------------------------------------------------------
-- 服务器
--------------------------------------------------------------------------------
if IsServer() then
	----------------------------------------Global----------------------------------------
	if UTIL_Remove_Engine == nil then
		---@private
		UTIL_Remove_Engine = UTIL_Remove
	end
	---移除实体
	function UTIL_Remove(hEnt)
		if hEnt.RemoveAllModifier then hEnt:RemoveAllModifier() end
		return UTIL_Remove_Engine(hEnt)
	end
	if UTIL_RemoveImmediate_Engine == nil then
		---@private
		UTIL_RemoveImmediate_Engine = UTIL_RemoveImmediate
	end
	---立即移除实体
	function UTIL_RemoveImmediate(hEnt)
		if hEnt.RemoveAllModifier then hEnt:RemoveAllModifier() end
		return UTIL_RemoveImmediate_Engine(hEnt)
	end
	-- 获取下次record
	function GetNextRecord()
		if RECORD_SYSTEM_DUMMY.iLastRecord == nil then RECORD_SYSTEM_DUMMY.iLastRecord = 0 end
		if RECORD_SYSTEM_DUMMY.iLastRecord and RECORD_SYSTEM_DUMMY.iLastRecord >= 255 then
			RECORD_SYSTEM_DUMMY.iLastRecord = RECORD_SYSTEM_DUMMY.iLastRecord - 256
		end
		return RECORD_SYSTEM_DUMMY.iLastRecord + 1
	end

	DAMAGE_STATE_PHYSICAL_CRIT = 1 -- 物理暴击
	DAMAGE_STATE_MAGICAL_CRIT = 2 -- 魔法暴击
	DAMAGE_STATE_NO_CRIT = 4 -- 不触发暴击
	DAMAGE_STATE_CLEAVE = 8 -- 分裂伤害
	if ApplyDamage_Engine == nil then
		ApplyDamage_Engine = ApplyDamage
	end
	function ApplyDamage(tDamageTable, iState)
		if iState == nil then iState = 0 end
		local iNextRecord = GetNextRecord()

		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iNextRecord] = iState

		return ApplyDamage_Engine(tDamageTable), iNextRecord
	end
	function DamageFilter(iRecord, ...)
		local bool = false
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		for i, iState in pairs({ ... }) do
			bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] or 0, iState) == iState)
		end
		return bool
	end
	-- 在物理暴击效果里插入
	function _PhysicalCrit(iRecord)
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = 0 end

		if bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord], DAMAGE_STATE_PHYSICAL_CRIT) ~= DAMAGE_STATE_PHYSICAL_CRIT then
			RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] + DAMAGE_STATE_PHYSICAL_CRIT
		end
	end
	-- 在魔法暴击效果里插入
	function _MagicalCrit(iRecord)
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM = {} end
		if RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = 0 end

		if bit.band(RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord], DAMAGE_STATE_MAGICAL_CRIT) ~= DAMAGE_STATE_MAGICAL_CRIT then
			RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.DAMAGE_SYSTEM[iRecord] + DAMAGE_STATE_MAGICAL_CRIT
		end
	end


	function AttackFilter(iRecord, ...)
		local bool = false
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		for i, iAttackState in pairs({ ... }) do
			bool = bool or (bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] or 0, iAttackState) == iAttackState)
		end
		return bool
	end
	-- 在暴击效果里插入
	function _Crit(iRecord)
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] = 0 end

		if bit.band(RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord], ATTACK_STATE_CRIT) ~= ATTACK_STATE_CRIT then
			RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] = RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iRecord] + ATTACK_STATE_CRIT
		end
	end
	---@private
	function PfromC(c)
		if c == 0 then return 1 end
		local pProcOnN = 0
		local pProcByN = 0
		local sumNpProcOnN = 0
		local maxFails = math.ceil(1 / c)
		for N = 1, maxFails, 1 do
			pProcOnN = math.min(1, N * c) * (1 - pProcByN)
			pProcByN = pProcByN + pProcOnN
			sumNpProcOnN = sumNpProcOnN + N * pProcOnN
		end
		return 1 / sumNpProcOnN
	end
	---@private
	function CfromP(p)
		local Cupper = p
		local Clower = 0
		local Cmid
		local p1
		local p2 = 1
		while true do
			Cmid = (Cupper + Clower) / 2
			p1 = PfromC(Cmid)
			if math.abs(p1 - p2) <= 0 then break end
			if p1 > p then
				Cupper = Cmid
			else
				Clower = Cmid
			end
			p2 = p1
		end
		return Cmid
	end

	PSEUDO_RANDOM_C = {}
	for i = 0, 100 do
		local C = CfromP(i * 0.01)
		PSEUDO_RANDOM_C[i] = C
	end
	---@private
	function PRD_C(chance)
		chance = math.max(math.min(chance, 100), 0)
		return PSEUDO_RANDOM_C[math.floor(chance)]
	end
	---伪随机
	---@param table table 表
	---@param chance number 概率
	---@param pseudo_random_recording any 记录
	function PRD(table, chance, pseudo_random_recording)
		if table.PSEUDO_RANDOM_RECORDING_LIST == nil then table.PSEUDO_RANDOM_RECORDING_LIST = {} end

		local N = table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] or 1
		local C = PRD_C(chance)
		if RandomFloat(0, 1) <= C * N then
			table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = 1
			return true
		end
		table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = N + 1
		return false
	end
	---获取某单位范围内单位最多的单位
	---@param search_position Vector 搜索点
	---@param search_radius number 搜索范围
	---@param team_number number 队伍
	---@param radius number 范围
	---@param team_filter number 队伍过滤
	---@param type_filter number 类型过滤
	---@param flag_filter number 特殊过滤
	---@param order number 排序规则
	---@param exclude table 排除单位（可缺省，可以填单位表或者单位）
	function GetAOEMostTargetsSpellTarget(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order, exclude)
		local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		if type(exclude) == "table" then
			if IsValidEntity(exclude) and IsValid(exclude) then
				ArrayRemove(targets, exclude)
			else
				for i = #targets, 1, -1 do
					if TableFindKey(exclude, targets[i]) ~= nil then
						table.remove(targets, i)
					end
				end
			end
		end

		local hTarget
		-- local N = 0
		local iMax = 0
		for i = 1, #targets, 1 do
			local first_target = targets[i]
			local n = 0
			if first_target:IsPositionInRange(search_position, search_radius) then
				if hTarget == nil then hTarget = first_target end
				for j = 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]
					if second_target:IsPositionInRange(first_target:GetAbsOrigin(), radius + second_target:GetHullRadius()) then
						n = n + 1
					end
				end
			end
			if n > iMax then
				hTarget = first_target
				iMax = n
			end
		end
		-- print("O(n):"..N)
		return hTarget
	end
	---获取一定范围内单位最多的点
	---@param search_position Vector 搜索点
	---@param search_radius number 搜索范围
	---@param team_number number 队伍
	---@param radius number 范围
	---@param team_filter number 队伍过滤
	---@param type_filter number 类型过滤
	---@param flag_filter number 特殊过滤
	---@param order number 排序规则
	---@param exclude table 排除单位（可缺省，可以填单位表或者单位）
	function GetAOEMostTargetsPosition(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order, exclude)
		local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		if type(exclude) == "table" then
			if IsValidEntity(exclude) and IsValid(exclude) then
				ArrayRemove(targets, exclude)
			else
				for i = #targets, 1, -1 do
					if TableFindKey(exclude, targets[i]) ~= nil then
						table.remove(targets, i)
					end
				end
			end
		end

		local position = vec3_invalid
		-- local N = 0
		if #targets == 1 then
			local vDirection = targets[1]:GetAbsOrigin() - search_position
			vDirection.z = 0
			position = GetGroundPosition(search_position + vDirection:Normalized() * math.min(search_radius - 1, vDirection:Length2D()), nil)
		elseif #targets > 1 then
			local tPoints = {}
			local funcInsertCheckPoint = function(vPoint)
				-- DebugDrawCircle(GetGroundPosition(vPoint, nil), Vector(0, 0, 255), 32, 32, true, 0.5)
				table.insert(tPoints, vPoint)
			end
			-- 取圆中点或交点
			for i = 1, #targets, 1 do
				local first_target = targets[i]
				-- DebugDrawCircle(first_target:GetAbsOrigin(), Vector(0, 255, 0), 32, radius, false, 0.5)
				for j = i + 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]
					local vDirection = second_target:GetAbsOrigin() - first_target:GetAbsOrigin()
					vDirection.z = 0
					local fDistance = vDirection:Length2D()
					if fDistance <= radius * 2 and fDistance > 0 then
						local vMid = (second_target:GetAbsOrigin() + first_target:GetAbsOrigin()) / 2
						if (vMid - search_position):Length2D() <= search_radius then
							table.insert(tPoints, vMid)
						else
							local fHalfLength = math.sqrt(radius ^ 2 - (fDistance / 2) ^ 2)
							local v = Rotation2D(vDirection:Normalized(), math.rad(90))
							local p = {
								vMid - v * fHalfLength,
								vMid + v * fHalfLength,
							}
							for k, vPoint in pairs(p) do
								if (vPoint - search_position):Length2D() <= search_radius then
									table.insert(tPoints, vPoint)
								end
							end
						end
					end
				end
			end
			-- print("O(n):"..N)
			local iMax = 0
			for i = 1, #tPoints, 1 do
				local vPoint = tPoints[i]
				local n = 0
				for j = 1, #targets, 1 do
					-- N = N + 1
					local hTarget = targets[j]
					if hTarget:IsPositionInRange(vPoint, radius + hTarget:GetHullRadius()) then
						n = n + 1
					end
				end
				if n > iMax then
					position = vPoint
					iMax = n
				end
			end
			-- 如果
			if position == vec3_invalid then
				local vDirection = targets[1]:GetAbsOrigin() - search_position
				vDirection.z = 0
				position = GetGroundPosition(search_position + vDirection:Normalized() * math.min(search_radius - 1, vDirection:Length2D()), nil)
			end
		end
		-- print("O(n):"..N)
		-- 获取地面坐标
		if position ~= vec3_invalid then
			position = GetGroundPosition(position, nil)
		end
		-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
		return position
	end
	---获取一条线上单位最多的施法点
	---@param search_position Vector 搜索点
	---@param search_radius number 搜索范围
	---@param team_number number 队伍
	---@param start_width number 开始宽度
	---@param end_width number 结束宽度
	---@param team_filter number 队伍过滤
	---@param type_filter number 类型过滤
	---@param flag_filter number 特殊过滤
	---@param order number 排序规则
	---@param exclude table 排除单位（可缺省，可以填单位表或者单位）
	function GetLinearMostTargetsPosition(search_position, search_radius, team_number, start_width, end_width, team_filter, type_filter, flag_filter, order, exclude)
		local targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + end_width, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		if type(exclude) == "table" then
			if IsValidEntity(exclude) and IsValid(exclude) then
				ArrayRemove(targets, exclude)
			else
				for i = #targets, 1, -1 do
					if TableFindKey(exclude, targets[i]) ~= nil then
						table.remove(targets, i)
					end
				end
			end
		end

		local position = vec3_invalid
		-- local N = 0
		if #targets == 1 then
			local vDirection = targets[1]:GetAbsOrigin() - search_position
			vDirection.z = 0
			position = search_position + vDirection:Normalized() * (search_radius - 1)
		elseif #targets > 1 then
			local tPolygons = {}
			local funcInsertCheckPolygon = function(tPolygon)
				-- for i = 1, #tPolygon, 1 do
				-- 	local vP1 = tPolygon[i]
				-- 	local vP2 = tPolygon[i+1]
				-- 	if vP2 == nil then
				-- 		vP2 = tPolygon[1]
				-- 	end
				-- 	DebugDrawLine(vP1, vP2, 255, 0, 0, false, 0.5)
				-- end
				-- DebugDrawCircle(tPolygon[3], Vector(255, 0, 0), 32, end_width, false, 0.5)
				table.insert(tPolygons, tPolygon)
			end
			for i = 1, #targets, 1 do
				local first_target = targets[i]
				for j = i + 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]

					local vDirection1 = first_target:GetAbsOrigin() - search_position
					vDirection1.z = 0
					local vDirection2 = second_target:GetAbsOrigin() - search_position
					vDirection2.z = 0
					local vDirection = (vDirection1 + vDirection2) / 2
					vDirection.z = 0
					local v = Rotation2D(vDirection:Normalized(), math.rad(90))
					local vEndPosition = search_position + vDirection:Normalized() * (search_radius - 1)
					local tPolygon = {
						search_position + v * start_width,
						vEndPosition + v * end_width,
						vEndPosition,
						vEndPosition - v * end_width,
						search_position - v * start_width,
					}
					if (IsPointInPolygon(first_target:GetAbsOrigin(), tPolygon) or first_target:IsPositionInRange(tPolygon[3], end_width + first_target:GetHullRadius()))
					and (IsPointInPolygon(second_target:GetAbsOrigin(), tPolygon) or second_target:IsPositionInRange(tPolygon[3], end_width + second_target:GetHullRadius())) then
						funcInsertCheckPolygon(tPolygon)
					end
				end
				local vDirection = first_target:GetAbsOrigin() - search_position
				vDirection.z = 0
				local v = Rotation2D(vDirection:Normalized(), math.rad(90))
				local vEndPosition = search_position + vDirection:Normalized() * (search_radius - 1)
				local tPolygon = {
					search_position + v * start_width,
					vEndPosition + v * end_width,
					vEndPosition,
					vEndPosition - v * end_width,
					search_position - v * start_width,
				}
				funcInsertCheckPolygon(tPolygon)
			end
			-- print("O(n):"..N)
			local iMax = 0
			for i = 1, #tPolygons, 1 do
				local tPolygon = tPolygons[i]
				local n = 0
				for j = 1, #targets, 1 do
					-- N = N + 1
					local hTarget = targets[j]
					if IsPointInPolygon(hTarget:GetAbsOrigin(), tPolygon) or hTarget:IsPositionInRange(tPolygon[3], end_width + hTarget:GetHullRadius()) then
						n = n + 1
					end
				end
				if n > iMax then
					position = tPolygon[3]
					iMax = n
				end
			end
		end
		-- print("O(n):"..N)
		if position ~= vec3_invalid then
			position = GetGroundPosition(position, nil)
		end
		-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
		return position
	end
	---获取弹射目标
	---@param last_target CDOTA_BaseNPC 现在目标
	---@param team_number number 队伍
	---@param position number 选择位置
	---@param radius number 范围
	---@param team_filter number 队伍过滤
	---@param type_filter number 类型过滤
	---@param flag_filter number 特殊过滤
	---@param order number 排序规则
	---@param unit_table table 单位记录表
	---@param can_bounce_bounced_unit boolean 是否可以弹射回来（缺省false）
	function GetBounceTarget(last_target, team_number, position, radius, team_filter, type_filter, flag_filter, order, unit_table, can_bounce_bounced_unit)
		local first_targets = FindUnitsInRadius(team_number, position, nil, radius, team_filter, type_filter, flag_filter, order, false)

		for i = #first_targets, 1, -1 do
			local unit = first_targets[i]
			if unit == last_target then
				table.remove(first_targets, i)
			end
		end

		local second_targets = {}
		for k, v in pairs(first_targets) do
			second_targets[k] = v
		end

		if unit_table and type(unit_table) == "table" then
			for i = #first_targets, 1, -1 do
				if TableFindKey(unit_table, first_targets[i]) then
					table.remove(first_targets, i)
				end
			end
		end

		local first_target = first_targets[1]
		local second_target = second_targets[1]

		if can_bounce_bounced_unit ~= nil and type(can_bounce_bounced_unit) == "boolean" and can_bounce_bounced_unit == true then
			return first_target or second_target
		else
			return first_target
		end
	end

	---进行分裂
	---@param hAttacker CDOTA_BaseNPC 操作攻击者
	---@param hTarget CDOTA_BaseNPC 攻击目标
	---@param fStartWidth number 开始宽度
	---@param fEndWidth number 结束宽度
	---@param fDistance number 距离
	---@param func function 操作函数
	---@param iTeamFilter number 可选队伍过滤
	---@param iTypeFilter number 可选类型过滤
	---@param iFlagFilter number 可选标记过滤
	function DoCleaveAction(hAttacker, hTarget, fStartWidth, fEndWidth, fDistance, func, iTeamFilter, iTypeFilter, iFlagFilter)
		local fRadius = math.max(fStartWidth / 2, math.max(fEndWidth / 2, math.sqrt(fDistance ^ 2 + (fEndWidth / 2) ^ 2)))
		local vStart = hAttacker:GetAbsOrigin()
		local vDirection = hTarget:GetAbsOrigin() - vStart
		vDirection.z = 0
		vDirection = vDirection:Normalized()

		local vEnd = vStart + vDirection * fDistance
		local v = Rotation2D(vDirection, math.rad(90))
		local tPolygon = {
			vStart + v * fStartWidth,
			vEnd + v * fEndWidth,
			vEnd - v * fEndWidth,
			vStart - v * fStartWidth,
		}
		DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())

		local iTeamNumber = hAttacker:GetTeamNumber()
		iTeamFilter = iTeamFilter or (DOTA_UNIT_TARGET_TEAM_ENEMY)
		iTypeFilter = iTypeFilter or (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
		iFlagFilter = iFlagFilter or (DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
		local tTargets = FindUnitsInRadius(iTeamNumber, vStart, nil, fRadius + 100, iTeamFilter, iTypeFilter, iFlagFilter, FIND_CLOSEST, false)
		for _, hUnit in pairs(tTargets) do
			if hUnit ~= hTarget then
				if IsPointInPolygon(hUnit:GetAbsOrigin(), tPolygon) then
					if func(hUnit) == true then
						break
					end
				end
			end
		end
	end

	ONLY_REFLECT_ABILITIES = {}
	function IsAbilityOnlyReflect(hAbility)
		if hAbility == nil then return false end
		return TableFindKey(ONLY_REFLECT_ABILITIES, hAbility:GetName()) ~= nil
	end

	function IsReflectSpellAbility(hAbility)
		if hAbility == nil then return false end
		return hAbility:IsStolen() and hAbility:IsHidden() and hAbility.bIsReflectSpellAbility
	end

	MAX_REFLECT_ABILITIES_COUNT = 5
	function ReflectSpell(hCaster, hTarget, hAbility)
		if IsReflectSpellAbility(hAbility) then
			return
		end

		local sAbilityName = hAbility:GetAbilityName()
		local hReflectAbility
		if hCaster.reflectSpellAbilities == nil then hCaster.reflectSpellAbilities = {} end
		for i = #hCaster.reflectSpellAbilities, 1, -1 do
			local ab = hCaster.reflectSpellAbilities[i]
			if IsValid(ab) then
				if ab:GetAbilityName() == sAbilityName then
					hReflectAbility = ab
				end
			else
				table.remove(hCaster.reflectSpellAbilities, i)
			end
		end
		if hReflectAbility == nil then
			hReflectAbility = hCaster:AddAbility(sAbilityName)
			table.insert(hCaster.reflectSpellAbilities, 1, hReflectAbility)
			if IsValid(hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT + 1]) then
				hCaster.reflectSpellAbilities[MAX_REFLECT_ABILITIES_COUNT + 1]:Remove()
				table.remove(hCaster.reflectSpellAbilities, MAX_REFLECT_ABILITIES_COUNT + 1)
			end
		end

		hReflectAbility:SetStolen(true)
		hReflectAbility:SetHidden(true)
		hReflectAbility.bIsReflectSpellAbility = true
		hReflectAbility.ProcsMagicStick = function(self) return false end

		hReflectAbility:SetLevel(hAbility:GetLevel())
		hCaster:RemoveModifierByName(hReflectAbility:GetIntrinsicModifierName() or "")
		hReflectAbility.GetIntrinsicModifierName = function(self) return "" end

		local hRecordTarget = hCaster:GetCursorCastTarget()
		hCaster:SetCursorCastTarget(hTarget)
		hReflectAbility:OnSpellStart()
		hCaster:SetCursorCastTarget(hRecordTarget)
	end
	---在范围内搜素拥有Modifier的单位的单位组
	function FindUnitsInRadiusByModifierName(sModifierName, iTeamNumber, vPosition, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder)
		local tUnits = FindUnitsInRadius(iTeamNumber, vPosition, nil, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		for i = #tUnits, 1, -1 do
			local hUnit = tUnits[i]
			if not hUnit:HasModifier(sModifierName) then
				table.remove(tUnits, i)
			end
		end
		return tUnits
	end
	---寻找扇形单位
	---@param iTeamNumber number 队伍
	---@param vPosition Vector 起始点
	---@param flRadius number 范围
	---@param vForwardVector Vector 方向
	---@param flAngle number 角度
	---@param iTeamFilter number 队伍过滤
	---@param iTypeFilter number 类型过滤
	---@param iFlagFilter number 标记过滤
	---@param iOrder number 排序规则
	function FindUnitsInSector(iTeamNumber, vPosition, flRadius, vForwardVector, flAngle, iTeamFilter, iTypeFilter, iFlagFilter, iOrder)
		local tRadiusGroup = FindUnitsInRadius(iTeamNumber, vPosition, nil, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		local tSectorGroup = {}
		for _, hUnit in pairs(tRadiusGroup) do
			local vTargetPosition = hUnit:GetAbsOrigin()
			local vTargetVector = vTargetPosition - vPosition
			local NAN = math.floor(vTargetVector:Dot(vForwardVector) / math.sqrt((vTargetVector.x ^ 2 + vTargetVector.y ^ 2) * (vForwardVector.x ^ 2 + vForwardVector.y ^ 2)))
			if NAN == 1 then
				table.insert(tSectorGroup, hUnit)
			else
				local vTargetAngle = math.abs(math.deg(math.acos(vTargetVector:Dot(vForwardVector) / math.sqrt((vTargetVector.x ^ 2 + vTargetVector.y ^ 2) * (vForwardVector.x ^ 2 + vForwardVector.y ^ 2)))))
				local flOffsetAngle = flAngle * 0.5
				if vTargetAngle < flOffsetAngle then
					table.insert(tSectorGroup, hUnit)
				end
			end
		end
		return tSectorGroup
	end

	-- 用技能kv寻找直线单位
	function FindUnitsInLineWithAbility(hCaster, vStart, vEnd, flWidth, hAbility)
		return FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, flWidth, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	end
	-- 用技能kv寻找单位
	function FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, hAbility, iOrder)
		if not IsValid(hCaster) or not IsValid(hAbility) then return end
		if iOrder == nil then
			iOrder = FIND_ANY_ORDER
		end
		if hCaster.IsBuilding and hCaster:IsBuilding() then
			return Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), vPosition, flRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), iOrder, hCaster.Spawner_spawnerPlayerID, true)
		else
			return FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, flRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), iOrder, false)
		end
	end
	-- 范围内是否有单位
	function CDOTABaseAbility:HasUnitInRange(flRange, iOrder)
		iOrder = iOrder or FIND_ANY_ORDER
		local hCaster = self:GetCaster()
		local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), flRange, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), iOrder, hCaster.Spawner_spawnerPlayerID, true)
		if IsValid(tTargets[1]) then
			return tTargets[1]
		end
		return false
	end
	--[[		DOTA_UNIT_ORDER_NONE
		DOTA_UNIT_ORDER_MOVE_TO_POSITION
		DOTA_UNIT_ORDER_MOVE_TO_TARGET
		DOTA_UNIT_ORDER_ATTACK_MOVE
		DOTA_UNIT_ORDER_ATTACK_TARGET
		DOTA_UNIT_ORDER_CAST_POSITION
		DOTA_UNIT_ORDER_CAST_TARGET
		DOTA_UNIT_ORDER_CAST_TARGET_TREE
		DOTA_UNIT_ORDER_CAST_NO_TARGET
		DOTA_UNIT_ORDER_CAST_TOGGLE
		DOTA_UNIT_ORDER_HOLD_POSITION
		DOTA_UNIT_ORDER_TRAIN_ABILITY
		DOTA_UNIT_ORDER_DROP_ITEM
		DOTA_UNIT_ORDER_GIVE_ITEM
		DOTA_UNIT_ORDER_PICKUP_ITEM
		DOTA_UNIT_ORDER_PICKUP_RUNE
		DOTA_UNIT_ORDER_PURCHASE_ITEM
		DOTA_UNIT_ORDER_SELL_ITEM
		DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
		DOTA_UNIT_ORDER_MOVE_ITEM
		DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
		DOTA_UNIT_ORDER_STOP
		DOTA_UNIT_ORDER_TAUNT
		DOTA_UNIT_ORDER_BUYBACK
		DOTA_UNIT_ORDER_GLYPH
		DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
		DOTA_UNIT_ORDER_CAST_RUNE
	]]
	---发布指令
	---@param hUnit CDOTA_BaseNPC 单位
	---@param iOrder number 指令
	function ExecuteOrder(hUnit, iOrder, ...)
		local hAbility = nil
		local hTarget = nil
		local vPosition = nil
		local tPositionOrder = { DOTA_UNIT_ORDER_MOVE_TO_POSITION, DOTA_UNIT_ORDER_ATTACK_MOVE }
		local tTargetOrder = { DOTA_UNIT_ORDER_MOVE_TO_TARGET, DOTA_UNIT_ORDER_ATTACK_TARGET }
		local tAbilityOrder = { DOTA_UNIT_ORDER_CAST_POSITION, DOTA_UNIT_ORDER_CAST_TARGET, DOTA_UNIT_ORDER_CAST_TARGET_TREE, DOTA_UNIT_ORDER_CAST_NO_TARGET, DOTA_UNIT_ORDER_CAST_TOGGLE }
		if TableFindKey(tPositionOrder, iOrder) ~= nil then
			vPosition = ...
		elseif TableFindKey(tTargetOrder, iOrder) ~= nil then
			hTarget = ...
		elseif TableFindKey(tAbilityOrder, iOrder) ~= nil then
			if iOrder == DOTA_UNIT_ORDER_CAST_POSITION then
				hAbility, vPosition = ...
			else
				hAbility, hTarget = ...
			end
		end
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = iOrder,
			TargetIndex = IsValid(hTarget) and hTarget:entindex() or nil,
			AbilityIndex = IsValid(hAbility) and hAbility:entindex() or nil,
			Position = vPosition,
			Queue = 0
		})
	end

	----------------------------------------CDOTA_BaseNPC----------------------------------------
	---升级
	function CDOTA_BaseNPC:LevelUp(iLevels)
		if iLevels <= 0 then
			return
		end
		for i = 1, iLevels, 1 do
			self:HeroLevelUp(false)
		end
	end

	--- 造成伤害
	---@param funcCallBack funtion funtion(tDamageData)=>void
	function CDOTA_BaseNPC:DealDamage(tTargets, hAbility, flDamage, iDamageType, iDamageFlags)
		if tTargets == nil then return end
		if flDamage == nil then flDamage = 0 end
		if tTargets.IsHero ~= nil then
			tTargets = { tTargets }
		end
		if hAbility ~= nil and iDamageType == nil then
			iDamageType = hAbility:GetAbilityDamageType()
		end
		if iDamageFlags == nil then
			iDamageFlags = DOTA_DAMAGE_FLAG_NONE
		end
		for i, hUnit in ipairs(tTargets) do
			local tDamageInfo = {
				attacker = self,
				victim = hUnit,
				ability = hAbility,
				damage = flDamage,
				damage_type = iDamageType,
				damage_flags = iDamageFlags
			}
			ApplyDamage(tDamageInfo)
		end
	end
	---使目标向某个方向击退
	---@param vDirection 方向
	---@param flDistance 距离
	---@param flHeight 最大高度
	---@param flDuration 持续时间
	---@param bStun 默认晕眩
	---@param hIntrinsicModifier 附带的modifier
	---@param callback 结束回调
	function CDOTA_BaseNPC:KnockBack(vDirection, flDistance, flHeight, flDuration, bStun, hIntrinsicModifier, callback)
		if bStun == nil then
			bStun = true
		end
		if not self:IsAlive() then
			return
		end
		local kv = {
			vDirection = vDirection,
			duration = flDuration,
			knockback_duration = flDuration,
			knockback_distance = flDistance,
			knockback_height = flHeight,
			bStun = bStun
		}
		self:RemoveModifierByName("modifier_knockback_custom")
		local hModifier = self:AddNewModifier(self, nil, "modifier_knockback_custom", kv)
		if IsValid(hModifier) then
			hModifier.callback = callback
			hModifier._hIntrinsicModifier = hIntrinsicModifier
			FireModifierEvent({
				event_name = MODIFIER_EVENT_ON_KNOCKBACK,
				unit = self
			})
		end
	end


	FOLLOW_MOTION_TYPE_PROJECTILE = 0	---跟随弹道
	FOLLOW_MOTION_TYPE_ENTITY = 1		---跟随实体

	---让单位跟随某个东西移动，可以是弹道也可以是单位
	---@param iFollowType 跟随类型
	---@param hHandle 跟随的实体或弹道
	---@param flDuration 持续时间 可选
	---@param hIntrinsicModifier 附带的modifier
	---@param callback 结束回调
	function CDOTA_BaseNPC:FollowMotion(iFollowType, hHandle, flDuration, hIntrinsicModifier, callback)
		if not IsValid(self) or not self:IsAlive() then return end
		self:RemoveModifierByName("modifier_follow_motion")
		local hModifier = self:AddNewModifier(self, nil, "modifier_follow_motion", { duration = flDuration })
		if IsValid(hModifier) then
			if iFollowType == FOLLOW_MOTION_TYPE_PROJECTILE then
				hModifier:FollowProjectile(hHandle)
			end
			if iFollowType == FOLLOW_MOTION_TYPE_ENTITY then
				hModifier:FollowEntity(hHandle)
			end
			hModifier.callback = callback
			hModifier._hIntrinsicModifier = hIntrinsicModifier
		end
	end

	---使目标向某个方向冲刺
	---@param vDirection 方向
	---@param flDistance 距离
	---@param flHeight 最大高度
	---@param flDuration 持续时间
	---@param hIntrinsicModifier 附带的modifier会在结束的时候销毁
	---@param callback 结束回调
	function CDOTA_BaseNPC:Dash(vDirection, flDistance, flHeight, flDuration, hIntrinsicModifier, callback)
		if not self:IsAlive() then
			return
		end
		local kv = {
			vDirection = vDirection,
			duration = flDuration,
			knockback_duration = flDuration,
			knockback_distance = flDistance,
			knockback_height = flHeight,
		}
		self:RemoveModifierByName("modifier_dash")
		local hModifier = self:AddNewModifier(self, nil, "modifier_dash", kv)
		if IsValid(hModifier) then
			hModifier.callback = callback
			hModifier._hIntrinsicModifier = hIntrinsicModifier
			FireModifierEvent({
				event_name = MODIFIER_EVENT_ON_DASH,
				unit = self
			})
		end
	end

	if CDOTA_BaseNPC.AddAbility_Engine == nil then
		---@private
		CDOTA_BaseNPC.AddAbility_Engine = CDOTA_BaseNPC.AddAbility
	end
	---添加技能给单位
	---@param sAbilityName 技能名
	---@param iLevel 可选技能等级
	---@return CDOTABaseAbility|CDOTA_Ability_Lua
	function CDOTA_BaseNPC:AddAbility(sAbilityName, iLevel)
		local hAbility = self:AddAbility_Engine(sAbilityName)
		if hAbility.GetIntrinsicModifierName and hAbility:GetIntrinsicModifierName() then
			self:RemoveModifierByNameAndCaster(hAbility:GetIntrinsicModifierName(), self)
		end
		if iLevel and iLevel > 0 then
			hAbility:SetLevel(iLevel)
		end
		return hAbility
	end

	---@private
	if CDOTA_BaseNPC.RemoveAbilityByHandle_Engine == nil then
		---@private
		CDOTA_BaseNPC.RemoveAbilityByHandle_Engine = CDOTA_BaseNPC.RemoveAbilityByHandle
	end
	---删除技能并清除modifier
	---@param hAbility 技能实体
	function CDOTA_BaseNPC:RemoveAbilityByHandle(hAbility)
		local tModifiers = self:FindAllModifiers()
		for _, hModifier in ipairs(tModifiers) do
			if hModifier:GetAbility() == hAbility then
				hModifier:Destroy()
			end
		end
		self:RemoveAbilityByHandle_Engine(hAbility)
	end
	-- 修正的技能
	function CDOTA_BaseNPC:FixAbilities(source)
		-- if not self:IsIllusion() then return end
		-- 删除技能
		for index = self:GetAbilityCount() - 1, 0, -1 do
			local hAbility = self:GetAbilityByIndex(index)
			if hAbility then
				self:RemoveAbility(hAbility:GetAbilityName())
			end
		end

		self:SetAbilityPoints(0)

		for index = 0, self:GetAbilityCount() - 1, 1 do
			local hAbility = source:GetAbilityByIndex(index)

			if hAbility then
				local _ability = self:AddAbility(hAbility:GetAbilityName())
				local abilityLevel = hAbility:GetLevel()
				if _ability then
					self:RemoveModifierByName(_ability:GetIntrinsicModifierName() or "")
					for i = 1, abilityLevel, 1 do
						self:UpgradeAbility(_ability)
					end
					_ability:SetHidden(hAbility:IsHidden())
					_ability:SetStolen(hAbility:IsStolen())
				end
			end
		end
	end

	---召唤单位
	---@param sUnitName 单位名字
	---@return CDOTA_BaseNPC
	function CDOTA_BaseNPC:SummonUnit(sUnitName, vPosition, bFindClearSpace, flDuration, tExtraData)
		local vForward = self:GetForwardVector()
		tExtraData = tExtraData or {}
		tExtraData.angles = tostring(vForward.x) .. " " .. tostring(vForward.y) .. " " .. tostring(vForward.z)
		tExtraData.iOwnerIndex = self:entindex()

		-- local hUnit = CreateUnitFromTable(tUnitData, vPosition)
		local hUnit = CreateUnitByNameWithNewData(sUnitName, vPosition, true, self, self, self:GetTeamNumber(), tExtraData)
		hUnit:SetControllableByPlayer(self:GetPlayerOwnerID(), false)
		hUnit:SetForwardVector(self:GetForwardVector())
		hUnit.hSummoner = self
		if flDuration then
			hUnit:AddNewModifier(self, nil, "modifier_kill", { duration = flDuration })
		end
		-- Fire_OnSummonned({
		-- 	unit = self,
		-- 	target = hUnit
		-- })
		return hUnit
	end

	---获取召唤者
	function CDOTA_BaseNPC:GetSummoner()
		return self.hSummoner
	end

	ATTACK_STATE_NOT_USECASTATTACKORB = 1 -- 不触发攻击法球
	ATTACK_STATE_NOT_PROCESSPROCS = 2 -- 不触发攻击特效
	ATTACK_STATE_SKIPCOOLDOWN = 8 -- 无视攻击间隔
	ATTACK_STATE_IGNOREINVIS = 16 -- 不触发破影一击
	ATTACK_STATE_NOT_USEPROJECTILE = 32 -- 没有攻击弹道
	ATTACK_STATE_FAKEATTACK = 64 -- 假攻击
	ATTACK_STATE_NEVERMISS = 128 -- 攻击不会丢失
	ATTACK_STATE_NO_CLEAVE = 256 -- 没有分裂攻击
	ATTACK_STATE_NO_EXTENDATTACK = 512 -- 没有触发额外攻击
	ATTACK_STATE_SKIPCOUNTING = 1024 -- 不减少各种攻击计数
	ATTACK_STATE_CRIT = 2048 -- 暴击，暴击技能里添加，Attack里加入无效

	---发动一次攻击
	function CDOTA_BaseNPC:Attack(hTarget, iAttackState)
		if iAttackState == nil then iAttackState = 0 end
		local iNextRecord = GetNextRecord()
		local bUseCastAttackOrb = (bit.band(iAttackState, ATTACK_STATE_NOT_USECASTATTACKORB) ~= ATTACK_STATE_NOT_USECASTATTACKORB)
		local bProcessProcs = (bit.band(iAttackState, ATTACK_STATE_NOT_PROCESSPROCS) ~= ATTACK_STATE_NOT_PROCESSPROCS)
		local bSkipCooldown = (bit.band(iAttackState, ATTACK_STATE_SKIPCOOLDOWN) == ATTACK_STATE_SKIPCOOLDOWN)
		local bIgnoreInvis = (bit.band(iAttackState, ATTACK_STATE_IGNOREINVIS) == ATTACK_STATE_IGNOREINVIS)
		local bUseProjectile = (bit.band(iAttackState, ATTACK_STATE_NOT_USEPROJECTILE) ~= ATTACK_STATE_NOT_USEPROJECTILE)
		local bFakeAttack = (bit.band(iAttackState, ATTACK_STATE_FAKEATTACK) == ATTACK_STATE_FAKEATTACK)
		local bNeverMiss = (bit.band(iAttackState, ATTACK_STATE_NEVERMISS) == ATTACK_STATE_NEVERMISS)

		if RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM == nil then RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM = {} end
		RECORD_SYSTEM_DUMMY.ATTACK_SYSTEM[iNextRecord] = iAttackState

		if not bFakeAttack and bProcessProcs and bUseCastAttackOrb then
			local params = {
				attacker = self,
				target = hTarget,
			}
			if IsValid(params.attacker) and params.attacker.tSourceModifierEvents and params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = params.attacker.tSourceModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(params.attacker) and IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
			if IsValid(params.target) and params.target.tTargetModifierEvents and params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = params.target.tTargetModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(params.target) and IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
			if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START] then
				local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_ATTACK_START]
				for i = #tModifiers, 1, -1 do
					local hModifier = tModifiers[i]
					if IsValid(hModifier) and hModifier.OnAttackStart_AttackSystem then
						hModifier:OnAttackStart_AttackSystem(params)
					else
						table.remove(tModifiers, i)
					end
				end
			end
		end

		self:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss)

		return iNextRecord
	end

	function CDOTA_BaseNPC:GetStatusResistanceCaster()
		local fValue = GetStatusResistanceCaster(self) * 0.01

		return fValue
	end

	function CDOTA_BaseNPC:GetStatusResistanceFactor(hCaster)
		local fValue = 1 - GetStatusResistance(self) * 0.01
		if IsValid(hCaster) then
			fValue = fValue * (1 + hCaster:GetStatusResistanceCaster())
		end
		return fValue
	end

	function CDOTA_BaseNPC:ReplaceItem(old_item, new_item)
		if type(old_item) ~= "table" then return end
		if type(new_item) == "string" then
			new_item = CreateItem(new_item, old_item:GetParent(), old_item:GetPurchaser())
		end
		if type(new_item) ~= "table" then return end
		new_item:SetPurchaseTime(old_item:GetPurchaseTime())
		new_item:SetCurrentCharges(old_item:GetCurrentCharges())
		new_item:SetItemState(old_item:GetItemState())
		local index1 = 0
		for index = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
			local item = self:GetItemInSlot(index)
			if item and item == old_item then
				index1 = index
				break
			end
		end
		self:RemoveItem(old_item)
		self:AddItem(new_item)
		for index2 = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
			local item = self:GetItemInSlot(index2)
			if item and item == new_item then
				self:SwapItems(index2, index1)
				break
			end
		end
		return new_item
	end

	---添加modifier，可以计算抗性
	function CDOTA_BaseNPC:AddModifier(hCaster, hAbility, sModifierName, params, bCaculateStatusResistance)
		if bCaculateStatusResistance and type(params.duration) == "number" then
			params.duration = params.duration * self:GetStatusResistanceFactor(hCaster)
		end
		self:AddNewModifier(hCaster, hAbility, sModifierName, params)
	end

	---被动施法模拟动作
	---@param hAbility CDOTABaseAbility 技能，自动调用kv里的施法前摇与动作
	---@param iOrderType DOTA_UNIT_ORDERS DOTA_UNIT_ORDER_CAST_POSITION | DOTA_UNIT_ORDER_CAST_TARGET | DOTA_UNIT_ORDER_CAST_NO_TARGET
	---@param tExtraData {vPosition:Vector,hTarget:CDOTA_BaseNPC,iAnimationRate:number,bFadeAnimation:boolean,sActivityModifier:string,tCallBackParams:table,flCastPoint:number,iCastAnimation:number,bIgnoreBackswing:boolean,bUseCooldown:boolean,bUseMana:boolean,OnAbilityPhaseStart:function,OnAbilityPhaseInterrupted:function}
	---@param func function 回调，默认调用技能的OnSpellStart
	function CDOTA_BaseNPC:PassiveCast(hAbility, iOrderType, tExtraData, func)
		if not IsValid(hAbility) then return end

		-- 默认值
		if tExtraData == nil then tExtraData = {} end
		local flCastPoint = tExtraData.flCastPoint or hAbility:GetCastPoint()
		local iCastAnimation = tExtraData.iCastAnimation or hAbility:GetCastAnimation()
		-- 处理sActivityModifier
		local sActivityModifier = tExtraData.sActivityModifier
		if tExtraData.sActivityModifier and type(tExtraData.sActivityModifier) == "table" then
			sActivityModifier = string.join(tExtraData.sActivityModifier, ",")
		end
		-- 使用modifier模拟前摇
		local tData = {
			duration = flCastPoint,
			flCastPoint = flCastPoint,
			iCastAnimation = iCastAnimation,
			iOrderType = iOrderType,
			iAnimationRate = tExtraData.iAnimationRate,
			vPosition = tExtraData.vPosition,
			iTargetIndex = IsValid(tExtraData.hTarget) and tExtraData.hTarget:entindex() or nil,
			bFadeAnimation = tExtraData.bFadeAnimation,
			sActivityModifier = sActivityModifier,
			bIgnoreBackswing = tExtraData.bIgnoreBackswing or true,
			bUseCooldown = (tExtraData.bUseCooldown == nil or tExtraData.bUseCooldown == true) and 1 or 0,
			bUseMana = (tExtraData.bUseMana == nil or tExtraData.bUseMana == true) and 1 or 0,
		}
		-- 自定义施法抬手与打断
		hAbility.CustomAbilityPhaseStart = tExtraData.OnAbilityPhaseStart
		hAbility.CustomAbilityPhaseInterrupted = tExtraData.OnAbilityPhaseInterrupted

		local hModifier = self:AddNewModifier(self, hAbility, "modifier_passive_cast", tData)
		if IsValid(hModifier) then
			hModifier.callback = func
		end
	end

	---闪电链跳跃（技能kv要填目标类型等）
	---@param hMainTarget CDOTA_BaseNPC 主要目标
	---@param hAbility CDOTA_Ability_Lua 技能
	---@param funcAction function 对目标的操作函数
	---@param callback function | string 回调自己创建特效或者填特效名自动绑定控制点0到1
	---@param tExtraData {hSource:CDOTA_BaseNPC,sAttachName:string,flJumpDelay:number,sSoundName:string,iJumpCount:number,flJumpRadius:number,bJumpRepeat:boolean,iTeamfilter:number,iTypeFilter:number,iFlagsFilter:number} hSource是默认特效来源单位是自身，sAttachName默认特效绑定点是attach_attack1，flDelay默认跳跃间隔是0
	function CDOTA_BaseNPC:LightningStrike(hMainTarget, hAbility, funcAction, callback, tExtraData)
		tExtraData = default(tExtraData, {})
		local hSource = default(tExtraData.hSource, self)
		local sAttachName = default(tExtraData.sAttachName, "attach_attack1")
		local flJumpDelay = default(tExtraData.flJumpDelay, 0)
		local flJumpRadius = default(tExtraData.flJumpRadius, 600)
		local bJumpRepeat = default(tExtraData.bJumpRepeat, false)
		local iTeamFilter = default(tExtraData.iTeamFilter, hAbility:GetAbilityTargetTeam())
		local iTypeFilter = default(tExtraData.iTypeFilter, hAbility:GetAbilityTargetType())
		local iFlagsFilter = default(tExtraData.iFlagsFilter, hAbility:GetAbilityTargetFlags())
		local Action = function(_hSource, _hTarget, bFirst)
			funcAction(_hTarget, bFirst)
			if type(callback) == "function" then
				callback(_hSource, _hTarget, bFirst)
			elseif type(callback) == "string" then
				local iParticleID = ParticleManager:CreateParticle(callback, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, _hSource, PATTACH_POINT_FOLLOW, bFirst and sAttachName or "attach_hitloc", _hSource:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, _hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", _hTarget:GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
		if tExtraData.sSoundName then
			EmitSoundOnLocationWithCaster(hMainTarget:GetAbsOrigin(), tExtraData.sSoundName, self)
		end
		local tTargets = { hMainTarget }
		local iJumpCount = default(tExtraData.iJumpCount, 0)

		for _, hUnit in ipairs(tTargets) do
			local tRecord = {}
			local _hUnit = hUnit
			Action(hSource, _hUnit, bFirst)
			table.insert(tRecord, _hUnit)
			if iJumpCount > 0 then
				self:GameTimer(flJumpDelay, function()
					iJumpCount = iJumpCount - 1
					local tJumpTargets = FindUnitsInRadius(self:GetTeamNumber(), _hUnit:GetAbsOrigin(), nil, flJumpRadius, iTeamFilter, iTypeFilter, iFlagsFilter, FIND_CLOSEST, false)
					if bJumpRepeat then
						ArrayRemove(tJumpTargets, _hUnit)
					else
						for _, hRecordUnit in ipairs(tRecord) do
							ArrayRemove(tJumpTargets, hRecordUnit)
						end
					end
					if IsValid(tJumpTargets[1]) then
						Action(_hUnit, tJumpTargets[1])
						table.insert(tRecord, tJumpTargets[1])
						if iJumpCount > 0 then
							_hUnit = tJumpTargets[1]
							return flJumpDelay
						end
					end
					if tExtraData.sSoundName then
						EmitSoundOnLocationWithCaster(_hUnit:GetAbsOrigin(), tExtraData.sSoundName, self)
					end
				end)
			end
		end
	end
	---消耗生命
	function CDOTA_BaseNPC:SpendHealth(flHealthSpend, hAbility, bLethal)
		self:ModifyHealth(self:GetCustomHealth() - flHealthSpend, hAbility, bLethal, 0)
	end

	---给生命
	function CDOTA_BaseNPC:GiveHealth(flHealth, hAbility)
		self:ModifyHealth(self:GetCustomHealth() + flHealth, hAbility, false, 0)
	end

	---刷新技能
	function CDOTA_BaseNPC:RefreshAbilities()
		for i = 0, self:GetAbilityCount() - 1 do
			local hAbility = self:GetAbilityByIndex(i)
			if IsValid(hAbility) and hAbility:IsRefreshable() then
				hAbility:AddCharges(1)
			end
		end
	end
	---刷新物品
	function CDOTA_BaseNPC:RefreshItems()
		for i = 0, DOTA_ITEM_MAX - 1, 1 do
			local hItem = self:GetItemInSlot(i)
			if IsValid(hItem) and hItem:IsRefreshable() then
				hItem:EndCooldown()
				-- hItem:SetCurrentCharges(hItem:GetInitialCharges())
			end
		end
	end


	---能量冲击（技能kv要填目标类型等）
	---@param hMainTarget CDOTA_BaseNPC 主要目标
	---@param hAbility CDOTA_Ability_Lua 技能
	---@param callback function | string 回调自己创建特效或者填特效名自动绑定控制点0到1
	---@param tExtraData {hSource:CDOTA_BaseNPC,sAttachName:string,flJumpDelay:number,sSoundName:string,iJumpCount:number,flJumpRadius:number,bRepeat:boolean} hSource是默认特效来源单位是自身，sAttachName默认特效绑定点是attach_attack1，flDelay默认跳跃间隔是0
	---@param hSource CDOTA_BaseNPC | nil 默认特效来源单位是自身
	---@param sAttachName string | nil 默认特效绑定点是attach_attack1
	function CDOTA_BaseNPC:EnergyStrike(hMainTarget, hAbility, flDamage, callback, tExtraData)
		tExtraData = default(tExtraData, {})
		local hSource = default(tExtraData.hSource, self)
		local sAttachName = default(tExtraData.sAttachName, "attach_attack1")
		local flJumpDelay = default(tExtraData.flJumpDelay, 0)
		local flJumpRadius = default(tExtraData.flJumpRadius, 600)
		local bRepeat = default(tExtraData.bRepeat, false)
		local Action = function(_hSource, _hTarget, bFirst)
			self:DealDamage(_hTarget, hAbility, flDamage, DAMAGE_TYPE_MAGICAL)
			if type(callback) == "function" then
				callback(_hSource, _hTarget, bFirst)
			elseif type(callback) == "string" then
				local iParticleID = ParticleManager:CreateParticle(callback, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, _hSource, PATTACH_POINT_FOLLOW, bFirst and sAttachName or "attach_hitloc", _hSource:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, _hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", _hTarget:GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
		if tExtraData.sSoundName then
			EmitSoundOnLocationWithCaster(hMainTarget:GetAbsOrigin(), tExtraData.sSoundName, self)
		end
		local tTargets = { hMainTarget }
		local iJumpCount = default(tExtraData.iJumpCount, 0)
		for _, hUnit in ipairs(tTargets) do
			local tRecord = {}
			local _hUnit = hUnit
			Action(hSource, _hUnit, true)
			table.insert(tRecord, _hUnit)
			if iJumpCount > 0 then
				self:GameTimer(flJumpDelay, function()
					iJumpCount = iJumpCount - 1
					local tJumpTargets = FindUnitsInRadiusWithAbility(self, _hUnit:GetAbsOrigin(), flJumpRadius, hAbility, FIND_CLOSEST)
					if bRepeat then
						ArrayRemove(tJumpTargets, _hUnit)
					else
						for _, hRecordUnit in ipairs(tRecord) do
							ArrayRemove(tJumpTargets, hRecordUnit)
						end
					end
					if IsValid(tJumpTargets[1]) then
						Action(_hUnit, tJumpTargets[1])
						table.insert(tRecord, tJumpTargets[1])
						if tExtraData.sSoundName then
							EmitSoundOnLocationWithCaster(_hUnit:GetAbsOrigin(), tExtraData.sSoundName, self)
						end
						if iJumpCount > 0 then
							_hUnit = tJumpTargets[1]
							return flJumpDelay
						end
					end
				end)
			end
		end
	end
	----------------------------------------CDOTABaseAbility----------------------------------------
	function CDOTABaseAbility:IsAbilityReady()
		local hCaster = self:GetCaster()
		local iBehavior = self:GetBehaviorInt()

		if not IsValid(hCaster) then
			return false
		end

		local hAbility = hCaster:GetCurrentActiveAbility()
		if IsValid(hAbility) and hAbility:IsInAbilityPhase() then
			return false
		end

		if self:GetLevel() <= 0 then
			return false
		end

		if self:IsHidden() then
			return false
		end

		if not self:IsActivated() then
			return false
		end

		if not self:IsCooldownReady() then
			return false
		end

		if not self:IsOwnersManaEnough() then
			return false
		end

		if not self:IsOwnersGoldEnough(hCaster:GetPlayerOwnerID()) then
			return false
		end

		if hCaster:IsHexed() or hCaster:IsCommandRestricted() then
			return false
		end

		if bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE and hCaster:IsStunned() then
			return false
		end

		if not self:IsItem() and not self:IsPassive() and hCaster:IsSilenced() then
			return false
		end

		if not self:IsItem() and self:IsPassive() and hCaster:PassivesDisabled() then
			return false
		end

		if self:IsItem() and not self:IsPassive() and hCaster:IsMuted() then
			return false
		end

		if bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL and hCaster:IsChanneling() then
			return false
		end

		if not self:IsFullyCastable() then
			return false
		end

		return true
	end

	---获取技能的被动modifier
	function CDOTABaseAbility:GetIntrinsicModifier()
		local tModifiers = self:GetCaster():FindAllModifiersByName(self:GetIntrinsicModifierName())
		for i, hModifier in ipairs(tModifiers) do
			if hModifier:GetAbility() == self then
				return hModifier
			end
		end
		return nil
	end

	----------------------------------------CDOTA_Buff----------------------------------------
	---获取技能伤害
	function CDOTA_Buff:GetAbilityDamage()
		return self:GetAbility():GetAbilityDamage()
	end

	----------------------------------------CDOTA_BaseNPC_Hero----------------------------------------
	--[[-
		创建幻象，tModifierKeys支持[outgoing_damage,incoming_damage,bounty_base,bounty_growth,outgoing_damage_structure,outgoing_damage_roshan]
	--]]
	function CDOTA_BaseNPC_Hero:CreateIllusions(hOwner, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
		local illusions = CreateIllusions(hOwner, self, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

		for i, illusion in ipairs(illusions) do
			-- illusion:FixAbilities(self)
			illusion:AddNewModifier(illusion, illusion:GetDummyAbility(), "modifier_attribute", nil)
			illusion:AddNewModifier(illusion, illusion:GetDummyAbility(), "modifier_hero_attribute", nil)
			illusion.tPermanentAttribute = self.tPermanentAttribute
		end

		return illusions
	end

	----------------------------------------CEntityInstance----------------------------------------
	function CEntityInstance:RemoveSelf()
		self:Remove()
	end
	function CEntityInstance:Destroy()
		self:Remove()
	end
end