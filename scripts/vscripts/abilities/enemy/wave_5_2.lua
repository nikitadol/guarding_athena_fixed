---@class wave_5_2: eom_ability
wave_5_2 = eom_ability({})
function wave_5_2:GetIntrinsicModifierName()
	return "modifier_wave_5_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_5_2 : eom_modifier
modifier_wave_5_2 = eom_modifier({
	Name = "modifier_wave_5_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_5_2:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_wave_5_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_5_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_wave_5_2_debuff", { duration = self:GetAbility():GetDuration() })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_5_2_debuff : eom_modifier
modifier_wave_5_2_debuff = eom_modifier({
	Name = "modifier_wave_5_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_5_2_debuff:GetAbilitySpecialValue()
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_wave_5_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_wave_5_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed
end