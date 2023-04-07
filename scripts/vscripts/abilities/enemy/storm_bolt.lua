---@class storm_bolt: eom_ability
storm_bolt = eom_ability({}, nil, ability_base_ai)
function storm_bolt:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local bolt_speed = self:GetSpecialValueFor("bolt_speed")
	local bolt_stun_duration = self:GetSpecialValueFor("bolt_stun_duration")
	local damage = self:GetAbilityDamage()
	local info = {
		hCaster = hCaster,
		hTarget = hTarget,
		sEffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
		hAbility = self,
		iMoveSpeed = bolt_speed,
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		OnProjectileHit = function(hTarget, vLocation, tInfo)
			hCaster:EmitSound("Hero_Sven.StormBoltImpact")
			hCaster:DealDamage(hTarget, self, damage)
			hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = bolt_stun_duration })
			-- hAttacker:PerformAttack(hTarget, true, false, true, true, false, false, false)
		end
	}
	local iProjectileIndex = ProjectileSystem:CreateTrackingProjectile(info)
	local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_storm_bolt", nil)
	hCaster:FollowMotion(FOLLOW_MOTION_TYPE_PROJECTILE, iProjectileIndex, nil, hModifier)
	hCaster:EmitSound("Hero_Sven.StormBolt")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_storm_bolt : eom_modifier
modifier_storm_bolt = eom_modifier({
	Name = "modifier_storm_bolt",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_storm_bolt:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION = ACT_DOTA_OVERRIDE_ABILITY_1,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA = -200
	}
end