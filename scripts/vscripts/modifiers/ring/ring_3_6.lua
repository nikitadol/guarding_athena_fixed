---@class ring_3_6: eom_modifier 暗夜魔王
ring_3_6 = eom_modifier({
	Name = "ring_3_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	IsIndependent = true,
	StackDuration = 10
})
function ring_3_6:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function ring_3_6:OnValidAbilityExecuted(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function ring_3_6:EOM_GetModifierBaseStats_All_Percentage()
	return self:GetStackCount() * 15
end
function ring_3_6:EOM_GetModifierPercentageCooldown()
	return self:GetStackCount() * 5
end
function ring_3_6:GetTexture()
	return "item_ring_secret"
end