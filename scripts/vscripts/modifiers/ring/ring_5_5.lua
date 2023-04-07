---@class ring_5_5: eom_modifier 破碎的瞳术
ring_5_5 = eom_modifier({
	Name = "ring_5_5",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_5_5:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = 20,
	}
end
function ring_5_5:GetTexture()
	return "item_ring_5"
end
function ring_5_5:GetTexture()
	return "item_ring_broken"
end