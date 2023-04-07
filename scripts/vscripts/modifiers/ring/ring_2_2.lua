---@class ring_2_2: eom_modifier 破碎的虚荣
ring_2_2 = eom_modifier({
	Name = "ring_2_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_2_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE = 50,
	}
end
function ring_2_2:GetTexture()
	return "item_ring_broken"
end