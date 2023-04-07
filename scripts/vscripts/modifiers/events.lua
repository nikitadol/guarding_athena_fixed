--[[	自定义modifier事件
]]
--
---@type _G
_eom_modifier_events = {
	MODIFIER_EVENT_ON_ATTACK_START_CUSTOM						= "OnAttackStartCustom",
	MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED					= "OnValidAbilityExecuted",
	MODIFIER_EVENT_ON_ATTACK_PROJECTILE_DISABLED				= "OnAttackProjectileDisabled",
	MODIFIER_EVENT_ON_TICK_TIME									= "OnTickTime",
	MODIFIER_EVENT_ON_ITEM_DEVOURED								= "OnItemDevoured",
	MODIFIER_EVENT_ON_REBORN									= "OnReborn", ---转生事件
	MODIFIER_EVENT_ON_SCEPTER_LEVELUP							= "OnScepterLevelup", ---专属装备升级事件
	MODIFIER_EVENT_ON_ABILITY_CHARGE_CHANGED					= "OnAbilityChargeChanged", ---技能能量点变更事件
	MODIFIER_EVENT_ON_CLEAVE									= "OnCleave", ---分裂事件
	MODIFIER_EVENT_ON_CRITICAL									= "OnCritical", ---暴击事件
}

_G.EOM_MODIFIER_EVENT_NAME = {}
_G.EOM_MODIFIER_EVENT_FUNCTIONS = {}
_G.EOM_MODIFIER_EVENT_INDEXES = {}

_G._iEomModifierEventIndex = MODIFIER_FUNCTION_LAST + 1

-- 注册事件
_G.EOM_MODIFIER_EVENTS = {
	-- 官方
	[MODIFIER_EVENT_ON_SPELL_TARGET_READY] = true,
	[MODIFIER_EVENT_ON_ATTACK_RECORD] = true,
	[MODIFIER_EVENT_ON_ATTACK_START] = true,
	[MODIFIER_EVENT_ON_ATTACK] = true,
	[MODIFIER_EVENT_ON_ATTACK_LANDED] = true,
	[MODIFIER_EVENT_ON_ATTACK_FAIL] = true,
	[MODIFIER_EVENT_ON_ATTACK_ALLIED] = true,
	-- [MODIFIER_EVENT_ON_PROJECTILE_DODGE] = true,
	[MODIFIER_EVENT_ON_ORDER] = true,
	[MODIFIER_EVENT_ON_UNIT_MOVED] = true,
	[MODIFIER_EVENT_ON_ABILITY_START] = true,
	[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = true,
	[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] = true,
	-- [MODIFIER_EVENT_ON_BREAK_INVISIBILITY] = true,
	[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] = true,
	-- [MODIFIER_EVENT_ON_PROCESS_UPGRADE] = true,
	-- [MODIFIER_EVENT_ON_REFRESH] = true,
	[MODIFIER_EVENT_ON_TAKEDAMAGE] = true,
	[MODIFIER_EVENT_ON_STATE_CHANGED] = true,
	-- [MODIFIER_EVENT_ON_ORB_EFFECT] = true,
	-- [MODIFIER_EVENT_ON_PROCESS_CLEAVE] = true,
	[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] = true,
	[MODIFIER_EVENT_ON_ATTACKED] = true,
	[MODIFIER_EVENT_ON_DEATH] = true,
	[MODIFIER_EVENT_ON_RESPAWN] = true,
	[MODIFIER_EVENT_ON_SPENT_MANA] = true,
	[MODIFIER_EVENT_ON_TELEPORTING] = true,
	[MODIFIER_EVENT_ON_TELEPORTED] = true,
	-- [MODIFIER_EVENT_ON_SET_LOCATION] = true,
	[MODIFIER_EVENT_ON_HEALTH_GAINED] = true,
	[MODIFIER_EVENT_ON_MANA_GAINED] = true,
	[MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT] = true,
	[MODIFIER_EVENT_ON_HERO_KILLED] = true,
	[MODIFIER_EVENT_ON_HEAL_RECEIVED] = true,
	-- [MODIFIER_EVENT_ON_BUILDING_KILLED] = true,
	-- [MODIFIER_EVENT_ON_MODEL_CHANGED] = true,
	[MODIFIER_EVENT_ON_MODIFIER_ADDED] = true,
	-- [MODIFIER_EVENT_ON_DOMINATED] = true,
	[MODIFIER_EVENT_ON_ATTACK_FINISHED] = true,
	[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = true,
	-- [MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT] = true,
	[MODIFIER_EVENT_ON_ATTACK_CANCELLED] = true,

-- 自定义
-- [MODIFIER_EVENT_ON_ATTACK_START_CUSTOM] = true,
-- [MODIFIER_EVENT_ON_SUMMONNED] = true,
}

---@private
function _InitModifierEvent(sEventName, sFunctionName)
	_G[sEventName] = _iEomModifierEventIndex
	EOM_MODIFIER_EVENT_INDEXES[sEventName] = _iEomModifierEventIndex
	EOM_MODIFIER_EVENT_NAME[_iEomModifierEventIndex] = sEventName
	EOM_MODIFIER_EVENT_FUNCTIONS[_iEomModifierEventIndex] = sFunctionName
	EOM_MODIFIER_EVENTS[_G[sEventName]] = true
	_iEomModifierEventIndex = _iEomModifierEventIndex + 1
end

for k, v in pairs(_eom_modifier_events) do
	_InitModifierEvent(k, v)
end

function AddModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			table.insert(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			table.insert(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		table.insert(tModifierEvents[iModifierEvent], hModifier)
	end
end

function RemoveModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		ArrayRemove(tModifierEvents[iModifierEvent], hModifier)
	end
end

---发起通用事件
---@param iModifierEvent number 事件ID
---@param params {} 事件参数表
---@param hSource CDOTA_BaseNPC|nil 来源
---@param hTarget CDOTA_BaseNPC|nil 来源
function FireModifierEvent(iModifierEvent, params, hSource, hTarget)
	if IsValid(hSource) and hSource.tSourceModifierEvents and hSource.tSourceModifierEvents[iModifierEvent] then
		local tModifiers = hSource.tSourceModifierEvents[iModifierEvent]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hSource) and IsValid(hModifier) and type(hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]]) == "function" then
				hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if IsValid(hTarget) and hTarget.tTargetModifierEvents and hTarget.tTargetModifierEvents[iModifierEvent] then
		local tModifiers = hTarget.tTargetModifierEvents[iModifierEvent]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hTarget) and IsValid(hModifier) and type(hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]]) == "function" then
				hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
	if tModifierEvents and tModifierEvents[iModifierEvent] then
		local tModifiers = tModifierEvents[iModifierEvent]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and type(hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]]) == "function" then
				hModifier[EOM_MODIFIER_EVENT_FUNCTIONS[iModifierEvent]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end