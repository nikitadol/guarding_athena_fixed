---@class omniknight_2 : eom_ability
omniknight_2 = eom_ability({})
function omniknight_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vLocation = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local flStrength = hCaster:GetStrength()
	local hUnit = CreateUnitByName("heal_device", vLocation, true, hCaster, hCaster, hCaster:GetTeamNumber())
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	hUnit:SetBaseMaxHealth(flStrength * 100)
	hUnit:SetMaxHealth(flStrength * 100)
	hUnit:SetHealth(flStrength * 100)
	hUnit:SetPhysicalArmorBaseValue(flStrength)
	hUnit:AddNewModifier(hCaster, self, "modifier_kill", { duration = duration })
	hUnit:AddNewModifier(hCaster, self, "modifier_omniknight_2", { duration = duration })
	-- sound
	hUnit:EmitSound("Hero_Tinker.GridEffect")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_2 : eom_modifier
modifier_omniknight_2 = eom_modifier({
	Name = "modifier_omniknight_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, aura_base)
function modifier_omniknight_2:GetAuraRadius()
	return self.radius
end
function modifier_omniknight_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_omniknight_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_omniknight_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_omniknight_2:GetModifierAura()
	return "modifier_omniknight_2_aura"
end
function modifier_omniknight_2:GetEffectName()
	return AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_omniknight/omniknight_2.vpcf", self:GetCaster())
end
function modifier_omniknight_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_2:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_interval = self:GetAbilitySpecialValueFor("scepter_interval")
	self.scepter_count = self:GetAbilitySpecialValueFor("scepter_count")
	self.scepter_jump = self:GetAbilitySpecialValueFor("scepter_jump")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
end
function modifier_omniknight_2:OnCreated(t)
	if IsServer() then
		if self:GetParent():GetOwner():GetScepterLevel() >= 3 then
			self:StartIntervalThink(self.scepter_interval)
		end
	end
end
function modifier_omniknight_2:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local scepter_count = self.scepter_count
	local hAbility = self:GetAbility()
	local hAbility_0 = hCaster:FindAbilityByName("omniknight_0")
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, hAbility, self.scepter_damage, DAMAGE_TYPE_MAGICAL)
		hAbility_0:ThunderPower(hUnit)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 7, Vector(self.radius - 50, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hParent:EmitSound("Hero_Disruptor.ThunderStrike.Target")
end
function modifier_omniknight_2:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function modifier_omniknight_2:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = self:GetCaster():HasScepter()
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_omniknight_2_aura : eom_modifier
modifier_omniknight_2_aura = eom_modifier({
	Name = "modifier_omniknight_2_aura",
	IsHidden = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_omniknight_2_aura:IsDebuff()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return false
	end
	return true
end
function modifier_omniknight_2_aura:GetAbilitySpecialValue(t)
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.attackspeed_reduce = self:GetAbilitySpecialValueFor("attackspeed_reduce")
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
end
function modifier_omniknight_2_aura:Roll()
	if RollPercentage(self.chance) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_2_refresh.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + Vector(0, 0, 100))
		self:GetParent():EmitSound("Hero_Tinker.RearmStart")
		return true
	end
	return false
end
function modifier_omniknight_2_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_omniknight_2_aura:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function modifier_omniknight_2_aura:EOM_GetModifierConstantHealthRegen()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return self.health_regen
	end
end
function modifier_omniknight_2_aura:EOM_GetModifierHealthRegenPercentage()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return self.health_regen_pct
	end
end
function modifier_omniknight_2_aura:EOM_GetModifierConstantManaRegen()
	if self:GetParent():IsFriendly(self:GetCaster()) then
		return self.mana_regen
	end
end
function modifier_omniknight_2_aura:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():IsFriendly(self:GetCaster()) then
		return -self.attackspeed_reduce
	end
end
function modifier_omniknight_2_aura:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():IsFriendly(self:GetCaster()) then
		return -self.movespeed_reduce
	end
end