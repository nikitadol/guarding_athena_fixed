---@class antimage_2: eom_ability
antimage_2 = eom_ability({})
function antimage_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_antimage_2", { duration = duration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_antimage_2 : eom_modifier
modifier_antimage_2 = eom_modifier({
	Name = "modifier_antimage_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_2:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_antimage_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		self.radius = hParent:HasModifier("modifier_antimage_4") and self.radius * 2 or self.radius
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_antimage_2:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local flDamage = self:GetAbilitySpecialValueFor("damage")
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		---@param hUnit CDOTA_BaseNPC
		for _, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, flDamage)
		end
	end
end
function modifier_antimage_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.heal,
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = self.radius - GetOriginalBaseAttackRange(self:GetParent()),
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_antimage_2:EOM_GetModifierEvasion_Constant(params)
	if params and (params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius then
		return 100
	end
end
function modifier_antimage_2:OnAttackLanded(params)
	local hParent = self:GetParent()
	local flDistance = (params.target:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()
	if flDistance <= self.radius then
		local length = RemapValClamped(flDistance, 0, self.radius, 200, 0)
		params.target:KnockBack((params.target:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized(), length, 0, 0.2, false)
	end
end