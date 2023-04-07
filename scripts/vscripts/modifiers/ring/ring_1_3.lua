---@class ring_1_3: eom_modifier 魔龙之心
ring_1_3 = eom_modifier({
	Name = "ring_1_3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE = 100,
		EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE = 100,
	}
end
function ring_1_3:GetTexture()
	return "item_ring_secret"
end