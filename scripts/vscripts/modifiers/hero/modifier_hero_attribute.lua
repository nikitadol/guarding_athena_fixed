modifier_hero_attribute = eom_modifier({})

local public = modifier_hero_attribute

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:IsStunDebuff()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BASE_STR,
		EOM_MODIFIER_PROPERTY_MANA_BASE_INT,
		EOM_MODIFIER_PROPERTY_BASE_MANA_REGEN_CONSTANT_INT,
		-- EOM_MODIFIER_PROPERTY_ARMOR_BASE_STR,
		EOM_MODIFIER_PROPERTY_ARMOR_BASE_AGI,
		-- EOM_MODIFIER_PROPERTY_ARMOR_BASE_INT,
		EOM_MODIFIER_PROPERTY_BASE_HEALTH_REGEN_CONSTANT_STR,
		EOM_MODIFIER_PROPERTY_IGNORE_DAMAGE_AGI,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_STR,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_AGI,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_INT,
		EOM_MODIFIER_PROPERTY_OUTGOING_PHYSICAL_DAMAGE_PERCENTAGE_AGI,
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE_INT,
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE_STR,
	}
end
function public:DeclareFunctions()
	return {
	-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	-- MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	-- MODIFIER_PROPERTY_HEALTH_BONUS,
	-- MODIFIER_PROPERTY_MANA_BONUS
	}
end
function public:EOM_GetModifierHealthBaseStr(params)
	return GetStrength(self:GetParent()) * ATTRIBUTE_STRENGTH_HP
end
function public:EOM_GetModifierManaBaseInt(params)
	return GetIntellect(self:GetParent()) * ATTRIBUTE_INTELLECT_MANA
end
function public:EOM_GetModifierConstantBaseManaRegenInt(params)
	return GetIntellect(self:GetParent()) * ATTRIBUTE_INTELLECT_MANA_REGEN
end
-- function public:EOM_GetModifierArmorBaseStr(params)
-- 	return GetStrength(self:GetParent()) * ATTRIBUTE_STRENGTH_ARMOR
-- end
-- function public:EOM_GetModifierArmorBaseAgi(params)
-- 	return GetAgility(self:GetParent()) * ATTRIBUTE_AGILITY_ARMOR
-- end
-- function public:EOM_GetModifierArmorBaseInt(params)
-- 	return GetIntellect(self:GetParent()) * ATTRIBUTE_INTELLECT_ARMOR
-- end
function public:EOM_GetModifierConstantBaseHealthRegenStr(params)
	return GetStrength(self:GetParent()) * ATTRIBUTE_STRENGTH_HP_REGEN
end
function public:EOM_GetModifierIgnoreDamageAgi(params)
	return GetStrength(self:GetParent()) * ATTRIBUTE_AGILITY_IGNORE_DAMAGE
end
function public:EOM_GetModifierAttackDamageBaseStr(params)
	return GetStrength(self:GetParent()) * ATTRIBUTE_STRENGTH_ATTACK_DAMAGE
end
function public:EOM_GetModifierAttackDamageBaseAgi(params)
	return GetAgility(self:GetParent()) * ATTRIBUTE_AGILITY_ATTACK_DAMAGE
end
function public:EOM_GetModifierAttackDamageBaseInt(params)
	return GetIntellect(self:GetParent()) * ATTRIBUTE_INTELLECT_ATTACK_DAMAGE
end
function public:EOM_GetModifierOutgoingPhysicalDamagePercentageAgi(params)
	return GetAgility(self:GetParent()) * ATTRIBUTE_AGILITY_PHYSICAL_DAMAGE_PERCENT
end
function public:EOM_GetModifierOutgoingMagicalDamagePercentageInt(params)
	return GetIntellect(self:GetParent()) * ATTRIBUTE_INTELLECT_MAGICAL_DAMAGE_PERCENT
end
function public:EOM_GetModifierIncomingDamagePercentageStr(params)
	return math.min(60, GetStrength(self:GetParent()) * ATTRIBUTE_STRENGTH_DAMAGE_REDUCTION)
end