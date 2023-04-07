---@class pet_16_1: eom_ability
pet_16_1 = eom_ability({})
function pet_16_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function pet_16_1:GetIntrinsicModifierName()
	return "modifier_pet_16_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_16_1 : eom_modifier
modifier_pet_16_1 = eom_modifier({
	Name = "modifier_pet_16_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_16_1:IsAura()
	return true
end
function modifier_pet_16_1:GetAuraRadius()
	return self.radius
end
function modifier_pet_16_1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_pet_16_1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_pet_16_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_pet_16_1:GetModifierAura()
	return "modifier_pet_16_1_aura"
end
function modifier_pet_16_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_16_1_aura : eom_modifier
modifier_pet_16_1_aura = eom_modifier({
	Name = "modifier_pet_16_1_aura",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_16_1_aura:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_slowed_cold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_16_1_aura:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed
end
function modifier_pet_16_1_aura:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end
function modifier_pet_16_1_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end