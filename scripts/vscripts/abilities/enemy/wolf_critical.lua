---@class wolf_critical: eom_ability
wolf_critical = eom_ability({})
function wolf_critical:GetIntrinsicModifierName()
	return "modifier_wolf_critical"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wolf_critical : eom_modifier
modifier_wolf_critical = eom_modifier({
	Name = "modifier_wolf_critical",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wolf_critical:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.critical = self:GetAbilitySpecialValueFor("critical")
end
function modifier_wolf_critical:OnCreated(params)
	if IsServer() then
	end
end
function modifier_wolf_critical:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_wolf_critical:OnDestroy()
	if IsServer() then
	end
end
function modifier_wolf_critical:DeclareFunctions()
	return {
	}
end
function modifier_wolf_critical:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = self.chance,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.critical,
	}
end