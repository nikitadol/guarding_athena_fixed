---@type _G
EOM_MODIFIER_PROPERTIES = {
	-- 一些仅能对敌方使用的属性
	EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY = { "EOM_GetModifierHealthPercentageEnemy", AdditionMultiplicationPercentage }, -- 敌方血量百分比加减，为乘法叠加
	-- AdditionMultiplicationPercentage
	-- 攻击力
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE = "EOM_GetModifierAttackDamageBase",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_STR = "EOM_GetModifierAttackDamageBaseStr",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_AGI = "EOM_GetModifierAttackDamageBaseAgi",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_INT = "EOM_GetModifierAttackDamageBaseInt",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS = "EOM_GetModifierAttackDamageBonus",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = "EOM_GetModifierAttackDamageBasePercentage",
	EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_PERCENTAGE = "EOM_GetModifierAttackDamagePercentage",
	-- 基础攻击间隔
	EOM_MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT_ADJUST = "EOM_GetModifierBaseAttackTimeConstant_Adjust",
	-- 攻击距离
	EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = "EOM_GetModifierAttackRangeBonus",
	EOM_MODIFIER_PROPERTY_ATTACK_RANGE_PERCENTAGE = "EOM_GetModifierAttackRangePercentage",
	-- 护甲
	EOM_MODIFIER_PROPERTY_ARMOR_BASE = "EOM_GetModifierArmorBase",
	EOM_MODIFIER_PROPERTY_ARMOR_BASE_STR = "EOM_GetModifierArmorBaseStr",
	EOM_MODIFIER_PROPERTY_ARMOR_BASE_AGI = "EOM_GetModifierArmorBaseAgi",
	EOM_MODIFIER_PROPERTY_ARMOR_BASE_INT = "EOM_GetModifierArmorBaseInt",
	EOM_MODIFIER_PROPERTY_ARMOR_BONUS = "EOM_GetModifierArmorBonus",
	EOM_MODIFIER_PROPERTY_ARMOR_BASE_PERCENTAGE = "EOM_GetModifierArmorBasePercentage",
	EOM_MODIFIER_PROPERTY_ARMOR_PERCENTAGE = "EOM_GetModifierArmorPercentage",
	-- 无视护甲
	EOM_MODIFIER_PROPERTY_IGNORE_ARMOR = "EOM_GetModifierIgnoreArmor",
	EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE = { "EOM_GetModifierIgnoreArmorPercentage", SubtractionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE_UNIQUE = { "EOM_GetModifierIgnoreArmorPercentageUnique", Maximum },
	EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE_TARGET = { "EOM_GetModifierIgnoreArmorPercentageTarget", SubtractionMultiplicationPercentage }, -- 护甲被无视一定比例，一般用于[符合条件的单位]无视此单位一定护甲的情况
	-- 生命值
	EOM_MODIFIER_PROPERTY_HEALTH_BASE_STR = "EOM_GetModifierHealthBaseStr",
	EOM_MODIFIER_PROPERTY_HEALTH_BONUS = "EOM_GetModifierHealthBonus",
	EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE = "EOM_GetModifierHealthPercentage",
	-- 生命恢复
	EOM_MODIFIER_PROPERTY_BASE_HEALTH_REGEN_CONSTANT_STR = "EOM_GetModifierConstantBaseHealthRegenStr",
	EOM_MODIFIER_PROPERTY_BASE_HEALTH_REGEN_CONSTANT = "EOM_GetModifierConstantBaseHealthRegen",
	EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = "EOM_GetModifierConstantHealthRegen",
	EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = "EOM_GetModifierHealthRegenPercentage",
	-- 魔法值
	EOM_MODIFIER_PROPERTY_MANA_BASE_INT = "EOM_GetModifierManaBaseInt",
	EOM_MODIFIER_PROPERTY_MANA_BONUS = "EOM_GetModifierManaBonus",
	EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE = "EOM_GetModifierManaPercentage",
	-- 魔法恢复
	EOM_MODIFIER_PROPERTY_BASE_MANA_REGEN_CONSTANT_INT = "EOM_GetModifierConstantBaseManaRegenInt",
	EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = "EOM_GetModifierConstantManaRegen",
	EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE = "EOM_GetModifierConstantManaRegenUnique",
	EOM_MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE = "EOM_GetModifierManaRegenPercentage",
	-- 状态抗性
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING = { "EOM_GetModifierStatusResistanceStacking", SubtractionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_UNIQUE = { "EOM_GetModifierStatusResistanceUnique", Maximum },
	EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER = { "EOM_GetModifierStatusResistanceCaster", AdditionMultiplicationPercentage },
	-- 闪避
	EOM_MODIFIER_PROPERTY_EVASION_CONSTANT = { "EOM_GetModifierEvasion_Constant", SubtractionMultiplicationPercentage },
	-- 冷却减少
	EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT = "EOM_GetModifierConstantCooldown",
	EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = { "EOM_GetModifierPercentageCooldown", SubtractionMultiplicationPercentage },
	-- 暴击
	EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = "EOM_GetModifierPhysicalCriticalStrikeChance",
	EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = "EOM_GetModifierPhysicalCriticalStrikeDamage",
	EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY = "EOM_GetModifierPhysicalCriticalStrikeDamageAmplify",
	EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_CHANCE = "EOM_GetModifierMagicalCriticalStrikeChance",
	EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE = "EOM_GetModifierMagicalCriticalStrikeDamage",
	EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY = "EOM_GetModifierMagicalCriticalStrikeDamageAmplify",
	EOM_MODIFIER_PROPERTY_CRITICALSTRIKE_SOUND = { "EOM_GetModifierCriticalStrikeSound", First },
	-- 最大攻击速度
	EOM_MODIFIER_PROPERTY_MAX_ATTACKSPEED_BONUS = "EOM_GetModifierMaximumAttackSpeedBonus",
	-- 造成伤害
	EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE = { "EOM_GetModifierOutgoingPhysicalDamagePercentage", AdditionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE_AGI = "EOM_GetModifierOutgoingPhysicalDamagePercentageAgi",
	EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE = { "EOM_GetModifierOutgoingMagicalDamagePercentage", AdditionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE_INT = "EOM_GetModifierOutgoingMagicalDamagePercentageInt",
	EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = "EOM_GetModifierOutgoingDamagePercentage",

	-- 受到伤害
	EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = { "EOM_GetModifierIncomingPhysicalDamagePercentage", AdditionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE = { "EOM_GetModifierIncomingMagicalDamagePercentage", AdditionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = { "EOM_GetModifierIncomingDamagePercentage", AdditionMultiplicationPercentage },
	EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE_STR = { "EOM_GetModifierIncomingDamagePercentageStr", AdditionMultiplicationPercentage },

	-- 伤害格挡
	EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE = "EOM_GetModifierIgnoreDamage",
	EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE_AGI = "EOM_GetModifierIgnoreDamageAgi",

	-- 全属性
	EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = "EOM_GetModifierBonusStats_All",
	EOM_MODIFIER_PROPERTY_STATS_ALL_BASE = "EOM_GetModifierBaseStats_All",
	EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE = "EOM_GetModifierStats_All_Percentage", -- 全属性百分比
	EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_All_Percentage",
	-- 力量
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = "EOM_GetModifierBonusStats_Strength",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE = "EOM_GetModifierBaseStats_Strength",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE = "EOM_GetModifierStats_Strength_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Strength_Percentage",
	-- 敏捷
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS = "EOM_GetModifierBonusStats_Agility",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE = "EOM_GetModifierBaseStats_Agility",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_PERCENTAGE = "EOM_GetModifierStats_Agility_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Agility_Percentage",
	-- 智力
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = "EOM_GetModifierBonusStats_Intellect",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE = "EOM_GetModifierBaseStats_Intellect",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE = "EOM_GetModifierStats_Intellect_Percentage",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE = "EOM_GetModifierBaseStats_Intellect_Percentage",
	-- 属性成长
	EOM_MODIFIER_PROPERTY_STATS_STRENGTH_GAIN = "EOM_GetModifierBonusStats_StrengthGain",
	EOM_MODIFIER_PROPERTY_STATS_AGILITY_GAIN = "EOM_GetModifierBonusStats_AgilityGain",
	EOM_MODIFIER_PROPERTY_STATS_INTELLECT_GAIN = "EOM_GetModifierBonusStats_IntellectGain",
	-- 吸血
	EOM_MODIFIER_PROPERTY_PHYSICAL_LIFESTEAL = "EOM_GetModifierPhysicalLifesteal",
	EOM_MODIFIER_PROPERTY_MAGICAL_LIFESTEAL = "EOM_GetModifierMagicalLifesteal",
	EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL = "EOM_GetModifierAllLifesteal",
	-- 分裂
	EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE = "EOM_GetModifierCleaveDamage",
	EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS = "EOM_GetModifierCleaveRadius",

	----------------------------------------以下为新项目新增----------------------------------------
	-- 击杀获得荣耀
	EOM_MODIFIER_PROPERTY_PLAYER_KILL_SCORE_BONUS = { "EOM_GetModifierPlayerKillScoreBonus", true },
	-- 击杀获得金币
	EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE = { "EOM_GetModifierPlayerKillGoldPercentage", true },
	-- 掉宝加成
	EOM_MODIFIER_PROPERTY_PLAYER_DROP_CHANCE_PERCENTAGE = { "EOM_GetModifierPlayerDropChancePercentage", true },
	-- 钓鱼暴击几率
	EOM_MODIFIER_PROPERTY_FISHING_CRIT_CHANCE = "EOM_GetModifierFishingCritChance",
	-- 攻击减甲的效果提升
	EOM_MODIFIER_PROPERTY_ARMOR_REDUCTION_PERCENTAGE = "EOM_GetModifierArmorReductionPercentage",
	-- 挖宝暴击几率
	EOM_MODIFIER_PROPERTY_DIG_CRIT_CHANCE = "EOM_GetModifierDigCritChance",
	-- 练功房怪物数量加成
	EOM_MODIFIER_PROPERTY_GOLD_MONSTER_BONUS = "EOM_GetModifierGoldMonsterBonus",
	-- 每秒金钱
	EOM_MODIFIER_PROPERTY_PLAYER_GOLD_PER_SECOND = { "EOM_GetModifierPlayerGoldPerSecond", true },
	-- 每秒魂晶
	EOM_MODIFIER_PROPERTY_PLAYER_CRYSTAL_PER_SECOND = { "EOM_GetModifierPlayerCrystalPerSecond", true },
	-- 每秒击杀
	EOM_MODIFIER_PROPERTY_PLAYER_SCORE_PER_SECOND = { "EOM_GetModifierPlayerScorePerSecond", true },
	-- 属性收益加成
	EOM_MODIFIER_PROPERTY_PLAYER_ATTRIBUTE_GAIN_PERCENTAGE = { "EOM_GetModifierPlayerAttributeGainPercentage", true },
	-- 经验收益加成
	EOM_MODIFIER_PROPERTY_PLAYER_EXPERIENCE_GAIN_PERCENTAGE = { "EOM_GetModifierPlayerExperienceGainPercentage", true },
}

-- 攻击力
function GetOriginalBaseAttackDamage(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseAttackDamage == nil then
			hUnit._BaseAttackDamage = tonumber(KeyValues:GetUnitData(hUnit, "AttackDamage"))
		end
		if hUnit._BaseAttackDamage ~= nil then
			fDefault = hUnit._BaseAttackDamage
		end
	end
	return fDefault
end
function GetBaseAttackDamageStr(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_STR, tParams)
end
function GetBaseAttackDamageAgi(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_AGI, tParams)
end
function GetBaseAttackDamageInt(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_INT, tParams)
end
function GetBaseAttackDamage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE, tParams) + GetBaseAttackDamageStr(hUnit, tParams) + GetBaseAttackDamageAgi(hUnit, tParams) + GetBaseAttackDamageInt(hUnit, tParams) + GetOriginalBaseAttackDamage(hUnit)
end
function GetBaseAttackDamagePercentage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE, tParams)
end
function GetBonusAttackDamage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS, tParams)
end
function GetAttackDamagePercentage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_PERCENTAGE, tParams)
end
function GetAttackDamage(hUnit, tParams)
	return (GetBaseAttackDamage(hUnit, tParams) * (1 + GetBaseAttackDamagePercentage(hUnit, tParams) * 0.01) + GetBonusAttackDamage(hUnit, tParams)) * (1 + GetAttackDamagePercentage(hUnit, tParams) * 0.01)
end
-- 基础攻击间隔
function GetOriginalBaseAttackTime(hUnit)
	local fDefault = 1
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseAttackTime == nil then
			hUnit._BaseAttackTime = tonumber(KeyValues:GetUnitData(hUnit, "AttackRate"))
		end
		if hUnit._BaseAttackTime ~= nil then
			fDefault = hUnit._BaseAttackTime
		end
	end
	return fDefault
end
function GetBaseAttackTimeAdjust(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT_ADJUST, tParams)
end
function GetBaseAttackTime(hUnit, tParams)
	return GetOriginalBaseAttackTime(hUnit) + GetBaseAttackTimeAdjust(hUnit, tParams)
end
-- 攻击距离
function GetOriginalBaseAttackRange(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseAttackRange == nil then
			hUnit._BaseAttackRange = tonumber(KeyValues:GetUnitData(hUnit, "AttackRange"))
		end
		if hUnit._BaseAttackRange ~= nil then
			fDefault = hUnit._BaseAttackRange
		end
	end
	return fDefault
end
function GetBaseAttackRange(hUnit, tParams)
	return GetOriginalBaseAttackRange(hUnit)
end
function GetBonusAttackRange(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, tParams)
end
function GetAttackRangePercentage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ATTACK_RANGE_PERCENTAGE, tParams)
end
function GetAttackRange(hUnit, tParams)
	return (GetBaseAttackRange(hUnit, tParams) + GetBonusAttackRange(hUnit, tParams)) * (1 + GetAttackRangePercentage(hUnit, tParams) * 0.01)
end
-- 防御
function GetOriginalBaseArmor(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseArmor == nil then
			hUnit._BaseArmor = tonumber(KeyValues:GetUnitData(hUnit, "Armor"))
		end
		if hUnit._BaseArmor ~= nil then
			fDefault = hUnit._BaseArmor
		end
	end
	return fDefault
end
function GetBaseArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BASE_PERCENTAGE)
end
function GetBaseArmorStr(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BASE_STR, tParams)
end
function GetBaseArmorAgi(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BASE_AGI, tParams)
end
function GetBaseArmorInt(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BASE_INT, tParams)
end
function GetBaseArmor(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BASE) + GetBaseArmorStr(hUnit) + GetBaseArmorAgi(hUnit) + GetBaseArmorInt(hUnit) + GetOriginalBaseArmor(hUnit)
end
function GetBonusArmor(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_BONUS)
end
function GetArmorPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ARMOR_PERCENTAGE)
end
function GetArmor(hUnit)
	return (GetBaseArmor(hUnit) * (1 + GetBaseArmorPercentage(hUnit) * 0.01) + GetBonusArmor(hUnit)) * (1 + GetArmorPercentage(hUnit) * 0.01)
end
-- 无视物理防御
function GetIgnoreArmor(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_ARMOR, tParams)
end
function GetIgnoreArmorPercentage(hUnit, tParams)
	return SubtractionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE_UNIQUE, tParams))
