---@class ring_0_1: eom_modifier 晨辉
ring_0_1 = eom_modifier({
	Name = "ring_0_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_0_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ring_0_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 6,
		EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE = 6,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 60,
	}
end
function ring_0_1:GetTexture()
	return "item_ring_1"
end