base_disruption = eom_ability({})
function base_disruption:GetIntrinsicModifierName()
	return "modifier_base_disruption"
end
---------------------------------------------------------------------
--Modifiers
---@class modifier_base_disruption:eom_modifier
modifier_base_disruption = eom_modifier({
	Name = "modifier_base_disruption",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	IsAura = true,
})
function modifier_base_disruption:GetAuraRadius()
	return self.radius
end
function modifier_base_disruption:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_base_disruption:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_base_disruption:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_base_disruption:GetModifierAura()
	return "modifier_base_disruption_debuff"
end
function modifier_base_disruption:GetAuraEntityReject(hEntity)
	return false
end
function modifier_base_disruption:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
---------------------------------------------------------------------
---@class modifier_base_disruption_debuff:eom_modifier
modifier_base_disruption_debuff = eom_modifier({
	Name = "modifier_base_disruption_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_base_disruption_debuff:GetAbilitySpecialValue()
	self.slow_move = self:GetAbilitySpecialValueFor("slow_move")
	self.slow_attack_speed = self:GetAbilitySpecialValueFor("slow_attack_speed")
end
function modifier_base_disruption_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = self.slow_move or 0,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.slow_attack_speed or 0,
	}
end