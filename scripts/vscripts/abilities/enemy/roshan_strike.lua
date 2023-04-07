---@class roshan_strike: eom_ability
roshan_strike = eom_ability({})
function roshan_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		local vDirection = (hUnit:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
		hUnit:KnockBack(vDirection, 200, 250, 1)
		hCaster:DealDamage(hUnit, self, damage)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/neutral_fx/roshan_slam.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Roshan.Slam")
end