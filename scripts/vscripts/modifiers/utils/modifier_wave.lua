---@class modifier_wave:eom_modifier
modifier_wave = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_wave:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_wave:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = false
	}
end
function modifier_wave:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end