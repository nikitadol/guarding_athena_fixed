---@class ring_0_5: eom_modifier 瞳术
ring_0_5 = eom_modifier({
	Name = "ring_0_5",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_5:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = 10,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 80,
	}
end
function ring_0_5:GetTexture()
	return "item_ring_5"
end