---@class golem_skin: eom_ability
golem_skin = eom_ability({})
function golem_skin:GetIntrinsicModifierName()
	return "modifier_golem_skin"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_golem_skin : eom_modifier
modifier_golem_skin = eom_modifier({
	Name = "modifier_golem_skin",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_golem_skin:GetAbilitySpecialValue()
	self.mdef = self:GetAbilitySpecialValueFor("mdef")
end
function modifier_golem_skin:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_MAGICAL_DAMAGE_PERCENTAGE = -self.mdef
	}
end