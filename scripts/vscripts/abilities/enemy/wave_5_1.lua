---@class wave_5_1: eom_ability
wave_5_1 = eom_ability({})
function wave_5_1:GetIntrinsicModifierName()
	return "modifier_wave_5_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_5_1 : eom_modifier
modifier_wave_5_1 = eom_modifier({
	Name = "modifier_wave_5_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_5_1:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_wave_5_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
function modifier_wave_5_1:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() and not params.unit:PassivesDisabled() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
			local flHealAmount = hParent:GetCustomMaxHealth() / #tTargets
			for _, hUnit in pairs(tTargets) do
				if not hUnit:IsFriendly(hParent) then
					hUnit:AddNewModifier(hParent, hAbility, "modifier_wave_5_1_debuff", { duration = self:GetAbility():GetDuration() })
				end
				hUnit:Heal(flHealAmount, hAbility)
				SendOverheadEventMessage(hUnit:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, hUnit, flHealAmount, hParent:GetPlayerOwner())
			end
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_wave_5_1_debuff : eom_modifier
modifier_wave_5_1_debuff = eom_modifier({
	Name = "modifier_wave_5_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_wave_5_1_debuff:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_wave_5_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_wave_5_1_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self.attackspeed
end