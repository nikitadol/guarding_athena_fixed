---@class ring_1_6: eom_modifier 辉夜
ring_1_6 = eom_modifier({
	Name = "ring_1_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_6:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function ring_1_6:EOM_GetModifierPercentageCooldown(params)
	if params and params.ability and PRD(self, 50, "ring_1_6") then
		local hParent = self:GetParent()
		hParent:Heal(hParent:GetCustomMaxHealth() * 0.2, nil)
		hParent:GiveMana(hParent:GetMaxMana() * 0.2)
		return 50
	end
end
function ring_1_6:GetTexture()
	return "item_ring_secret"
end