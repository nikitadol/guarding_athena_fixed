---填键值自动生效的属性
modifier_auto_property = eom_modifier({
	Name = "modifier_auto_property",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
local public = modifier_auto_property
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function public:AddCustomTransmitterData()
	return {
		tWearableValues = self.tWearableValues
	}
end
function public:HandleCustomTransmitterData(tData)
	self.tWearableValues = tData.tWearableValues
end
function public:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	self:CalculateStatBonus()
	if IsServer() then
		self.iTime = 0
		self:StartIntervalThink(1)
	end
end
function public:OnIntervalThink()
	if IsServer() then
		local flGold = self.tWearableValues.auto_gold_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_gold_per_sec")
		local flHealth = self.tWearableValues.auto_health_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_health_per_sec")
		local flSoul = self.tWearableValues.auto_soul_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_soul_per_sec")
		local flKill = self.tWearableValues.auto_kill_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_kill_per_sec")
		local flAttack = self.tWearableValues.auto_attack_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_per_sec")
		local flArmor = self.tWearableValues.auto_armor_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_armor_per_sec")
		local flAttribute = self.tWearableValues.auto_all_attribute_per_sec + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_all_attribute_per_sec")
		local flIntellect = 0
		local flAttackDamage = 0
		local flMagicalDamage = 0
		self.iTime = self.iTime + 1
		if self.iTime >= 60 then
			self.iTime = 0
			flHealth = flHealth + self.tWearableValues.auto_health_per_min + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_health_per_min")
			flIntellect = flIntellect + self.tWearableValues.auto_intellect_per_min + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_intellect_per_min")
			flAttackDamage = flAttackDamage + self.tWearableValues.auto_attack_damage_pct_per_min + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_damage_pct_per_min")
			flMagicalDamage = flMagicalDamage + self.tWearableValues.auto_magical_damage_pct_per_min + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_damage_pct_per_min")
			flAttribute = flAttribute + self.tWearableValues.auto_all_attribute_per_min + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_all_attribute_per_min")
		end
		-- TODO:添加实际效果
	end
end
function public:CalculateStatBonus()
	if IsServer() then
		---计算饰品的奖励
		self.tWearableValues = {
		-- auto_mana_regen									= 0, -- 魔法恢复
		-- auto_mana										= 0, -- 魔法
		-- auto_bonus_kill									= 0, -- 额外杀敌
		-- auto_fishing_crit_chance						= 0, -- 钓鱼暴击几率
		-- auto_physical_damage_again_pct					= 0, -- 物理伤害再次提升
		-- auto_magical_damage_directly_pct				= 0, -- 法术伤害直接提升
		-- auto_crit_damage_again_pct						= 0, -- 暴击伤害再次提升
		-- auto_damage_outgoing_pct						= 0, -- 所有伤害
		-- auto_resource_pct								= 0, -- 资源获取
		-- auto_movespeed_pct								= 0, -- 移动速度提升
		-- auto_health_regen_pct							= 0, -- 生命回复
		-- auto_health										= 0, -- 生命
		-- auto_magical_damage_again_pct					= 0, -- 法术伤害再次提升
		-- auto_magical_crit_damage_again_pct				= 0, -- 法术暴击伤害再次提升
		-- auto_magical_lifesteal_pct						= 0, -- 法术吸血
		-- auto_magical_damage_pct							= 0, -- 法术伤害
		-- auto_magical_crit_chance						= 0, -- 法暴几率
		-- auto_magical_crit_damage						= 0, -- 法暴伤害
		-- auto_gold_per_sec								= 0, -- 每秒金币
		-- auto_health_per_sec								= 0, -- 每秒生命
		-- auto_soul_per_sec								= 0, -- 每秒灵魂值
		-- auto_kill_per_sec								= 0, -- 每秒杀敌数
		-- auto_attack_per_sec								= 0, -- 每秒攻击
		-- auto_armor_per_sec								= 0, -- 每秒护甲
		-- auto_all_attribute_per_sec						= 0, -- 每秒全属性
		-- auto_health_per_min								= 0, -- 每分钟生命
		-- auto_intellect_per_min							= 0, -- 每分钟智力
		-- auto_attack_damage_pct_per_min					= 0, -- 每分钟攻击伤害
		-- auto_magical_damage_pct_per_min					= 0, -- 每分钟法术伤害
		-- auto_all_attribute_per_min						= 0, -- 每分钟全属性
		-- auto_final_damage_pct							= 0, -- 最终增伤
		-- auto_crit_chance								= 0, -- 暴击几率
		-- auto_crit_damage								= 0, -- 暴击伤害
		-- auto_strength									= 0, -- 力量
		-- auto_agility									= 0, -- 敏捷
		-- auto_intellect									= 0, -- 智力
		-- auto_attack_rate								= 0, -- 攻击间隔
		-- auto_evade										= 0, -- 闪避
		-- auto_attack_damage_again_pct					= 0, -- 攻击造成的伤害再次提升
		-- auto_attackspeed								= 0, -- 攻击速度
		-- auto_attackrange								= 0, -- 攻击距离
		-- auto_attack_health								= 0, -- 攻击生命
		-- auto_attack_attack								= 0, -- 攻击攻击
		-- auto_attack_lifesteal							= 0, -- 攻击吸血
		-- auto_attack_armor_reduce_pct					= 0, -- 攻击减甲的效果提升
		-- auto_attack_armor_reduce						= 0, -- 攻击减甲
		-- auto_attack_all_attribute						= 0, -- 攻击全属性
		-- auto_attack_damage_pct							= 0, -- 攻击伤害
		-- auto_attack										= 0, -- 攻击
		-- auto_drop_chance								= 0, -- 掉宝加成
		-- auto_dig_crit_chance							= 0, -- 挖宝暴击几率
		-- auto_armor										= 0, -- 护甲
		-- auto_respawn_time								= 0, -- 复活时间
		-- auto_damage_incoming_pct						= 0, -- 受到的伤害
		-- auto_cleave_radius								= 250, -- 分裂范围
		-- auto_cleave_damage								= 9, -- 分裂伤害
		-- auto_cooldown_reduction							= 0, -- 冷却缩减
		-- auto_all_lifesteal								= 0, -- 全能吸血
		-- auto_all_attribute								= 0, -- 全属性
		-- auto_damage_ignore								= 0, -- 伤害忽视
		-- auto_final_damage_reduce_pct					= 0, -- 伤害减免
		-- auto_avoid_chance								= 0, -- 伤害免伤
		}
		local hParent = self:GetParent()
		for i = 0, 5 do
			local hItem = hParent:GetItemInSlot(i)
			if IsValid(hItem) then
				local AbilitySpecial = KeyValues.ItemsKv[hItem:GetAbilityName()].AbilitySpecial
				if AbilitySpecial then
					for iIndex, tSpecialData in pairs(AbilitySpecial) do
						for sKey, sValue in pairs(tSpecialData) do
							if self.tWearableValues[sKey] then
								self.tWearableValues[sKey] = self.tWearableValues[sKey] + sValue
							end
						end
					end
				end
			end
		end
		self:SendBuffRefreshToClients()
		self:GetParent():CalculateStatBonus(true)
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_RESPAWNTIME,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function public:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BASE,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS,
		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_BONUS_KILL,
		EOM_MODIFIER_PROPERTY_FISHING_CRIT_CHANCE,
		EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_SECONDARY_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_FIRST_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_CRIT_DAMAGE_SECONDARY_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_RESOURCE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_SECONDARY_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_CRIT_DAMAGE_SECONDARY_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_MAGICAL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICAL_CHANCE,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICAL_DAMAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_FINAL_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_CRITICAL_CHANCE,
		EOM_MODIFIER_PROPERTY_OUTGOING_CRIT_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_ATTACK_DAMAGE_SECONDARY_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_ATTACK_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_DROP_CHANCE,
		EOM_MODIFIER_PROPERTY_DIG_CRIT_CHANCE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_FINAL_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
	}
end
function public:GetModifierCooldownReduction_Constant(params)
	if not IsValid(params.ability) then
		return 0
	end

	return -AbilityUpgrades:GetSpecialValueUpgrade(self:GetParent(), params.ability:GetAbilityName(), "cooldown", ABILITY_UPGRADES_OP_ADD)
end
function public:GetPropertyValue(sName)
	return self.tWearableValues[sName] + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), sName)
