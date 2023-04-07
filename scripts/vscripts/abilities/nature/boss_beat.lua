---@class boss_beat: eom_ability
boss_beat = eom_ability({}, nil, ability_base_ai)
function boss_beat:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	hCaster:DealDamage(hTarget, self, damage)
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "n_creep_Ursa.Clap", hCaster)
end