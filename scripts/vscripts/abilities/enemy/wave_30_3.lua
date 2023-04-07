---@class wave_30_3: eom_ability
wave_30_3 = eom_ability({})
function wave_30_3:GetIntrinsicModifierName()
	return "modifier_wave_30_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_30_3 : eom_modifier
modifier_wave_30_3 = eom_modifier({
	Name = "modifier_wave_30_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_30_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
function modifier_wave_30_3:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() and params.attacker ~= nil and not params.unit:PassivesDisabled() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			hParent:DealDamage(params.attacker, hAbility, hAbility:GetAbilityDamage())
		end
	end
end