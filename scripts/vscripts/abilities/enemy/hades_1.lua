---@class hades_1: eom_ability
hades_1 = eom_ability({}, nil, ability_base_ai)
function hades_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local speed = self:GetSpecialValueFor("speed")
	for _, hUnit in pairs(tTargets) do
		local info = {
			hCaster = hCaster,
			hTarget = hUnit,
			sEffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
			hAbility = self,
			iMoveSpeed = speed,
			vSpawnOrigin = hCaster:GetAttachmentPosition("attach_hitloc"),
			OnProjectileHit = function(hTarget, vLocation, tInfo)
				hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
				hCaster:Heal(hCaster:GetCustomMaxHealth() * self:GetSpecialValueFor("regen") * 0.01, self, true)
			end
		}
		ProjectileSystem:CreateTrackingProjectile(info)
	end
	hCaster:EmitSound("Hero_Necrolyte.DeathPulse")
end