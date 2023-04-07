---@class solar_fire: eom_ability
solar_fire = eom_ability({})
function solar_fire:GetIntrinsicModifierName()
	return "modifier_solar_fire"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_fire : eom_modifier
modifier_solar_fire = eom_modifier({
	Name = "modifier_solar_fire",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_fire:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.armor = self:GetAbilitySpecialValueFor("armor")
end
function modifier_solar_fire:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_solar_fire:OnIntervalThink()
	self:IncrementStackCount()
end
function modifier_solar_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end
function modifier_solar_fire:GetModifierModelScale()
	return self:GetStackCount() * 3
end
function modifier_solar_fire:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE,
		EOM_MODIFIER_PROPERTY_ARMOR_BASE,
	}
end
function modifier_solar_fire:EOM_GetModifierHealthBonus()
	return self.health * self:GetStackCount()
end
function modifier_solar_fire:EOM_GetModifierAttackDamageBase()
	return self.damage * self:GetStackCount()
end
function modifier_solar_fire:EOM_GetModifierArmorBase()
	return self.armor * self:GetStackCount()
end