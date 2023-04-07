---@class privilege_29 : PrivilegeBaseClass 锁妖塔2层和6层之间打开一个传送门
privilege_29 = class({}, nil, PrivilegeBaseClass)

local public = privilege_29

function public:OnCreated(params)
	local hCaster = self:GetCaster()
	self.hPortal2 = CreateUnitByName("npc_portal", Vector(-4633, -11912, 257), true, hCaster, hCaster, hCaster:GetTeamNumber())
	self.hPortal2:SetForwardVector(Vector(-1, 0, 0))
	self.hPortal2:AddNewModifier(hCaster, nil, "modifier_portal", { vPosition = "1308,-6551,257" })
	self.hPortal6 = CreateUnitByName("npc_portal", Vector(1208, -6551, 257), true, hCaster, hCaster, hCaster:GetTeamNumber())
	self.hPortal6:SetForwardVector(Vector(1, 0, 0))
	self.hPortal6:AddNewModifier(hCaster, nil, "modifier_portal", { vPosition = "-4733,-11912,257" })
end
function public:OnRefresh(params)

end
function public:OnDestroy()
	self.hPortal2:Remove()
	self.hPortal6:Remove()
end

return public