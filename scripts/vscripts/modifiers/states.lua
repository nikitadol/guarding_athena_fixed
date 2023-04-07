
---@type _G
_eom_modifier_states = {
	EOM_MODIFIER_STATE_NO_HEALTH_BAR = true, -- 无血条
	EOM_MODIFIER_STATE_CRITICAL_IMMUNE = true, -- 免疫暴击
	EOM_MODIFIER_STATE_ATTACK_PROJECTILE_DISABLED = true, -- 禁用攻击弹道
	EOM_MODIFIER_STATE_DASH_DISABLE = true, -- 冲锋无效
	EOM_MODIFIER_STATE_TELEPORT_DISABLE = true, -- 传送无效
	EOM_MODIFIER_STATE_FEAR = true, -- 恐惧
}

_G.EOM_MODIFIER_STATE_NAME = {}
_G.EOM_MODIFIER_STATE_INDEXES = {}

local _iIndex = MODIFIER_STATE_LAST + 1
---@private
function _InitModifierState(sStateName)
	_G[sStateName] = _iIndex
	EOM_MODIFIER_STATE_INDEXES[sStateName] = _iIndex
	EOM_MODIFIER_STATE_NAME[_iIndex] = sStateName
	_iIndex = _iIndex + 1
end

for k, v in pairs(_eom_modifier_states) do
	if v then
		_InitModifierState(k)
	end
end
---@private
function RegisterModifierState(hUnit, hModifier)
	if hUnit == nil then return false end
	if hUnit.tStateModifers == nil then hUnit.tStateModifers = {} end

	table.insert(hUnit.tStateModifers, hModifier)

	table.sort(hUnit.tStateModifers, function(a, b)
		local iPriorityA = type(a.GetPriority) == "function" and a:GetPriority() or MODIFIER_PRIORITY_NORMAL
		local iPriorityB = type(b.GetPriority) == "function" and b:GetPriority() or MODIFIER_PRIORITY_NORMAL
		return iPriorityA < iPriorityB
	end)

	return true
end
---@private
function UnregisterModifierState(hUnit, hModifier)
	if hUnit == nil then return false end
	if hUnit.tStateModifers == nil then hUnit.tStateModifers = {} end

	if ArrayRemove(hUnit.tStateModifers, hModifier) ~= nil then
		return true
	end

	return false
end
---@private
function HasState(hUnit, iState)
	if EOM_MODIFIER_STATE_NAME[iState] == nil then return false end
	if hUnit == nil then return false end
	if hUnit.tStateModifers == nil then hUnit.tStateModifers = {} end

	for i = #hUnit.tStateModifers, 1, -1 do
		local hModifier = hUnit.tStateModifers[i]
		if IsValid(hModifier) and type(hModifier.ECheckState) == "function" then
			local tFlags = hModifier:ECheckState()
			if type(tFlags) == "table" and tFlags[iState] ~= nil then
				return tFlags[iState]
			end
		else
			table.remove(hUnit.tStateModifers, i)
		end
	end

	return false
end
----------------------------------------public----------------------------------------
---是否没有血条
function HasNoHealthBar(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_NO_HEALTH_BAR)
end
---是否免疫暴击
function HasCriticalImmune(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_CRITICAL_IMMUNE)
end
---是否禁用攻击弹道
function HasAttackProjectileDisabled(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_ATTACK_PROJECTILE_DISABLED)
end
---冲锋无效
function HasDashDisable(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_DASH_DISABLE)
end
---传送无效
function HasTeleportDisable(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_TELEPORT_DISABLE)
end
---恐惧
function HasFear(hUnit)
	return HasState(hUnit, EOM_MODIFIER_STATE_FEAR)
end