end
----------------------------------------官方----------------------------------------
function public:GetModifierMoveSpeedBonus_Percentage()
	return self.tWearableValues.auto_movespeed_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_movespeed_pct")
end
function public:GetModifierHealthRegenPercentage()
	return self.tWearableValues.auto_health_regen_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_health_regen_pct")
end
function public:GetModifierHealthBonus(params)
	return self.tWearableValues.auto_health + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_health")
end
function public:GetModifierEvasion_Constant(params)
	return self.tWearableValues.auto_evade + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_evade")
end
function public:GetModifierAttackSpeedBonus_Constant(params)
	return self.tWearableValues.auto_attackspeed + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attackspeed")
end
function public:GetModifierAttackRangeBonus(params)
	return self.tWearableValues.auto_attackrange + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attackrange")
end
function public:GetModifierBaseAttack_BonusDamage(params)
	return self.tWearableValues.auto_attack + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack")
end
function public:GetModifierConstantRespawnTime(params)
	return self.tWearableValues.auto_respawn_time + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_respawn_time")
end
function public:GetModifierTotal_ConstantBlock(params)
	return self.tWearableValues.auto_damage_ignore + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_damage_ignore")
end
function public:GetModifierAvoidDamage(params)
	local flChance = self:GetPropertyValue("auto_avoid_chance")
	if PRD(self, flChance, "modifier_auto_property") then
		return 1
	end
