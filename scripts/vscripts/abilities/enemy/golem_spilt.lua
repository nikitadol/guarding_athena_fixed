---@class golem_spilt: eom_ability
golem_spilt = eom_ability({})
function golem_spilt:GetIntrinsicModifierName()
	return "modifier_golem_spilt"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_golem_spilt : eom_modifier
modifier_golem_spilt = eom_modifier({
	Name = "modifier_golem_spilt",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_golem_spilt:OnDeath(params)
	local hParent = self:GetParent()
	for i = 1, 2 do
		local hUnit = hParent:SummonUnit("wave_11", hParent:GetAbsOrigin(), false, 60)
		hUnit:AddNewModifier(hParent, nil, "modifier_original_health_bar", {})
		hUnit:KnockBack(RandomVector(1), 300, 200, 1)
	end
end
function modifier_golem_spilt:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end