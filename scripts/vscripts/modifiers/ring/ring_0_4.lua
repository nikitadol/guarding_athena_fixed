---@class ring_0_4: eom_modifier 石化
ring_0_4 = eom_modifier({
	Name = "ring_0_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_4:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -10,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 60,
	}
end
function ring_0_4:GetTexture()
	return "item_ring_4"
end