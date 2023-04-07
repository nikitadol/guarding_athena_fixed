---@class ring_2_5: eom_modifier 破环死光
ring_2_5 = eom_modifier({
	Name = "ring_2_5",
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
function ring_2_5:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE
	}
end
function ring_2_5:OnAttackLanded(t)
	if IsServer() then
		local hParent = self:GetParent()
		PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), 36 * Rounds:GetRoundNumber())
		self:IncrementStackCount()
	end
end
function ring_2_5:EOM_GetModifierOutgoingDamagePercentage()
	return self:GetStackCount() * 2
end
function ring_2_5:GetTexture()
	return "item_ring_secret"
end