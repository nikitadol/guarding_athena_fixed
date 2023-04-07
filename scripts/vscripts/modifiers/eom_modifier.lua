--[[	Example: 
	modifier_item_dagon_custom = eom_modifier({
		Name = "modifier_item_dagon_custom",	-- 在技能文件中的modifier可以填Name以省去LinkLuaModifier
		-- 在MODIFIER_BOOLEAN_LIST定义过的值才可以直接这样写
		IsHidden = false,
		IsDebuff = false,
		IsPurgable = false,
		IsPurgeException = false,
		IsStunDebuff = false,
		AllowIllusionDuplicate = true,
		RemoveOnDeath = false,

		Type = LUA_MODIFIER_MOTION_NONE,		-- 一般是motion才需要填
		Super = true,	-- 当填写base时会继承base的OnCreated, OnRefresh, OnDestroy, DeclareFunctions, EDeclareFunctions函数
	}, nil, item_base)
]]
DOTA_MODIFIER_FUNCTIONS = nil
xpcall(function()
	DOTA_MODIFIER_FUNCTIONS = require("utils/modifierfunction")
end, function()
	DOTA_MODIFIER_FUNCTIONS = {}
end)

MODIFIER_BOOLEAN_LIST = {
	"IsHidden",
	"IsDebuff",
	"IsPermanent",
	"IsPurgable",
	"IsPurgeException",
	"IsStunDebuff",
	"RemoveOnDeath",
	"ShouldUseOverheadOffset",
	"DestroyOnExpire",
	"CanParentBeAutoAttacked",
	"AllowIllusionDuplicate",
	"IsAura",
	"IsModifierThinker",
}
-- IsIndependent
-- StackDuration
MODIFIER_PROPERTY_PLAYER_DATA = MODIFIER_PROPERTY_PLAYER_DATA or {}

---@class eom_modifier : CDOTA_Modifier_Lua
eom_modifier = {}

local mt = {}
mt.__call = function(class_tbl, ...)
	local c = class(...)

	c.constructor = function(self)
		local _OnCreated = self.OnCreated
		if type(_OnCreated) == "function" then
			self.OnCreated = function(...)
				if self.GetAbilitySpecialValue then
					self:GetAbilitySpecialValue()
				end
				local result = _OnCreated(...)
				if type(eom_modifier.OnCreated) == "function" then
					eom_modifier.OnCreated(...)
				end
				return result
			end
		else
			self.OnCreated = eom_modifier.OnCreated
		end

		local _OnRefresh = self.OnRefresh
		if type(_OnRefresh) == "function" then
			self.OnRefresh = function(...)
				if self.GetAbilitySpecialValue then
					self:GetAbilitySpecialValue()
				end
				local result = _OnRefresh(...)
				if type(eom_modifier.OnRefresh) == "function" then
					eom_modifier.OnRefresh(...)
				end
				return result
			end
		else
			self.OnRefresh = eom_modifier.OnRefresh
		end

		local _OnDestroy = self.OnDestroy
		if type(_OnDestroy) == "function" then
			self.OnDestroy = function(...)
				local result = _OnDestroy(...)
				if type(eom_modifier.OnDestroy) == "function" then
					eom_modifier.OnDestroy(...)
				end
				return result
			end
		else
			self.OnDestroy = eom_modifier.OnDestroy
		end

		for _, key in ipairs(MODIFIER_BOOLEAN_LIST) do
			if type(self[key]) == "boolean" then
				local value = self[key]
				self[key] = function(self)
					return value
				end
			end
		end

		self._DeclareFunctions = self.DeclareFunctions
		if type(self._DeclareFunctions) == "function" then
			local t = self:_DeclareFunctions()
			if type(t) == "table" then
				local tDeclareFunctions = {}
				for k, v in pairs(t) do
					if type(k) == "string" then
						local i = _G[k]
						if type(i) == "number" then
							table.insert(tDeclareFunctions, i)
							local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
							if type(sFunctionName) == "string" then
								self[sFunctionName] = function(self, params)
									return v
								end
							end
						end
					else
						table.insert(tDeclareFunctions, v)
					end
				end
				self.DeclareFunctions = function(self)
					return tDeclareFunctions
				end
			end
		end
		-- 处理modifier叠层
		-- TODO:优化
		if self.IsIndependent == true then
			self.tIndependentData = {}
			if IsServer() then
				self.hIndependentTimer = GameTimer(0, function()
					if IsValid(self) then
						local flTime = GameRules:GetGameTime()
						for i = #self.tIndependentData, 1, -1 do
							if self.tIndependentData[i].flDieTime <= flTime then
								self:DecrementStackCount(self.tIndependentData[i].iStackCount)
								table.remove(self.tIndependentData, i)
							end
						end
						return 0
					end
				end)
			end

			local _OnStackCountChanged = self.OnStackCountChanged
			if type(_OnStackCountChanged) == "function" then
				self.OnStackCountChanged = function(...)
					local result = _OnStackCountChanged(...)
					if type(eom_modifier.OnStackCountChanged) == "function" then
						eom_modifier.OnStackCountChanged(...)
					end
					return result
				end
			else
				self.OnStackCountChanged = eom_modifier.OnStackCountChanged
			end
		end
	end


	-- 自动link只支持技能里的modifier
	if type(c.__initprops__.Name) == "string" then
		local linkType = c.__initprops__.Type or LUA_MODIFIER_MOTION_NONE
		local env, source = unpack(getFileScope(nil))
		local fileName = string.gsub(source, ".*scripts[\\/]vscripts[\\/]", "")
		LinkLuaModifier(c.__initprops__.Name, fileName, linkType)
	end

	return c
