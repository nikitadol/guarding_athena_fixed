---@class courier_drop_item: eom_ability
courier_drop_item = eom_ability({})
function courier_drop_item:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vGridPosition = Items:GetGridNearest(vPosition)
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	if Training:IsPositionInTrainingRoom(iPlayerID, vPosition) then
		-- TODO: 是否自动分类技能书和物品
		Items:ClearGroundItems()
		for iSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local hItem = hCaster:GetItemInSlot(iSlot)
			if IsValid(hItem) then
				hCaster:TakeItem(hItem)
				Items:DropItem(iPlayerID, hItem, vPosition)
			end
		end
	else
		Items:ClearGroundItems()
		for iSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local hItem = hCaster:GetItemInSlot(iSlot)
			if IsValid(hItem) then
				hCaster:TakeItem(hItem)
				Items:DropItem(iPlayerID, hItem, vPosition)
			end
		end
	end
end