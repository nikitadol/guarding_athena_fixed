if Selection == nil then
	---@module Selection
	Selection = class({})
end
local public = Selection

function public:init(bReload)
	if not bReload then
		self.tSelectionData = {}

		---@class SelectionCommon
		---@field type string 类型
		---@field src string 图片路径
		---@field title string 标题
		---@field description string 描述
		---@field callback function 回调
	end
	CustomUIEvent("selection_confirm", Dynamic_Wrap(public, "OnConfirmSelection"), public)
end

---@private
function public:UpdateNetTables(iPlayerID)
	if iPlayerID then
		CustomNetTables:SetTableValue("selection", tostring(iPlayerID), self.tSelectionData[iPlayerID])
	else
		Game:EachPlayer(function(iPlayerID)
			CustomNetTables:SetTableValue("selection", tostring(iPlayerID), self.tSelectionData[iPlayerID])
		end)
	end
end

---添加一个通用选择，选项的标题、描述和图标路径都可以定义
---@param iPlayerID number
---@param tSelection table<string,SelectionCommon>
function public:AddCommonSelection(iPlayerID, tSelection)
	if self.tSelectionData[iPlayerID] == nil then
		self.tSelectionData[iPlayerID] = {}
	end
	for i, v in ipairs(tSelection) do
		if v.type == nil then
			tSelection[i].type = "common"
		end
	end
	table.insert(self.tSelectionData[iPlayerID], tSelection)
	self:UpdateNetTables(iPlayerID)
end
---添加一个技能选择，传入技能名的数组即可
---@param iPlayerID number
---@param tSelection string[] 技能名字数组
function public:AddAbilitySelection(iPlayerID, tSelection)
	local tTempSelection = {}
	for i, v in ipairs(tSelection) do
		tTempSelection[v] = {
			type = "ability",
			title = v
		}
	end
	self:AddCommonSelection(iPlayerID, tTempSelection)
end
---添加一个物品选择，传入物品名的数组即可
---@param iPlayerID number
---@param tSelection string[] 物品名字数组
function public:AddItemSelection(iPlayerID, tSelection)
	local tTempSelection = {}
	for i, v in ipairs(tSelection) do
		tTempSelection[v] = {
			type = "item",
			title = v
		}
	end
	self:AddCommonSelection(iPlayerID, tTempSelection)
end
--------------------------------------------------------------------------------
-- UI事件
--------------------------------------------------------------------------------
function public:OnConfirmSelection(iEventSourceIndex, tEvents)
	if IsClient() then return end
	local iPlayerID = tEvents.PlayerID
	local name = tEvents.name
	local tPlayerData = self.tSelectionData[iPlayerID]
	if tPlayerData and tPlayerData[1] and tPlayerData[1][name] and tPlayerData[1][name].callback then
		tPlayerData[1][name].callback()
		table.remove(tPlayerData, 1)
	end
	self:UpdateNetTables(iPlayerID)
end
return public