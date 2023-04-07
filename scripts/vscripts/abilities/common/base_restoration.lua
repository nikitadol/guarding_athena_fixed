base_restoration = eom_ability({})
function base_restoration:GetIntrinsicModifierName()
	return "modifier_base_restoration"
end
---------------------------------------------------------------------
--Modifiers
---@class modifier_base_restoration:eom_modifier
modifier_base_restoration = eom_modifier({
	Name = "modifier_base_restoration",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_base_restoration:GetAbilitySpecialValue()
	self.health_regen_percent = self:GetAbilitySpecialValueFor("health_regen_percent")
end
function modifier_base_restoration:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.health_regen_percent,
	}
end