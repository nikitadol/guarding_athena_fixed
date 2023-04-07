---@class jugg_attack: eom_ability
jugg_attack = eom_ability({})
function jugg_attack:GetIntrinsicModifierName()
	return "modifier_jugg_attack"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_jugg_attack : eom_modifier
modifier_jugg_attack = eom_modifier({
	Name = "modifier_jugg_attack",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_jugg_attack:GetAbilitySpecialValue()
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.evasion = self:GetAbilitySpecialValueFor("evasion")
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_jugg_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.bonus_attack_speed or 0,
	}
end
function modifier_jugg_attack:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = self.chance,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.critical,
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT = self.evasion,
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE
	}
end
function modifier_jugg_attack:EOM_GetModifierIgnoreArmorPercentage(params)
	return 100
end