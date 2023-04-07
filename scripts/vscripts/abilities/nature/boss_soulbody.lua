---@class boss_soulbody: eom_ability
boss_soulbody = eom_ability({})
function boss_soulbody:GetIntrinsicModifierName()
	return "modifier_boss_soulbody"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_soulbody : eom_modifier
modifier_boss_soulbody = eom_modifier({
	Name = "modifier_boss_soulbody",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_soulbody:GetAbilitySpecialValue()
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
end
function modifier_boss_soulbody:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = -self.damage_pct,
		EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE = self.damage_pct,
	}
end