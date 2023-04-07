---@class roshan_stun: eom_ability
roshan_stun = eom_ability({})
function roshan_stun:GetIntrinsicModifierName()
	return "modifier_roshan_stun"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_roshan_stun : eom_modifier
modifier_roshan_stun = eom_modifier({
	Name = "modifier_roshan_stun",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_roshan_stun:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.cooldown = self:GetAbilitySpecialValueFor("cooldown")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_roshan_stun:OnAttackLanded(params)
	if self:GetAbility():IsCooldownReady() and PRD(self, self.chance, "modifier_roshan_stun") then
		self:GetAbility():StartCooldown(self.cooldown)
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_stunned", { duration = self.duration })
	end
end
function modifier_roshan_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed
	}
end
function modifier_roshan_stun:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end