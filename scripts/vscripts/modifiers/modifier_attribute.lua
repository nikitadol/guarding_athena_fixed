modifier_attribute = eom_modifier({})

local list = {
	tItemValues = {
		"item_attack_damage"					, -- 攻击力
		"item_attack_speed"						, -- 攻击速度
		"item_attack_range"						, -- 攻击距离
		"item_attack_rate"						, -- 攻击间隔
		"item_physical_damage"					, -- 物理伤害增强
		"item_physical_damage_2"				, -- 物理伤害再增强
		"item_magical_damage"					, -- 魔法伤害增强
		"item_magical_damage_2"					, -- 魔法伤害再增强
		"item_max_attack_speed"					, -- 最大攻击速度
		"item_movement_speed"					, -- 移动速度
		"item_movement_speed_pct"				, -- 移动速度百分比
		"item_health"							, -- 生命值
		"item_health_pct"						, -- 生命值百分比
		"item_mana"								, -- 魔法值
		"item_armor"							, -- 防御力
		"item_health_regen"						, -- 生命恢复
		"item_health_regen_pct"					, -- 生命恢复百分比
		"item_mana_regen"						, -- 魔法回复
		"item_mana_regen_pct"					, -- 魔法回复百分比
		"item_physical_lifesteal"				, -- 物理吸血
		"item_magical_lifesteal"				, -- 魔法吸血
		"item_all_lifesteal"					, -- 全能吸血
		"item_strength"							, -- 力量
		"item_agility"							, -- 敏捷
		"item_intellect"						, -- 智力
		"item_all_stats"						, -- 全属性

		"item_armor_ignore_pct"					, -- 忽视护甲百分比
		"item_incoming_damage"					, -- 受到伤害
		"item_damage_reduce_physical"			, -- 物理伤害减免
		"item_damage_reduce_magical"			, -- 魔法伤害减免
		"item_damage_reduce"					, -- 伤害减免
		"item_damage_reduce_2"					, -- 伤害再减免
		"item_outgoing_damage"					, -- 伤害增强
		"item_outgoing_damage_2"				, -- 伤害再增强
		"item_magical_crit_chance"				, -- 魔法暴击率
		"item_magical_crit_damage"				, -- 魔法暴击伤害
		"item_magical_crit_damage_2"			, -- 魔法暴击伤害增强
		"item_physical_crit_chance"				, -- 物理暴击率
		"item_physical_crit_damage"				, -- 物理暴击伤害
		"item_physical_crit_damage_2"			, -- 物理暴击伤害增强

		"item_evasion"							, -- 闪避
		"item_ignore_damage"					, -- 伤害格挡
		"item_status_resistance"				, -- 状态抗性（没用到）
		"item_cooldown_reduction"				, -- 冷却缩减

		"item_kill_score"						, -- 击杀获得荣耀
		"item_kill_gold_pct"					, -- 击杀获得金币
		"item_fishing_crit_chance"				, -- 钓鱼暴击几率TODO:没实现
		"item_drop_chance"						, -- 掉宝加成
		"item_dig_crit_chance"					, -- 挖宝暴击几率TODO:没实现
		"item_respawn_time"						, -- 复活时间

		"item_attack_health"					, -- 攻击增加生命
		"item_attack_attack"					, -- 攻击增加攻击
		"item_attack_armor_reduce"				, -- 攻击减少防御
		"item_attack_armor_reduce_pct"			, -- 攻击减甲的效果提升
		"item_attack_all_attribute"				, -- 攻击增加全属性
		"item_kill_all_attribute"				, -- 击杀增加全属性
		"item_kill_attack"						, -- 击杀增加攻击
		"item_kill_strength"					, -- 击杀增加力量
		"item_kill_gold"						, -- 击杀增加金钱

		"item_cleave_radius"					, -- 分裂范围
		"item_cleave_damage"					, -- 分裂伤害

		"item_gold_per_sec"						, -- 每秒金币
		"item_health_per_sec"					, -- 每秒生命
		"item_soul_per_sec"						, -- 每秒魂晶
		"item_kill_per_sec"						, -- 每秒荣耀
		"item_attack_per_sec"					, -- 每秒攻击
		"item_agility_per_sec"					, -- 每秒敏捷
		"item_armor_per_sec"					, -- 每秒护甲
		"item_all_attribute_per_sec"			, -- 每秒全属性
		"item_health_per_min"					, -- 每分钟生命
		"item_intellect_per_min"				, -- 每分钟智力
		"item_armor_per_min"					, -- 每分钟护甲
		"item_attack_damage_pct_per_min"		, -- 每分钟攻击伤害
		"item_magical_damage_pct_per_min"		, -- 每分钟法术伤害
		"item_all_attribute_per_min"			, -- 每分钟全属性
	},
	tPermanentAttribute = {
		CUSTOM_ATTRIBUTE_ATTACK,
		CUSTOM_ATTRIBUTE_ATTACK_SPEED,
		CUSTOM_ATTRIBUTE_ATTACK_RANGE,
		CUSTOM_ATTRIBUTE_ATTACK_REDUCE_ARMOR,
		CUSTOM_ATTRIBUTE_CLEAVE_DAMAGE,
		CUSTOM_ATTRIBUTE_ARMOR_IGNORE,

		CUSTOM_ATTRIBUTE_STRENGTH,
		CUSTOM_ATTRIBUTE_AGILITY,
		CUSTOM_ATTRIBUTE_INTELLECT,
		CUSTOM_ATTRIBUTE_STRENGTH_GAIN,
		CUSTOM_ATTRIBUTE_AGILITY_GAIN,
		CUSTOM_ATTRIBUTE_INTELLECT_GAIN,
		CUSTOM_ATTRIBUTE_ALL,

		CUSTOM_ATTRIBUTE_HEALTH,
		CUSTOM_ATTRIBUTE_HEALTH_REGEN,
		CUSTOM_ATTRIBUTE_MANA,
		CUSTOM_ATTRIBUTE_MANA_REGEN,
		CUSTOM_ATTRIBUTE_ARMOR,
		CUSTOM_ATTRIBUTE_EVASION,
		CUSTOM_ATTRIBUTE_DAMAGE_IGNORE,
		CUSTOM_ATTRIBUTE_DAMAGE_REDUCE,
		CUSTOM_ATTRIBUTE_DAMAGE_REDUCE2,

		CUSTOM_ATTRIBUTE_PHYSICAL_DAMAGE,
		CUSTOM_ATTRIBUTE_MAGICAL_DAMAGE,
		CUSTOM_ATTRIBUTE_FINALLY_DAMAGE,
		CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_CHANCE,
		CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_DAMAGE,
		CUSTOM_ATTRIBUTE_MAGICAL_CRIT_CHANCE,
		CUSTOM_ATTRIBUTE_MAGICAL_CRIT_DAMAGE,

		CUSTOM_ATTRIBUTE_DROP_CHANCE,
		CUSTOM_ATTRIBUTE_KILL_SCORE,
		CUSTOM_ATTRIBUTE_KILL_GOLD,
		CUSTOM_ATTRIBUTE_EXPERIENCE,

		CUSTOM_ATTRIBUTE_ATTACK_PER_SEC,
		CUSTOM_ATTRIBUTE_HEALTH_PER_SEC,
		CUSTOM_ATTRIBUTE_ARMOR_PER_SEC,
		CUSTOM_ATTRIBUTE_ALL_PER_SEC,
		CUSTOM_ATTRIBUTE_STRENGTH_PER_SEC,
		CUSTOM_ATTRIBUTE_AGILITY_PER_SEC,
		CUSTOM_ATTRIBUTE_INTELLECT_PER_SEC,
		CUSTOM_ATTRIBUTE_GOLD_PER_SEC,

		CUSTOM_ATTRIBUTE_PHYSICAL_DAMAGE_PER_MIN,
		CUSTOM_ATTRIBUTE_MAGICAL_DAMAGE_PER_MIN,
		CUSTOM_ATTRIBUTE_ATTACK_PER_MIN,
		CUSTOM_ATTRIBUTE_HEALTH_PER_MIN,
		CUSTOM_ATTRIBUTE_ARMOR_PER_MIN,
		CUSTOM_ATTRIBUTE_ALL_PER_MIN,
		-- CUSTOM_ATTRIBUTE_STRENGTH_PER_MIN,
		-- CUSTOM_ATTRIBUTE_AGILITY_PER_MIN,
		-- CUSTOM_ATTRIBUTE_INTELLECT_PER_MIN,
		CUSTOM_ATTRIBUTE_ATTACK_ATTACK,
		CUSTOM_ATTRIBUTE_ATTACK_HEALTH,
		CUSTOM_ATTRIBUTE_ATTACK_ARMOR,
		CUSTOM_ATTRIBUTE_ATTACK_ALL,
		-- CUSTOM_ATTRIBUTE_ATTACK_STRENGTH,
		-- CUSTOM_ATTRIBUTE_ATTACK_AGILITY,
		-- CUSTOM_ATTRIBUTE_ATTACK_INTELLECT,
		CUSTOM_ATTRIBUTE_KILL_ATTACK,
		-- CUSTOM_ATTRIBUTE_KILL_HEALTH,
		-- CUSTOM_ATTRIBUTE_KILL_ARMOR,
		CUSTOM_ATTRIBUTE_KILL_ALL,
		CUSTOM_ATTRIBUTE_KILL_STRENGTH,
		-- CUSTOM_ATTRIBUTE_KILL_AGILITY,
		-- CUSTOM_ATTRIBUTE_KILL_INTELLECT,
		CUSTOM_ATTRIBUTE_RESPAWN_TIME,
		CUSTOM_ATTRIBUTE_COOLDOWN_REDUCE,
		CUSTOM_ATTRIBUTE_ALL_LIFESTEAL,
	}
}

