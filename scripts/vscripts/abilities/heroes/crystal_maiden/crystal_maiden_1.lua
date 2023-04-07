---@class crystal_maiden_1 : eom_ability
crystal_maiden_1 = eom_ability({})
function crystal_maiden_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("radius") + hCaster:GetColdStackCount() * self:GetSpecialValueFor("radius_per_cold")
	local flDamage = self:GetSpecialValueFor("damage") * (1 + hCaster:GetColdStackCount() * self:GetSpecialValueFor("damage_per_cold") * 0.01)
	local flFrozenDuration = self:GetSpecialValueFor("frozen_duration") + self:GetSpecialValueFor("frozen_per_cold") * hCaster:GetColdStackCount()
	local flDuration = flFrozenDuration + self:GetSpecialValueFor("duration")

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddNewModifier(hCaster, self, "modifier_crystal_maiden_1_debuff", { duration = flDuration * hUnit:GetStatusResistanceFactor(), flFrozenDuration = flFrozenDuration })
	end

	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/crystal_maiden/chilliness_burst.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, flRadius, flRadius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Crystal.CrystalNova")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_crystal_maiden_1_debuff : eom_modifier
modifier_crystal_maiden_1_debuff = eom_modifier({
	Name = "modifier_crystal_maiden_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_crystal_maiden_1_debuff:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.frozen_duration = self:GetAbilitySpecialValueFor("frozen_duration")
end
function modifier_crystal_maiden_1_debuff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_slowed_cold.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystal_maiden_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_crystal_maiden_1_debuff:GetModifierMoveSpeedBonus_Constant()
	if self:GetElapsedTime() > self.frozen_duration then
		return self.movespeed
	end
end
function modifier_crystal_maiden_1_debuff:GetModifierAttackSpeedBonus_Constant()
	if self:GetElapsedTime() > self.frozen_duration then
		return self.attackspeed
	end
end
function modifier_crystal_maiden_1_debuff:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = self:GetElapsedTime() < self.frozen_duration,
		[MODIFIER_STATE_ROOTED] = self:GetElapsedTime() < self.frozen_duration,
		[MODIFIER_STATE_DISARMED] = self:GetElapsedTime() < self.frozen_duration,
		[MODIFIER_STATE_STUNNED] = self:GetElapsedTime() < self.frozen_duration,
	}
end