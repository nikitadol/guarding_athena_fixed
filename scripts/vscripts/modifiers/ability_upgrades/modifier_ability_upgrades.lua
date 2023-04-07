modifier_ability_upgrades = eom_modifier({})

local public = modifier_ability_upgrades

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
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_PRIMARY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_SECONDARY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

		EOM_MODIFIER_PROPERTY_HEALTH_BONUS,
		EOM_MODIFIER_PROPERTY_MANA_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,

		EOM_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BONUS,

		EOM_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT,
		EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		EOM_MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,

		EOM_MODIFIER_PROPERTY_ACQUISITION_RANGE_BONUS,
	}
end
function public:EOM_GetModifierBonusStats_Primary(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_primary_stat")
end
function public:EOM_GetModifierBonusStats_Secondary(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_secondary_stat")
end
function public:EOM_GetModifierBonusStats_All(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_all_stats")
end
function public:EOM_GetModifierBonusStats_Strength(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_strength")
end
function public:EOM_GetModifierBonusStats_Agility(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_agility")
end
function public:EOM_GetModifierBonusStats_Intellect(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_intellect")
end

function public:EOM_GetModifierHealthBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_health")
end
function public:EOM_GetModifierManaBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_mana")
end
function public:EOM_GetModifierConstantHealthRegen(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_health_regen")
end
function public:EOM_GetModifierConstantManaRegen(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_mana_regen")
end

function public:EOM_GetModifierBaseAttack_BonusDamage(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_base_attack_damage")
end
function public:EOM_GetModifierArmorBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_armor")
end
function public:EOM_GetModifierMagicalArmorBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_magical_armor")
end

function public:EOM_GetModifierSpellAmplifyBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_spell_amplify")
end
function public:EOM_GetModifierEvasion_Constant(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_evasion")
end
function public:EOM_GetModifierStatusResistanceStacking(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_status_resist")
end
function public:EOM_GetModifierStatusResistanceCaster(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_debuff_amplify")
end

function public:EOM_GetModifierAcquisitionRangeBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_acquisition_range")
end

function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,

		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,

		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_REDUCTION_CONSTANT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
	}
end
function public:GetModifierPreAttack_BonusDamage(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_attack_damage")
end
function public:GetModifierMoveSpeedBonus_Constant(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_movement_speed")
end
function public:GetModifierAttackSpeedBonus_Constant(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_attack_speed")
end
function public:GetModifierAttackRangeBonus(params)
	return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_attack_range")
end
function public:GetModifierCastRangeBonusStacking(params)
	if IsValid(params.ability) and bit.band(params.ability:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_ATTACK) == DOTA_ABILITY_BEHAVIOR_ATTACK then
		return AbilityUpgrades:GetStatsUpgrade(self:GetParent(), "bonus_attack_range")
	end
	return 0
end

function public:GetModifierCooldownReduction_Constant(params)
	if not IsValid(params.ability) then
		return 0
	end

	return AbilityUpgrades:GetSpecialValueUpgrade(self:GetParent(), params.ability:GetAbilityName(), "cooldown", ABILITY_UPGRADES_OP_ADD)
end
function public:GetModifierPercentageCooldown(params)
	if not IsValid(params.ability) then
		return 0
	end

	return -AbilityUpgrades:GetSpecialValueUpgrade(self:GetParent(), params.ability:GetAbilityName(), "cooldown", ABILITY_UPGRADES_OP_MUL)
end
function public:GetModifierManacostReduction_Constant(params)
	if not IsValid(params.ability) then
		return 0
	end

	return AbilityUpgrades:GetSpecialValueUpgrade(self:GetParent(), params.ability:GetAbilityName(), "mana_cost", ABILITY_UPGRADES_OP_ADD)
end
function public:GetModifierPercentageManacostStacking( params )
	if not IsValid(params.ability) then
		return 0
	end

	return -AbilityUpgrades:GetSpecialValueUpgrade(self:GetParent(), params.ability:GetAbilityName(), "mana_cost", ABILITY_UPGRADES_OP_MUL)
end