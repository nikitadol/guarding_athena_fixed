---@class privilege_11 : PrivilegeBaseClass 练功房怪物数量+1
privilege_11 = class({}, nil, PrivilegeBaseClass)

local public = privilege_11

function public:OnCreated(params)
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_GOLD_MONSTER_COUNT, 1)
end

function public:OnRefresh(params)

end

function public:OnDestroy()
	self:GetCaster():AddPermanentAttribute(CUSTOM_ATTRIBUTE_GOLD_MONSTER_COUNT, -1)
end

return public