local zip = function(t, list_key)
	local new_t = {}
	if type(list[list_key]) == "table" then
		for i, s in ipairs(list[list_key]) do
			new_t[i] = t[s]
		end
	end
	return new_t
end
local unzip = function(t, list_key)
	local new_t = {}
	if type(list[list_key]) == "table" then
		for i, s in ipairs(list[list_key]) do
			new_t[s] = t[i]
		end
	end
	return new_t
end

local public = modifier_attribute

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:AddCustomTransmitterData()
	local sItemValues = json.encode(zip(self.tItemValues, "tItemValues"))
	local sPermanentAttribute = json.encode(zip(self.tPermanentAttribute, "tPermanentAttribute"))
	return {
		sItemValues = sItemValues,
		sPermanentAttribute = sPermanentAttribute,
	}
end
function public:HandleCustomTransmitterData(tData)
	self.tItemValues = unzip(json.decode(tData.sItemValues or "{}"), "tItemValues")
	self.tPermanentAttribute = unzip(json.decode(tData.sPermanentAttribute or "{}"), "tPermanentAttribute")
end
function public:RefreshInventory()
	if IsServer() then
		local hParent = self:GetParent()
		self.tItemValues = {}
		for i, v in ipairs(list.tItemValues) do
			self.tItemValues[v] = 0
		end
		local SPECIALLY_PROPERTY_OPERATION = {
			item_evasion = SubtractionMultiplicationPercentage,
			item_status_resistance = SubtractionMultiplicationPercentage,
			item_cooldown_reduction = SubtractionMultiplicationPercentage,
			item_incoming_damage = AdditionMultiplicationPercentage,
			item_damage_reduce_physical = SubtractionMultiplicationPercentage,
			item_damage_reduce_magical = SubtractionMultiplicationPercentage,
			item_damage_reduce = SubtractionMultiplicationPercentage,
			item_damage_reduce_2 = SubtractionMultiplicationPercentage,
			item_physical_crit_chance = SubtractionMultiplicationPercentage,
			item_magical_crit_chance = SubtractionMultiplicationPercentage,
			item_magical_crit_damage = AdditionMultiplicationPercentage,
			item_physical_crit_damage = AdditionMultiplicationPercentage,
			item_magical_crit_damage_2 = AdditionMultiplicationPercentage,
			item_physical_crit_damage_2 = AdditionMultiplicationPercentage,
			item_outgoing_damage = AdditionMultiplicationPercentage,
			item_outgoing_damage_2 = AdditionMultiplicationPercentage,
			item_physical_damage = AdditionMultiplicationPercentage,
			item_magical_damage = AdditionMultiplicationPercentage,
			item_physical_damage_2 = AdditionMultiplicationPercentage,
			item_magical_damage_2 = AdditionMultiplicationPercentage,
			item_movement_speed_pct = SubtractionMultiplicationPercentage,
		}
		if hParent:IsHero() then
			-- 遍历装备栏
			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6, 1 do
				local hItem = hParent:GetItemInSlot(i)
				if IsValid(hItem) and Items:GetCustomType(hItem:GetAbilityName()) ~= CUSTOM_ITEM_TYPE_DIVINE then
					for sPropertyName, fValue in pairs(self.tItemValues) do
						local funcOperation = SPECIALLY_PROPERTY_OPERATION[sPropertyName]
						if funcOperation ~= nil then
							self.tItemValues[sPropertyName] = funcOperation(fValue, hItem:GetSpecialValueForUnit(sPropertyName, nil, true))
						else
							self.tItemValues[sPropertyName] = fValue + hItem:GetSpecialValueForUnit(sPropertyName, nil, true)
						end
					end
				end
			end
			-- 遍历吞噬物品
			-- local n = 0
			for i, hItem in ipairs(Items:GetDevourItems(hParent)) do
				if IsValid(hItem) then
					if hItem._tPropertyNameList == nil then
						hItem._tPropertyNameList = {}

						for sPropertyName, fValue in pairs(self.tItemValues) do
							local v = hItem:GetSpecialValueForUnit(sPropertyName, nil, true)
							if v ~= 0 then
								table.insert(hItem._tPropertyNameList, sPropertyName)
							end

							local funcOperation = SPECIALLY_PROPERTY_OPERATION[sPropertyName]
							if funcOperation ~= nil then
								self.tItemValues[sPropertyName] = funcOperation(fValue, v)
							else
								self.tItemValues[sPropertyName] = fValue + v
							end
							-- n = n + 1
						end
					else
						for _, sPropertyName in ipairs(hItem._tPropertyNameList) do
							local fValue = self.tItemValues[sPropertyName]
							local funcOperation = SPECIALLY_PROPERTY_OPERATION[sPropertyName]
							if funcOperation ~= nil then
								self.tItemValues[sPropertyName] = funcOperation(fValue, hItem:GetSpecialValueForUnit(sPropertyName, nil, true))
							else
								self.tItemValues[sPropertyName] = fValue + hItem:GetSpecialValueForUnit(sPropertyName, nil, true)
							end
							-- n = n + 1
						end
					end
				end
			end
			-- print("O(n) = ", n)
		end
	end
