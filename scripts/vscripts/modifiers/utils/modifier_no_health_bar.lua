---@class modifier_no_health_bar:eom_modifier
modifier_no_health_bar = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_no_health_bar:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end