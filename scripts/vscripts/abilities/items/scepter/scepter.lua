-- Abilities
if item_scepter == nil then
	item_scepter = class({})
end
function item_scepter:GetIntrinsicModifierName()
	return "modifier_scepter"
end
-- 全能
if item_npc_dota_hero_omniknight == nil then
	item_npc_dota_hero_omniknight = class({}, nil, item_scepter)
end
-- 圣堂
if item_npc_dota_hero_templar_assassin == nil then
	item_npc_dota_hero_templar_assassin = class({}, nil, item_scepter)
end
-- 幽鬼
if item_npc_dota_hero_spectre == nil then
	item_npc_dota_hero_spectre = class({}, nil, item_scepter)
end
-- 剑圣
if item_npc_dota_hero_juggernaut == nil then
	item_npc_dota_hero_juggernaut = class({}, nil, item_scepter)
end
-- 鬼面武士
if item_npc_dota_hero_juggernaut_juggernaut_01 == nil then
	item_npc_dota_hero_juggernaut_juggernaut_01 = class({}, nil, item_scepter)
end
-- 影魔
if item_npc_dota_hero_nevermore == nil then
	item_npc_dota_hero_nevermore = class({}, nil, item_scepter)
end
-- 拉比克
if item_npc_dota_hero_rubick == nil then
	item_npc_dota_hero_rubick = class({}, nil, item_scepter)
end
-- 风行者
if item_npc_dota_hero_windrunner == nil then
	item_npc_dota_hero_windrunner = class({}, nil, item_scepter)
end
-- 水晶室女
if item_npc_dota_hero_crystal_maiden == nil then
	item_npc_dota_hero_crystal_maiden = class({}, nil, item_scepter)
end
-- 神谕者
if item_npc_dota_hero_oracle == nil then
	item_npc_dota_hero_oracle = class({}, nil, item_scepter)
end
-- 虚无之灵
if item_npc_dota_hero_void_spirit == nil then
	item_npc_dota_hero_void_spirit = class({}, nil, item_scepter)
end
-- 齐天大圣
if item_npc_dota_hero_monkey_king == nil then
	item_npc_dota_hero_monkey_king = class({}, nil, item_scepter)
end
-- 莉娜
if item_npc_dota_hero_lina == nil then
	item_npc_dota_hero_lina = class({}, nil, item_scepter)
end
-- 军团指挥官
if item_npc_dota_hero_legion_commander == nil then
	item_npc_dota_hero_legion_commander = class({}, nil, item_scepter)
end
-- 敌法师
if item_npc_dota_hero_antimage == nil then
	item_npc_dota_hero_antimage = class({}, nil, item_scepter)
end
-- 幻影刺客
if item_npc_dota_hero_phantom_assassin == nil then
	item_npc_dota_hero_phantom_assassin = class({}, nil, item_scepter)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_scepter : eom_modifier
modifier_scepter = eom_modifier({
	Name = "modifier_scepter",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false
})
function modifier_scepter:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_scepter:OnCreated(params)
	self.property = self:GetAbilitySpecialValueFor("property") * 0.01
	if IsServer() then
		EmitAnnouncerSoundForPlayer("ui.treasure_01", self:GetParent():GetPlayerOwnerID())
		self:SetStackCount(self:GetParent():GetRebornTimes())
		for iReborn = 1, self:GetStackCount() do
			local hParent = self:GetParent()
			for iIndex = 0, 6 do
				local hAbility = hParent:GetAbilityByIndex(iIndex)
				if IsValid(hAbility) and KeyValues.AbilitiesKv[hAbility:GetAbilityName()] and KeyValues.AbilitiesKv[hAbility:GetAbilityName()].HasScepterUpgrade and hAbility.OnScepterLevelup then
					hAbility:OnScepterLevelup(iReborn)
				end
			end
		end
	end
end
function modifier_scepter:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_REBORN = { self:GetParent() }
	}
end
function modifier_scepter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER
	}
end
function modifier_scepter:OnReborn(params)
	if IsServer() then
		self:SetStackCount(self:GetParent():GetRebornTimes())
		local hParent = self:GetParent()
		for iIndex = 0, 6 do
			local hAbility = hParent:GetAbilityByIndex(iIndex)
			if IsValid(hAbility) and KeyValues.AbilitiesKv[hAbility:GetAbilityName()] and KeyValues.AbilitiesKv[hAbility:GetAbilityName()].HasScepterUpgrade and hAbility.OnScepterLevelup then
				hAbility:OnScepterLevelup(params.level)
			end
		end
	end
end
function modifier_scepter:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		for iIndex = 0, 6 do
			local hAbility = hParent:GetAbilityByIndex(iIndex)
			if IsValid(hAbility) and KeyValues.AbilitiesKv[hAbility:GetAbilityName()] and KeyValues.AbilitiesKv[hAbility:GetAbilityName()].HasScepterUpgrade and hAbility.OnScepterRemove then
				hAbility:OnScepterRemove()
			end
		end
	end
end
function modifier_scepter:GetModifierHealthBonus(t)
	return self:GetParent():GetBaseMaxHealth() * self.property
end
function modifier_scepter:GetModifierManaBonus(t)
	return self:GetParent():GetMaxMana() * self.property
end
function modifier_scepter:GetModifierBonusStats_Strength(t)
	return self:GetParent():GetBaseStrength() * self.property
end
function modifier_scepter:GetModifierBonusStats_Agility(t)
	return self:GetParent():GetBaseAgility() * self.property
end
function modifier_scepter:GetModifierBonusStats_Intellect(t)
	return self:GetParent():GetBaseIntellect() * self.property
end
function modifier_scepter:GetModifierScepter(t)
	return true
end