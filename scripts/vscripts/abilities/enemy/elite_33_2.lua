---@class elite_33_2: eom_ability
elite_33_2 = eom_ability({})
function elite_33_2:GetIntrinsicModifierName()
	return "modifier_elite_33_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_2 : eom_modifier
modifier_elite_33_2 = eom_modifier({
	Name = "modifier_elite_33_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_elite_33_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetAbility():UseResources(false, false, true)
		self:StartIntervalThink(self:GetAbility():GetCooldownTimeRemaining())
	end
end
function modifier_elite_33_2:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_elite_33_2:OnRemoved()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_elite_33_2:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:PassivesDisabled() then
		return
	end
	local hAbility = self:GetAbility()
	local flDuration = self:GetAbility():GetDuration()
	local flDamage = self:GetAbility():GetAbilityDamage()
	hAbility:UseResources(false, false, true)
	hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	hParent:EmitSound("Hero_NagaSiren.Riptide.Cast")
	-- damage
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		hParent:DealDamage(hUnit, hAbility, flDamage)
		hUnit:AddNewModifier(hParent, hAbility, "modifier_elite_33_2_debuff", { duration = flDuration * hUnit:GetStatusResistanceFactor() })
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(self.radius, 0, 0))
	self:AddParticle(iParticleID, false, false, -1, false, false)

	return hAbility:GetCooldownTimeRemaining()
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_33_2_debuff : eom_modifier
modifier_elite_33_2_debuff = eom_modifier({
	Name = "modifier_elite_33_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_33_2_debuff:GetAbilitySpecialValue()
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
end
function modifier_elite_33_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor_reduce
	}
end