---@class troll_fireball: eom_ability
troll_fireball = eom_ability({}, nil, ability_base_ai)
function troll_fireball:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/linear_projectile/fire_ball.vpcf",
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		vDirection = vDirection,
		iMoveSpeed = 600,
		flDistance = 2000,
		iHitCount = 1,
		flRadius = 150,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hCaster:DealDamage(hTarget, self, damage)
		end
	}
	ProjectileSystem:CreateLinearProjectile(info)
end