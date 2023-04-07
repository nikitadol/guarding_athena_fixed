if Items == nil then
	---@module Items
	---@field tGroundItems table 记录地上的物品
	---@field vPlayerEquipment table 玩家练功房的装备掉落位置
	---@field vPlayerAbilityBook table 玩家练功房的技能书掉落位置
	---@field vPlayerDevour table 玩家练功房的神佑宝石掉落位置
	---@field tCastingInfo table 每局随机的铸造物品
	---@field iGridSize number 每个网格大小
	Items = class({})
end
local public = Items

function public:init(bReload)
	self.iGridSize = 48
	if not bReload then
		self.tGroundItems = {}
		self.vPlayerEquipment = {}
		self.vPlayerAbilityBook = {}
		self.vPlayerDevour = {}
		self.tCastingInfo = {}
		self.tPlayerDevourCount = 16
		---随机的铸造物品
		---@type CWeightPool
		local tPools = Game.hPools["item_equipment_level_5"]:Copy()
		for sItemName, tData in pairs(KeyValues.ItemsKv) do
			if type(tData) == "table" and tData.CustomItemType and _G[tData.CustomItemType] == CUSTOM_ITEM_TYPE_CASTING then
				self.tCastingInfo[sItemName] = {}
				for i = 1, 2 do
					local _sItemName = tPools:Random()
					table.insert(self.tCastingInfo[sItemName], _sItemName)
					tPools:Remove(_sItemName)
				end
			end
		end
		CustomNetTables:SetTableValue("common", "casting_info", self.tCastingInfo)
	end

	GameEvent("custom_inventory_contents_changed", Dynamic_Wrap(public, "OnInventoryChanged"), public)
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)

	CustomUIEvent("casting_item", Dynamic_Wrap(public, "OnCastingItem"), public)
end

---掉落物品（会自动按网格摆放）
---@param iPlayerID number 玩家ID
---@param sItemName string | CDOTA_Item 物品名或者物品
function public:DropItem(iPlayerID, sItemName, vPosition)
	self:ClearGroundItems()
	-- TODO:是否掉落到练功房接入
	if true then
		local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		local hItem = type(sItemName) == "string" and CreateItem(sItemName, nil, hHero) or sItemName
		if IsValid(hItem) then
			local vClearPosition = Items:FindClearGridPosition(vPosition)
			local hItemPhysical = CreateItemOnPosition(vClearPosition, hItem)
			Items.tGroundItems[VectorToString(vClearPosition)] = hItemPhysical
			return hItemPhysical
		end
	else
		return self:DropItemOnTrainingRoom(iPlayerID, hItem)
	end
end

