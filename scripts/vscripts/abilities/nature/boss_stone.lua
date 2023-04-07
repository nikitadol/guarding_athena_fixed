---@class boss_stone: eom_ability
boss_stone = eom_ability({})
function boss_stone:GetIntrinsicModifierName()
	return "modifier_boss_stone"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_stone : eom_modifier
modifier_boss_stone = eom_modifier({
	Name = "modifier_boss_stone",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_stone:GetAbilitySpecialValue()
	self.magical_reduce = self:GetAbilitySpecialValueFor("magical_reduce")
end
function modifier_boss_stone:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE = -self.magical_reduce
	}
end