---@class roshan_shock: eom_ability
roshan_shock = eom_ability({})
function roshan_shock:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function roshan_shock:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local shock_duration = self:GetSpecialValueFor("shock_duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_roshan_shock", { duration = shock_duration })
		hCaster:DealDamage(hUnit, self, damage)
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_roshan_shock_buff", { duration = duration })
	local iParticleID = ParticleManager:CreateParticle("particles/units/wave_37/roshan_shock.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Roshan.Slam")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_roshan_shock : eom_modifier
modifier_roshan_shock = eom_modifier({
	Name = "modifier_roshan_shock",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_roshan_shock:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_roshan_shock:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_roshan_shock:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:MoveToPosition(hParent:GetAbsOrigin() + RandomVector(500))
	end
end
function modifier_roshan_shock:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = -(self.movespeed or 0)
	}
end
function modifier_roshan_shock:CheckState()
	return {
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_roshan_shock_buff : eom_modifier
modifier_roshan_shock_buff = eom_modifier({
	Name = "modifier_roshan_shock_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_roshan_shock_buff:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_roshan_shock_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0
	}
end