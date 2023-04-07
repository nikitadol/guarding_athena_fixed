---@class ring_1_5: eom_modifier 狂战士
ring_1_5 = eom_modifier({
	Name = "ring_1_5",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_5:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE
	}
end
function ring_1_5:EOM_GetModifierOutgoingDamagePercentage()
	return RemapValClamped(self:GetParent():GetHealthPercent(), 0, 100, 200, 0)
end
function ring_1_5:EOM_GetModifierHealthPercentage()
	return RemapValClamped(self:GetParent():GetHealthPercent(), 0, 100, 100, 0)
end
function ring_1_5:GetTexture()
	return "item_ring_secret"
end