---@class demon_chains_1: eom_ability
demon_chains_1 = eom_ability({})
function demon_chains_1:GetIntrinsicModifierName()
	return "modifier_demon_chains_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_1 : eom_modifier
modifier_demon_chains_1 = eom_modifier({
	Name = "modifier_demon_chains_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_demon_chains_1:GetAbilitySpecialValue()
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_demon_chains_1:OnAttackLanded(params)
	local hTarget = params.target
	if hTarget:HasModifier("modifier_item_demon_chains_debuff") or PRD(self, self.chance, "modifier_demon_chains_1") then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hParent:DealDamage(hTarget, hAbility, hParent:GetSummoner():GetPrimaryStats() * self.bonus_damage, DAMAGE_TYPE_MAGICAL)
		hParent:AddNewModifier(hParent, hAbility, "modifier_demon_chains_1_buff", { duration = self.duration })
	end
end
function modifier_demon_chains_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE = 100,
		EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS = self.cleave_radius,
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_demon_chains_1_buff : eom_modifier
modifier_demon_chains_1_buff = eom_modifier({
	Name = "modifier_demon_chains_1_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_demon_chains_1_buff:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_demon_chains_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = 0.1
	}
end