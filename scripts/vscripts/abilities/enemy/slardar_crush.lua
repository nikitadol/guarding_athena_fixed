---@class slardar_crush: eom_ability
slardar_crush = eom_ability({}, nil, ability_base_ai)
function slardar_crush:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function slardar_crush:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = duration })
		hCaster:DealDamage(hUnit, self, damage)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Slardar.Pick")
end