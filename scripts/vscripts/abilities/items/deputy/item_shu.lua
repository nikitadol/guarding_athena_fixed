---@class item_shu_1: eom_ability 书
item_shu_1 = class({})
function item_shu_1:GetIntrinsicModifierName()
	return "modifier_shu"
end
---@class item_shu_2: eom_ability 书
item_shu_2 = class({}, nil, item_shu_1)
---@class item_shu_3: eom_ability 书
item_shu_3 = class({}, nil, item_shu_1)
---@class item_shu_4: eom_ability 书
item_shu_4 = class({}, nil, item_shu_1)
---@class item_shu_5: eom_ability 书
item_shu_5 = class({}, nil, item_shu_1)
function item_shu_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shu_active", { duration = self:GetSpecialValueFor("duration") })
	self:GetCaster():EmitSound("Blink_Layer.Arcane")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_shu_active : eom_modifier
modifier_shu_active = eom_modifier({
	Name = "modifier_shu_active",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_shu_active:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shu_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
end
function modifier_shu_active:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_shu_active:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_shu_active:EOM_GetModifierBonusStats_Strength()
	if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		return self:GetParent():GetBaseStrength() * 0.5
	end
end
function modifier_shu_active:EOM_GetModifierBonusStats_Agility()
	if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		return self:GetParent():GetBaseAgility() * 0.5
	end
end
function modifier_shu_active:EOM_GetModifierBonusStats_Intellect()
	if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		return self:GetParent():GetBaseIntellect() * 0.5
	end
end