---@class pet_44_1: eom_ability
pet_44_1 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_44_1:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function pet_44_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local flDamage = hMaster:GetPrimaryStats() * self:GetAbilityDamage()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = self:GetDuration() * hUnit:GetStatusResistanceFactor() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Slardar.Slithereen_Crush")
end