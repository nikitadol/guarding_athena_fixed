if DialogEvents == nil then
	---@module DialogEvents
	DialogEvents = class({})
end
local public = DialogEvents

function public:init(bReload)
	if not bReload then
		self.tPlayerDialogEventsData = {}
	end
	---@type {event_name:string, func:function}[]
	self.tListener = {}

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	CustomUIEvent("on_dialog_events_activate", Dynamic_Wrap(public, "OnDialogEventsActivate"), public)
end

function public:UpdateNetTables(iPlayerID)
	if iPlayerID ~= nil then
		CustomNetTables:SetTableValue("dialog_events", tostring(iPlayerID), self.tPlayerDialogEventsData[iPlayerID])
	else
		for iPlayerID, tData in ipairs(self.tPlayerDialogEventsData) do
			CustomNetTables:SetTableValue("dialog_events", tostring(iPlayerID), tData)
		end
	end
end

---注册
---@overload fun(sDialogEventName: string, func: function):number
---@param sDialogEventName number
---@param func function
---@param context table
---@return number
function public:Register(sDialogEventName, func, context)
	return table.insert(self.tListener, {
		event_name = sDialogEventName,
		func = function(...)
			if context ~= nil then
				return func(context, ...)
			end
			return func(...)
		end,
	})
end

function public:Unregister(index)
	return table.remove(self.tListener, index) ~= nil
end

function public:FireEvent(iPlayerID, sDialogEventName)
	for i = 1, #self.tListener, 1 do
		local tData = self.tListener[i]
		if type(tData) == "table" then
			if tData.event_name == sDialogEventName then
				if tData.func({
					PlayerID = iPlayerID,
					dialog_event_name = sDialogEventName,
				}) == false then
					return false
				end
			end
		end
	end
	return true
end
---修改数据
function public:SetPlayerDialogEventsData(iPlayerID, sDialogEventName, sKey, value)
	if type(self.tPlayerDialogEventsData[iPlayerID]) == "table" then
		if type(self.tPlayerDialogEventsData[iPlayerID][sDialogEventName]) ~= "table" then
			self.tPlayerDialogEventsData[iPlayerID][sDialogEventName] = {}
		end
		self.tPlayerDialogEventsData[iPlayerID][sDialogEventName][sKey] = value
		self:UpdateNetTables(iPlayerID)
	end
end
---获取数据
function public:GetPlayerDialogEventsData(iPlayerID, sDialogEventName, sKey)
	if type(self.tPlayerDialogEventsData[iPlayerID]) == "table" and type(self.tPlayerDialogEventsData[iPlayerID][sDialogEventName]) == "table" and self.tPlayerDialogEventsData[iPlayerID][sDialogEventName][sKey] ~= nil then
		return self.tPlayerDialogEventsData[iPlayerID][sDialogEventName][sKey]
	end
	if type(KeyValues) == "table" and type(KeyValues.DialogEventsKV[sDialogEventName]) == "table" then
		return KeyValues.DialogEventsKV[sDialogEventName][sKey]
	end
end

function public:IsValidDialogEvent(iPlayerID, sDialogEventName)
	if type(KeyValues) == "table" and type(KeyValues.DialogEventsKV[sDialogEventName]) == "table" then
		return true
	end
	if type(self.tPlayerDialogEventsData[iPlayerID]) == "table" and type(self.tPlayerDialogEventsData[iPlayerID][sDialogEventName]) == "table" then
		return true
	end
	return false
end

--[[	UI事件
]]
--
function public:OnDialogEventsActivate(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local sDialogEventName = tEvents.dialog_event_name
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	if GameRules:IsGamePaused() then
		ErrorMessage(iPlayerID, "dota_hud_error_game_is_paused")
		return
	end
	if not self:IsValidDialogEvent(iPlayerID, sDialogEventName) then
		return
	end
	if tonumber(self:GetPlayerDialogEventsData(iPlayerID, sDialogEventName, "Disabled")) == 1 then
		return
	end
	local iGoldCost = math.floor(default(tonumber(self:GetPlayerDialogEventsData(iPlayerID, sDialogEventName, "GoldCost")), 0))
	if PlayerData:GetGold(iPlayerID) < iGoldCost then
		ErrorMessage(iPlayerID, "dota_hud_error_not_enough_gold")
		return
	end
	local iCrystalCost = math.floor(default(tonumber(self:GetPlayerDialogEventsData(iPlayerID, sDialogEventName, "CrystalCost")), 0))
	if PlayerData:GetCrystal(iPlayerID) < iCrystalCost then
		ErrorMessage(iPlayerID, "error_not_enough_crystal")
		return
	end
	local iScoreCost = math.floor(default(tonumber(self:GetPlayerDialogEventsData(iPlayerID, sDialogEventName, "ScoreCost")), 0))
	if PlayerData:GetScore(iPlayerID) < iScoreCost then
		ErrorMessage(iPlayerID, "error_not_enough_score")
		return
	end
	-- local iAttributeCost = default(tonumber(tKV.AttributeCost), 0)
	-- if not IsValid(hHero) or hHero:GetBaseStrength() < iAttributeCost or hHero:GetBaseAgility() < iAttributeCost or hHero:GetBaseIntellect() < iAttributeCost then
	-- 	ErrorMessage(iPlayerID, "error_not_enough_attribute")
	-- 	return
	-- end
	if self:FireEvent(iPlayerID, sDialogEventName) == true then
		PlayerData:ModifyGold(iPlayerID, -iGoldCost)
		PlayerData:ModifyCrystal(iPlayerID, -iCrystalCost)
		PlayerData:ModifyScore(iPlayerID, -iScoreCost)
		-- hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_STRENGTH, -iAttributeCost)
		-- hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_AGILITY, -iAttributeCost)
		-- hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_INTELLECT, -iAttributeCost)
	end
end
--[[	监听

]]
--
function public:OnGameRulesStateChange()
	local iState = GameRules:State_Get()
	if iState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		Game:EachPlayer(function(iPlayerID, iTeamNumber, n)
			self.tPlayerDialogEventsData[iPlayerID] = {}
		end)
	end
end
return public