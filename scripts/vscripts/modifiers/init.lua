require("modifiers/BaseClass")
require("modifiers/states")
require("modifiers/events")
require("modifiers/eom_modifier")

LinkLuaModifier("ring_0_1", "modifiers/ring/ring_0_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_2", "modifiers/ring/ring_0_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_3", "modifiers/ring/ring_0_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_4", "modifiers/ring/ring_0_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_5", "modifiers/ring/ring_0_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_6", "modifiers/ring/ring_0_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_1", "modifiers/ring/ring_1_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_2", "modifiers/ring/ring_1_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_3", "modifiers/ring/ring_1_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_4", "modifiers/ring/ring_1_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_5", "modifiers/ring/ring_1_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_6", "modifiers/ring/ring_1_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_2", "modifiers/ring/ring_2_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_3", "modifiers/ring/ring_2_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_4", "modifiers/ring/ring_2_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_5", "modifiers/ring/ring_2_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_6", "modifiers/ring/ring_2_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_3", "modifiers/ring/ring_3_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_4", "modifiers/ring/ring_3_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_5", "modifiers/ring/ring_3_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_6", "modifiers/ring/ring_3_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_4", "modifiers/ring/ring_4_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_5", "modifiers/ring/ring_4_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_6", "modifiers/ring/ring_4_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_5_5", "modifiers/ring/ring_5_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_5_6", "modifiers/ring/ring_5_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_6_6", "modifiers/ring/ring_6_6.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_charges", "modifiers/modifier_charges.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_common", "modifiers/modifier_common.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy", "modifiers/modifier_dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_events", "modifiers/modifier_events.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_record_system_dummy", "modifiers/modifier_record_system_dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invulnerable_custom", "modifiers/modifier_invulnerable_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute", "modifiers/modifier_attribute.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier", "modifiers/modifier_courier.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("demo_take_no_damage", "modifiers/demo/demo_take_no_damage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy_damage", "modifiers/demo/modifier_dummy_damage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_hero_attribute", "modifiers/hero/modifier_hero_attribute", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_ability_upgrades", "modifiers/ability_upgrades/modifier_ability_upgrades", LUA_MODIFIER_MOTION_NONE)

-- 通用
LinkLuaModifier("modifier_knockback_custom", "modifiers/utils/modifier_knockback_custom", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_dash", "modifiers/utils/modifier_dash", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_follow_motion", "modifiers/utils/modifier_follow_motion", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_passive_cast", "modifiers/utils/modifier_passive_cast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_base", "modifiers/utils/modifier_base.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_base_invulnerable", "modifiers/utils/modifier_base_invulnerable.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attack_reduce_armor", "modifiers/utils/modifier_attack_reduce_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc", "modifiers/utils/modifier_npc.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reborn", "modifiers/utils/modifier_reborn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_base", "modifiers/utils/modifier_pet_base.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_summoned", "modifiers/utils/modifier_summoned.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_neutral", "modifiers/utils/modifier_neutral.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guarding_1", "modifiers/utils/modifier_guarding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guarding_2", "modifiers/utils/modifier_guarding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guarding_3", "modifiers/utils/modifier_guarding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_guarding_4", "modifiers/utils/modifier_guarding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_no_health_bar", "modifiers/utils/modifier_no_health_bar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave", "modifiers/utils/modifier_wave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_singlehero", "modifiers/utils/modifier_singlehero.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_elite", "modifiers/utils/modifier_elite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_champion", "modifiers/utils/modifier_champion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_original_health_bar", "modifiers/utils/modifier_original_health_bar.lua", LUA_MODIFIER_MOTION_NONE)

for sUnitName, tData in pairs(KeyValues.UnitsKv) do
	if type(tData) == "table" and tData.Modifiers ~= nil and tData.Modifiers ~= "" then
		local tList = string.split(string.gsub(tData.Modifiers, " ", ""), "|")
		for i, sModifierName in pairs(tList) do
			LinkLuaModifier(sModifierName, "modifiers/unit/" .. sModifierName .. ".lua", LUA_MODIFIER_MOTION_NONE)
		end
	end
	if type(tData) == "table" and tData.SpawnModifier ~= nil and tData.SpawnModifier ~= "" then
		LinkLuaModifier(tData.SpawnModifier, "modifiers/spawn/" .. tData.SpawnModifier .. ".lua", LUA_MODIFIER_MOTION_NONE)
	end
end
-- 饰品特效
for sSkinName, tData in pairs(KeyValues.AssetModifiersKv) do
	if type(tData) == "table" then
		LinkLuaModifier("modifier_" .. sSkinName, "modifiers/asset_modifiers/modifier_" .. sSkinName .. ".lua", LUA_MODIFIER_MOTION_NONE)
	end
end
for sCourierName, tData in pairs(LoadKeyValues("scripts/npc/kv/units/npc_pet.kv")) do
	if type(tData) == "table" and tData.AmbientEffect ~= nil and tData.AmbientEffect ~= "" then
		local sModifierName = tData.AmbientEffect
		LinkLuaModifier(sModifierName, "modifiers/courier_fx/" .. sModifierName .. ".lua", LUA_MODIFIER_MOTION_NONE)
	end
end
-- 特效
LinkLuaModifier("modifier_particle_1", "modifiers/particle/modifier_particle_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_particle_2", "modifiers/particle/modifier_particle_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_particle_3", "modifiers/particle/modifier_particle_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_particle_4", "modifiers/particle/modifier_particle_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_particle_5", "modifiers/particle/modifier_particle_5.lua", LUA_MODIFIER_MOTION_NONE)