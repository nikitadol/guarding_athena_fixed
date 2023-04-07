---@class privilege_10 : PrivilegeBaseClass 铸造上限+1
privilege_10 = class({}, nil, PrivilegeBaseClass)

local public = privilege_10

function public:OnCreated(params)
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_DEVOUR_CASTING_COUNT, 1)
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_DEVOUR_CASTING_COUNT, -1)
end

return public