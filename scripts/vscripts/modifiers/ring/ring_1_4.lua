---@class ring_1_4: eom_modifier 魔纹血钻
ring_1_4 = eom_modifier({
	Name = "ring_1_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_1_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function ring_1_4:GetModifierAvoidDamage()
	if PRD(self, 15, "ring_1_4") then
		local hParent = self:GetParent()
		hParent:GiveHealth(hParent:GetCustomMaxHealth() * 0.2)
	end
end
function ring_1_4:GetTexture()
	return "item_ring_secret"
end