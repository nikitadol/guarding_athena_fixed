---@class alien_growth: eom_ability
alien_growth = eom_ability({})
function alien_growth:GetIntrinsicModifierName()
	return "modifier_alien_growth"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_growth : eom_modifier
modifier_alien_growth = eom_modifier({
	Name = "modifier_alien_growth",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_growth:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_alien_growth:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.duration)
	end
end
function modifier_alien_growth:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		local sUnitName = "alien_enigma_small"
		if hParent:GetUnitName() == "alien_enigma_small" then
			local sUnitName = "alien_enigma"
		end
		hParent:ForceKill(false)
		CreateUnitByNameWithNewData(sUnitName, hParent:GetAbsOrigin(), true, nil, nil, ENEMY_TEAM, {})
	end
end