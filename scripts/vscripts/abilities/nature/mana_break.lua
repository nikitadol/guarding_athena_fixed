---@class mana_break: eom_ability
mana_break = eom_ability({})
function mana_break:GetIntrinsicModifierName()
	return "modifier_mana_break"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_mana_break : eom_modifier
modifier_mana_break = eom_modifier({
	Name = "modifier_mana_break",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_mana_break:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.mana = self:GetAbilitySpecialValueFor("mana")
end
function modifier_mana_break:OnAttackLanded(params)
	if PRD(self, self.chance, "modifier_mana_break") then
		local hParent = self:GetParent()
		local hTarget = params.target
		hTarget:SpendMana(hTarget:GetMaxMana() * self.mana * 0.01, self:GetAbility())
	end
end
function modifier_mana_break:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end