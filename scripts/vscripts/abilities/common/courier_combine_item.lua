---@class courier_combine_item: eom_ability
courier_combine_item = eom_ability({})
function courier_combine_item:GetAOERadius()
	return 200
end
function courier_combine_item:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local tEntities = Entities:FindAllByClassnameWithin("dota_item_drop", vPosition, 200)
	local tPool = {
		[CUSTOM_ITEM_TYPE_EQUIPMENT] = "item_equipment_level_",
		[CUSTOM_ITEM_TYPE_ABILITY_BOOK] = "item_ability_book_level_",
	}
	local tItemRarity = {
		[CUSTOM_ITEM_TYPE_EQUIPMENT] = {
			["0"] = {},
			["1"] = {},
			["2"] = {},
			["3"] = {},
			["4"] = {},
			["5"] = {},
		},
		[CUSTOM_ITEM_TYPE_ABILITY_BOOK] = {
			["0"] = {},
			["1"] = {},
			["2"] = {},
			["3"] = {},
			["4"] = {},
			["5"] = {},
		}
	}
	local tRawItemRarity = {
		[CUSTOM_ITEM_TYPE_EQUIPMENT] = {
			["0"] = 0,
			["1"] = 0,
			["2"] = 0,
			["3"] = 0,
			["4"] = 0,
			["5"] = 0,
		},
		[CUSTOM_ITEM_TYPE_ABILITY_BOOK] = {
			["0"] = 0,
			["1"] = 0,
			["2"] = 0,
			["3"] = 0,
			["4"] = 0,
			["5"] = 0,
		}
	}
	for i, v in ipairs(tEntities) do
		local hItem = tEntities[i]:GetContainedItem()
		if IsValid(hItem) then
			local sRarity = hItem:GetRarity()
			if sRarity then
				local iItemType = Items:GetCustomType(hItem:GetAbilityName())
				if iItemType == CUSTOM_ITEM_TYPE_EQUIPMENT or iItemType == CUSTOM_ITEM_TYPE_ABILITY_BOOK then
					tRawItemRarity[iItemType][sRarity] = tRawItemRarity[iItemType][sRarity] + 1
					table.insert(tItemRarity[iItemType][sRarity], tEntities[i])
				end
			end
		end
	end
	local tCombineItemRarity = deepcopy(tRawItemRarity)
	for iItemType, v in pairs(tCombineItemRarity) do
		for i = 0, 5 do
			local sRarity = tostring(i)
			local iItemCount = tCombineItemRarity[iItemType][sRarity]
			local iCombineCount = math.modf(iItemCount / 3)
			if iCombineCount > 0 and tonumber(sRarity) < 5 then
				tCombineItemRarity[iItemType][sRarity] = iItemCount % 3
				for i = 1, iCombineCount do
					tCombineItemRarity[iItemType][tostring(tonumber(sRarity) + 1)] = tCombineItemRarity[iItemType][tostring(tonumber(sRarity) + 1)] + 1
				end
			end
		end
	end
	for iItemType, tRarityList in pairs(tCombineItemRarity) do
		for sRarity, iItemCount in pairs(tRarityList) do
			local iRawCount = tRawItemRarity[iItemType][sRarity]
			if iItemCount < iRawCount then
				for i = 1, iRawCount - iItemCount do
					local hPhysicalItem = tItemRarity[iItemType][sRarity][i]
					local hItem = hPhysicalItem:GetContainedItem()
					if IsValid(hItem) then
						UTIL_Remove(hItem)
					end
					UTIL_Remove(hPhysicalItem)
				end
			else
				Items:ClearGroundItems()
				for i = 1, iItemCount - iRawCount do
					Items:DropItemOnTrainingRoom(iPlayerID, CreateItem(Game:DrawPool(tPool[iItemType] .. sRarity), hHero, hHero), false)
				end
			end
		end
	end
end