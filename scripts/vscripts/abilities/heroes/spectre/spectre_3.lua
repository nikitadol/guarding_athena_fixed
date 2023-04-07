---@class spectre_3 : eom_ability
spectre_3 = eom_ability({})
function spectre_3:GetIntrinsicModifierName()
	return "modifier_spectre_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_3 : eom_modifier
modifier_spectre_3 = eom_modifier({
	Name = "modifier_spectre_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_3:GetAbilitySpecialValue()
	self.health = self:GetAbilitySpecialValueFor("health")
	self.str = self:GetAbilitySpecialValueFor("str")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.max_reduce = self:GetAbilitySpecialValueFor("max_reduce")
	self.damage_limit = self:GetAbilitySpecialValueFor("damage_limit")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
	self.health_str = self:GetAbilitySpecialValueFor("health_str")
	self.scepter_damage_limit = self:GetAbilitySpecialValueFor("scepter_damage_limit")
end
function modifier_spectre_3:OnCreated(params)
	if IsServer() then
		self.flDamageRecorder = 0
	end
end
function modifier_spectre_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE
	}
end
function modifier_spectre_3:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit == hParent then
			if params.damage_flags and (bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS) then
				return
			end
			-- 反弹伤害
			local flDamagePercent = RemapValClamped(params.original_damage or params.damage, 0, hParent:GetCustomMaxHealth(), self.damage_limit, 100)
			local flDamage = self.damage * flDamagePercent
			local flRadius = RemapVal(flDamagePercent, self.damage_limit, 100, self.radius, self.max_radius)
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), flRadius, self:GetAbility())
			hParent:DealDamage(tTargets, self:GetAbility(), flDamage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
			-- 记录伤害
			self.flDamageRecorder = self.flDamageRecorder + (params.original_damage or params.damage)
			if self.flDamageRecorder >= hParent:GetCustomMaxHealth() then
				self.flDamageRecorder = self.flDamageRecorder - hParent:GetCustomMaxHealth()
				self:IncrementStackCount()
			end
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_spectre_3_particle", { duration = 1 })
		end
	end
end
function modifier_spectre_3:EOM_GetModifierHealthBonus()
	if self:GetCaster():IsRealHero() then
		return self:GetStackCount() * self:GetCaster():GetStrength() * self.health_str
	end
end
function modifier_spectre_3:EOM_GetModifierHealthPercentage()
	return self:GetStackCount() * self.health
end
function modifier_spectre_3:EOM_GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.str
end
function modifier_spectre_3:EOM_GetModifierConstantHealthRegen()
	return self:GetStackCount() * self.regen
end
function modifier_spectre_3:EOM_GetModifierIncomingDamagePercentage()
	return RemapVal(self:GetParent():GetHealthPercent(), 0, 100, -self.max_reduce, 0)
end
function modifier_spectre_3:EOM_GetModifierIgnoreDamage(params)
	if self:GetParent():GetScepterLevel() >= 3 then
		local flDamageLimit = self.scepter_damage_limit * self:GetParent():GetCustomMaxHealth() * 0.01
		return math.max(params.damage - flDamageLimit, 0)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_3_particle : eom_modifier
modifier_spectre_3_particle = eom_modifier({
	Name = "modifier_spectre_3_particle",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_3_particle:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end