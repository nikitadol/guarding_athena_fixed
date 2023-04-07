---@class solar_ice_blade: eom_ability
solar_ice_blade = eom_ability({})
function solar_ice_blade:GetIntrinsicModifierName()
	return "modifier_solar_ice_blade"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_ice_blade : eom_modifier
modifier_solar_ice_blade = eom_modifier({
	Name = "modifier_solar_ice_blade",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_ice_blade:OnAttackLanded(params)
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_solar_ice_blade_buff", { duration = 2 })
end
function modifier_solar_ice_blade:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_ice_blade_buff : eom_modifier
modifier_solar_ice_blade_buff = eom_modifier({
	Name = "modifier_solar_ice_blade_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_ice_blade_buff:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_solar_ice_blade_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -(self.attackspeed or 0),
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = -(self.movespeed or 0),
	}
end