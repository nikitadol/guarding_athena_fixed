---@class ring_2_3: eom_modifier 贪魔
ring_2_3 = eom_modifier({
	Name = "ring_2_3",
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
function ring_2_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE
	}
end
function ring_2_3:OnAttackLanded(t)
	if IsServer() then
		local hParent = self:GetParent()
		PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), 36 * Rounds:GetRoundNumber())
		self:IncrementStackCount()
	end
end
function ring_2_3:EOM_GetModifierBaseStats_All_Percentage()
	return self:GetStackCount() * 2
end
function ring_2_3:GetTexture()
	return "item_ring_secret"
end