end
function GetIgnoreArmorPercentageTarget(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE_TARGET, tParams)
end
function GetReduction(hUnit, tParams)
	local fValue = GetArmor(hUnit)
	if fValue > 0 then
		local fIgnore = GetIgnoreArmorPercentageTarget(hUnit, tParams)
		if tParams and IsValid(tParams.attacker) then
			fValue = math.max(fValue - GetIgnoreArmor(tParams.attacker, tParams), 0)
			fIgnore = SubtractionMultiplicationPercentage(fIgnore, GetIgnoreArmorPercentage(tParams.attacker, tParams))
		end
		fValue = fValue - math.max(fValue * fIgnore * 0.01, 0)
	end
	return ARMOR_FACTOR * fValue / (1 + ARMOR_FACTOR * math.abs(fValue))
end
-- 生命值
function GetOriginalBaseStatusHealth(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseStatusHealth == nil then
			hUnit._BaseStatusHealth = tonumber(KeyValues:GetUnitData(hUnit, "CustomStatusHealth"))
		end
		if hUnit._BaseStatusHealth ~= nil then
			fDefault = hUnit._BaseStatusHealth
		end
	end
	return fDefault
end
function GetBaseHealthStr(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_BASE_STR)
end
function GetBaseHealth(hUnit)
	return math.max(GetOriginalBaseStatusHealth(hUnit) + GetBaseHealthStr(hUnit), 0)
end
function GetBonusHealth(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_BONUS)
end
function GetHealthPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE)
end
function GetHealthPercentageEnemy(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY)
end
function GetHealth(hUnit)
	return (GetBaseHealth(hUnit) + GetBonusHealth(hUnit)) * (1 + GetHealthPercentage(hUnit) * 0.01 + GetHealthPercentageEnemy(hUnit) * 0.01)
