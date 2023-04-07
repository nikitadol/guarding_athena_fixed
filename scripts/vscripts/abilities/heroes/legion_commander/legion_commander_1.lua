---@class legion_commander_1: eom_ability
legion_commander_1 = eom_ability({})
function legion_commander_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local taunt_duration = self:GetSpecialValueFor("taunt_duration")
	if hCaster:GetScepterLevel() >= 2 then
		taunt_duration = self:GetSpecialValueFor("scepter_duration")
	end
	local radius = self:GetSpecialValueFor("radius")
	if hCaster:HasModifier("modifier_legion_commander_4") then
		radius = radius * 2
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_1", { duration = duration })
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(radius, radius, radius))
	hCaster:EmitSound("Hero_LegionCommander.PressTheAttack")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_legion_commander_1_buff", { duration = taunt_duration })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_1 : eom_modifier
modifier_legion_commander_1 = eom_modifier({
	Name = "modifier_legion_commander_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_1:GetAbilitySpecialValue()
	self.regen = self:GetAbilitySpecialValueFor("regen")
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.scepter_armor_pct = self:GetAbilitySpecialValueFor("scepter_armor_pct")
end
function modifier_legion_commander_1:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_legion_commander_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.regen,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = 100,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = self.critical,
		EOM_MODIFIER_PROPERTY_IGNORE_ARMOR_PERCENTAGE
	}
end
function modifier_legion_commander_1:EOM_GetModifierIgnoreArmorPercentage(params)
	if self:GetParent():GetScepterLevel() >= 2 then
		return self.scepter_armor_pct
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_1_buff : eom_modifier
modifier_legion_commander_1_buff = eom_modifier({
	Name = "modifier_legion_commander_1_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_1_buff:GetAbilitySpecialValue()
	self.armor = self:GetAbilitySpecialValueFor("armor")
end
function modifier_legion_commander_1_buff:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		hParent:SetForceAttackTarget(self:GetCaster())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_beserkers_call.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_legion_commander_1_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetForceAttackTarget(nil)
	end
end
function modifier_legion_commander_1_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor,
	}
end