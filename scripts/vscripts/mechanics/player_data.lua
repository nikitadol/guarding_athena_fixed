if PlayerData == nil then
	---玩家游戏数据模块
	---@module PlayerData
	PlayerData = class({})

	---@class PlayerInfo 玩家数据结构
	---@field iGold number 金钱
	---@field iCrystal number 魂晶
	---@field iScore number 荣誉
	---@field tRing table 戒指
end

local public = PlayerData

function public:init(bReload)
	if not bReload then
		---@type table<number, PlayerInfo>
		self.tPlayerData = {}
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	CustomUIEvent("sell_item", Dynamic_Wrap(public, "OnItemSell"), public)
	CustomUIEvent("item_purchase", Dynamic_Wrap(public, "OnItemPurchase"), public)
	if GameRules:IsCheatMode() then
	end
end

-- 金钱
function public:ModifyGold(iPlayerID, iGoldChange)
	self:SetGold(iPlayerID, self:GetGold(iPlayerID) + iGoldChange)
end
function public:SetGold(iPlayerID, iGold)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return
	end
	self.tPlayerData[iPlayerID].iGold = iGold
	self:UpdateNetTables(iPlayerID)
end
function public:GetGold(iPlayerID)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return 0
	end
	return self.tPlayerData[iPlayerID].iGold or 0
end

-- 魂晶
function public:ModifyCrystal(iPlayerID, iCrystalChange)
	self:SetCrystal(iPlayerID, self:GetCrystal(iPlayerID) + iCrystalChange)
end
function public:SetCrystal(iPlayerID, iCrystal)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return
	end
	self.tPlayerData[iPlayerID].iCrystal = iCrystal
	self:UpdateNetTables(iPlayerID)
end
function public:GetCrystal(iPlayerID)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return
	end
	return self.tPlayerData[iPlayerID].iCrystal or 0
end

-- 荣誉
function public:ModifyScore(iPlayerID, iScoreChange)
	self:SetScore(iPlayerID, self:GetScore(iPlayerID) + iScoreChange)
end
function public:SetScore(iPlayerID, iScore)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return
	end
	self.tPlayerData[iPlayerID].iScore = iScore
	self:UpdateNetTables(iPlayerID)
end
function public:GetScore(iPlayerID)
	if type(self.tPlayerData[iPlayerID]) ~= "table" then
		return
	end
	return self.tPlayerData[iPlayerID].iScore or 0
end

-- 戒指
function public:AddRing(iPlayerID, iRingIndex)
	table.insert(self.tPlayerData[iPlayerID].tRing, iRingIndex)
	while #self.tPlayerData[iPlayerID].tRing > 2 do
		table.remove(self.tPlayerData[iPlayerID].tRing, 1)
	end
	print("AddRing")
	PrintTable(self.tPlayerData[iPlayerID].tRing)
end
function public:GetRingData(iPlayerID)
	return self.tPlayerData[iPlayerID].tRing
end

function public:UpdateNetTables(iPlayerID)
	if iPlayerID ~= nil then
		local s = "PlayerDataUpdateNetTables" .. iPlayerID .. "_" .. GetFrameCount()
		if self.tPlayerData[iPlayerID][s] == nil then
			self.tPlayerData[iPlayerID][s] = true
			Timer(s, 0, function()
				self.tPlayerData[iPlayerID][s] = nil
				CustomNetTables:SetTableValue("player_data", tostring(iPlayerID), self.tPlayerData[iPlayerID])
			end)
		end
	else
		for iPlayerID, tData in ipairs(self.tPlayerData) do
			local s = "PlayerDataUpdateNetTables" .. iPlayerID .. "_" .. GetFrameCount()
			if tData[s] == nil then
				tData[s] = true
				Timer(s, 0, function()
					self.tPlayerData[iPlayerID][s] = nil
					CustomNetTables:SetTableValue("player_data", tostring(iPlayerID), self.tPlayerData[iPlayerID])
				end)
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------
function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Game:EachPlayer(function(iPlayerID)
			self.tPlayerData[iPlayerID] = {
				iGold = 0,
				iCrystal = 0,
				iScore = 0,
				tRing = {}
			}
			self:UpdateNetTables(iPlayerID)
		end)
	end
end
-------------------------------------------------------------------------------------------------------------
function public:OnItemSell(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local hItem = EntIndexToHScript(tEvents.item_ent_index)
	if IsValid(hItem) then
		SendOverheadEventMessage(PlayerResource:GetPlayer(iPlayerID), OVERHEAD_ALERT_GOLD, hHero, hItem:GetCost(), hHero:GetPlayerOwner())
		PlayerData:ModifyGold(iPlayerID, hItem:GetCost())
		hItem:Remove()
	end
end
function public:OnItemPurchase(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local hUnit = EntIndexToHScript(tEvents.unit)
	if not IsValid(hUnit) then
		hUnit = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	end
	-- local hUnit = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local sItemName = tEvents.itemname
	if tEvents.crystal_cost and tEvents.crystal_cost > 0 then
		local iGold = PlayerData:GetCrystal(iPlayerID)
		local iGoldCost = tEvents.crystal_cost
		if iGold >= iGoldCost then
			PlayerData:ModifyCrystal(iPlayerID, -iGoldCost)
			local hItem = CreateItem(sItemName, nil, hUnit)
			if not Items:TryGiveItem(hUnit, hItem) then
				Items:DropItem(iPlayerID, hItem, hUnit:GetAbsOrigin())
			end
		end
	elseif tEvents.score_cost and tEvents.score_cost > 0 then
		local iGold = PlayerData:GetScore(iPlayerID)
		local iGoldCost = tEvents.score_cost
		if iGold >= iGoldCost then
			PlayerData:ModifyScore(iPlayerID, -iGoldCost)
			local hItem = CreateItem(sItemName, nil, hUnit)
			if not Items:TryGiveItem(hUnit, hItem) then
				Items:DropItem(iPlayerID, hItem, hUnit:GetAbsOrigin())
			end
		end
	else
		local iGold = PlayerData:GetGold(iPlayerID)
		local iGoldCost = tEvents.gold_cost
		local bFull = true
		for k, v in pairs(tEvents.item_requirement) do
			if KeyValues.ItemsKv[v].ItemPurchasable ~= nil and KeyValues.ItemsKv[v].ItemPurchasable == 0 then
				local hItem = hUnit:FindItemInInventory(v)
				if not IsValid(hItem) then
					bFull = false
					break
				end
			end
		end
		if iGold >= iGoldCost and bFull then
			PlayerData:ModifyGold(iPlayerID, -iGoldCost)
			for k, v in pairs(tEvents.item_accessories) do
				local hItem = hUnit:FindItemInInventory(v)
				if IsValid(hItem) then
					hUnit:TakeItem(hItem)
					hItem:Remove()
				end
			end
			local hItem = CreateItem(sItemName, nil, hUnit)
			if not Items:TryGiveItem(hUnit, hItem) then
				Items:DropItem(iPlayerID, hItem, hUnit:GetAbsOrigin())
			end
		else
			ErrorMessage(iPlayerID, "DOTA_Shop_Item_Error_Cant_Purchase")
		end
	end
end

return public