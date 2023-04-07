---@type CDOTA_PlayerResource
PlayerResource = PlayerResource
---@type CEntities
Entities = Entities
---@type CDOTAGamerules
GameRules = GameRules

pcall(require, "encrypt")
_G.Service = require("service/init_dev")
_G.json = require("game/dkjson")

_G.old_debug_traceback = old_debug_traceback or debug.traceback
if IsInToolsMode() then
	debug.traceback = function(...)
		local a = old_debug_traceback(...)
		print("[debug error]:", a)
		return a
	end

	local src = debug.getinfo(1).source
	if src:sub(2):find("(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]") then
		_G.GameDir, _G.AddonName = string.match(src:sub(2), "(.*dota 2 beta[\\/]game[\\/]dota_addons[\\/])([^\\/]+)[\\/]")
		_G.ContentDir = GameDir:gsub("\\game\\dota_addons\\", "\\content\\dota_addons\\")
	end
else
	_G.tError = {}
	debug.traceback = function(error, ...)
		local a = old_debug_traceback(error, ...)
		local sMsg = tostring(error)
		print("[debug error]:", a)
		if not tError[sMsg] then
			tError[sMsg] = pcall(function()
				-- Service:HTTPRequest("POST", ACTION_DEBUG_ERROR_MSG, {debug_msg=a}, function(iStatusCode, sBody)
				-- 	if iStatusCode ~= 200 then
				-- 		tError[sMsg] = nil
				-- 	end
				-- end, 30)
			end)
		end
		return a
	end
end

require("enums")
require("libraries/built_in_modifier")
require("utils")
require("kv")
require("abilities/init")
require("modifiers/init")

function Precache(context)
	--local tPrecacheList = require("precache")
	--for sPrecacheMode, tList in pairs(tPrecacheList) do
	--	for _, sResource in pairs(tList) do
	--		PrecacheResource(sPrecacheMode, sResource, context)
	--	end
	--end
	--
	--for k, v in pairs(KeyValues.AbilitiesKv) do
	--	if k ~= "Version" then
	--		if v.precache and type(v.precache) == "table" then
	--			for sPrecacheMode, sResource in pairs(v.precache) do
	--				PrecacheResource(sPrecacheMode, sResource, context)
	--			end
	--		end
	--	end
	--end
	--for k, v in pairs(KeyValues.ItemsKv) do
	--	if k ~= "Version" then
	--		if v.precache and type(v.precache) == "table" then
	--			for sPrecacheMode, sResource in pairs(v.precache) do
	--				PrecacheResource(sPrecacheMode, sResource, context)
	--			end
	--		end
	--	end
	--end
	--
	--for k, v in pairs(KeyValues.UnitsKv) do
	--	if k ~= "Version" then
	--		PrecacheUnitByNameSync(k, context)
	--	end
	--end
	--
	--for k, v in pairs(KeyValues.ItemsKv) do
	--	if k ~= "Version" then
	--		PrecacheItemByNameSync(k, context)
	--	end
	--end
	--for index, tData in pairs(KeyValues.CouriersKV) do
	--	PrecacheResource("model", tData.Model, context)
	--end
end

function SpawnGroupPrecache(hSpawnGroup, context)
end

