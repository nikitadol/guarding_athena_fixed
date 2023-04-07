---@class privilege_4 : PrivilegeBaseClass 可以召唤傀儡木偶进行挖宝
privilege_4 = class({}, nil, PrivilegeBaseClass)

local public = privilege_4

function public:OnCreated(params)
	local hCaster = self:GetCaster()
	local iPlayerID = self:GetPlayerID()
	local vCenter = Vector(3838, 4217, 255)
	self.hMiner = CreateUnitByName("npc_miner", vCenter, true, hCaster, hCaster, DOTA_TEAM_GOODGUYS)
	-- self.hMiner:SetControllableByPlayer(iPlayerID, false)
	self.hMiner:GameTimer(1, function()
		if self.hMiner:IsIdle() and self.hMiner:GetCurrentActiveAbility() == nil then
			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
				local hItem = self.hMiner:GetItemInSlot(i)
				if IsValid(hItem) and string.find(hItem:GetAbilityName(), "item_treasure_map") then
					ExecuteOrder(self.hMiner, DOTA_UNIT_ORDER_CAST_NO_TARGET, hItem)
					break
				end
			end
		end
		return 1
	end)
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	self.hMiner:Remove()
end

return public