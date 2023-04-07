---@class PrivilegeBaseClass
PrivilegeBaseClass = class({})

local public = PrivilegeBaseClass

function public:constructor(sPrivilegeName, iPlayerID)
	self.sPrivilegeName = sPrivilegeName
	self.iPlayerID = iPlayerID
	self.hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
end
function public:GetCaster()
	return self.hHero
end
function public:GetPlayerID()
	return self.iPlayerID
end
function public:GetSpecialValueFor(sKey)
	return Privilege:GetPrivilegeSpecialValue(self.sPrivilegeName, sKey)
end

return public