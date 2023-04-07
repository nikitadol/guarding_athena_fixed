---@class modifier_npc:eom_modifier
modifier_npc = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})

local public = modifier_npc

function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
	}
end