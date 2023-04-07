---@class wolf_invisible: eom_ability
wolf_invisible = eom_ability({})
function wolf_invisible:GetIntrinsicModifierName()
	return "modifier_wolf_invisible"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wolf_invisible : eom_modifier
modifier_wolf_invisible = eom_modifier({
	Name = "modifier_wolf_invisible",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wolf_invisible:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_wolf_invisible_buff", nil)
	end
end
function modifier_wolf_invisible:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wolf_invisible:OnAttackLanded(params)
	local hParent = self:GetParent()
	hParent:RemoveModifierByName("modifier_wolf_invisible_buff")
	self:StartIntervalThink(1.2)
end
function modifier_wolf_invisible:OnIntervalThink()
	local hParent = self:GetParent()
	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_wolf_invisible_buff", nil)
	self:StartIntervalThink(-1)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wolf_invisible_buff : eom_modifier
modifier_wolf_invisible_buff = eom_modifier({
	Name = "modifier_wolf_invisible_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wolf_invisible_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end
function modifier_wolf_invisible_buff:GetModifierInvisibilityLevel()
	return RemapValClamped(self:GetElapsedTime(), 0, 0.3, 0, 1)
end
function modifier_wolf_invisible_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = self:GetModifierInvisibilityLevel() >= 1
	}
end