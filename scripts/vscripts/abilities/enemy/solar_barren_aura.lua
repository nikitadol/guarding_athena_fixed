---@class solar_barren_aura: eom_ability
solar_barren_aura = eom_ability({})
function solar_barren_aura:GetIntrinsicModifierName()
	return "modifier_solar_barren_aura"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_barren_aura : eom_modifier
modifier_solar_barren_aura = eom_modifier({
	Name = "modifier_solar_barren_aura",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_solar_barren_aura:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(4)
	end
end
function modifier_solar_barren_aura:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.aura_radius, hAbility)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hParent, hAbility, BUILT_IN_MODIFIER.MAGIC_IMMUNE, { duration = 1 })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_barren_aura_buff : eom_modifier
modifier_solar_barren_aura_buff = eom_modifier({
	Name = "modifier_solar_barren_aura_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_barren_aura_buff:GetAbilitySpecialValue()
	self.regen = self:GetAbilitySpecialValueFor("regen")
end
function modifier_solar_barren_aura_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.regen
	}
end