---@class item_essence: eom_ability 精髓
item_essence = class({})
function item_essence:Upgrade()
	local iLevel = self:GetLevel()
	local sItemName = self:GetAbilityName()
	local iSlot = self:GetItemSlot()
	local sBaseName = string.sub(sItemName, 0, 17)
	local hCaster = self:GetCaster()
	local hItem = CreateItem(sBaseName .. (iLevel + 1), hCaster, hCaster)
	hCaster:TakeItem(self)
	hCaster:AddItem(hItem)
	if hItem.Upgrade then
		hItem:SetCurrentCharges(self:GetCurrentCharges())
	end
	if hItem:GetCaster() ~= nil then
		hItem:GetIntrinsicModifier():OnRefresh()
	end
	hCaster:SwapItems(hItem:GetItemSlot(), iSlot)
	UTIL_Remove(self)
end
function item_essence:AddCharges(iCharges)
	local require_count = self:GetSpecialValueFor("require_count")
	self:SetCurrentCharges(self:GetCurrentCharges() + iCharges)
	if self:GetCurrentCharges() >= require_count then
		self:SetCurrentCharges(self:GetCurrentCharges() - require_count)
		self:Upgrade()
	end
end
function item_essence:OnSpellStart()
	local hCaster = self:GetCaster()
	local sItemName = self:GetAbilityName()
	local iSlot = self:GetItemSlot()
	if string.find(sItemName, "str") ~= nil then
		sItemName = string.gsub(sItemName, "str", "agi")
	elseif string.find(sItemName, "agi") ~= nil then
		sItemName = string.gsub(sItemName, "agi", "int")
	elseif string.find(sItemName, "int") ~= nil then
		sItemName = string.gsub(sItemName, "int", "str")
	end
	local hItem = CreateItem(sItemName, hCaster, hCaster)
	hCaster:TakeItem(self)
	hCaster:AddItem(hItem)
	hItem:SetLevel(self:GetLevel())
	hItem:SetCurrentCharges(self:GetCurrentCharges())
	hItem:GetIntrinsicModifier():OnRefresh()
	hCaster:SwapItems(hItem:GetItemSlot(), iSlot)
	UTIL_Remove(self)
end
function item_essence:GetIntrinsicModifierName()
	return "modifier_essence"
end

-- 未知精华
if item_essence_small == nil then item_essence_small = class({}) end
function item_essence_small:OnSpellStart()
	local hCaster = self:GetCaster()
	local bHasEssence = false
	for iSlot = 0, 5 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) and string.find(hItem:GetAbilityName(), "item_essence") and hItem:GetLevel() < 15 then
			hItem:AddCharges(self:GetSpecialValueFor("charges"))
			bHasEssence = true
			break
		end
	end
	if bHasEssence == false then
		local hItem = CreateItem("item_essence_str_1", hCaster, hCaster)
		hCaster:AddItem(hItem)
	end
	-- self:SpendCharge()
	self:Destroy()
end
if item_essence_medium == nil then item_essence_medium = class({}) end
function item_essence_medium:OnSpellStart()
	local hCaster = self:GetCaster()
	local bHasEssence = false
	for iSlot = 0, 5 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) and string.find(hItem:GetAbilityName(), "item_essence") and hItem:GetLevel() < 15 then
			hItem:AddCharges(self:GetSpecialValueFor("charges"))
			bHasEssence = true
			break
		end
	end
	if bHasEssence == false then
		local hItem = CreateItem("item_essence_str_1", hCaster, hCaster)
		hCaster:AddItem(hItem)
	end
	-- self:SpendCharge()
	self:Destroy()
end
if item_essence_big == nil then item_essence_big = class({}) end
function item_essence_big:OnSpellStart()
	local hCaster = self:GetCaster()
	local bHasEssence = false
	for iSlot = 0, 5 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) and string.find(hItem:GetAbilityName(), "item_essence") and hItem:GetLevel() < 15 then
			hItem:AddCharges(self:GetSpecialValueFor("charges"))
			bHasEssence = true
			break
		end
	end
	if bHasEssence == false then
		local hItem = CreateItem("item_essence_str_1", hCaster, hCaster)
		hCaster:AddItem(hItem)
	end
	-- self:SpendCharge()
	self:Destroy()
