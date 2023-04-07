---@class privilege_5 : PrivilegeBaseClass 第N波开始（支持配置出生即获得）时获得物品（如吞噬丹）/物品池中随机（如随机SS装备）
privilege_5 = class({}, nil, PrivilegeBaseClass)

local public = privilege_5

function public:OnCreated(params)
	self.iListenerID = GameEvent("custom_round_state_change", Dynamic_Wrap(self, "OnRoundStateChange"), self)
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	if self.iListenerID then
		StopGameEvent(self.iListenerID)
		self.iListenerID = nil
	end
end
function public:OnRoundStateChange(tEvents)
	if tEvents.round_state == ROUND_STATE_START and tEvents.round_number == self:GetSpecialValueFor("round") then
		local hCaster = self:GetCaster()
		local sItemName = Game:GetRandomItemNameByName(self:GetSpecialValueFor("name"), self:GetPlayerID())
		local hItem = CreateItem(sItemName, nil, hCaster)
		if not Items:TryGiveItem(hCaster, hItem) then
			Items:DropItemOnTrainingRoom(self:GetPlayerID(), hItem)
		end
	end
end

return public