end
-- 生命恢复
function GetOriginalBaseStatusHealthRegen(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseStatusHealthRegen == nil then
			hUnit._BaseStatusHealthRegen = tonumber(KeyValues:GetUnitData(hUnit, "StatusHealthRegen"))
		end
		if hUnit._BaseStatusHealthRegen ~= nil then
			fDefault = hUnit._BaseStatusHealthRegen
		end
	end
	return fDefault
end
function GetBaseHealthRegenStr(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_BASE_HEALTH_REGEN_CONSTANT_STR)
end
function GetBaseHealthRegen(hUnit)
	return math.max(GetOriginalBaseStatusHealthRegen(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_BASE_HEALTH_REGEN_CONSTANT) + GetBaseHealthRegenStr(hUnit), 0)
end
function GetHealthRegen(hUnit)
	return GetBaseHealthRegen(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE) * GetHealth(hUnit) * 0.01
end
-- 魔法值
function GetOriginalBaseStatusMana(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseStatusMana == nil then
			hUnit._BaseStatusMana = tonumber(KeyValues:GetUnitData(hUnit, "StatusMana"))
		end
		if hUnit._BaseStatusMana ~= nil then
			fDefault = hUnit._BaseStatusMana
		end
	end
	return fDefault
end
function GetBaseManaInt(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_BASE_INT)
end
function GetBaseMana(hUnit)
	return math.max(GetOriginalBaseStatusMana(hUnit) + GetBaseManaInt(hUnit), 0)
end
function GetManaBonus(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_BONUS)
end
function GetManaPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE)
end
function GetMana(hUnit)
	return (GetManaBonus(hUnit) + GetBaseMana(hUnit)) * (1 + GetManaPercentage(hUnit) * 0.01)
end
-- 魔法恢复
function GetOriginalBaseStatusManaRegen(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseStatusManaRegen == nil then
			hUnit._BaseStatusManaRegen = tonumber(KeyValues:GetUnitData(hUnit, "StatusManaRegen"))
		end
		if hUnit._BaseStatusManaRegen ~= nil then
			fDefault = hUnit._BaseStatusManaRegen
		end
	end
	return fDefault
end
function GetBaseManaaRegenInt(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_BASE_MANA_REGEN_CONSTANT_INT)
end
function GetBaseManaRegen(hUnit)
	return math.max(GetOriginalBaseStatusManaRegen(hUnit), 0) + GetBaseManaaRegenInt(hUnit)
end
function GetManaRegen(hUnit)
	return GetBaseManaRegen(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE) * GetMana(hUnit) * 0.01
end
-- 状态抗性
function GetStatusResistanceStack(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING)
end
function GetStatusResistanceUnique(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_UNIQUE)
end
function GetStatusResistance(hUnit)
	return SubtractionMultiplicationPercentage(GetStatusResistanceStack(hUnit), GetStatusResistanceUnique(hUnit))
end
function GetStatusResistanceCaster(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER)
end
-- 闪避
function GetOriginalBaseEvasion(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._BaseEvasion == nil then
			hUnit._BaseEvasion = tonumber(KeyValues:GetUnitData(hUnit, "Evasion"))
		end
		if hUnit._BaseEvasion ~= nil then
			fDefault = hUnit._BaseEvasion
		end
	end
	return fDefault
end
function GetEvasion(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_EVASION_CONSTANT, tParams) + GetOriginalBaseEvasion(hUnit)
end
-- 冷却减少
function GetCooldownConstantReduction(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT, tParams)
end
function GetCooldownReduction(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, tParams)
end
-- 暴击
function GetOriginalPhysicalCriticalStrikeChance(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._PhysicalCritChance == nil then
			hUnit._PhysicalCritChance = tonumber(KeyValues:GetUnitData(hUnit, "PhysicalCritChance"))
		end
		if hUnit._PhysicalCritChance ~= nil then
			fDefault = hUnit._PhysicalCritChance
		end
	end
	return fDefault
end
function GetPhysicalCriticalStrikeChance(hUnit, tParams)
	return GetOriginalPhysicalCriticalStrikeChance(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE, tParams)
end
function GetOriginalPhysicalCriticalStrikeDamage(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._PhysicalCritDamage == nil then
			hUnit._PhysicalCritDamage = tonumber(KeyValues:GetUnitData(hUnit, "PhysicalCritDamage"))
		end
		if hUnit._PhysicalCritDamage ~= nil then
			fDefault = hUnit._PhysicalCritDamage
		end
	end
	return fDefault
end
function GetPhysicalCriticalStrikeDamage(hUnit, tParams)
	return (GetOriginalPhysicalCriticalStrikeDamage(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE, tParams)) * (1 + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY, tParams) * 0.01)
end
function GetOriginalMagicalCriticalStrikeChance(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._MagicalCritChance == nil then
			hUnit._MagicalCritChance = tonumber(KeyValues:GetUnitData(hUnit, "MagicalCritChance"))
		end
		if hUnit._MagicalCritChance ~= nil then
			fDefault = hUnit._MagicalCritChance
		end
	end
	return fDefault
end
function GetMagicalCriticalStrikeChance(hUnit, tParams)
	return GetOriginalMagicalCriticalStrikeChance(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_CHANCE, tParams)
end
function GetOriginalMagicalCriticalStrikeDamage(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._MagicalCritDamage == nil then
			hUnit._MagicalCritDamage = tonumber(KeyValues:GetUnitData(hUnit, "MagicalCritDamage"))
		end
		if hUnit._MagicalCritDamage ~= nil then
			fDefault = hUnit._MagicalCritDamage
		end
	end
	return fDefault
end
function GetMagicalCriticalStrikeDamage(hUnit, tParams)
	return (GetOriginalMagicalCriticalStrikeDamage(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE, tParams)) * (1 + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY, tParams) * 0.01)
end
function GetCriticalStrikeSound(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_CRITICALSTRIKE_SOUND, tParams)
end
-- 最大攻击速度
function GetBonusMaximumAttackSpeed(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAX_ATTACKSPEED_BONUS)
end
-- 造成的伤害
function GetOutgoingPhysicalDamagePercentAgi(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE_AGI, tParams)
end
function GetOutgoingPhysicalDamagePercent(hUnit, tParams)
	return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE, tParams)), GetOutgoingPhysicalDamagePercentAgi(hUnit, tParams))
end
function GetOutgoingMagicalDamagePercentInt(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE_INT, tParams)
end
function GetOutgoingMagicalDamagePercent(hUnit, tParams)
	return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE, tParams)), GetOutgoingMagicalDamagePercentInt(hUnit, tParams))
