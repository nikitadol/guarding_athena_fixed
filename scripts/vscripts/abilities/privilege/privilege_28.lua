---@class privilege_28 : PrivilegeBaseClass 开局解锁团队boss功能，初始出生时间-5分钟
privilege_28 = class({}, nil, PrivilegeBaseClass)

local public = privilege_28

function public:OnCreated(params)
	local iPlayerID = self:GetPlayerID()
	for sUnitName, tData in pairs(Training.tTeamBossSetting) do
		if tData.bInit == false then
			tData.flEndTime = tData.flEndTime - self:GetSpecialValueFor("value")
		end
	end
	CustomNetTables:SetTableValue("common", "team_boss", Training.tTeamBossSetting)
end
function public:OnRefresh(params)

end
function public:OnDestroy()

end

return public