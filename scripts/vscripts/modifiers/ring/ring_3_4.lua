---@class ring_3_4: eom_modifier 石化凝视
ring_3_4 = eom_modifier({
	Name = "ring_3_4",
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
function ring_3_3:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -50,
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
function ring_3_4:OnTakeDamage(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function ring_3_4:EOM_GetModifierBaseStats_All_Percentage()
	return self:GetStackCount()
end
function ring_3_4:GetTexture()
	return "item_ring_secret"
end