end
function public:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	local hParent = self:GetParent()
	hParent.hModifierAttribute = self
	if IsServer() then
		self.tShieldData = {
			[DAMAGE_TYPE_PHYSICAL] = {},
			[DAMAGE_TYPE_MAGICAL] = {},
			[DAMAGE_TYPE_PURE] = {},
		}
		self:StartIntervalThink(1)
		self:RefreshInventory()
		if hParent.tPermanentAttribute == nil then
			hParent.tPermanentAttribute = {}
			for i, v in ipairs(list.tPermanentAttribute) do
				hParent.tPermanentAttribute[v] = 0
			end
		end
		self.tPermanentAttribute = hParent.tPermanentAttribute
	end
end
function public:OnIntervalThink()
	if IsServer() then
		self:CalculateItemProperties()
	end
end
function public:CalculateItemProperties()
	if IsServer() then
		self:RefreshInventory()
		self:SendBuffRefreshToClients()
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,

		---------------------------------------------------------------------
		MODIFIER_PROPERTY_RESPAWNTIME_STACKING,
	}
end
function public:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() },
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() },
		MODIFIER_EVENT_ON_TICK_TIME,

		---------------------------------------------------------------------
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS,
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		EOM_MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT_ADJUST,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_MAX_ATTACKSPEED_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_MANA_BONUS,
		EOM_MODIFIER_PROPERTY_ARMOR_BASE,
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_MAGICAL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_GAIN,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_GAIN,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_GAIN,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS,

		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT,
		EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,

		EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE,
		EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE,

		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_CHANCE,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY,

		EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE,
		EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS,

		EOM_MODIFIER_PROPERTY_ATTACK_REDUCE_ARMOR,
		EOM_MODIFIER_PROPERTY_ATTACK_REDUCE_ARMOR_PERCENTAGE,

		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE,

		EOM_MODIFIER_PROPERTY_PLAYER_KILL_SCORE_BONUS,
		EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_PLAYER_DROP_CHANCE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_PLAYER_EXPERIENCE_GAIN_PERCENTAGE,

		EOM_MODIFIER_PROPERTY_PLAYER_GOLD_PER_SECOND,
		EOM_MODIFIER_PROPERTY_PLAYER_CRYSTAL_PER_SECOND,
		EOM_MODIFIER_PROPERTY_PLAYER_SCORE_PER_SECOND,
	}
