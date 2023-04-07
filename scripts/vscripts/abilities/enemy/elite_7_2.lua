---@class elite_7_2: eom_ability
elite_7_2 = eom_ability({}, nil, ability_base_ai)
function elite_7_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_elite_7_2", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_Warlock.ShadowWordCastBad")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_7_2 : eom_modifier
modifier_elite_7_2 = eom_modifier({
	Name = "modifier_elite_7_2",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_7_2:OnCreated(params)
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	if IsServer() then
		self:StartIntervalThink(self.tick_interval)
		self:GetParent():EmitSound("Hero_Warlock.ShadowWord")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_shadow_word_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_elite_7_2:OnRefresh(params)
	self.tick_interval = self:GetAbilitySpecialValueFor("tick_interval")
	self.regen_reduce = self:GetAbilitySpecialValueFor("regen_reduce")
	if IsServer() then
	end
end
function modifier_elite_7_2:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Warlock.ShadowWord")
	end
end
function modifier_elite_7_2:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(hParent, self:GetAbility(), self:GetAbility():GetAbilityDamage())
end
function modifier_elite_7_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET
	}
end
function modifier_elite_7_2:GetModifierHPRegenAmplify_Percentage()
	return -self.regen_reduce
end
function modifier_elite_7_2:GetModifierHealAmplify_PercentageTarget()
	return -self.regen_reduce
end