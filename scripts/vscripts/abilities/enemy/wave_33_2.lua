---@class wave_33_2: eom_ability
wave_33_2 = eom_ability({})
function wave_33_2:GetIntrinsicModifierName()
	return "modifier_wave_33_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_33_2 : eom_modifier
modifier_wave_33_2 = eom_modifier({
	Name = "modifier_wave_33_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_33_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_33_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_wave_33_2_debuff", { duration = self:GetAbility():GetDuration() })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_33_2_debuff : eom_modifier
modifier_wave_33_2_debuff = eom_modifier({
	Name = "modifier_wave_33_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_33_2_debuff:GetAbilitySpecialValue()
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
end
function modifier_wave_33_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.armor_reduce
	}
end