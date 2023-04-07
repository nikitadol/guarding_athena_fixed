---@class elite_30_2: eom_ability
elite_30_2 = eom_ability({})
function elite_30_2:GetIntrinsicModifierName()
	return "modifier_elite_30_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_30_2 : eom_modifier
modifier_elite_30_2 = eom_modifier({
	Name = "modifier_elite_30_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_30_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_elite_30_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_elite_30_2_debuff", { duration = self:GetAbility():GetDuration() })
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_30_2_debuff : eom_modifier
modifier_elite_30_2_debuff = eom_modifier({
	Name = "modifier_elite_30_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_30_2_debuff:OnCreated(params)
	self.health_reduce = self:GetAbilitySpecialValueFor("health_reduce")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_elite_30_2_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		self:GetParent():CalculateStatBonus(true)
	end
end
function modifier_elite_30_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS
	}
end
function modifier_elite_30_2_debuff:EOM_GetModifierHealthBonus()
	return -self.health_reduce * self:GetStackCount()
end