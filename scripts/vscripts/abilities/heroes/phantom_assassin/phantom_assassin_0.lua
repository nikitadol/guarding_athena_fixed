---@class phantom_assassin_0: eom_ability
phantom_assassin_0 = eom_ability({})
function phantom_assassin_0:GetIntrinsicModifierName()
	return "modifier_phantom_assassin_0"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_0 : eom_modifier
modifier_phantom_assassin_0 = eom_modifier({
	Name = "modifier_phantom_assassin_0",
	-- IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	DestroyOnExpire = false,
	IsIndependent = true
})
function modifier_phantom_assassin_0:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_phantom_assassin_0:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.bonus_damage_percent = self:GetAbilitySpecialValueFor("bonus_damage_percent")
	self.critical_chance = self:GetAbilitySpecialValueFor("critical_chance")
	self.critical_damage = self:GetAbilitySpecialValueFor("critical_damage")
	self.life_steal = self:GetAbilitySpecialValueFor("life_steal")
	self.scepter_attack = self:GetAbilitySpecialValueFor("scepter_attack")
	self.scepter_crit_damage = self:GetAbilitySpecialValueFor("scepter_crit_damage")
end
function modifier_phantom_assassin_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_phantom_assassin_0:OnAttackLanded(params)
	self:SetDuration(self.duration, true)
	self:IncrementStackCount()
end
function modifier_phantom_assassin_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = self.critical_chance,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.critical_damage,
		EOM_MODIFIER_PROPERTY_PHYSICAL_LIFESTEAL,
		EOM_MODIFIER_PROPERTY_CRITICALSTRIKE_SOUND = "Hero_PhantomAssassin.CoupDeGrace",
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE_AMPLIFY
	}
end
function modifier_phantom_assassin_0:EOM_GetModifierAttackDamageBasePercentage(params)
	if self:GetParent():GetScepterLevel() >= 1 then
		return self.scepter_attack * self:GetStackCount()
	end
	return self:GetStackCount() * self.bonus_damage_percent
end
function modifier_phantom_assassin_0:EOM_GetModifierPhysicalLifesteal(params)
	if IsServer() and params and DamageFilter(params.record, DAMAGE_STATE_PHYSICAL_CRIT) then
		if self:GetParent():GetScepterLevel() >= 3 then
			params.unit:AddNewModifier(params.attacker, self:GetAbility(), "modifier_stunned", { duration = 0.1 })
		end
		return self.life_steal
	end
end
function modifier_phantom_assassin_0:EOM_GetModifierPhysicalCriticalStrikeDamageAmplify(params)
	if self:GetParent():GetScepterLevel() >= 3 then
		return self.scepter_crit_damage
	end
end