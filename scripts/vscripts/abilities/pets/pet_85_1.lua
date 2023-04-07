---@class pet_85_1: eom_ability
pet_85_1 = eom_ability({})
function pet_85_1:GetIntrinsicModifierName()
	return "modifier_pet_85_1"
end
function pet_85_1:IsHiddenWhenStolen()
	return false
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_85_1 : eom_modifier
modifier_pet_85_1 = eom_modifier({
	Name = "modifier_pet_85_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_85_1:OnCreated(params)
	if IsServer() then
		self.duration = self:GetAbilitySpecialValueFor("duration")
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		-- self:OnIntervalThink()
	end
end
function modifier_pet_85_1:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:GetOwner():AddNewModifier(hParent, self:GetAbility(), "modifier_pet_85_1_buff", { duration = self.duration })
	if hParent:GetOwner():HasAbility("omniknight_1") then
		local hAbility = hParent:GetOwner():FindAbilityByName("omniknight_1")
		if hAbility:GetCharges() < hAbility:GetMaxCharges() then
			hAbility:AddCharges(1)
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_85_1_buff : eom_modifier
modifier_pet_85_1_buff = eom_modifier({
	Name = "modifier_pet_85_1_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_85_1_buff:OnCreated(params)
	if IsClient() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_give.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_85_1_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 5,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE = 5,
	}
end