---@class alien_split: eom_ability
alien_split = eom_ability({})
function alien_split:GetIntrinsicModifierName()
	return "modifier_alien_split"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_split : eom_modifier
modifier_alien_split = eom_modifier({
	Name = "modifier_alien_split",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_split:GetAbilitySpecialValue()
	self.count = self:GetAbilitySpecialValueFor("count")
end
function modifier_alien_split:OnDeath(params)
	local hParent = self:GetParent()
	local sUnitName = "alien_enigma_split"
	if hParent:GetUnitName() == "alien_enigma" then
		sUnitName = "alien_enigma_small"
	end
	for i = 1, self.count do
		local hUnit = hParent:SummonUnit(sUnitName, hParent:GetAbsOrigin(), false, 60)
		hUnit:KnockBack(RandomVector(1), 300, 200, 1)
	end
end
function modifier_alien_split:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end