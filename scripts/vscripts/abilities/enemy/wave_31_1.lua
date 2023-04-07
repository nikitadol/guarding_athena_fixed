---@class wave_31_1: eom_ability
wave_31_1 = eom_ability({})
function wave_31_1:GetIntrinsicModifierName()
	return "modifier_wave_31_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_31_1 : eom_modifier
modifier_wave_31_1 = eom_modifier({
	Name = "modifier_wave_31_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_31_1:GetAbilitySpecialValue()
	self.lifesteal = self:GetAbilitySpecialValueFor("lifesteal")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
end
function modifier_wave_31_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = self.crit_chance,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.crit_mult,
		EOM_MODIFIER_PROPERTY_ALL_LIFESTEAL = self.lifesteal
	}
end
function modifier_wave_31_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0
	}
end