---@class ring_0_2: eom_modifier 虚荣
ring_0_2 = eom_modifier({
	Name = "ring_0_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE = 25,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 20,
	}
end
function ring_0_2:GetTexture()
	return "item_ring_2"
end