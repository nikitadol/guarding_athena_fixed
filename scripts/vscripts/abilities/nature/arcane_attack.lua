---@class arcane_attack: eom_ability
arcane_attack = eom_ability({})
function arcane_attack:GetIntrinsicModifierName()
	return "modifier_arcane_attack"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_arcane_attack : eom_modifier
modifier_arcane_attack = eom_modifier({
	Name = "modifier_arcane_attack",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_arcane_attack:GetAbilitySpecialValue()
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_arcane_attack:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hTarget = params.target
	local hAbility = self:GetAbility()
	hTarget:AddNewModifier(hParent, hAbility, "modifier_arcane_attack_debuff", { duration = 10 })
end
function modifier_arcane_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.bonus_attack_speed or 0
	}
end
function modifier_arcane_attack:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_arcane_attack:EOM_GetModifierOutgoingDamagePercentage(params)
	if IsServer() and params and params.target then
		return (params.target:GetRebornTimes()) * 100
	end
end
function modifier_arcane_attack:EOM_GetModifierIncomingDamagePercentage(params)
	if IsServer() and params and params.attacker then
		return -(params.attacker:GetRebornTimes()) * 20
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_arcane_attack_debuff : eom_modifier
modifier_arcane_attack_debuff = eom_modifier({
	Name = "modifier_arcane_attack_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	IsIndependent = true
})
function modifier_arcane_attack_debuff:GetAbilitySpecialValue()
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
end
function modifier_arcane_attack_debuff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_arcane_attack_debuff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_arcane_attack_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self:GetStackCount() * self:GetParent():GetRebornTimes() * self.bonus_damage
	}
end