end
setmetatable(eom_modifier, mt)

function eom_modifier:EDeclareFunctions(bUnregister)
	return {}
end
function eom_modifier:OnCreated(params)
	if type(self._DeclareFunctions) == "function" then
		local t = self:_DeclareFunctions()
		if type(t) == "table" then
			local tDeclareFunctions = {}
			for k, v in pairs(t) do
				if type(k) == "string" then
					local i = _G[k]
					if type(i) == "number" then
						table.insert(tDeclareFunctions, i)
						local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
						if type(sFunctionName) == "string" then
							self[sFunctionName] = function(self, params)
								return v
							end
						end
					end
				else
					table.insert(tDeclareFunctions, v)
				end
			end
			self.DeclareFunctions = function(self)
				return tDeclareFunctions
			end
		end
	end

	if not self._bDestroy and type(self.ECheckState) == "function" then
		self._bModifierState = RegisterModifierState(self:GetParent(), self)
	end

	if not self._bDestroy and not self._tDeclareFunction and type(self.EDeclareFunctions) == "function" then
		self._tDeclareFunction = self:EDeclareFunctions()

		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() then
			hParent:CalculateGenericBonuses()
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				RegisterModifierProperty(hParent, self, iProperty)
				if IsServer() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, v)
					if IsServer() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						AddModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
	end
end
function eom_modifier:OnRefresh(params)
	if type(self._DeclareFunctions) == "function" then
		local t = self:_DeclareFunctions()
		if type(t) == "table" then
			local tDeclareFunctions = {}
			for k, v in pairs(t) do
				if type(k) == "string" then
					local i = _G[k]
					if type(i) == "number" then
						table.insert(tDeclareFunctions, i)
						local sFunctionName = DOTA_MODIFIER_FUNCTIONS[k]
						if type(sFunctionName) == "string" then
							self[sFunctionName] = function(self, params)
								return v
							end
						end
					end
				else
					table.insert(tDeclareFunctions, v)
				end
			end
			self.DeclareFunctions = function(self)
				return tDeclareFunctions
			end
		end
	end

	if not self._bDestroy and self._tDeclareFunction and type(self.EDeclareFunctions) == "function" then
		self._tDeclareFunction = self:EDeclareFunctions()

		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() then
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				if IsServer() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil and v ~= nil then
					if IsServer() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					end
					SetModifierProperty(hParent, self, iProperty, v)
				end
			end
		end

		if IsServer() and bCalculateHealth then
			hParent:CalculateHealth()
		end
		if IsServer() and bCalculateMana then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
	end
