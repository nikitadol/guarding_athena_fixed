---@class item_blood_fruit: eom_ability
item_blood_fruit = class({})
function item_blood_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local iLevel = default(NeutralSpawners:GetLevel("boss_clotho"), 1)
	local iAttributeType
	if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		iAttributeType = CUSTOM_ATTRIBUTE_STRENGTH
	elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		iAttributeType = CUSTOM_ATTRIBUTE_AGILITY
	elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		iAttributeType = CUSTOM_ATTRIBUTE_INTELLECT
	end
	hHero:AddPermanentAttribute(iAttributeType, RandomInt(iLevel, iLevel * 5) * self:GetCurrentCharges())
	hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH_GAIN, self:GetCurrentCharges())
	hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_AGILITY_GAIN, self:GetCurrentCharges())
	hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT_GAIN, self:GetCurrentCharges())
	self:Destroy()
end