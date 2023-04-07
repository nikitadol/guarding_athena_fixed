---@class ring_3_5: eom_modifier 圣魔纹章
ring_3_5 = eom_modifier({
	Name = "ring_3_5",
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
function ring_3_5:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_CHANCE = 50,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_CHANCE = 50,
		EOM_MODIFIER_PROPERTY_PHYSICAL_CRITICALSTRIKE_DAMAGE = 200,
		EOM_MODIFIER_PROPERTY_MAGICAL_CRITICALSTRIKE_DAMAGE = 200,
		MODIFIER_EVENT_ON_CRITICAL = { self:GetParent() }
	}
end
function ring_3_5:OnCritical(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function ring_3_5:EOM_GetModifierBaseStats_All_Percentage()
	return self:GetStackCount()
end
function ring_3_5:GetTexture()
	return "item_ring_secret"
end