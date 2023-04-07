---@class privilege_22 : PrivilegeBaseClass 每局前1次合成SS品质物品时2选1
privilege_22 = class({}, nil, PrivilegeBaseClass)

local public = privilege_22

function public:OnCreated(params)
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_combine_item").privilege_22 = 1
end
function public:OnRefresh(params)
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_combine_item").privilege_22 = hCaster:FindAbilityByName("hero_combine_item").privilege_22 + 1
end
function public:OnDestroy()
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_combine_item").privilege_22 = nil
end

return public