---尝试添加物品
---@param hUnit CDOTA_BaseNPC
---@param hItem CDOTA_Item
function public:TryGiveItem(hUnit, hItem)
	if not IsValid(hItem) then
		return false
	end
	local sAbilityName = hItem:GetAbilityName()
	local iCustomItemType = self:GetCustomType(sAbilityName)
	-- 不允许佩戴重复装备
	if iCustomItemType == CUSTOM_ITEM_TYPE_MAIN_WEAPON and self:HasTypeItemInInventory(hUnit, iCustomItemType) then
		ErrorMessage(hUnit:GetPlayerOwnerID(), "error_not_repeat_item_main_weapon")
		-- local hContainer = hItem:GetContainer()
		-- if IsValid(hContainer) then
		-- 	hContainer:Remove()
		-- end
		return false
	end
	if iCustomItemType == CUSTOM_ITEM_TYPE_DEPUTY and self:HasTypeItemInInventory(hUnit, iCustomItemType) then
		ErrorMessage(hUnit:GetPlayerOwnerID(), "error_not_repeat_item_deputy")
		-- local hContainer = hItem:GetContainer()
		-- if IsValid(hContainer) then
		-- 	hContainer:Remove()
		-- end
		return false
	end
	-- 戒指
	if sAbilityName == "item_ring_shop" then
		local iHour = GetDayTime()
		for iRingIndex = 1, 6 do
			local flTimeStart = KeyValues:GetItemSpecialFor("item_ring_" .. iRingIndex, "time_start")
			local flTimeEnd = KeyValues:GetItemSpecialFor("item_ring_" .. iRingIndex, "time_end")
			if iHour >= tonumber(flTimeStart) and iHour < tonumber(flTimeEnd) then
				local hRing = CreateItem("item_ring_" .. iRingIndex, nil, hUnit)
				if not Items:TryGiveItem(hUnit, hRing) then
					Items:DropItem(hUnit:GetPlayerOwnerID(), hRing, hUnit:GetAbsOrigin())
				end
				-- PlayerData:AddRing(hUnit:GetPlayerOwnerID(), iRingIndex)
				local hContainer = hItem:GetContainer()
				if IsValid(hContainer) then
					hContainer:Remove()
				end
				hItem:Remove()
				return true
			end
		end
	end
	if string.sub(sAbilityName, 0, 10) == "item_ring_" then
		local iRingIndex = tonumber(string.sub(sAbilityName, 11, 12))
		PlayerData:AddRing(hUnit:GetPlayerOwnerID(), iRingIndex)
	end
	----------------------------------------特殊处理----------------------------------------
	-- 吞噬主武器
	-- if iCustomItemType == CUSTOM_ITEM_TYPE_MAIN_WEAPON then
	-- 	if not self:IsDevouredItemType(hUnit, CUSTOM_ITEM_TYPE_MAIN_WEAPON) then
	-- 		hUnit:AddItem(hItem)
	-- 		self:DevourItem(hUnit, hItem)
	-- 		return true
	-- 	end
	-- end
	-- 吞噬护甲
	-- if iCustomItemType == CUSTOM_ITEM_TYPE_ARMOR then
	-- end
	-- 吞噬副手
	-- if iCustomItemType == CUSTOM_ITEM_TYPE_DEPUTY then
	-- 	hUnit:AddItem(hItem)
	-- 	self:DevourItem(hUnit, hItem)
	-- 	return true
	-- end
	-- 药水包
	if hItem:GetAbilityName() == "item_salve1_pack" then
		local hPotion = CreateItem("item_salve1", nil, hUnit)
		hPotion:SetCurrentCharges(hItem:GetSpecialValueFor("count"))
		hPotion:SetPurchaseTime(hPotion:GetPurchaseTime() - 10)
		hUnit:AddItem(hPotion)
		local hContainer = hItem:GetContainer()
		if IsValid(hContainer) then
			hContainer:Remove()
		end
		hItem:Remove()
		return true
	end
	if hItem:GetAbilityName() == "item_clarity1_pack" then
		local hPotion = CreateItem("item_clarity1", nil, hUnit)
		hPotion:SetCurrentCharges(hItem:GetSpecialValueFor("count"))
		hPotion:SetPurchaseTime(hPotion:GetPurchaseTime() - 10)
		hUnit:AddItem(hPotion)
		local hContainer = hItem:GetContainer()
		if IsValid(hContainer) then
			hContainer:Remove()
		end
		hItem:Remove()
		return true
	end
	-- 属性书
	if iCustomItemType == CUSTOM_ITEM_TYPE_ATTRIBUTE_BOOK then
		hUnit:AddPermanentAttribute(_G[hItem:GetSpecialAddedValueFor("value", "type")], hItem:GetSpecialValueFor("value"))
		hUnit:AddItem(hItem)
		local hContainer = hItem:GetContainer()
		if IsValid(hContainer) then
			hContainer:Remove()
		end
		hUnit:EmitSound("Item.MoonShard.Consume")
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", PATTACH_ABSORIGIN, hUnit)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hItem:Remove()
		return true
	end
	----------------------------------------End----------------------------------------
	local hParent = hItem:GetParent()
	if hItem:GetPurchaser() == nil then
		hItem:SetPurchaser(hUnit)
	end
	local hContainer = hItem:GetContainer()
	local hNewItem = hUnit:AddItem(hItem)
	if hNewItem ~= nil then
		if IsValid(hContainer) then
			hContainer:Remove()
		end
		if IsValid(hParent) then
			hParent:TakeItem(hNewItem)
			hUnit:TakeItem(hNewItem)
			hUnit:AddItem(hNewItem)
		end
		return true
	end
	return false
end