end
-- 力量精华
if item_essence_str_1 == nil then item_essence_str_1 = class({}, nil, item_essence) end
if item_essence_str_2 == nil then item_essence_str_2 = class({}, nil, item_essence) end
if item_essence_str_3 == nil then item_essence_str_3 = class({}, nil, item_essence) end
if item_essence_str_4 == nil then item_essence_str_4 = class({}, nil, item_essence) end
if item_essence_str_5 == nil then item_essence_str_5 = class({}, nil, item_essence) end
if item_essence_str_6 == nil then item_essence_str_6 = class({}, nil, item_essence) end
if item_essence_str_7 == nil then item_essence_str_7 = class({}, nil, item_essence) end
if item_essence_str_8 == nil then item_essence_str_8 = class({}, nil, item_essence) end
if item_essence_str_9 == nil then item_essence_str_9 = class({}, nil, item_essence) end
if item_essence_str_10 == nil then item_essence_str_10 = class({}, nil, item_essence) end
if item_essence_str_11 == nil then item_essence_str_11 = class({}, nil, item_essence) end
if item_essence_str_12 == nil then item_essence_str_12 = class({}, nil, item_essence) end
if item_essence_str_13 == nil then item_essence_str_13 = class({}, nil, item_essence) end
if item_essence_str_14 == nil then item_essence_str_14 = class({}, nil, item_essence) end
if item_essence_str_15 == nil then item_essence_str_15 = class({}) end
function item_essence_str_15:GetIntrinsicModifierName() return "modifier_essence" end
-- 虚幻精华 
if item_essence_agi_1 == nil then item_essence_agi_1 = class({}, nil, item_essence) end
if item_essence_agi_2 == nil then item_essence_agi_2 = class({}, nil, item_essence) end
if item_essence_agi_3 == nil then item_essence_agi_3 = class({}, nil, item_essence) end
if item_essence_agi_4 == nil then item_essence_agi_4 = class({}, nil, item_essence) end
if item_essence_agi_5 == nil then item_essence_agi_5 = class({}, nil, item_essence) end
if item_essence_agi_6 == nil then item_essence_agi_6 = class({}, nil, item_essence) end
if item_essence_agi_7 == nil then item_essence_agi_7 = class({}, nil, item_essence) end
if item_essence_agi_8 == nil then item_essence_agi_8 = class({}, nil, item_essence) end
if item_essence_agi_9 == nil then item_essence_agi_9 = class({}, nil, item_essence) end
if item_essence_agi_10 == nil then item_essence_agi_10 = class({}, nil, item_essence) end
if item_essence_agi_11 == nil then item_essence_agi_11 = class({}, nil, item_essence) end
if item_essence_agi_12 == nil then item_essence_agi_12 = class({}, nil, item_essence) end
if item_essence_agi_13 == nil then item_essence_agi_13 = class({}, nil, item_essence) end
if item_essence_agi_14 == nil then item_essence_agi_14 = class({}, nil, item_essence) end
if item_essence_agi_15 == nil then item_essence_agi_15 = class({}) end
function item_essence_agi_15:GetIntrinsicModifierName() return "modifier_essence" end
-- 能量精华
if item_essence_int_1 == nil then item_essence_int_1 = class({}, nil, item_essence) end
if item_essence_int_2 == nil then item_essence_int_2 = class({}, nil, item_essence) end
if item_essence_int_3 == nil then item_essence_int_3 = class({}, nil, item_essence) end
if item_essence_int_4 == nil then item_essence_int_4 = class({}, nil, item_essence) end
if item_essence_int_5 == nil then item_essence_int_5 = class({}, nil, item_essence) end
if item_essence_int_6 == nil then item_essence_int_6 = class({}, nil, item_essence) end
if item_essence_int_7 == nil then item_essence_int_7 = class({}, nil, item_essence) end
if item_essence_int_8 == nil then item_essence_int_8 = class({}, nil, item_essence) end
if item_essence_int_9 == nil then item_essence_int_9 = class({}, nil, item_essence) end
if item_essence_int_10 == nil then item_essence_int_10 = class({}, nil, item_essence) end
if item_essence_int_11 == nil then item_essence_int_11 = class({}, nil, item_essence) end
if item_essence_int_12 == nil then item_essence_int_12 = class({}, nil, item_essence) end
if item_essence_int_13 == nil then item_essence_int_13 = class({}, nil, item_essence) end
if item_essence_int_14 == nil then item_essence_int_14 = class({}, nil, item_essence) end
if item_essence_int_15 == nil then item_essence_int_15 = class({}) end
function item_essence_int_15:GetIntrinsicModifierName() return "modifier_essence" end
-- 世界之心
if item_essence_core == nil then item_essence_core = class({}) end
function item_essence_core:GetIntrinsicModifierName() return "modifier_essence" end
----------------------------------------Modifier----------------------------------------
---@class modifier_essence : eom_modifier
modifier_essence = eom_modifier({
	Name = "modifier_essence",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_essence:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_essence:OnCreated(params)
	self.str = self:GetAbilitySpecialValueFor("str")
	self.agi = self:GetAbilitySpecialValueFor("agi")
	self.int = self:GetAbilitySpecialValueFor("int")
	self.hp = self:GetAbilitySpecialValueFor("hp")
	self.mp = self:GetAbilitySpecialValueFor("mp")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	self.mp_regen = self:GetAbilitySpecialValueFor("mp_regen")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	self:SetStackCount(1)
end
function modifier_essence:OnRefresh(params)
	self.str = self:GetAbilitySpecialValueFor("str")
	self.agi = self:GetAbilitySpecialValueFor("agi")
	self.int = self:GetAbilitySpecialValueFor("int")
	self.hp = self:GetAbilitySpecialValueFor("hp")
	self.mp = self:GetAbilitySpecialValueFor("mp")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	self.mp_regen = self:GetAbilitySpecialValueFor("mp_regen")
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
end
function modifier_essence:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS,
		EOM_MODIFIER_PROPERTY_MANA_BONUS,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() }
	}
end
function modifier_essence:OnDeath(params)
	local attacker = params.attacker
	if attacker:IsIllusion() then
		if attacker.caster_hero then
			attacker = attacker.caster_hero
		end
	end
	if attacker.GetMaster then
		attacker = attacker:GetMaster()
	end
	if attacker == self:GetParent() and self:GetAbility().AddCharges and self:GetParent():IsRealHero() then
		self:GetAbility():AddCharges(1)
	end
end
function modifier_essence:EOM_GetModifierHealthBonus(t)
	return self.hp
end
function modifier_essence:EOM_GetModifierManaBonus(t)
	return self.mp
end
function modifier_essence:EOM_GetModifierConstantHealthRegen(t)
	return self.hp_regen
end
function modifier_essence:EOM_GetModifierConstantManaRegen(t)
	return self.mp_regen
end
function modifier_essence:EOM_GetModifierBonusStats_Strength(t)
	return self.str
end
function modifier_essence:EOM_GetModifierBonusStats_Agility(t)
	return self.agi
end
function modifier_essence:EOM_GetModifierBonusStats_Intellect(t)
	return self.int
end