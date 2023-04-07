---@class wave_30_1: eom_ability
wave_30_1 = eom_ability({})
function wave_30_1:GetIntrinsicModifierName()
	return "modifier_wave_30_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_30_1 : eom_modifier
modifier_wave_30_1 = eom_modifier({
	Name = "modifier_wave_30_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_30_1:OnCreated(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
end
function modifier_wave_30_1:OnRefresh(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
end
function modifier_wave_30_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_wave_30_1:OnAttackLanded(params)
	if params.target == nil then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		local flDamage = params.target:GetCustomMaxHealth() * self.percent * 0.01
		params.attacker:Heal(flDamage, self:GetAbility())
		params.attacker:DealDamage(params.target, self:GetAbility(), flDamage, DAMAGE_TYPE_PURE)
	end
end