---吞噬物品
---@param hUnit CDOTA_BaseNPC
---@param hItem CDOTA_Item
function public:DevourItem(hUnit, hItem)
	if hUnit._tDevourItems == nil then hUnit._tDevourItems = {} end
	local bDevoured = false
	local iDevouredEquipmentCount = 0
	local iDevouredCastingCount = 0
	for i, v in ipairs(hUnit._tDevourItems) do
		if self:GetCustomType(v:GetAbilityName()) == CUSTOM_ITEM_TYPE_EQUIPMENT then
			iDevouredEquipmentCount = iDevouredEquipmentCount + 1
		end
		if self:GetCustomType(v:GetAbilityName()) == CUSTOM_ITEM_TYPE_CASTING then
			iDevouredCastingCount = iDevouredCastingCount + 1
		end
		if v:GetAbilityName() == hItem:GetAbilityName() then
			bDevoured = true
		end
	end
	if self:GetCustomType(hItem:GetAbilityName()) == CUSTOM_ITEM_TYPE_EQUIPMENT and iDevouredEquipmentCount >= GetMaxEquipmentDevourCount(hUnit) then
		return false
	end
	if self:GetCustomType(hItem:GetAbilityName()) == CUSTOM_ITEM_TYPE_CASTING and iDevouredCastingCount >= GetMaxCastingDevourCount(hUnit) then
		return false
	end
	if bDevoured then
		return false
	end
	local hContainer = hItem:GetContainer()
	if IsValid(hContainer) then
		hContainer:Remove()
	end
	local hParent = hItem:GetParent()
	if IsValid(hParent) then
		hParent:TakeItem(hItem)
	end
	hUnit:AddNewModifier(hUnit, hItem, hItem:GetIntrinsicModifierName(), nil)
	table.insert(hUnit._tDevourItems, hItem)
	hUnit:CalculateItemProperties()
	Notification:Combat({
		message = "Combat_DevourItem",
		player_id = hUnit:GetPlayerOwnerID(),
		string_itemname = hItem:GetAbilityName()
	})
	FireModifierEvent(MODIFIER_EVENT_ON_ITEM_DEVOURED, {
		item = hItem,
		unit = hUnit,
	}, hUnit, nil)
	if hItem.OnDevoured then
		hItem:OnDevoured(hUnit)
	end
	self:_UpdateNetTable(hUnit)
	return true
end

---掉落物品到练功房，只接受有CustomItemType键值的物品（会自动按网格摆放）
---@param iPlayerID number 玩家ID
---@param sItemName string | CDOTA_Item 物品名或者物品
---@param bClearInvalidGrid boolean 是否调用ClearInvalidGrid，默认调用
function public:DropItemOnTrainingRoom(iPlayerID, sItemName, bClearInvalidGrid)
	local tIndex = {
		[CUSTOM_ITEM_TYPE_ABILITY_BOOK] = self.vPlayerAbilityBook[iPlayerID],
		[CUSTOM_ITEM_TYPE_EQUIPMENT] = self.vPlayerEquipment[iPlayerID],
		[CUSTOM_ITEM_TYPE_DEVOUR] = self.vPlayerDevour[iPlayerID],
	}
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local hItem = type(sItemName) == "string" and CreateItem(sItemName, nil, hHero) or sItemName
	local vDropCenter = default(tIndex[self:GetCustomType(hItem:GetAbilityName())], self.vPlayerDevour[iPlayerID])
	local vPosition = self:FindClearGridPosition(vDropCenter, 19, bClearInvalidGrid)
	local hPhysicalItem = CreateItemOnPosition(vPosition, hItem)
	self.tGroundItems[VectorToString(vPosition)] = hPhysicalItem
	return hPhysicalItem
end
---移动物品到练功房，只接受有CustomItemType键值的物品（会自动按网格摆放）
---@param iPlayerID number 玩家ID
---@param hItem CDOTA_Item 物品名或者物品
---@param bClearInvalidGrid boolean 是否调用ClearInvalidGrid，默认调用
function public:MoveItemToTrainingRoom(iPlayerID, hItem, bClearInvalidGrid)
	local tIndex = {
		[CUSTOM_ITEM_TYPE_ABILITY_BOOK] = self.vPlayerAbilityBook[iPlayerID],
		[CUSTOM_ITEM_TYPE_EQUIPMENT] = self.vPlayerEquipment[iPlayerID],
		[CUSTOM_ITEM_TYPE_DEVOUR] = self.vPlayerDevour[iPlayerID],
	}
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local vDropCenter = default(tIndex[self:GetCustomType(hItem:GetAbilityName())], self.vPlayerDevour[iPlayerID])
	local vPosition = self:FindClearGridPosition(vDropCenter, 19, bClearInvalidGrid)
	hItem:GetContainer():SetAbsOrigin(GetGroundPosition(vPosition, hItem:GetContainer()))
	self.tGroundItems[VectorToString(vPosition)] = hItem:GetContainer()
	return hItem
