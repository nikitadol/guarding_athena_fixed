---@class elite_30_3: eom_ability
elite_30_3 = eom_ability({})
function elite_30_3:GetIntrinsicModifierName()
	return "modifier_elite_30_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_30_3 : eom_modifier
modifier_elite_30_3 = eom_modifier({
	Name = "modifier_elite_30_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_30_3:IsAura()
	return self:GetParent():PassivesDisabled() and false or true
end
function modifier_elite_30_3:GetAuraRadius()
	return self.radius
end
function modifier_elite_30_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_elite_30_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_elite_30_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_elite_30_3:GetModifierAura()
	return "modifier_elite_30_3_aura"
end
function modifier_elite_30_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_30_3_aura : eom_modifier
modifier_elite_30_3_aura = eom_modifier({
	Name = "modifier_elite_30_3_aura",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_30_3_aura:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
end
function modifier_elite_30_3_aura:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE,
	}
end
function modifier_elite_30_3_aura:EOM_GetModifierAttackDamageBasePercentage()
	return self.bonus_attack
end