---@class ogre_strike: eom_ability
ogre_strike = eom_ability({}, nil, ability_base_ai)
function ogre_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local vTargetLoc = hCaster:GetAbsOrigin() + (vPosition - hCaster:GetAbsOrigin()):Normalized() * self:GetCastRange(hCaster:GetAbsOrigin(), nil)
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vTargetLoc, radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vTargetLoc)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(vTargetLoc, "n_creep_Thunderlizard_Big.Stomp", hCaster)
end