end
---清理地上的物品位置信息
function public:ClearGroundItems()
	for sVector, hItem in pairs(self.tGroundItems) do
		local vPosition = StringToVector(sVector)
		if not IsValid(hItem) or hItem:GetAbsOrigin().x ~= vPosition.x or hItem:GetAbsOrigin().y ~= vPosition.y then
			self.tGroundItems[sVector] = nil
		end
	end
end
--------------------------------------------------------------------------------
-- Get
--------------------------------------------------------------------------------
---是否是技能书
function public:IsAbilityBookType(sItemName)
	return _G[KeyValues.ItemsKv[sItemName].CustomItemType] == CUSTOM_ITEM_TYPE_ABILITY_BOOK
end
---是否是装备
function public:IsEquipmentType(sItemName)
	return _G[KeyValues.ItemsKv[sItemName].CustomItemType] == CUSTOM_ITEM_TYPE_EQUIPMENT
end
---获取物品类型
function public:GetCustomType(sItemName)
	return _G[KeyValues.ItemsKv[sItemName].CustomItemType]
end
---获取所有吞噬的物品
---@return table<number,CDOTA_Item>
function public:GetDevourItems(hUnit)
	if hUnit._tDevourItems == nil then
		hUnit._tDevourItems = {}
	end
	return hUnit._tDevourItems
end
---获取吞噬的物品
---@return table<number,CDOTA_Item>
function public:GetDevourItem(hUnit, sItemName)
	if hUnit._tDevourItems == nil then
		hUnit._tDevourItems = {}
	end
	for i, v in ipairs(hUnit._tDevourItems) do
		if v:GetAbilityName() == sItemName then
			return v
		end
	end
	return false
end
---获取最近的Grid坐标
function public:GetGridNearest(vPosition)
	local iX = Round(vPosition.x, 0)
	local iY = Round(vPosition.y, 0)
	local vGrid = Vector(0, 0, 128)
	local fXMod = math.abs(iX) % self.iGridSize
	local fYMod = math.abs(iY) % self.iGridSize
	vGrid.x = (math.abs(iX + fXMod) % self.iGridSize == 0) and iX + fXMod or iX - fXMod
	vGrid.y = (math.abs(iY + fYMod) % self.iGridSize == 0) and iY + fYMod or iY - fYMod
	return vGrid
end
---寻找空的Grid坐标
---@param vCenter Vector 终点
---@param iOffect number 寻找尺寸，默认100
---@param bClearInvalidGrid boolean 是否调用ClearInvalidGrid，默认调用
function public:FindClearGridPosition(vCenter, iOffect, bClearInvalidGrid)
	bClearInvalidGrid = default(bClearInvalidGrid, true)
	if bClearInvalidGrid then
		self:ClearGroundItems()
	end
	vCenter = self:GetGridNearest(vCenter)
	iOffect = default(iOffect, 100)
	local tOrder = { { 0, 1 }, { 1, 1 }, { 1, 0 }, { 1, -1 }, { 0, -1 }, {-1, -1 }, {-1, 0 }, {-1, 1 } }
	for iOffect = 0, iOffect do
		for iIndex, tOrderData in ipairs(tOrder) do
			local iX = iOffect * tOrderData[1]
			local iY = iOffect * tOrderData[2]
			local tNextOrderData = tOrder[iIndex + 1] or tOrder[1]
			local iNextX = tNextOrderData and (iOffect * tNextOrderData[1]) or iX
			local iNextY = tNextOrderData and (iOffect * tNextOrderData[2]) or iY
			for i = iX, iNextX, (iNextX > iX and 1 or -1) do
				for j = iY, iNextY, (iNextY > iY and 1 or -1) do
					local vPosition = vCenter + Vector(i * self.iGridSize, j * self.iGridSize, 0)
					vPosition.z = 128
					if self.tGroundItems[VectorToString(vPosition)] == nil then
						return vPosition
					end
				end
			end
		end
	end
	ErrorMsg("没有找到有效的位置！")
