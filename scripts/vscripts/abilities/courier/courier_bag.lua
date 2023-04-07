courier_bag = class({})
function courier_bag:Spawn()
	self.tItemBag = {}
end
function courier_bag:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()

	local tItemTable = {}
	for iSlot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) then
			tItemTable[tostring(iSlot)] = hCaster:TakeItem(hItem)
		end
	end
	for sSlot, hItem in pairs(self.tItemBag) do
		if IsValid(hItem) then
			hCaster:AddItem(hItem)
			if hItem:GetItemSlot() ~= tonumber(sSlot) then
				hCaster:SwapItems(tonumber(sSlot), hItem:GetItemSlot())
			end
		end
	end
	self.tItemBag = tItemTable
end