end
function public:OnAttackLanded(params)
	if IsServer() then
		local flHealth = self.tWearableValues.auto_attack_health + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_health")
		local flAttack = self.tWearableValues.auto_attack_attack + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_attack")
		local flArmorReduce = self.tWearableValues.auto_attack_armor_reduce + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_armor_reduce")
		local flAttribute = self.tWearableValues.auto_attack_all_attribute + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_all_attribute")
		-- TODO:实际效果
		-- 分裂
		local flCleaveRadius = self.tWearableValues.auto_cleave_radius + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_cleave_radius")
		local flCleaveDamage = self.tWearableValues.auto_cleave_damage + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_cleave_damage")

		local sParticlePath = ParticleManager:GetParticleReplacement("particles/items_fx/battlefury_cleave.vpcf", params.attacker)
		local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
		local n = 0

		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, flCleaveRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)

		for _, hUnit in ipairs(tTargets) do
			if hUnit ~= params.target and not params.attacker:IsIllusion() then
				local tDamageTable = {
					victim = hUnit,
					attacker = params.attacker,
					damage = params.original_damage * flCleaveDamage * 0.01,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY,
				}
				ApplyDamage(tDamageTable)
				n = n + 1
				ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetAbsOrigin(), true)
			end
		end
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
----------------------------------------EOM----------------------------------------
function public:EOM_GetModifierKillBonus()
	return self.tWearableValues.auto_bonus_kill + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_bonus_kill")
end
function public:EOM_GetModifierFishingCritChance()
	return self.tWearableValues.auto_fishing_crit_chance + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_fishing_crit_chance")
end
function public:EOM_GetModifierOutgoingPhysicalDamageSecondaryPercentage()
	return self.tWearableValues.auto_physical_damage_again_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_physical_damage_again_pct")
end
function public:EOM_GetModifierOutgoingMagicalDamageFirstPercentage()
	return self.tWearableValues.auto_magical_damage_directly_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_damage_directly_pct")
