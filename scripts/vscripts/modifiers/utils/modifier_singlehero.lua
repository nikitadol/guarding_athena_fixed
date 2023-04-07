---@class modifier_singlehero:eom_modifier
modifier_singlehero = eom_modifier({
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_singlehero:GetTexture()
	return "bloodseeker_thirst"
end
function modifier_singlehero:OnDestroy()
	if IsServer() then
	end
end
function modifier_singlehero:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = 20,
	}
end
function modifier_singlehero:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS = 20,
		EOM_MODIFIER_PROPERTY_PLAYER_KILL_GOLD_PERCENTAGE = 15,
		EOM_MODIFIER_PROPERTY_PLAYER_EXPERIENCE_GAIN_PERCENTAGE = 15

	}
end