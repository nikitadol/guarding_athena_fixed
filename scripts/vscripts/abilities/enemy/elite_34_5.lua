---@class elite_34_5: eom_ability
elite_34_5 = eom_ability({}, nil, ability_base_ai)
function elite_34_5:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorTarget():GetAbsOrigin()
	local distance = self:GetSpecialValueFor("distance")
	local starting_aoe = self:GetSpecialValueFor("starting_aoe")
	local final_aoe = self:GetSpecialValueFor("final_aoe")
	local speed = self:GetSpecialValueFor("speed")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local tInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = starting_aoe,
		fEndRadius = final_aoe,
		vVelocity = vDirection * speed,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(tInfo)
	hCaster:EmitSound("Hero_QueenOfPain.SonicWave")
end
function elite_34_5:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		local cooldown_add = self:GetSpecialValueFor("cooldown_add")
		local damage_pct = self:GetSpecialValueFor("damage_pct")
		local flDamage = self:GetAbilityDamage()
		for i = 1, hTarget:GetAbilityCount() do
			local hAbility = hTarget:GetAbilityByIndex(i)
			if IsValid(hAbility) and hAbility:GetCooldownTimeRemaining() > 0 then
				local flCooldown = hAbility:GetCooldownTimeRemaining()
				hAbility:EndCooldown()
				hAbility:StartCooldown(flCooldown + cooldown_add)
				flDamage = flDamage + hTarget:GetCustomMaxHealth() * damage_pct * 0.01
			end
		end
		hCaster:DealDamage(hTarget, self, flDamage)
		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_QueenOfPain.ShadowStrike.Target", hCaster)
	end
end