end
function public:EOM_GetModifierAttackDamageBase(params)
	if self.tItemValues ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK] or 0
	end
	return 0
end
function public:EOM_GetModifierAttackDamageBonus(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_attack_damage or 0
	end
	return 0
end
function public:EOM_GetModifierAttackRangeBonus(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_attack_range or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_RANGE] or 0)
	end
	return 0
end
function public:EOM_GetModifierBaseAttackTimeConstant_Adjust(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_attack_rate or 0
	end
	return 0
end
function public:EOM_GetModifierAttackDamagePercentage(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_attack_damage_percent or 0
	end
	return 0
end
function public:EOM_GetModifierAttackDamagePercentage_2(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_attack_damage_percent_2 or 0
	end
	return 0
end
function public:GetModifierAttackSpeedBonus_Constant(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_attack_speed or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_SPEED] or 0)
	end
	return 0
end
function public:EOM_GetModifierMaximumAttackSpeedBonus(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_max_attack_speed or 0
	end
	return 0
end
function public:GetModifierMoveSpeedBonus_Constant(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_movement_speed or 0
	end
	return 0
end
function public:GetModifierMoveSpeedBonus_Percentage(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_movement_speed_pct or 0
	end
	return 0
end
function public:GetModifierStackingRespawnTime(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_respawn_time or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_RESPAWN_TIME] or 0)
	end
	return 0
end
function public:EOM_GetModifierHealthBonus(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_health or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_HEALTH] or 0)
	end
	return 0
end
function public:EOM_GetModifierHealthPercentage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_health_pct or 0)
	end
	return 0
end
function public:EOM_GetModifierManaBonus(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_mana or 0
	end
	return 0
end
function public:EOM_GetModifierArmorBase(params)
	if self.tItemValues ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ARMOR] or 0
	end
	return 0
end
function public:EOM_GetModifierArmorBonus(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_armor or 0
	end
	return 0
end
function public:EOM_GetModifierConstantHealthRegen(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_health_regen or 0
	end
	return 0
end
function public:EOM_GetModifierHealthRegenPercentage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_health_regen_pct or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_HEALTH_REGEN] or 0)
	end
	return 0
end
function public:EOM_GetModifierConstantManaRegen(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_mana_regen or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_MANA_REGEN] or 0)
	end
	return 0
end
function public:EOM_GetModifierManaRegenPercentage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_mana_regen_pct or 0)
	end
	return 0
