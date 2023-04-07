---@class pet_15_1: eom_ability
pet_15_1 = eom_ability({})
function pet_15_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function pet_15_1:GetIntrinsicModifierName()
	return "modifier_pet_15_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_15_1 : eom_modifier
modifier_pet_15_1 = eom_modifier({
	Name = "modifier_pet_15_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_15_1:IsAura()
	return true
end
function modifier_pet_15_1:GetAuraRadius()
	return self.radius
end
function modifier_pet_15_1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_pet_15_1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_pet_15_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_pet_15_1:GetModifierAura()
	return "modifier_pet_15_1_aura"
end
function modifier_pet_15_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_15_1_aura : eom_modifier
modifier_pet_15_1_aura = eom_modifier({
	Name = "modifier_pet_15_1_aura",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_15_1_aura:OnCreated(params)
	if IsServer() then
		self.hMaster = self:GetCaster():GetMaster()
		self.interval = self:GetAbilitySpecialValueFor("interval")
		self.damage = self:GetAbilityDamage() * self.hMaster:GetPrimaryStats() * self.interval
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_15_1_aura:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.damage)
end