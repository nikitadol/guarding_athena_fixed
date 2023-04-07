---@class item_ogre_2: eom_ability
item_ogre_2 = class({})
function item_ogre_2:GetIntrinsicModifierName()
	return "modifier_item_ogre_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_ogre_2 : eom_modifier
modifier_item_ogre_2 = eom_modifier({
	Name = "modifier_item_ogre_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_ogre_2:OnCreated(params)
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
end
function modifier_item_ogre_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end
function modifier_item_ogre_2:GetModifierHealthBonus(params)
	return self.bonus_health
end