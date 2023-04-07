---@class privilege_23 : PrivilegeBaseClass 每局前1次重铸SS物品时必定2选1
privilege_23 = class({}, nil, PrivilegeBaseClass)

local public = privilege_23

function public:OnCreated(params)
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_exchange_item").privilege_23 = 1
end
function public:OnRefresh(params)
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_exchange_item").privilege_23 = hCaster:FindAbilityByName("hero_exchange_item").privilege_23 + 1
end
function public:OnDestroy()
	local hCaster = self:GetCaster()
	hCaster:FindAbilityByName("hero_exchange_item").privilege_23 = nil
end

return public