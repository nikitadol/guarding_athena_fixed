---@class ring_1_1: eom_modifier 破碎的晨辉
ring_1_1 = eom_modifier({
	Name = "ring_1_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_1:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 12,
		EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE = 12,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 60,
	}
end
function ring_1_1:GetTexture()
	return "item_ring_broken"
end