---@class modifier_original_health_bar:eom_modifier
modifier_original_health_bar = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false
})
function modifier_original_health_bar:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_original_health_bar:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = false
	}
end
function modifier_original_health_bar:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end