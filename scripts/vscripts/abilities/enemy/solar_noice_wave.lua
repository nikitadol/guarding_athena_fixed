---@class solar_noice_wave: eom_ability
solar_noice_wave = eom_ability({}, nil, ability_base_ai)
function solar_noice_wave:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("damage")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/units/solar_noice_wave.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = 600,
		flDistance = 600,
		flRadius = 450,
		OnProjectileHit = function(hTarget, vPosition, tInfo)
			hCaster:DealDamage(hTarget, self, hTarget:GetCustomHealth() * damage * 0.01)
			for i = 1, 8 do
				if hTarget:GetAbilityByIndex(i - 1) then
					local hAbility = hTarget:GetAbilityByIndex(i - 1)
					if not hAbility:IsCooldownReady() then
						local flCooldown = hAbility:GetCooldownTimeRemaining() + 20
						hAbility:EndCooldown()
						hAbility:StartCooldown(flCooldown)
					end
				end
			end
		end
	}
	ProjectileSystem:CreateLinearProjectile(info)
	hCaster:EmitSound("Hero_QueenOfPain.SonicWave")
end