end
---获取稀有度
---@param sItemName string | CDOTA_Item 物品名或者物品
function public:GetRarity(sItemName)
	sItemName = type(sItemName) == "string" and sItemName or sItemName:GetItemName()
	return tostring(KeyValues.ItemsKv[sItemName].Rarity) or tostring(KeyValues.AbilitiesKv[sItemName].Rarity)
end
---是否吞噬物品
---@param hUnit CDOTA_BaseNPC
---@param sItemName string
function public:IsDevouredItem(hUnit, sItemName)
	if hUnit._tDevourItems == nil then hUnit._tDevourItems = {} end
	for i, v in ipairs(hUnit._tDevourItems) do
		if v:GetAbilityName() == sItemName then
			return true
		end
	end
	return false
end
---是否吞噬某种物品
---@param hUnit CDOTA_BaseNPC
---@param iCustomItemType number
function public:IsDevouredItemType(hUnit, iCustomItemType)
	if hUnit._tDevourItems == nil then hUnit._tDevourItems = {} end
	for i, v in ipairs(hUnit._tDevourItems) do
		if self:GetCustomType(v:GetAbilityName()) == iCustomItemType then
			return true
		end
	end
	return false
end
function public:HasTypeItemInInventory(hUnit, iCustomItemType)
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
		local hItem = hUnit:GetItemInSlot(i)
		if IsValid(hItem) and self:GetCustomType(hItem:GetAbilityName()) == iCustomItemType then
			return true
		end
	end
	return false
end
---@private
function public:_UpdateNetTable(hUnit)
	local tList = {}
	if hUnit._tDevourItems == nil then hUnit._tDevourItems = {} end
	for i, v in ipairs(hUnit._tDevourItems) do
		table.insert(tList, v:entindex())
	end
	CustomNetTables:SetTableValue("devoured_list", tostring(hUnit:entindex()), tList)
end
--[[	UI事件
]]
---铸造ui事件
function public:OnCastingItem(iEventSourceIndex, tEvents)
	if IsClient() then return end
	local iPlayerID = tEvents.PlayerID
	local hItem = EntIndexToHScript(tEvents.item_ent_index or -1)
	local sCastingName = tEvents.casting_name
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local hParent = hItem:GetParent()
	local bSuccess = false
	local iCastingCost = default(KeyValues.ItemsKv[sCastingName].CastingCrystalCost, 3500)
	if PlayerData:GetCrystal(iPlayerID) < iCastingCost then
		ErrorMessage(iPlayerID, "error_not_enough_crystal")
		return
	end
	for i, v in ipairs(self.tCastingInfo[sCastingName]) do
		if v == hItem:GetAbilityName() then
			bSuccess = true
		end
	end
	if IsValid(hParent) and bSuccess then
		PlayerData:ModifyCrystal(iPlayerID, -iCastingCost)
		hParent:TakeItem(hItem)
		local hCastingItem = CreateItem(sCastingName, nil, hHero)
		Items:DevourItem(hHero, hCastingItem)
		hItem:Remove()
		self.tCastingInfo[sCastingName] = {}
		CustomNetTables:SetTableValue("common", "casting_info", self.tCastingInfo)
	end
end
--[[	监听
]]
function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Game:EachPlayer(function(iPlayerID, iTeamNumber, n)
			local vPosition = TRAINING_ORIGIN[n]
			-- 记录物品掉落位置
			self.vPlayerEquipment[iPlayerID] = vPosition + Vector(480, 0, 0)
			self.vPlayerAbilityBook[iPlayerID] = vPosition - Vector(480, 0, 0)
			self.vPlayerDevour[iPlayerID] = vPosition + Vector(0, -400, 0)
		end)
	end
end
---物品栏变化事件
function public:OnInventoryChanged(tEvents)
	local hUnit = EntIndexToHScript(tEvents.EntityIndex)
	local iEventType = tonumber(tEvents.EventType)
	local iDropItemIndex = tonumber(tEvents.DropItemIndex)
	local iPickItemIndex = tonumber(tEvents.PickItemIndex)
	if iEventType == CUSTOM_INVENTORY_CHANGE_LOSE then
	elseif iEventType == CUSTOM_INVENTORY_CHANGE_RECEIVE then
	end
end

return public