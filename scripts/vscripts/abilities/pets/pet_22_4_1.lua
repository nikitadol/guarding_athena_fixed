---@class pet_22_4_1: eom_ability
pet_22_4_1 = eom_ability({})
function pet_22_4_1:GetIntrinsicModifierName()
	return "modifier_pet_22_4_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_4_1 : eom_modifier
modifier_pet_22_4_1 = eom_modifier({
	Name = "modifier_pet_22_4_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_4_1:GetAbilitySpecialValue()
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
end
function modifier_pet_22_4_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE = 100,
		EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE = self.cleave_percent,
		EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS = self.cleave_radius,
	-- MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end