end
-- 受到的伤害
function GetIncomingDamagePercentStr(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE_STR, tParams)
end
function GetIncomingPhysicalDamagePercent(hUnit, tParams)
	return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, tParams)), GetIncomingDamagePercentStr(hUnit, tParams))
end
function GetIncomingMagicalDamagePercent(hUnit, tParams)
	return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE, tParams), GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, tParams)), GetIncomingDamagePercentStr(hUnit, tParams))
end
-- 伤害格挡
function GetIgnoreDamageAgi(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE_AGI, tParams)
end
function GetIgnoreDamage(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE, tParams) + GetIgnoreDamageAgi(hUnit, tParams)
end
-- 属性
function GetOriginalBaseStrength(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseStrength == nil then
			hUnit._BaseStrength = tonumber(KeyValues:GetUnitData(hUnit, "BaseStrength"))
		end
		if IsValid(hUnit) and hUnit._StrengthGain == nil then
			hUnit._StrengthGain = tonumber(KeyValues:GetUnitData(hUnit, "StrengthGain"))
		end
		if hUnit._BaseStrength ~= nil then
			fValue = hUnit._BaseStrength
		end
		if hUnit._StrengthGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._StrengthGain
		end
		fValue = math.floor(fValue)
	end
	return fValue
end
function GetBaseStrength(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE)) + GetOriginalBaseStrength(hUnit), 0)
end
function GetOriginalBaseAgility(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseAgility == nil then
			hUnit._BaseAgility = tonumber(KeyValues:GetUnitData(hUnit, "BaseAgility"))
		end
		if IsValid(hUnit) and hUnit._AgilityGain == nil then
			hUnit._AgilityGain = tonumber(KeyValues:GetUnitData(hUnit, "AgilityGain"))
		end
		if hUnit._BaseAgility ~= nil then
			fValue = hUnit._BaseAgility
		end
		if hUnit._AgilityGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._AgilityGain
		end
		fValue = math.floor(fValue)
	end
	return fValue
end
function GetBaseAgility(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE)) + GetOriginalBaseAgility(hUnit), 0)
end
function GetOriginalBaseIntellect(hUnit)
	local fValue = 0
	if hUnit ~= nil then
		if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
			return 0
		end
		if IsValid(hUnit) and hUnit._BaseIntellect == nil then
			hUnit._BaseIntellect = tonumber(KeyValues:GetUnitData(hUnit, "BaseIntellect"))
		end
		if IsValid(hUnit) and hUnit._IntellectGain == nil then
			hUnit._IntellectGain = tonumber(KeyValues:GetUnitData(hUnit, "IntellectGain"))
		end
		if hUnit._BaseIntellect ~= nil then
			fValue = hUnit._BaseIntellect
		end
		if hUnit._IntellectGain ~= nil then
			fValue = fValue + (hUnit:GetLevel() - 1) * hUnit._IntellectGain
		end
		fValue = math.floor(fValue)
	end
	return fValue
