---@class hell_beast_aura: eom_ability
hell_beast_aura = eom_ability({})
function hell_beast_aura:GetIntrinsicModifierName()
	return "modifier_hell_beast_aura"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hell_beast_aura : eom_modifier
modifier_hell_beast_aura = eom_modifier({
	Name = "modifier_hell_beast_aura",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_hell_beast_aura:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hell_beast_aura_buff : eom_modifier
modifier_hell_beast_aura_buff = eom_modifier({
	Name = "modifier_hell_beast_aura_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hell_beast_aura_buff:GetAbilitySpecialValue()
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_hell_beast_aura_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.movespeed or 0,
	}
end
function modifier_hell_beast_aura_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.attack_pct
	}
end