end
function public:EOM_GetModifierOutgoingCritDamageSecondaryPercentage()
	return self.tWearableValues.auto_crit_damage_again_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_crit_damage_again_pct")
end
function public:EOM_GetModifierOutgoingDamagePercentage()
	return self.tWearableValues.auto_damage_outgoing_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_damage_outgoing_pct")
end
function public:EOM_GetModifierResourcePercentage()
	return self.tWearableValues.auto_resource_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_resource_pct")
end
function public:EOM_GetModifierOutgoingMagicalDamageSecondaryPercentage()
	return self.tWearableValues.auto_magical_damage_again_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_damage_again_pct")
end
function public:EOM_GetModifierOutgoingMagicalCritDamageSecondaryPercentage()
	return self.tWearableValues.auto_magical_crit_damage_again_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_crit_damage_again_pct")
end
function public:EOM_GetModifierMagicalLifesteal()
	return self.tWearableValues.auto_magical_lifesteal_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_lifesteal_pct")
end
function public:EOM_GetModifierOutgoingMagicalDamagePercentage()
	return self.tWearableValues.auto_magical_damage_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_damage_pct")
end
function public:EOM_GetModifierMagicalCriticalChance()
	return self.tWearableValues.auto_magical_crit_chance + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_crit_chance")
end
function public:EOM_GetModifierMagicalCriticalDamage()
	return self.tWearableValues.auto_magical_crit_damage + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_magical_crit_damage")
end
function public:EOM_GetModifierOutgoingDamageFinalPercentage()
	return self.tWearableValues.auto_final_damage_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_final_damage_pct")
end
function public:EOM_GetModifierCriticalChance()
	return self.tWearableValues.auto_crit_chance + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_crit_chance")
end
function public:EOM_GetModifierOutgoingCritDamagePercentage()
	return self.tWearableValues.auto_crit_damage + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_crit_damage")
end
function public:EOM_GetModifierBaseStats_Strength()
	return self.tWearableValues.auto_strength + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_strength")
end
function public:EOM_GetModifierBaseStats_Agility()
	return self.tWearableValues.auto_agility + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_agility")
end
function public:EOM_GetModifierBaseStats_Intellect()
	return self.tWearableValues.auto_intellect + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_intellect")
end
function public:EOM_GetModifierOutgoingAttackDamageSecondaryPercentage(params)
	return self.tWearableValues.auto_attack_damage_again_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_damage_again_pct")
end
function public:EOM_GetModifierOutgoingAttackDamagePercentage(params)
	return self.tWearableValues.auto_attack_damage_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_damage_pct")
end
function public:EOM_GetModifierDropChance(params)
	return self.tWearableValues.auto_drop_chance + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_drop_chance")
end
function public:EOM_GetModifierDigCritChance(params)
	return self.tWearableValues.auto_dig_crit_chance + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_dig_crit_chance")
end
function public:EOM_GetModifierPhysicalArmorBase()
	return self.tWearableValues.auto_armor + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_armor")
end
function public:EOM_GetModifierIncomingDamagePercentage()
	return self.tWearableValues.auto_damage_incoming_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_damage_incoming_pct")
end
function public:EOM_GetModifierPercentageCooldown()
	return self.tWearableValues.auto_cooldown_reduction + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_cooldown_reduction")
end
function public:EOM_GetModifierLifesteal()
	return self.tWearableValues.auto_attack_lifesteal + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_attack_lifesteal")
end
function public:EOM_GetModifierAllLifesteal()
	return self.tWearableValues.auto_all_lifesteal + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_all_lifesteal")
end
function public:EOM_GetModifierBonusStats_All()
	return self.tWearableValues.auto_all_attribute + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_all_attribute")
end
function public:EOM_GetModifierIncomingDamageFinalPercentage()
	return self.tWearableValues.auto_final_damage_reduce_pct + AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "auto_final_damage_reduce_pct")
end