end
function public:EOM_GetModifierPhysicalLifesteal(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_physical_lifesteal or 0)
	end
	return 0
end
function public:EOM_GetModifierMagicalLifesteal(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_magical_lifesteal or 0)
	end
	return 0
end
function public:EOM_GetModifierAllLifesteal(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_all_lifesteal or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ALL_LIFESTEAL] or 0)
	end
	return 0
end
function public:EOM_GetModifierBaseStats_Strength(params)
	if self.tPermanentAttribute ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_STRENGTH] or 0
	end
	return 0
end
function public:EOM_GetModifierBaseStats_Agility(params)
	if self.tPermanentAttribute ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_AGILITY] or 0
	end
	return 0
end
function public:EOM_GetModifierBaseStats_Intellect(params)
	if self.tPermanentAttribute ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_INTELLECT] or 0
	end
	return 0
end
function public:EOM_GetModifierBaseStats_All(params)
	if self.tPermanentAttribute ~= nil then
		return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ALL] or 0
	end
	return 0
end
function public:EOM_GetModifierBonusStats_Strength(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_strength or 0
	end
	return 0
end
function public:EOM_GetModifierBonusStats_Agility(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_agility or 0
	end
	return 0
end
function public:EOM_GetModifierBonusStats_Intellect(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_intellect or 0
	end
	return 0
end
function public:EOM_GetModifierBonusStats_StrengthGain(params)
	return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_STRENGTH_GAIN] or 0
end
function public:EOM_GetModifierBonusStats_AgilityGain(params)
	return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_AGILITY_GAIN] or 0
end
function public:EOM_GetModifierBonusStats_IntellectGain(params)
	return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_INTELLECT_GAIN] or 0
