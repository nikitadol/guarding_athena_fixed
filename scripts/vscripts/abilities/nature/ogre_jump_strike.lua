---@class ogre_jump_strike: eom_ability
ogre_jump_strike = eom_ability({}, nil, ability_base_ai)
function ogre_jump_strike:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function ogre_jump_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("n_creep_Thunderlizard_Big.Stomp")
end