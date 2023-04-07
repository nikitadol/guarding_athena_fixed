---@class item_ring: eom_ability 戒指
item_ring = class({})
function item_ring:OnSpellStart()
	local hCaster = self:GetCaster()
	local sModifierName = "ring_0_" .. string.sub(self:GetAbilityName(), 11)
	if hCaster:HasModifier(sModifierName) then
		ErrorMessage(hCaster:GetPlayerOwnerID(), "error_ring_active")
		self:EndCooldown()
	else
		hCaster:AddNewModifier(hCaster, self, sModifierName, { duration = self:GetDuration() })
	end
end
function item_ring:GetIntrinsicModifierName()
	return "modifier_ring"
end
--Abilities
if item_ring_1 == nil then item_ring_1 = class({}, nil, item_ring) end
if item_ring_2 == nil then item_ring_2 = class({}, nil, item_ring) end
if item_ring_3 == nil then item_ring_3 = class({}, nil, item_ring) end
if item_ring_4 == nil then item_ring_4 = class({}, nil, item_ring) end
if item_ring_5 == nil then item_ring_5 = class({}, nil, item_ring) end
if item_ring_6 == nil then item_ring_6 = class({}, nil, item_ring) end
----------------------------------------Modifier----------------------------------------
---@class modifier_ring : eom_modifier
modifier_ring = eom_modifier({
	Name = "modifier_ring",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_ring:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_ring:OnCreated(params)
	self.time_start = self:GetAbilitySpecialValueFor("time_start")
	self.time_end = self:GetAbilitySpecialValueFor("time_end")
	if IsServer() then
		self.hModifier = nil
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end
end
function modifier_ring:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) and self.hModifier:GetDuration() == -1 then
			self.hModifier:Destroy()
		end
	end
end
function modifier_ring:OnIntervalThink()
	local hParent = self:GetParent()
	local sModifierName = "ring_0_" .. string.sub(self:GetAbility():GetAbilityName(), 11)
	local iHour = GetDayTime()
	if iHour >= self.time_start and iHour < self.time_end then
		if not IsValid(self.hModifier) then
			if hParent:HasModifier(sModifierName) then
				hParent:RemoveModifierByName(sModifierName)
			end
			self.hModifier = hParent:AddNewModifier(hParent, nil, sModifierName, nil)
		end
	elseif IsValid(self.hModifier) and self.hModifier:GetDuration() > 0 then
		self.hModifier:Destroy()
	end
end