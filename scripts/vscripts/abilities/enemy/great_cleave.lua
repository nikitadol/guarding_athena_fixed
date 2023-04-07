---@class great_cleave: eom_ability
great_cleave = eom_ability({})
function great_cleave:GetIntrinsicModifierName()
	return "modifier_great_cleave"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_great_cleave : eom_modifier
modifier_great_cleave = eom_modifier({
	Name = "modifier_great_cleave",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_great_cleave:GetAbilitySpecialValue()
	self.great_cleave_radius = self:GetAbilitySpecialValueFor("great_cleave_radius")
	self.great_cleave_damage = self:GetAbilitySpecialValueFor("great_cleave_damage")
end
function modifier_great_cleave:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS = self.great_cleave_radius,
		EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE = self.great_cleave_damage
	}
end