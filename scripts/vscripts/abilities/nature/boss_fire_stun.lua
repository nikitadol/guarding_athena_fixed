---@class boss_fire_stun: eom_ability
boss_fire_stun = eom_ability({})
function boss_fire_stun:GetIntrinsicModifierName()
	return "modifier_boss_fire_stun"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_fire_stun : eom_modifier
modifier_boss_fire_stun = eom_modifier({
	Name = "modifier_boss_fire_stun",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_fire_stun:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.heal = self:GetAbilitySpecialValueFor("heal")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_boss_fire_stun:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = params.target
	if PRD(self, self.chance, "modifier_boss_fire_stun") then
		hTarget:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.duration })
		hParent:DealDamage(hTarget, hAbility, self.damage)
		hParent:Heal(self.heal, hAbility)
	end
	hParent:Heal(1000, hAbility)
end
function modifier_boss_fire_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 100
	}
end
function modifier_boss_fire_stun:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 1
	}
end