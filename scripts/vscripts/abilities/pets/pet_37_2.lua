---@class pet_37_2: eom_ability
pet_37_2 = eom_ability({})
function pet_37_2:GetIntrinsicModifierName()
	return "modifier_pet_37_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_37_2 : eom_modifier
modifier_pet_37_2 = eom_modifier({
	Name = "modifier_pet_37_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_37_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_37_2:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_37_2_buff") then
		self.hModifier = self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_37_2_buff", nil)
		self:StartIntervalThink(-1)
	end
end
function modifier_pet_37_2:OnDestroy()
	if IsServer() then
		self.hModifier:Destroy()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_37_2_buff : eom_modifier
modifier_pet_37_2_buff = eom_modifier({
	Name = "modifier_pet_37_2_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false,
})
function modifier_pet_37_2_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_37_2_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_pet_37_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_pet_37_2_buff:GetModifierAvoidDamage(params)
	if RollPercentage(self.chance) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		return 1
	end
end