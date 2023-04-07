---@class mubei: eom_ability
mubei = eom_ability({})
function mubei:GetIntrinsicModifierName()
	return "modifier_mubei"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_mubei : eom_modifier
modifier_mubei = eom_modifier({
	Name = "modifier_mubei",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_mubei:OnIntervalThink()
	if IsServer() then
		if IsValid(self.mubei) and self.mubei:IsAlive() then
			self:GetParent():RespawnUnit()
		else
			self:GetParent():Remove()
		end
	end
end
function modifier_mubei:OnDeath()
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		local hParent = self:GetParent()
		hParent:SetUnitCanRespawn(true)
		self.mubei = hParent:SummonUnit("mubei", hParent:GetAbsOrigin(), true, 20.1)
		self.mubei:AddNewModifier(hParent, self:GetAbility(), "modifier_mubei_aura", nil)
		self:StartIntervalThink(20)
	end
end
function modifier_mubei:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_mubei_aura : eom_modifier
modifier_mubei_aura = eom_modifier({
	Name = "modifier_mubei_aura",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_mubei_aura:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_mubei_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_mubei_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end
function modifier_mubei_aura:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end
function modifier_mubei_aura:OnCreated()
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/undying/undying_manyone/undying_pale_tombstone_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_mubei_aura_buff : eom_modifier
modifier_mubei_aura_buff = eom_modifier({
	Name = "modifier_mubei_aura_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_mubei_aura_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_mubei_aura_buff:GetAbilitySpecialValue()
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_mubei_aura_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.heal
	}
end