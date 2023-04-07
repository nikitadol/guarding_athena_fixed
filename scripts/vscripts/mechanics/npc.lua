if NPC == nil then
	---@module NPC
	NPC = class({})
end
local public = NPC

function public:init(bReload)
	if not bReload then
		self.tNPCs = {}
	end
end

function public:UpdateNetTables(iUnitEntIndex)
	if iUnitEntIndex ~= nil then
		local tData = self.tNPCs[iUnitEntIndex]
		if type(tData) == "table" then
			CustomNetTables:SetTableValue("npc", tostring(iUnitEntIndex), tData)
		end
	else
		for iUnitEntIndex, tData in pairs(self.tNPCs) do
			CustomNetTables:SetTableValue("npc", tostring(iUnitEntIndex), tData)
		end
	end
end

function public:CreateNPC(sUnitName, vLocation, iPlayerID)
	local hNPC = CreateUnitByNameWithNewData(sUnitName, vLocation, false, nil, nil, PlayerResource:GetTeam(iPlayerID), {
		CustomStatusHealth = 1000
	})
	-- local hNPC = CreateUnitByName(sUnitName, vLocation, false, nil, nil, PlayerResource:GetTeam(iPlayerID))
	if IsValid(hNPC) then
		hNPC:SetControllableByPlayer(iPlayerID, false)

		hNPC:AddNewModifier(hNPC, nil, "modifier_npc", nil)

		local sNPCDialogEvents = tostring(KeyValues:GetUnitData(hNPC, "NPCDialogEvents") or "")
		sNPCDialogEvents = string.gsub(sNPCDialogEvents, "%s", "")
		self.tNPCs[hNPC:entindex()] = {
			iPlayerID = iPlayerID,
			tDialogEvents = string.split(sNPCDialogEvents, ","),
			sPosition = VectorToString(vLocation),
			sUnitName = sUnitName
		}

		self:UpdateNetTables(hNPC:entindex())
		return hNPC
	end
end

function public:EachDialogEvent(hNPC, func)
	if type(hNPC) ~= "table" or type(hNPC.entindex) ~= "function" or type(func) ~= "function" then
		return
	end
	if IsValid(hNPC) and hNPC:HasModifier("modifier_npc") then
		local iUnitEntIndex = hNPC:entindex()
		if type(self.tNPCs[iUnitEntIndex].tDialogEvents) == "table" then
			for i = 1, #self.tNPCs[iUnitEntIndex].tDialogEvents, 1 do
				if func(self.tNPCs[iUnitEntIndex].tDialogEvents[i]) == true then
					return
				end
			end
		end
	end
end

-- 判断是否拥有按钮事件
function public:HasDialogEvent(hNPC, sDialogEventName)
	local b = false
	self:EachDialogEvent(hNPC, function(_sDialogEventName)
		if _sDialogEventName == sDialogEventName then
			b = true
			return true
		end
	end)
	return b
end

---替换按钮事件
function public:ReplaceDialogEvent(hNPC, sOldDialogEventName, sNewDialogEventName)
	if type(hNPC) ~= "table" or type(hNPC.entindex) ~= "function" then
		return
	end
	if IsValid(hNPC) and hNPC:HasModifier("modifier_npc") then
		local iUnitEntIndex = hNPC:entindex()
		if type(self.tNPCs[iUnitEntIndex].tDialogEvents) == "table" then
			local index = TableFindKey(self.tNPCs[iUnitEntIndex].tDialogEvents, sOldDialogEventName)
			if index ~= nil then
				self.tNPCs[iUnitEntIndex].tDialogEvents[index] = sNewDialogEventName
				self:UpdateNetTables(iUnitEntIndex)
			end
		end
	end
end
---替换按钮事件
function public:AddDialogEvent(hNPC, sDialogEventName)
	if type(hNPC) ~= "table" or type(hNPC.entindex) ~= "function" then
		return
	end
	if IsValid(hNPC) and hNPC:HasModifier("modifier_npc") then
		local iUnitEntIndex = hNPC:entindex()
		if type(self.tNPCs[iUnitEntIndex].tDialogEvents) ~= "table" then
			self.tNPCs[iUnitEntIndex].tDialogEvents = {}
		end
		table.insert(self.tNPCs[iUnitEntIndex].tDialogEvents, sDialogEventName)
		self:UpdateNetTables(iUnitEntIndex)
	end
end
function public:RemoveDialogEvent(hNPC, sDialogEventName)
	if type(hNPC) ~= "table" or type(hNPC.entindex) ~= "function" then
		return
	end
	if IsValid(hNPC) and hNPC:HasModifier("modifier_npc") then
		local iUnitEntIndex = hNPC:entindex()
		if type(self.tNPCs[iUnitEntIndex].tDialogEvents) == "table" then
			ArrayRemove(self.tNPCs[iUnitEntIndex].tDialogEvents, sDialogEventName)
			self:UpdateNetTables(iUnitEntIndex)
		end
	end
end
function public:SwapDialogEvent(hNPC, sFirstDialogEventName, sSecondDialogEventName)
	if type(hNPC) ~= "table" or type(hNPC.entindex) ~= "function" then
		return
	end
	if IsValid(hNPC) and hNPC:HasModifier("modifier_npc") then
		local iUnitEntIndex = hNPC:entindex()
		if type(self.tNPCs[iUnitEntIndex].tDialogEvents) == "table" then
			local index1
			local index2
			for i = #self.tNPCs[iUnitEntIndex].tDialogEvents, 1, -1 do
				if index1 == nil and self.tNPCs[iUnitEntIndex].tDialogEvents[i] == sFirstDialogEventName then
					index1 = i
				end
				if index2 == nil and self.tNPCs[iUnitEntIndex].tDialogEvents[i] == sSecondDialogEventName then
					index2 = i
				end
				if index1 ~= nil and index2 ~= nil then
					local sTemp = self.tNPCs[iUnitEntIndex].tDialogEvents[index1]
					self.tNPCs[iUnitEntIndex].tDialogEvents[index1] = self.tNPCs[iUnitEntIndex].tDialogEvents[index2]
					self.tNPCs[iUnitEntIndex].tDialogEvents[index2] = sTemp
					self:UpdateNetTables(iUnitEntIndex)

					return
				end
			end
		end
	end
end

--[[	UI事件
]]
--
--[[	监听
]]
--
return public