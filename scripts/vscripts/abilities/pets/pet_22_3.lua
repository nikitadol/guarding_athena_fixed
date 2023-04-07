---@class pet_22_3: eom_ability
pet_22_3 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_22_3:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_22_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster:GetMaster(), hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local flDamage = self:GetAbilityDamage() * hCaster:GetMaster():GetPrimaryStats()
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_pet_22_3", { duration = self:GetDuration() * hUnit:GetStatusResistanceFactor() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/pets/pet_22_3.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(300, 300, 300))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Icewrack_Pup.Ult.Howl")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_3 : eom_modifier
modifier_pet_22_3 = eom_modifier({
	Name = "modifier_pet_22_3",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_3:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.armor = self:GetAbilitySpecialValueFor("armor")
	self.fear_duration = self:GetAbilitySpecialValueFor("fear_duration")
	self.movespeed = self.distance / self.fear_duration

	if IsServer() then
		local vPosition = self:GetParent():GetAbsOrigin() + RandomVector(self.distance)
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, vPosition)
	end
end
function modifier_pet_22_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.armor,
	}
end
function modifier_pet_22_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
end
function modifier_pet_22_3:GetModifierMoveSpeed_Absolute()
	if self:GetElapsedTime() < self.fear_duration then
		return self.movespeed
	end
end
function modifier_pet_22_3:CheckState()
	return {
		[MODIFIER_STATE_FEARED] = (self:GetElapsedTime() < self.fear_duration) and true or false,
		[MODIFIER_STATE_DISARMED] = (self:GetElapsedTime() < self.fear_duration) and true or false
	}
end