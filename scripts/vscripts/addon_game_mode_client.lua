if Activated == nil then
	_G.Activated = false
	_G.GameEventListenerIDs = {}
else
	_G.Activated = true
end
function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end
function init(bReload)
	pcall(require, "encrypt")
	_G.json = require("game/dkjson")
	require("enums")
	require("libraries/built_in_modifier")
	require("utils")
	require("kv")
	require("settings")

	require("abilities/init")
	require("modifiers/init")

	local t = {
		"mechanics/ability_upgrades",
		"mechanics/asset_modifiers",
	-- "mechanics/player_data",
	}
	for k, v in pairs(t) do
		local t = require(v)
		if t ~= nil and type(t) == "table" then
			_G[k] = t
			if t.init ~= nil then
				t:init(bReload)
			end
		end
	end

	GameEvent("custom_update_fps", OnUpdateFPS, nil)
	GameEvent("custom_get_ability_cooldown", OnGetAbilityCooldown, nil)
	GameEvent("custom_get_ability_mana_cost", OnGetAbilityManaCost, nil)
	GameEvent("custom_get_ability_gold_cost", OnGetAbilityGoldCost, nil)
	GameEvent("custom_get_ability_energy_cost", OnGetAbilityEnergyCost, nil)
	GameEvent("custom_get_ability_special_value", OnGetAbilitySpecialValue, nil)
	GameEvent("custom_get_unit_data", OnGetUnitData, nil)
	GameEvent("custom_hover_item", OnHoverItem, nil)
	GameEvent("custom_get_active_ability", OnGetActiveAbility, nil)

	GameEvent("client_reload_game_keyvalues", function()
		require("addon_game_mode_client")
	end, nil)
	GameEvent("date_now", function(params)
		_G.date_now = params.date
	end, nil)
	-- Convars:SetInt("dota_camera_edgemove", 0)
end


_G.GetAbilityCooldown_AbilityEntIndex = -1
_G.GetAbilityCooldown_Level = -1

_G.GetAbilityManaCost_AbilityEntIndex = -1
_G.GetAbilityManaCost_Level = -1

_G.GetAbilityGoldCost_AbilityEntIndex = -1
_G.GetAbilityGoldCost_Level = -1

_G.GetAbilityEnergyCost_AbilityEntIndex = -1
_G.GetAbilityEnergyCost_Level = -1

_G.GetAbilitySpecialValue_AbilityEntIndex = -1
_G.GetAbilitySpecialValue_Level = -1
_G.GetAbilitySpecialValue_KeyName = ""

_G.iHoverItem = -1

_G.iActiveAbility = -1

function OnGetAbilityCooldown(tEvents)
	_G.GetAbilityCooldown_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityCooldown_Level = tEvents.level
end
function OnGetAbilityManaCost(tEvents)
	_G.GetAbilityManaCost_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityManaCost_Level = tEvents.level
end
function OnGetAbilityGoldCost(tEvents)
	_G.GetAbilityGoldCost_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityGoldCost_Level = tEvents.level
end
function OnGetAbilityEnergyCost(tEvents)
	_G.GetAbilityEnergyCost_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilityEnergyCost_Level = tEvents.level
end
function OnGetAbilitySpecialValue(tEvents)
	_G.GetAbilitySpecialValue_AbilityEntIndex = tEvents.ability_ent_index
	_G.GetAbilitySpecialValue_Level = tEvents.level
	_G.GetAbilitySpecialValue_KeyName = tEvents.key_name
end
function OnGetUnitData(tEvents)
	_G.GetUnitData_UnitEntIndex = tEvents.unit_ent_index
	_G.GetUnitData_FunctionName = tEvents.function_name
end
function OnHoverItem(tEvents)
	_G.iHoverItem = tEvents.item_entindex
end
function OnGetActiveAbility(tEvents)
	_G.iActiveAbility = tEvents.entindex
end

function OnUpdateFPS(tEvents)
	_G.fFPS = tEvents.fps
	_G._Count = (_G._Count or 0) % DEBUG_COUNTDOWN + 1
	if _G._Count == DEBUG_COUNTDOWN then
		local m = collectgarbage('count')
		-- print(string.format("[Client Lua Memory]  %.3f KB  %.3f MB", m, m / 1024))
		-- print(string.format("[Client FPS] %d", fFPS))
	end
end


if Activated == true then
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	_G.GameEventListenerIDs = {}
	init(true)
else
	init(false)
end