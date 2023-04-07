---@class ring_2_4: eom_modifier 极光屏障
ring_2_4 = eom_modifier({
	Name = "ring_2_4",
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
function ring_2_4:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function ring_2_4:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), 36 * Rounds:GetRoundNumber())
		self:IncrementStackCount()
	end
end
function ring_2_4:EOM_GetModifierIncomingDamagePercentage()
	return -math.min(self:GetStackCount(), 99)
end
function ring_2_4:GetTexture()
	return "item_ring_secret"
end