end
function eom_modifier:OnDestroy(params)
	---@private
	self._bDestroy = true

	if self._bModifierState then
		UnregisterModifierState(self:GetParent(), self)
	end

	if self._tDeclareFunction then
		local hParent = self:GetParent()
		local bCalculateHealth = false
		local bCalculateMana = false

		local fManaPercent
		if IsServer() and hParent:IsAlive() then
			fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
		end

		for k, v in pairs(self._tDeclareFunction) do
			if type(k) == "number" then
				local iProperty = v
				UnregisterModifierProperty(hParent, self, iProperty)
				if IsServer() and hParent:IsAlive() then
					bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
					bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
				end
			elseif type(k) == "string" then
				local iProperty = EOM_MODIFIER_PROPERTY_INDEXES[k]
				if iProperty ~= nil then
					SetModifierProperty(hParent, self, iProperty, nil)
					if IsServer() and hParent:IsAlive() then
						bCalculateHealth = bCalculateHealth or UPDATE_HEALTH_PROPERTY[iProperty]
						bCalculateMana = bCalculateMana or UPDATE_MANA_PROPERTY[iProperty]
					end
				elseif type(v) == "table" then
					local iModifierEvent = _G[k]
					if iModifierEvent ~= nil then
						RemoveModifierEvents(iModifierEvent, self, unpack(v))
					end
				end
			end
		end

		if IsServer() and hParent:IsAlive() then
			if bCalculateHealth then
				hParent:CalculateHealth()
			end
			if bCalculateMana then
				hParent:CalculateGenericBonuses()
				hParent:SetMana(fManaPercent * hParent:GetMaxMana())
			end
		end

		self._tDeclareFunction = nil
	end

	if IsServer() and type(self.IsModifierThinker) == "function" and self:IsModifierThinker() == true then
		self:GetParent():RemoveSelf()
	end
end
function eom_modifier:OnStackCountChanged(iOldStackCount)
	if IsServer() then
		local iChangeCount = self:GetStackCount() - iOldStackCount
		if iChangeCount > 0 then
			local flDieTime = self.StackDuration ~= nil and (GameRules:GetGameTime() + self.StackDuration) or self:GetDieTime()
			table.insert(self.tIndependentData, {
				iStackCount = iChangeCount,
				flDieTime = flDieTime
			})
		end
	end
end

ZERO_VALUE = 1 / 10000000000

-- 加法相乘（百分比）
function AdditionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return ((1 + a * 0.01) * (1 + b * 0.01) - 1) * 100
end

-- 减法相乘（百分比）
function SubtractionMultiplicationPercentage(a, b)
	if a == nil and b == nil then
		return 0
	end
	return -AdditionMultiplicationPercentage(-a, -b)
end

-- 最大值
function Maximum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.max(a, b)
end

-- 最小值
function Minimum(a, b)
	if a == nil and b == nil then
		return ZERO_VALUE
	end
	if a == ZERO_VALUE then
		return b
	end
	return math.min(a, b)
end

-- 优先前值
function First(a, b)
	if a == nil then
		return b
	else
		return a
	end
end

--[[-
	自定义属性列表
	格式：
		属性名称 = "属性函数名"
		这种格式会自动将不同modifier里提供的属性在GetModifierProperty函数里加起来返回。

		如果需要修改加法规则可以额外填格式，例如：
		属性名称 = {sFunctionName = "属性函数名", funcSettleCallback = SubtractionMultiplicationPercentage} 或 属性名称 = {"属性函数名", SubtractionMultiplicationPercentage} (如果用第二种写法省略变量名的话，就必须全部变量名都省略)
		其中SubtractionMultiplicationPercentage函数是固定参量(a, b)的函数，a和b分别为上一次的值和新获取到的值（两者都为nil的话，为定义a的初始值），函数需要返回下次运算时的a值。

		实际效果在发挥对应效果的地方使用GetModifierProperty来获取数值。
]]
--
-- 属性声明
xpcall(function()
	_G.EOM_MODIFIER_PROPERTIES = require("modifiers/declaration/EOM_MODIFIER_PROPERTIES")
end, function()
	_G.EOM_MODIFIER_PROPERTIES = {}
end)

_G.EOM_MODIFIER_PROPERTY_NAME = {}
_G.EOM_MODIFIER_PROPERTY_FUNCTIONS = {}
_G.EOM_MODIFIER_PROPERTY_INDEXES = {}
_G.EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA = {}

local _tSettleCallbacks = {}
local _tCheckValueCallbacks = {}
local _iIndex = _iEomModifierEventIndex
---@private
function _InitModifierProperty(sPropertyName, sFunctionName, funcSettleCallback, bIsPlayerProperty, funcCheckValueCallback)
	_G[sPropertyName] = _iIndex
	EOM_MODIFIER_PROPERTY_INDEXES[sPropertyName] = _iIndex
	EOM_MODIFIER_PROPERTY_NAME[_iIndex] = sPropertyName
	EOM_MODIFIER_PROPERTY_FUNCTIONS[_iIndex] = sFunctionName
	EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA[_iIndex] = bIsPlayerProperty
	_tSettleCallbacks[_iIndex] = funcSettleCallback
	_tCheckValueCallbacks[_iIndex] = funcCheckValueCallback
	_iIndex = _iIndex + 1
