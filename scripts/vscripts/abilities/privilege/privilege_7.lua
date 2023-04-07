---@class privilege_7 : PrivilegeBaseClass 修改怪物刷新点
privilege_7 = class({}, nil, PrivilegeBaseClass)

local public = privilege_7

function public:OnCreated(params)
	self.iListenerID = GameEvent("player_chat", Dynamic_Wrap(self, "OnPlayerChat"), self)
	self.bActive = false
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	if self.iListenerID then
		StopGameEvent(self.iListenerID)
		self.iListenerID = nil
	end
	NeutralSpawners:SetSpawnerOverdataData(self:GetSpecialValueFor("unit_name"), self:GetSpecialValueFor("key"), nil)
end

function public:OnPlayerChat(tEvents)
	local iPlayerID = tEvents.playerid
	local sText = string.lower(tEvents.text)
	local bTeamOnly = tEvents.teamonly == 1

	if sText == "-sx" then
		if self.bActive == false then
			self.bActive = true
			NeutralSpawners:SetSpawnerOverdataData(self:GetSpecialValueFor("unit_name"), self:GetSpecialValueFor("key"), self:GetSpecialValueFor("value"))
		else
			self.bActive = false
			NeutralSpawners:SetSpawnerOverdataData(self:GetSpecialValueFor("unit_name"), self:GetSpecialValueFor("key"), nil)
		end
	end
end

return public