end
function public:EOM_GetModifierBonusStats_All(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_all_stats or 0
	end
	return 0
end
function public:EOM_GetModifierEvasion_Constant(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_evasion or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_EVASION] or 0)
	end
	return 0
end
function public:EOM_GetModifierStatusResistanceStacking(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_status_resistance or 0
	end
	return 0
end
function public:EOM_GetModifierPercentageCooldown(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_cooldown_reduction or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_COOLDOWN_REDUCE] or 0)
	end
	return 0
end
function public:EOM_GetModifierIgnoreDamage(params)
	local flItemIgnoreDamage = 0
	if self.tItemValues ~= nil then
		flItemIgnoreDamage = flItemIgnoreDamage + (self.tItemValues.item_ignore_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DAMAGE_IGNORE] or 0)
	end
	if params and params.last_damage and params.damage_type and self.tShieldData[params.damage_type] then
		local flDamage = math.max(params.last_damage - flItemIgnoreDamage, 0)
		for i, tData in ipairs(self.tShieldData[params.damage_type]) do
			if tData.hModifier == nil or IsValid(tData.hModifier) then
				if flDamage < tData.flValue then
					tData.flValue = tData.flValue - flDamage
					return flDamage
				else
					flDamage = flDamage - tData.flValue
					tData.flValue = 0
					if tData.hModifier and tData.hModifier.OnShieldDestroy then
						tData.hModifier:OnShieldDestroy()
					end
				end
			end
		end
		for i = #self.tShieldData[params.damage_type], 1, -1 do
			if self.tShieldData[params.damage_type][i].flValue == 0 or (self.tShieldData[params.damage_type][i].hModifier and not IsValid(self.tShieldData[params.damage_type][i].hModifier)) then
				table.remove(self.tShieldData[params.damage_type], i)
			end
		end
		if flDamage > 0 then
			return params.last_damage - flDamage
		else
			return params.last_damage
		end
	end
	return flItemIgnoreDamage
end
function public:EOM_GetModifierIncomingPhysicalDamagePercentage(params)
	if self.tItemValues ~= nil then
		local tReduceList = {
			(self.tItemValues.item_damage_reduce_physical or 0),
			(self.tItemValues.item_damage_reduce or 0),
			(self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DAMAGE_REDUCE] or 0),
			(self.tItemValues.item_damage_reduce_2 or 0),
			(self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DAMAGE_REDUCE2] or 0),
			(self.tItemValues.item_incoming_damage or 0)
		}
		local result = 0
		for i = 1, #tReduceList do
			result = SubtractionMultiplicationPercentage(result, tReduceList[i])
		end
		return -result
	end
	return 0
end
function public:EOM_GetModifierIncomingMagicalDamagePercentage(params)
	if self.tItemValues ~= nil then
		local tReduceList = {
			(self.tItemValues.item_damage_reduce_magical or 0),
			(self.tItemValues.item_damage_reduce or 0),
			(self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DAMAGE_REDUCE] or 0),
			(self.tItemValues.item_damage_reduce_2 or 0),
			(self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DAMAGE_REDUCE2] or 0),
			(self.tItemValues.item_incoming_damage or 0)
		}
		local result = 0
		for i = 1, #tReduceList do
			result = SubtractionMultiplicationPercentage(result, tReduceList[i])
		end
		return -result
	end
	return 0