end

for k, v in pairs(EOM_MODIFIER_PROPERTIES) do
	if type(k) ~= "number" then
		local sPropertyName = k
		if type(v) == "string" then
			_InitModifierProperty(sPropertyName, v)
		elseif type(v) == "table" then
			local sFunctionName = v.sFunctionName
			if type(sFunctionName) == "string" then
				_InitModifierProperty(sPropertyName, sFunctionName, v.funcSettleCallback, v.bIsPlayerProperty, v.funcCheckValueCallback)
			else
				local iLength = #v
				sFunctionName = v[1]
				if type(sFunctionName) == "string" then
					if iLength == 1 then
						_InitModifierProperty(sPropertyName, sFunctionName)
					elseif iLength == 2 then
						if type(v[2]) == "boolean" then
							_InitModifierProperty(sPropertyName, sFunctionName, nil, v[2])
						else
							_InitModifierProperty(sPropertyName, sFunctionName, v[2])
						end
					elseif iLength == 3 then
						if type(v[2]) == "boolean" then
							_InitModifierProperty(sPropertyName, sFunctionName, nil, v[2], v[3])
						elseif type(v[3]) == "boolean" then
							_InitModifierProperty(sPropertyName, sFunctionName, v[2], v[3])
						else
							_InitModifierProperty(sPropertyName, sFunctionName, v[2], nil, v[3])
						end
					elseif iLength == 4 then
						_InitModifierProperty(sPropertyName, sFunctionName, v[2], v[3], v[4])
					end
				end
			end
		end
	end
end

-- 血量更新的属性
_G.UPDATE_HEALTH_PROPERTY = {
	[EOM_MODIFIER_PROPERTY_HEALTH_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_HEALTH_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_HEALTH_PERCENT_ENEMY] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_STRENGTH_BASE_PERCENTAGE] = true,
}

-- 蓝量更新的属性
_G.UPDATE_MANA_PROPERTY = {
	[EOM_MODIFIER_PROPERTY_MANA_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_MANA_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_ALL_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_PERCENTAGE] = true,
	[EOM_MODIFIER_PROPERTY_STATS_INTELLECT_BASE_PERCENTAGE] = true,
}

function CDOTA_Buff:RefreshModifierProperties(iProperty, fValue)
	local hParent = self:GetParent()

	local fManaPercent
	if IsServer() then
		fManaPercent = hParent:GetMana() / hParent:GetMaxMana()
	end

	SetModifierProperty(hParent, self, iProperty, fValue)

	if IsServer() then
		if UPDATE_HEALTH_PROPERTY[iProperty] then
			hParent:CalculateHealth()
		end
		if UPDATE_MANA_PROPERTY[iProperty] then
			hParent:CalculateGenericBonuses()
			hParent:SetMana(fManaPercent * hParent:GetMaxMana())
		end
	end
end

function SetModifierProperty(hUnit, hModifier, iProperty, fValue)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	local bIsPlayerProperty = EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if bIsPlayerProperty then
			local iPlayerID = hUnit:GetPlayerOwnerID()
			if iPlayerID ~= -1 then
				MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] or {}
				hUnit = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID]
			end
		end
		if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
		if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

		local tPropertyValues = hUnit.tPropertyValues[iProperty]
		local funcSettleCallback = _tSettleCallbacks[iProperty]
		local funcCheckValueCallback = _tCheckValueCallbacks[iProperty]

		tPropertyValues[hModifier] = fValue

		tPropertyValues.fValue = 0
		if funcSettleCallback ~= nil then
			tPropertyValues.fValue = funcSettleCallback()
		end
		for hModifier, fValue in pairs(tPropertyValues) do
			if type(hModifier) == "table" then
				if funcCheckValueCallback ~= nil then
					fValue = funcCheckValueCallback(fValue) or fValue
				end
				if funcSettleCallback ~= nil then
					tPropertyValues.fValue = funcSettleCallback(tPropertyValues.fValue, fValue)
				else
					tPropertyValues.fValue = tPropertyValues.fValue + fValue
				end
			end
		end

		if tPropertyValues.fValue == ZERO_VALUE then
			tPropertyValues.fValue = 0
		end
	end
end

function RegisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	local bIsPlayerProperty = EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if bIsPlayerProperty then
			local iPlayerID = hUnit:GetPlayerOwnerID()
			if iPlayerID ~= -1 then
				MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] or {}
				hUnit = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID]
			else
				return
			end
		end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		for i = #tPropertyModifers, 1, -1 do
			if not IsValid(tPropertyModifers[i]) then
				table.remove(tPropertyModifers, i)
			end
		end
		table.insert(tPropertyModifers, hModifier)

		table.sort(tPropertyModifers, function(a, b)
			local iPriorityA = type(a.GetPriority) == "function" and a:GetPriority() or MODIFIER_PRIORITY_NORMAL
			local iPriorityB = type(b.GetPriority) == "function" and b:GetPriority() or MODIFIER_PRIORITY_NORMAL
			return iPriorityA < iPriorityB
		end)
	elseif EOM_MODIFIER_EVENTS[iProperty] then
		AddModifierEvents(iProperty, hModifier)
	end
end

function UnregisterModifierProperty(hUnit, hModifier, iProperty)
	local sPropertyName = EOM_MODIFIER_PROPERTY_NAME[iProperty]
	local bIsPlayerProperty = EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA[iProperty]
	if EOM_MODIFIER_PROPERTIES[sPropertyName] ~= nil then
		if hUnit == nil then return end
		if bIsPlayerProperty then
			local iPlayerID = hUnit:GetPlayerOwnerID()
			if iPlayerID ~= -1 then
				MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] or {}
				hUnit = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID]
			else
				return
			end
		end
		if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
		if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end

		local tPropertyModifers = hUnit.tPropertyModifers[iProperty]

		for i = #tPropertyModifers, 1, -1 do
			if not IsValid(tPropertyModifers[i]) or tPropertyModifers[i] == hModifier then
				table.remove(tPropertyModifers, i)
			end
		end
	elseif EOM_MODIFIER_EVENTS[iProperty] then
		RemoveModifierEvents(iProperty, hModifier)
	end
end

function GetModifierProperty(hUnit, iProperty, tParams)
	local bIsPlayerProperty = EOM_MODIFIER_PROPERTY_IS_PLAYER_DATA[iProperty]
	if bIsPlayerProperty and type(hUnit) == "number" then
		local iPlayerID = hUnit
		if iPlayerID ~= -1 then
			MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID] or {}
			hUnit = MODIFIER_PROPERTY_PLAYER_DATA[iPlayerID]
		else
			return 0
		end
	end
	if hUnit == nil then return 0 end
	if hUnit.tPropertyModifers == nil then hUnit.tPropertyModifers = {} end
	if hUnit.tPropertyModifers[iProperty] == nil then hUnit.tPropertyModifers[iProperty] = {} end
	if hUnit.tPropertyValues == nil then hUnit.tPropertyValues = {} end
	if hUnit.tPropertyValues[iProperty] == nil then hUnit.tPropertyValues[iProperty] = {} end

	local tPropertyModifers = hUnit.tPropertyModifers[iProperty]
	local tPropertyValues = hUnit.tPropertyValues[iProperty]
	local funcSettleCallback = _tSettleCallbacks[iProperty]
	local funcCheckValueCallback = _tCheckValueCallbacks[iProperty]
	local sFunctionName = EOM_MODIFIER_PROPERTY_FUNCTIONS[iProperty]

	local fPropertyValue = tPropertyValues.fValue
	if fPropertyValue ~= nil and funcCheckValueCallback ~= nil then
		fPropertyValue = funcCheckValueCallback(fPropertyValue, tParams) or fPropertyValue
	end

	local fTotalValue = fPropertyValue or 0
	if funcSettleCallback ~= nil then
		fTotalValue = funcSettleCallback()
		if fPropertyValue ~= nil then
			fTotalValue = funcSettleCallback(fTotalValue, fPropertyValue)
		end
	end

	for i = #tPropertyModifers, 1, -1 do
		local hModifier = tPropertyModifers[i]
		if IsValid(hModifier) and type(hModifier[sFunctionName]) == "function" then
			local fValue = hModifier[sFunctionName](hModifier, tParams)
			if fValue ~= nil then
				if funcCheckValueCallback ~= nil then
					fValue = funcCheckValueCallback(fValue, tParams) or fValue
				end
				if funcSettleCallback ~= nil then
					fTotalValue = funcSettleCallback(fTotalValue, fValue)
				else
					fTotalValue = fTotalValue + fValue
				end
			end
		else
			table.remove(tPropertyModifers, i)
		end
	end

	if fTotalValue == ZERO_VALUE then
		fTotalValue = 0
	end
	return fTotalValue
end