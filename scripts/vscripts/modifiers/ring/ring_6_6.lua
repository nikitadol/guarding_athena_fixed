---@class ring_6_6: eom_modifier 长夜
ring_6_6 = eom_modifier({
	Name = "ring_6_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_6_6:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT = 2,
	}
end
function ring_6_6:GetTexture()
	return "item_ring_6"
end
function ring_6_6:GetTexture()
	return "item_ring_broken"
end