---@class ring_0_3: eom_modifier 魔血
ring_0_3 = eom_modifier({
	Name = "ring_0_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE = 10,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 40,
	}
end
function ring_0_3:GetTexture()
	return "item_ring_3"
end