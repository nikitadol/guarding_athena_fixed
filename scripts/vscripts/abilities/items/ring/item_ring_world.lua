---@class item_ring_world: eom_ability 创世之戒
item_ring_world = class({})
function item_ring_world:GetIntrinsicModifierName()
	return "modifier_item_ring_world"
end
---@class item_ring_world_broken: eom_ability 破碎的创世之戒
item_ring_world_broken = class({})
function item_ring_world_broken:GetIntrinsicModifierName()
	return "modifier_item_ring_world"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_ring_world : eom_modifier
modifier_item_ring_world = eom_modifier({
	Name = "modifier_item_ring_world",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_ring_world:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			self.tModifiers = {}
			local iPlayerID = hParent:IsSummoned() and hParent:GetOwner():GetPlayerOwnerID() or hParent:GetPlayerOwnerID()
			self.tRingData = PlayerData:GetRingData(iPlayerID)
			table.sort(self.tRingData, function(a, b)
				return a < b
			end)
			if #self.tRingData >= 2 then
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_0_" .. self.tRingData[1], nil))
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_0_" .. self.tRingData[2], nil))
				-- 激活合并效果
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_" .. self.tRingData[1] .. "_" .. self.tRingData[2], nil))
			end
		end
	end
end
function modifier_item_ring_world:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		for i, v in ipairs(self.tModifiers) do
			v:Destroy()
		end
	end
end