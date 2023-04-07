---@class ring_3_3: eom_modifier 破碎的恶魔之血
ring_3_3 = eom_modifier({
	Name = "ring_3_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_3_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE = 20,
	}
end
function ring_3_3:GetTexture()
	return "item_ring_3"
end
function ring_3_3:GetTexture()
	return "item_ring_broken"
end