-- Create the game mode when we activate
function Activate()
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
		local m = collectgarbage('count')
		-- print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m / 1024))
		-- print(string.format("[Hashtable Count]  %d", HashtableCount()))
		local tThinkers = Entities:FindAllByName("npc_dota_thinker")
		for i = #tThinkers, 1, -1 do
			local hThinker = tThinkers[i]
			local tModifiers = hThinker:FindAllModifiers()
			if #tModifiers == 0 then
				hThinker:Remove()
				table.remove(tThinkers, i)
			end
		end
		-- print(string.format("[Thinker Count]  %d", #tThinkers))
		return 10
	end, 0)

	Initialize(false)

	_G.MODIFIER_EVENTS_DUMMY = CreateModifierThinker((not IsDedicatedServer() and GameRules:GetGameModeEntity() or nil), nil, "modifier_events", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
	_G.RECORD_SYSTEM_DUMMY = CreateModifierThinker((not IsDedicatedServer() and GameRules:GetGameModeEntity() or nil), nil, "modifier_record_system_dummy", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
end

function Require(requireList, bReload)
	for k, v in pairs(requireList) do
		local t = require(v)
		if t ~= nil and type(t) == "table" then
			_G[k] = t
			if t.init ~= nil then
				t:init(bReload)
			end
		end
	end
end

function Initialize(bReload)
	_G.CustomUIEventListenerIDs = {}
	_G.GameEventListenerIDs = {}
	_G.TimerEventListenerIDs = {}
	_G.Activated = true

	Require({
		Request = "libraries/request",
		HPack = "libraries/hpack",
		"class/weight_pool",
	-- "class/lz77",
	-- "class/behavior_tree",
	-- "class/spawner",
	-- "class/round",
	}, bReload)

	Require({
		Settings = "settings",
		Filters = "filters",
		Game = "game",
	}, bReload)

	Require({
		Mechanics = "mechanics/main",
	}, bReload)

	if Service then
		Service:init(bReload)
	end
end

function CustomUIEvent(eventName, func, context)
	table.insert(CustomUIEventListenerIDs, CustomGameEventManager:RegisterListener(eventName, function(...)
		if context ~= nil then
			return func(context, ...)
		end
		return func(...)
	end))
end
_G.CustomUIEvent = CustomUIEvent

---@param eventName CustomEventName
function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end
_G.GameEvent = GameEvent

function TimerEvent(startInterval, func, context)
	local hGameMode = GameRules:GetGameModeEntity()
	table.insert(TimerEventListenerIDs, hGameMode:Timer(startInterval, function()
		if context ~= nil then
			return func(context)
		end
		return func()
	end))
end
_G.TimerEvent = TimerEvent

function GameTimerEvent(startInterval, func, context)
	local hGameMode = GameRules:GetGameModeEntity()
	table.insert(TimerEventListenerIDs, hGameMode:GameTimer(startInterval, function()
		if context ~= nil then
			return func(context)
		end
		return func()
	end))
end
_G.GameTimerEvent = GameTimerEvent

function _ClearEventListenerIDs()
	for i = #CustomUIEventListenerIDs, 1, -1 do
		CustomGameEventManager:UnregisterListener(CustomUIEventListenerIDs[i])
	end
	CustomUIEventListenerIDs = {}
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	GameEventListenerIDs = {}
	local hGameMode = GameRules:GetGameModeEntity()
	for i = #TimerEventListenerIDs, 1, -1 do
		hGameMode:SetContextThink(TimerEventListenerIDs[i], nil, -1)
	end
	TimerEventListenerIDs = {}
end

function Reload()
	local state = GameRules:State_Get()
	if state > DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
		GameRules:Playtesting_UpdateAddOnKeyValues()
		FireGameEvent("client_reload_game_keyvalues", {})

		_ClearEventListenerIDs()
		Initialize(true)

		local tUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)
		for n, hUnit in pairs(tUnits) do
			if IsValid(hUnit) then
				hUnit:RemoveModifierByName("modifier_common")
				hUnit:AddNewModifier(hUnit, nil, "modifier_common", nil)
				if hUnit:HasModifier("modifier_hero_attribute") then
					hUnit:RemoveModifierByName("modifier_hero_attribute")
					hUnit:AddNewModifier(hUnit, hUnit:GetDummyAbility(), "modifier_hero_attribute", nil)
				end
				if hUnit:HasModifier("modifier_attribute") then
					hUnit:RemoveModifierByName("modifier_attribute")
					hUnit:AddNewModifier(hUnit, hUnit:GetDummyAbility(), "modifier_attribute", nil)
				end
				if hUnit:HasModifier("modifier_base") then
					hUnit:RemoveModifierByName("modifier_base")
					hUnit:AddNewModifier(hUnit, hUnit:GetDummyAbility(), "modifier_base", nil)
				end
				for i = 0, hUnit:GetAbilityCount() - 1, 1 do
					local hAbility = hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) and hAbility:GetLevel() > 0 then
						if hAbility:GetIntrinsicModifierName() ~= nil and hAbility:GetIntrinsicModifierName() ~= "" then
							hUnit:RemoveModifierByName(hAbility:GetIntrinsicModifierName())
							hUnit:AddNewModifier(hUnit, hAbility, hAbility:GetIntrinsicModifierName(), nil)
						end
					end
				end
			end
		end

		print("Reload Scripts")
	end
end

if Activated == true then
	Reload()
end
