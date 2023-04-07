---@class item_exp_fruit: eom_ability
item_exp_fruit = class({})
function item_exp_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local iLevel = default(NeutralSpawners:GetLevel("boss_clotho"), 1)
	hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_EXPERIENCE, 10 * self:GetCurrentCharges())
	local iAttributeType
	if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		iAttributeType = CUSTOM_ATTRIBUTE_STRENGTH
	elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		iAttributeType = CUSTOM_ATTRIBUTE_AGILITY
	elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		iAttributeType = CUSTOM_ATTRIBUTE_INTELLECT
	end
	hHero:AddPermanentAttribute(iAttributeType, RandomInt(iLevel, iLevel * 5) * self:GetCurrentCharges())
	self:Destroy()
end