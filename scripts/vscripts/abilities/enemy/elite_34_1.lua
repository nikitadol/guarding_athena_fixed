---@class elite_34_1: eom_ability
elite_34_1 = eom_ability({}, nil, ability_base_ai)
function elite_34_1:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function elite_34_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local shock_duration = self:GetSpecialValueFor("shock_duration")

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	local tProjectileInfo = {
		Source = hCaster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
		bDodgeable = true,
		iMoveSpeed = projectile_speed,
		vSourceLoc = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("mouth")),
		ExtraData = {
			flDamage = self:GetAbilityDamage(),
			flDuration = shock_duration
		}
	}
	for _, hUnit in pairs(tTargets) do
		tProjectileInfo.Target = hUnit
		ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_QueenOfPain.ScreamOfPain")
end
function elite_34_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hTarget, self, ExtraData.flDamage)
	hTarget:AddNewModifier(hCaster, self, "modifier_elite_34_1", { duration = ExtraData.flDuration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_34_1 : eom_modifier
modifier_elite_34_1 = eom_modifier({
	Name = "modifier_elite_34_1",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_34_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.5)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_34_1:OnIntervalThink()
	self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + RandomVector(500))
end
function modifier_elite_34_1:CheckState()
	return {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
	}
end