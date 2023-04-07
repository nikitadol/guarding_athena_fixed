---@class pet_49_1: eom_ability
pet_49_1 = eom_ability({})
function pet_49_1:GetIntrinsicModifierName()
	return "modifier_pet_49_1"
end
function pet_49_1:IsHiddenWhenStolen()
	return false
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_49_1 : eom_modifier
modifier_pet_49_1 = eom_modifier({
	Name = "modifier_pet_49_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_49_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1))
		-- self:OnIntervalThink()
	end
end
function modifier_pet_49_1:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:GetOwner():AddNewModifier(hParent, self:GetAbility(), "modifier_pet_49_1_buff", nil)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_49_1_buff : eom_modifier
modifier_pet_49_1_buff = eom_modifier({
	Name = "modifier_pet_49_1_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_49_1_buff:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.min_health = 1
	self.bTrigger = false
end
function modifier_pet_49_1_buff:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.min_health = 1
	self.bTrigger = false
end
function modifier_pet_49_1_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function modifier_pet_49_1_buff:OnTakeDamage(params)
	local caster = params.unit
	if caster == self:GetParent() then
		local ability = self:GetAbility()
		if caster:GetHealth() == 1 and self.bTrigger == false then
			self.bTrigger = true
			self:SetDuration(self.duration, true)
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
			self:GetParent():EmitSound("Hero_Dazzle.Shallow_Grave")
		end
	end
end
function modifier_pet_49_1_buff:GetMinHealth()
	return self.min_health
end
function modifier_pet_49_1_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end