end
function GetBaseIntellect(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor(GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE)) + GetOriginalBaseIntellect(hUnit), 0)
end
function GetBaseStrengthPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE)
end
function GetBaseAgilityPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE)
end
function GetBaseIntellectPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE)
end
function GetBonusStrength(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS)
end
function GetBonusAgility(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS)
end
function GetBonusIntellect(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS)
end
function GetStrengthPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE)
end
function GetAgilityPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE)
end
function GetIntellectPercentage(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE)
end
function GetStrength(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor((GetBaseStrength(hUnit) * (1 + GetBaseStrengthPercentage(hUnit) * 0.01) + GetBonusStrength(hUnit)) * (1 + GetStrengthPercentage(hUnit) * 0.01)), 0)
end
function GetAgility(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor((GetBaseAgility(hUnit) * (1 + GetBaseAgilityPercentage(hUnit) * 0.01) + GetBonusAgility(hUnit)) * (1 + GetAgilityPercentage(hUnit) * 0.01)), 0)
end
function GetIntellect(hUnit)
	if not IsValid(hUnit) or not hUnit:HasModifier("modifier_hero_attribute") then
		return 0
	end
	return math.max(math.floor((GetBaseIntellect(hUnit) * (1 + GetBaseIntellectPercentage(hUnit) * 0.01) + GetBonusIntellect(hUnit)) * (1 + GetIntellectPercentage(hUnit) * 0.01)), 0)
