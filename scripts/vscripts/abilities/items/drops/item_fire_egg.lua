---@class item_fire_egg: eom_ability
item_fire_egg = eom_ability({})
function item_fire_egg:OnSpellStart()
	local iPlayerID = self:GetCaster():GetOwner():GetPlayerID()
	local hCaster = self:GetCaster()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local bHasEssence = false
	for iSlot = 0, 5 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) and string.find(hItem:GetAbilityName(), "item_essence") and hItem:GetLevel() < 15 then
			if RollPercentage(50) then
				hItem:AddCharges(self:GetSpecialValueFor("charges"))
				bHasEssence = true
			end
			break
		end
	end
	if bHasEssence == false then
		local iValue = RandomInt(self:GetSpecialValueFor("max_attribute"), self:GetSpecialValueFor("min_attribute"))
		if hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
			hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, iValue)
		elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
			hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_AGILITY, iValue)
		elseif hHero:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
			hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT, iValue)
		end
		hHero:EmitSound("DOTA_Item.Refresher.Activate")
	end
	self:Destroy()
end