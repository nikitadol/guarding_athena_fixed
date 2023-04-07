---@class privilege_9 : PrivilegeBaseClass 吞噬上限+1
privilege_9 = class({}, nil, PrivilegeBaseClass)

local public = privilege_9

function public:OnCreated(params)
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_DEVOUR_EQUIPMENT_COUNT, 1)
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_DEVOUR_EQUIPMENT_COUNT, -1)
end

return public