end
function public:EOM_GetModifierOutgoingPhysicalDamagePercentage(params)
	if self.tItemValues ~= nil then
		return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(self.tItemValues.item_outgoing_damage or 0, ((self.tItemValues.item_outgoing_damage_2 or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_FINALLY_DAMAGE] or 0))), AdditionMultiplicationPercentage(((self.tItemValues.item_physical_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_PHYSICAL_DAMAGE] or 0)), self.tItemValues.item_physical_damage_2 or 0))
	end
	return 0
end
function public:EOM_GetModifierOutgoingMagicalDamagePercentage(params)
	if self.tItemValues ~= nil then
		return AdditionMultiplicationPercentage(AdditionMultiplicationPercentage(self.tItemValues.item_outgoing_damage or 0, ((self.tItemValues.item_outgoing_damage_2 or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_FINALLY_DAMAGE] or 0))), AdditionMultiplicationPercentage(((self.tItemValues.item_magical_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_MAGICAL_DAMAGE] or 0)), self.tItemValues.item_magical_damage_2 or 0))
	end
	return 0
end
function public:EOM_GetModifierPhysicalCriticalStrikeChance(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_physical_crit_chance or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_CHANCE] or 0)
	end
	return 0
end
function public:EOM_GetModifierPhysicalCriticalStrikeDamage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_physical_crit_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_DAMAGE] or 0)
	end
	return 0
end
function public:EOM_GetModifierPhysicalCriticalStrikeDamageAmplify(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_physical_crit_damage_2 or 0
	end
	return 0
end
function public:EOM_GetModifierMagicalCriticalStrikeChance(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_magical_crit_chance or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_MAGICAL_CRIT_CHANCE] or 0)
	end
	return 0
end
function public:EOM_GetModifierMagicalCriticalStrikeDamage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_magical_crit_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_MAGICAL_CRIT_DAMAGE] or 0)
	end
	return 0
end
function public:EOM_GetModifierMagicalCriticalStrikeDamageAmplify(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_magical_crit_damage_2 or 0
	end
	return 0
end
function public:EOM_GetModifierCleaveDamage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_cleave_damage or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_CLEAVE_DAMAGE] or 0)
	end
	return 0
end
function public:EOM_GetModifierCleaveRadius(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_cleave_radius or 0
	end
	return 0
end
function public:EOM_GetModifierAttackReduceArmor(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_attack_armor_reduce or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_REDUCE_ARMOR] or 0)
	end
	return 0
end
function public:EOM_GetModifierAttackReduceArmorPercentage(params)
	if self.tItemValues ~= nil then
		return self.tItemValues.item_attack_armor_reduce_pct or 0
	end
	return 0
end
function public:EOM_GetModifierIgnoreArmorPercentage(params)
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_armor_ignore_pct or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ARMOR_IGNORE] or 0)
	end
	return 0
end
function public:EOM_GetModifierPlayerKillScoreBonus(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_kill_score or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_KILL_SCORE] or 0)
	end
	return 0
end
function public:EOM_GetModifierPlayerKillGoldPercentage(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_kill_gold_pct or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_KILL_GOLD] or 0)
	end
	return 0
end
function public:EOM_GetModifierPlayerDropChancePercentage(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return (self.tItemValues.item_drop_chance or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_DROP_CHANCE] or 0)
	end
	return 0
end
function public:EOM_GetModifierPlayerGoldPerSecond(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return self.tItemValues.item_gold_per_sec or 0
	end
	return 0
end
function public:EOM_GetModifierPlayerCrystalPerSecond(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return self.tItemValues.item_soul_per_sec or 0
	end
	return 0
end
function public:EOM_GetModifierPlayerScorePerSecond(params)
	if not self:GetParent():IsRealHero() then return 0 end
	if self.tItemValues ~= nil then
		return self.tItemValues.item_kill_per_sec or 0
	end
	return 0
end
function public:EOM_GetModifierPlayerExperienceGainPercentage(params)
	if not self:GetParent():IsRealHero() then return 0 end
	return self.tPermanentAttribute[CUSTOM_ATTRIBUTE_EXPERIENCE] or 0
end
----------------------------------------事件----------------------------------------
function public:OnDamageCalculated(params)
	local hTarget = params.target
	if not IsValid(hTarget) == nil or hTarget:GetClassname() == "dota_item_drop" then return end
	local hParent = self:GetParent()

	if not AttackFilter(params.record, ATTACK_STATE_SKIPCOUNTING) then
		local flHealth = (self.tItemValues.item_attack_health or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_HEALTH] or 0)
		local flArmor = (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_ARMOR] or 0)
		local flAttack = (self.tItemValues.item_attack_attack or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_ATTACK] or 0)
		local flAll = (self.tItemValues.item_attack_all_attribute or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_ALL] or 0)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_HEALTH, flHealth, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ARMOR, flArmor, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, flAttack, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, flAll, true)
	end

	-- 攻击减甲
	-- hParent:ReduceArmor(hTarget, 100, params)
