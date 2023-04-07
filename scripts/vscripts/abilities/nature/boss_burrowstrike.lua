---@class boss_burrowstrike: eom_ability
boss_burrowstrike = eom_ability({}, nil, ability_base_ai)
function boss_burrowstrike:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_SAND_KING_BURROW_IN)
	return true
end
function boss_burrowstrike:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = (vPosition - hCaster:GetAbsOrigin()):Length2D()
	local damage = self:GetSpecialValueFor("damage")
	local width = self:GetSpecialValueFor("width")
	hCaster:Dash(vDirection, flDistance, 0, 0.25, nil, function()
		hCaster:RemoveGesture(ACT_DOTA_SAND_KING_BURROW_IN)
		hCaster:StartGesture(ACT_DOTA_SAND_KING_BURROW_OUT)
	end)

	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = flDistance / 0.25,
		flDistance = flDistance,
		flRadius = width,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hTarget:KnockBack(vec3_zero, 0, 400, 0.52)
			hCaster:DealDamage(hTarget, self, damage)
		end
	}
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	ProjectileSystem:CreateLinearProjectile(info)
	hCaster:EmitSound("Ability.SandKing_BurrowStrike")
end