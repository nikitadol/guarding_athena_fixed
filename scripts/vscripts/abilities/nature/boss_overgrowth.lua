---@class boss_overgrowth: eom_ability
boss_overgrowth = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetCaster():GetHealthPercent() < 50
	end
}, nil, ability_base_ai)
function boss_overgrowth:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:EmitSound("Hero_Treant.Overgrowth.Cast")
	hCaster:AddNewModifier(hCaster, self, "modifier_boss_overgrowth", { duration = duration })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_overgrowth : eom_modifier
modifier_boss_overgrowth = eom_modifier({
	Name = "modifier_boss_overgrowth",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_boss_overgrowth:GetAuraRadius()
	return self.radius
end
function modifier_boss_overgrowth:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.regen = self:GetAbilitySpecialValueFor("regen")
end
function modifier_boss_overgrowth:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/skills/overgrowth.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_overgrowth:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = -100,
	}
end
function modifier_boss_overgrowth:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.regen,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_overgrowth_buff : eom_modifier
modifier_boss_overgrowth_buff = eom_modifier({
	Name = "modifier_boss_overgrowth_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_overgrowth_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_boss_overgrowth_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/skills/seed_entwine.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_overgrowth_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), self.damage)
end
function modifier_boss_overgrowth_buff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end