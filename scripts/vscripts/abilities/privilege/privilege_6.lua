---@class privilege_6 : PrivilegeBaseClass 修改怪物的重生时间
privilege_6 = class({}, nil, PrivilegeBaseClass)

local public = privilege_6

function public:OnCreated(params)
	NeutralSpawners:SetSpawnerOverdataData(self:GetSpecialValueFor("unit_name"), self:GetSpecialValueFor("key"), self:GetSpecialValueFor("value"))
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	NeutralSpawners:SetSpawnerOverdataData(self:GetSpecialValueFor("unit_name"), self:GetSpecialValueFor("key"), nil)
end

return public