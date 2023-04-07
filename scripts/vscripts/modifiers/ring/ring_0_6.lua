---@class ring_0_6: eom_modifier 长夜
ring_0_6 = eom_modifier({
	Name = "ring_0_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_6:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_6:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT = 1,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 40,
	}
end
function ring_0_6:IsHidden()
	return false
end
function ring_0_6:GetTexture()
	return "item_ring_6"
end