end
---额外力量获取
function GetBonusStrengthGain(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_STRENGTH_GAIN)
end
---额外敏捷获取
function GetBonusAgilityGain(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_AGILITY_GAIN)
end
---额外智力获取
function GetBonusIntellectGain(hUnit)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_STATS_INTELLECT_GAIN)
end
-- 伤害吸血
function GetPhysicalLifesteal(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_PHYSICAL_LIFESTEAL, tParams) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL, tParams)
end
function GetMagicalLifesteal(hUnit, tParams)
	return GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_MAGICAL_LIFESTEAL, tParams) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL, tParams)
end
-- 分裂
function GetOriginalCleaveDamage(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._CleaveDamage == nil then
			hUnit._CleaveDamage = tonumber(KeyValues:GetUnitData(hUnit, "CleaveDamage"))
		end
		if hUnit._CleaveDamage ~= nil then
			fDefault = hUnit._CleaveDamage
		end
	end
	return fDefault
end
function GetCleaveDamage(hUnit, tParams)
	return GetOriginalCleaveDamage(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE, tParams)
end
function GetOriginalCleaveRadius(hUnit)
	local fDefault = 0
	if hUnit ~= nil then
		if IsValid(hUnit) and hUnit._CleaveRadius == nil then
			hUnit._CleaveRadius = tonumber(KeyValues:GetUnitData(hUnit, "CleaveRadius"))
		end
		if hUnit._CleaveRadius ~= nil then
			fDefault = hUnit._CleaveRadius
		end
	end
	return fDefault
end
function GetCleaveRadius(hUnit, tParams)
	return GetOriginalCleaveRadius(hUnit) + GetModifierProperty(hUnit, EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS, tParams)
end
---------------------------------------------------------------------
-- 玩家资源
function GetPlayerKillScore(iPlayerID)
	return KILL_SCORE + GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_KILL_SCORE_BONUS)
end
function GetPlayerKillGoldPercent(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE)
end
function GetPlayerDropChancePercent(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_DROP_CHANCE_PERCENTAGE)
end
function GetPlayerGoldPerSecond(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_GOLD_PER_SECOND)
end
function GetPlayerCrystalPerSecond(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_CRYSTAL_PER_SECOND)
end
function GetPlayerScorePerSecond(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_SCORE_PER_SECOND)
end
function GetPlayerAttributeGainPercent(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_ATTRIBUTE_GAIN_PERCENTAGE)
end
function GetPlayerExperienceGainPercent(iPlayerID)
	return GetModifierProperty(iPlayerID, EOM_MODIFIER_PROPERTY_PLAYER_EXPERIENCE_GAIN_PERCENTAGE)
end
return EOM_MODIFIER_PROPERTIES