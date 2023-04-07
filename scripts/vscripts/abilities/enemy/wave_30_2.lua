---@class wave_30_2: eom_ability
wave_30_2 = eom_ability({})
function wave_30_2:GetIntrinsicModifierName()
	return "modifier_wave_30_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_30_2 : eom_modifier
modifier_wave_30_2 = eom_modifier({
	Name = "modifier_wave_30_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_30_2:GetAbilitySpecialValue()
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_wave_30_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_wave_30_2:GetModifierMoveSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return math.floor((100 - self:GetParent():GetHealthPercent()) / self.trigger_pct) * self.movespeed
	end
end
function modifier_wave_30_2:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return math.floor((100 - self:GetParent():GetHealthPercent()) / self.trigger_pct) * self.attackspeed
	end
end