---@class demon_chains_3: eom_ability
demon_chains_3 = eom_ability({})
function demon_chains_3:GetIntrinsicModifierName()
	return "modifier_demon_chains_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_3 : eom_modifier
modifier_demon_chains_3 = eom_modifier({
	Name = "modifier_demon_chains_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_3_buff : eom_modifier
modifier_demon_chains_3_buff = eom_modifier({
	Name = "modifier_demon_chains_3_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_demon_chains_3_buff:GetAbilitySpecialValue()
	self.aura_hp_regen_percent = self:GetAbilitySpecialValueFor("aura_hp_regen_percent")
	self.aura_attack_percent = self:GetAbilitySpecialValueFor("aura_attack_percent")
	self.aura_attackspeed = self:GetAbilitySpecialValueFor("aura_attackspeed")
end
function modifier_demon_chains_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.aura_attackspeed or 0
	}
end
function modifier_demon_chains_3_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.aura_hp_regen_percent,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.aura_attack_percent
	}
end