---@class dragon_energy_ball: eom_ability
dragon_energy_ball = eom_ability({}, nil, ability_base_ai)
function dragon_energy_ball:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local damage = self:GetSpecialValueFor("damage")
	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/neutral_fx/satyr_hellcaller.vpcf",
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		vDirection = vDirection,
		iMoveSpeed = 900,
		flDistance = 900,
		flRadius = 150,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hCaster:DealDamage(hTarget, self, hTarget:GetCustomMaxHealth() * damage * 0.01)
		end
	}
	ProjectileSystem:CreateLinearProjectile(info)
	hCaster:EmitSound("Hero_DragonKnight.DragonTail.Cast.Kindred")
end