---@class templar_assassin_1 : eom_ability
templar_assassin_1 = eom_ability({})
function templar_assassin_1:OnAbilityPhaseStart()
	self:GetCaster():AddActivityModifier("meld")
	return true
end
function templar_assassin_1:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveActivityModifier("meld")
end
function templar_assassin_1:OnSpellStart(hUnit)
	self:GetCaster():RemoveActivityModifier("meld")
	local hCaster = self:GetCaster()
	local hTarget = hUnit or self:GetCursorTarget()
	hCaster:SetCursorCastTarget(nil)
	local speed = self:GetSpecialValueFor("speed")
	local tProjectileInfo = {
		hCaster = hCaster,
		hTarget = hTarget,
		sEffectName = "particles/heroes/revelater/revelater_cash.vpcf",
		hAbility = self,
		iMoveSpeed = speed,
		vSpawnOrigin = hCaster:GetAttachmentPosition("attach_attack1"),
		bScepter = IsValid(hUnit)
	}
	ProjectileSystem:CreateTrackingProjectile(tProjectileInfo)

	hCaster:EmitSound("Hero_TemplarAssassin.Meld.Attack")
end
function templar_assassin_1:OnProjectileHit(hTarget, vLocation, tInfo)
	local hCaster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")
	local health_pct = self:GetSpecialValueFor("health_pct")
	local angle = self:GetSpecialValueFor("angle")
	local distance = self:GetSpecialValueFor("distance")
	local duration = self:GetSpecialValueFor("duration") + (hCaster:GetScepterLevel() >= 2 and self:GetSpecialValueFor("scepter_duration") or 0)
	local bonus_pct = self:GetSpecialValueFor("bonus_pct")

	local flDamagePct = health_pct * hTarget:GetCustomMaxHealth() * 0.01
	local vTargetLoc = hTarget:GetAbsOrigin()
	if tInfo.bScepter == false then
		-- 先造成百分比伤害
		hCaster:DealDamage(hTarget, self, flDamagePct, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS)
		-- 施加负面状态
		hTarget:AddNewModifier(hCaster, self, "modifier_templar_assassin_1_debuff", { duration = duration * hTarget:GetStatusResistanceFactor() })
	end
	-- 附带一次攻击
	hCaster:PerformAttack(hTarget, true, true, true, false, false, false, true)
	if hCaster:GetScepterLevel() >= 2 then
		hTarget:SetForwardVector(ProjectileSystem:GetDirection(tInfo))
		hTarget:KnockBack(ProjectileSystem:GetDirection(tInfo), tInfo.bScepter and 100 or 200, 0, tInfo.bScepter and 0.15 or 0.3, true)
	end
	-- 造成伤害
	hCaster:DealDamage(hTarget, self, damage)
	-- 溅射
	if hCaster:HasModifier("modifier_templar_assassin_2_buff") or
	hTarget:HasModifier("modifier_templar_assassin_2_debuff") then
		distance = distance * (1 + bonus_pct * 0.01)
	end
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vTargetLoc, distance, self)
	ArrayRemove(tTargets, hTarget)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, damage + flDamagePct)
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_cash_back.vpcf", PATTACH_CUSTOMORIGIN, hnilParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_1_debuff : eom_modifier
modifier_templar_assassin_1_debuff = eom_modifier({
	Name = "modifier_templar_assassin_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_1_debuff:GetAbilitySpecialValue()
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
end
function modifier_templar_assassin_1_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_templar_assassin_1_debuff:GetEffectName()
	return "particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_overhead.vpcf"
end
function modifier_templar_assassin_1_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_templar_assassin_1_debuff:OnDestroy()
	if IsServer() then
		-- 提前结束会回复剩余生命
		if self:GetParent():IsAlive() and self:GetRemainingTime() > 0 then
			self:GetParent():Heal(self.health_pct / self:GetDuration() * self:GetRemainingTime() * self:GetParent():GetCustomMaxHealth() * 0.01, self:GetAbility())
		end
	end
end
function modifier_templar_assassin_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE = 0.01
	}
end
function modifier_templar_assassin_1_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
	}
end
function modifier_templar_assassin_1_debuff:EOM_GetModifierHealthRegenPercentage()
	return self.health_pct / self:GetDuration()
end
function modifier_templar_assassin_1_debuff:GetModifierMoveSpeedBonus_Percentage(params)
	return -RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end
function modifier_templar_assassin_1_debuff:EOM_GetModifierIncomingDamagePercentage(params)
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end
function modifier_templar_assassin_1_debuff:EOM_GetModifierOutgoingDamagePercentage(params)
	return -RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end