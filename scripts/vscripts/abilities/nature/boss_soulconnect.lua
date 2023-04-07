---@class boss_soulconnect: eom_ability
boss_soulconnect = eom_ability({}, nil, ability_base_ai)
function boss_soulconnect:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function boss_soulconnect:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_boss_soulconnect", { duration = 10 })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_soulconnect : eom_modifier
modifier_boss_soulconnect = eom_modifier({
	Name = "modifier_boss_soulconnect",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_soulconnect:OnCreated()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:EmitSound("Hero_Visage.GraveChill.Target")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_soulconnect:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(0)
	end
end
function modifier_boss_soulconnect:OnTakeDamage(params)
	if self:GetStackCount() == 0 and params.attacker == self:GetParent() then
		self:SetStackCount(1)
		self:StartIntervalThink(0.2)
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hCaster:DealDamage(hParent, hAbility, params.damage)
	end
end
function modifier_boss_soulconnect:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetCaster() }
	}
end