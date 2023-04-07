---@class shock_wave: eom_ability
shock_wave = eom_ability({}, nil, ability_base_ai)
function shock_wave:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function shock_wave:OnSpellStart()
	local hCaster = self:GetCaster()
	local iCount = 16
	local flAngle = 360 / iCount

	local radius = self:GetSpecialValueFor("radius")
	local distance = self:GetSpecialValueFor("distance")
	local speed = self:GetSpecialValueFor("speed")
	local damage = self:GetSpecialValueFor("damage")
	for i = 1, iCount do
		local vDirection = RotatePosition(vec3_zero, QAngle(0, flAngle * i, 0), Vector(0, 1, 0))
		local info = {
			hAbility = self,
			hCaster = hCaster,
			sEffectName = "particles/units/wave_23/shock_wave.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			vDirection = vDirection,
			iMoveSpeed = speed,
			flDistance = distance,
			flRadius = radius,
			OnProjectileHit = function(hTarget, vPosition, tInfo)
				if not hTarget:HasModifier("modifier_knockback_custom") then
					hTarget:KnockBack(ProjectileSystem:GetDirection(tInfo), 150, 150, 1)
					hCaster:DealDamage(hTarget, self, damage)
					for i = 1, iCount / 2 do
						local info = {
							hAbility = self,
							hCaster = hCaster,
							sEffectName = "particles/units/wave_23/shock_wave.vpcf",
							vSpawnOrigin = hTarget:GetAbsOrigin(),
							vDirection = RotatePosition(vec3_zero, QAngle(0, flAngle * i * 2, 0), Vector(0, 1, 0)),
							iMoveSpeed = speed / 2,
							flDistance = distance / 2,
							flRadius = radius,
							OnProjectileHit = function(_hTarget, vPosition, tInfo)
								hCaster:DealDamage(_hTarget, self, damage)
							end
						}
						ProjectileSystem:CreateLinearProjectile(info)
					end
				end
			end
		}
		ProjectileSystem:CreateLinearProjectile(info)
	end
	hCaster:EmitSound("Hero_EarthShaker.EchoSlam")
end