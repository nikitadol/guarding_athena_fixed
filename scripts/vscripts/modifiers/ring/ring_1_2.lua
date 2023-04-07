---@class ring_1_2: eom_modifier 荣光
ring_1_2 = eom_modifier({
	Name = "ring_1_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
	}
end
function ring_1_2:OnAttackLanded(t)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:Heal(hParent:GetCustomMaxHealth() * 0.08, nil)
		hParent:GiveMana(hParent:GetMaxMana() * 0.08)
		PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), 36 * Rounds:GetRoundNumber())
	end
end
function ring_1_2:GetTexture()
	return "item_ring_secret"
end