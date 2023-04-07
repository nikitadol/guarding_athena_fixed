---@class item_ring_secret: eom_ability 隐秘之戒
item_ring_secret = class({})
function item_ring_secret:OnSpellStart()
	local hCaster = self:GetCaster()
	local tRingData = PlayerData:GetRingData(hCaster:GetPlayerOwnerID())
	table.sort(tRingData, function(a, b)
		return a < b
	end)
	if hCaster:IsRealHero() and #tRingData >= 2 then
		hCaster:AddNewModifier(hCaster, nil, "ring_0_" .. tRingData[1], { duration = self:GetDuration() })
		hCaster:AddNewModifier(hCaster, nil, "ring_0_" .. tRingData[2], { duration = self:GetDuration() })
		-- 激活合并效果
		hCaster:AddNewModifier(hCaster, nil, "ring_" .. tRingData[1] .. "_" .. tRingData[2], { duration = self:GetDuration() })
	end
end
function item_ring_secret:GetIntrinsicModifierName()
	return "modifier_ring_secret"
end
---@class item_ring_broken: eom_ability 破碎的隐秘之戒
item_ring_broken = class({})
function item_ring_broken:OnSpellStart()
	local hCaster = self:GetCaster()
	local tRingData = PlayerData:GetRingData(hCaster:GetPlayerOwnerID())
	print("OnSpellStart")
	PrintTable(tRingData)
	table.sort(tRingData, function(a, b)
		return a < b
	end)
	if hCaster:IsRealHero() then
		hCaster:AddNewModifier(hCaster, nil, "ring_0_" .. tRingData[1], { duration = self:GetDuration() })
		hCaster:AddNewModifier(hCaster, nil, "ring_0_" .. tRingData[2], { duration = self:GetDuration() })
		-- 激活合并效果
		hCaster:AddNewModifier(hCaster, nil, "ring_" .. tRingData[1] .. "_" .. tRingData[2], { duration = self:GetDuration() })
	end
end
function item_ring_broken:GetIntrinsicModifierName()
	return "modifier_ring_secret"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_ring_secret : eom_modifier
modifier_ring_secret = eom_modifier({
	Name = "modifier_ring_secret",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_ring_secret:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			self.tModifiers = {}
			self.bActive = false
			local iPlayerID = hParent:IsSummoned() and hParent:GetOwner():GetPlayerOwnerID() or hParent:GetPlayerOwnerID()
			self.tRingData = PlayerData:GetRingData(iPlayerID)
			table.sort(self.tRingData, function(a, b)
				return a < b
			end)
			if #self.tRingData >= 2 then
				self.tTimeStart = {
					KeyValues:GetItemSpecialFor("item_ring_" .. self.tRingData[1], "time_start"),
					KeyValues:GetItemSpecialFor("item_ring_" .. self.tRingData[2], "time_start")
				}
				self.tTimeEnd = {
					KeyValues:GetItemSpecialFor("item_ring_" .. self.tRingData[1], "time_end"),
					KeyValues:GetItemSpecialFor("item_ring_" .. self.tRingData[2], "time_end")
				}
			end
			self:StartIntervalThink(1)
			self:OnIntervalThink()
		end
	end
end
function modifier_ring_secret:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		for i, v in ipairs(self.tModifiers) do
			v:Destroy()
		end
	end
end
function modifier_ring_secret:OnIntervalThink()
	local hParent = self:GetParent()
	local iHour = GetDayTime()
	local bActive = false
	if #self.tRingData >= 2 then
		-- 任一戒指激活则激活全部
		for i = 1, 2 do
			if iHour >= self.tTimeStart[i] and iHour < self.tTimeEnd[i] then
				bActive = true
				break
			end
		end
		-- 激活所有戒指
		if bActive then
			if self.bActive == false then
				self.bActive = true
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_0_" .. self.tRingData[1], nil))
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_0_" .. self.tRingData[2], nil))
				-- 激活合并效果
				table.insert(self.tModifiers, hParent:AddNewModifier(hParent, nil, "ring_" .. self.tRingData[1] .. "_" .. self.tRingData[2], nil))
			end
		else
			if self.bActive == true then
				self.bActive = false
				hParent:RemoveModifierByName("ring_0_" .. self.tRingData[1])
				hParent:RemoveModifierByName("ring_0_" .. self.tRingData[2])
				hParent:RemoveModifierByName("ring_" .. self.tRingData[1] .. "_" .. self.tRingData[2])
				self.tModifiers = {}
			end
		end
	end
end