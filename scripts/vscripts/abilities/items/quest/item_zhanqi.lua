---@class item_zhanqi: eom_ability
item_zhanqi = class({})
function item_zhanqi:GetIntrinsicModifierName()
	return "modifier_item_zhanqi"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_zhanqi : eom_modifier
modifier_item_zhanqi = eom_modifier({
	Name = "modifier_item_zhanqi",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_item_zhanqi:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_zhanqi_buff : eom_modifier
modifier_item_zhanqi_buff = eom_modifier({
	Name = "modifier_item_zhanqi_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_item_zhanqi_buff:GetAbilitySpecialValue()
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_item_zhanqi_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.bonus_attack_speed or 0
	}
end
function modifier_item_zhanqi_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.bonus_attack
	}
end