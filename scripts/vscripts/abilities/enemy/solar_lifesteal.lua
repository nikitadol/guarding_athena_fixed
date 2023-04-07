---@class solar_lifesteal: eom_ability
solar_lifesteal = eom_ability({})
function solar_lifesteal:GetIntrinsicModifierName()
	return "modifier_solar_lifesteal"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_lifesteal : eom_modifier
modifier_solar_lifesteal = eom_modifier({
	Name = "modifier_solar_lifesteal",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_lifesteal:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_solar_lifesteal:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.attackspeed
end
function modifier_solar_lifesteal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_solar_lifesteal:OnAttackLanded(params)
	local hParent = self:GetParent()
	local flDamage = params.target:GetCustomHealth() * 0.1
	hParent:DealDamage(params.target, self:GetAbility(), flDamage)
	hParent:Heal(flDamage / params.target:GetCustomMaxHealth() * hParent:GetCustomHealth(), self:GetAbility())
	self:IncrementStackCount()
end
function modifier_solar_lifesteal:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end