end
function public:OnDeath(params)
	if not self:GetParent():IsRealHero() then return end
	local hParent = self:GetParent()
	local flAll = (self.tItemValues.item_kill_all_attribute or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_KILL_ALL] or 0)
	local flAttack = (self.tItemValues.item_kill_attack or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_KILL_ATTACK] or 0)
	local flStrength = (self.tItemValues.item_kill_strength or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_KILL_STRENGTH] or 0)
	local flGold = (self.tItemValues.item_kill_gold or 0)
	local flSoul = (self.tItemValues.item_kill_soul or 0)
	hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, flAll, true)
	hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, flAttack, true)
	hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, flAttack, true)

	PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), flGold)
	PlayerData:ModifyCrystal(hParent:GetPlayerOwnerID(), flSoul)
end
function public:OnTickTime(params)
	if not self:GetParent():IsRealHero() then return end
	local hParent = self:GetParent()
	local iPlayerID = hParent:GetPlayerOwnerID()
	if params.tick_time == 1 then
		----------------------------------------每秒增加的属性----------------------------------------
		local flGold = (self.tItemValues.item_gold_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_GOLD_PER_SEC] or 0)
		local flHealth = (self.tItemValues.item_health_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_HEALTH_PER_SEC] or 0)
		local flSoul = (self.tItemValues.item_soul_per_sec or 0)
		local flKill = (self.tItemValues.item_kill_per_sec or 0)
		local flAttack = (self.tItemValues.item_attack_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_PER_SEC] or 0)
		local flArmor = (self.tItemValues.item_armor_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ARMOR_PER_SEC] or 0)
		local flAttribute = (self.tItemValues.item_all_attribute_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ALL_PER_SEC] or 0)
		local flStrength = (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_STRENGTH_PER_SEC] or 0)
		local flAgility = (self.tItemValues.item_agility_per_sec or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_AGILITY_PER_SEC] or 0)
		local flIntellect = (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_INTELLECT_PER_SEC] or 0)
		PlayerData:ModifyGold(iPlayerID, flGold)
		PlayerData:ModifyCrystal(iPlayerID, flSoul)
		PlayerData:ModifyScore(iPlayerID, flKill)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_HEALTH, flHealth, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, flAttack, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ARMOR, flArmor, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, flAttribute, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, flStrength, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_AGILITY, flAgility, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT, flIntellect, true)
	elseif params.tick_time == 60 then
		local flAttack = (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ATTACK_PER_MIN] or 0)
		local flHealth = (self.tItemValues.item_health_per_min or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_HEALTH_PER_MIN] or 0)
		local flIntellect = self.tItemValues.item_intellect_per_min or 0
		local flArmor = self.tItemValues.item_armor_per_min or 0
		local flAttackDamage = (self.tItemValues.item_attack_damage_pct_per_min or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_PHYSICAL_DAMAGE_PER_MIN] or 0)
		local flMagicalDamage = (self.tItemValues.item_magical_damage_pct_per_min or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_MAGICAL_DAMAGE_PER_MIN] or 0)
		local flAttribute = (self.tItemValues.item_all_attribute_per_min or 0) + (self.tPermanentAttribute[CUSTOM_ATTRIBUTE_ALL_PER_MIN] or 0)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_HEALTH, flHealth, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT, flIntellect, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, flAttack, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_PHYSICAL_DAMAGE, flAttackDamage, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_MAGICAL_DAMAGE, flMagicalDamage, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL, flAttribute, true)
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ARMOR, flArmor, true)
	end
end