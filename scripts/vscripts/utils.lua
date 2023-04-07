function IsArray(t)
	if type(t) ~= "table" then
		return false
	end

	local n = #t
	for i, v in pairs(t) do
		if type(i) ~= "number" then
			return false
		end

		if i > n then
			return false
		end
	end

	return true
end
-- 获取文件域
function getFileScope(self)
	local level = 1
	while true do
		local info = debug.getinfo(level, "S")
		if info and (info.what == "main") then
			return {
				getfenv(level),
				info.source
			}
		end
		level = level + 1
	end
end

--[[	将字符串按照条件表达式分解，传入回调func，func需要返回boolean值，最后返回boolean值查看表达式最终结果
	例：
		local bool = parse_conditional("a&(b|c)", function(str)
			if str == "a" then
				return false
			elseif str == "b" then
				return true
			elseif str == "c" then
				return false
			end
			return false
		end)
		这里bool值最终为 bool = false and (true or false) => bool = false
]]
--
function parse_conditional(s, func)
	function split_conditional(str)
		local sp = "[&|]"
		local result = {}
		local i = 0
		local j = 0
		local num = 1
		local pos = 0
		local last_operator
		while true do
			i, j = string.find(str, sp, i + 1)
			if i == nil then
				result[num] = {
					str = string.sub(str, pos, string.len(str)),
					operator = last_operator,
				}
				break
			end
			result[num] = {
				str = string.sub(str, pos, i - 1),
				operator = last_operator,
			}
			pos = i + (j - (i - 1))
			num = num + 1
			last_operator = string.sub(str, i, j)
		end
		return result
	end

	local bool
	s = string.gsub(s, "%s", "")
	while true do
		local i, j = string.find(s, "%b()")
		if i == nil then
			break
		end
		bool = parse_conditional(string.sub(s, i + 1, j - 1), func)
		s = string.sub(s, 1, i - 1) .. tostring(bool) .. string.sub(s, j + 1, -1)
	end
	local a = split_conditional(s)
	for i, v in ipairs(a) do
		local result
		if v.str ~= "false" and v.str ~= "true" then
			result = func(v.str)
		else
			result = v.str == "true"
		end
		if bool == nil then
			bool = result
		elseif v.operator == nil then
			bool = result
		elseif v.operator == "|" then
			bool = bool or result
		elseif v.operator == "&" then
			bool = bool and result
		end
	end
	return bool or false
end

-- 分割字符串
function string.split(str, sp)
	local result = {}
	local i = 0
	local j = 0
	local num = 1
	local pos = 0
	while true do
		i, j = string.find(str, sp, i + 1)
		if i == nil then
			result[num] = string.sub(str, pos, string.len(str))
			break
		end
		result[num] = string.sub(str, pos, i - 1)
		pos = i + (j - (i - 1))
		num = num + 1
	end
	return result
end

-- 分割字符串
function string.osplit(str, delimiter)
	local rt = {}
	string.gsub(str, '[^' .. delimiter .. ']+', function(w) table.insert(rt, w) end)
	return rt
end

-- 分割字符串的字母
function string.gsplit(str)
	local str_tb = {}
	if string.len(str) ~= 0 then
		for i = 1, string.len(str) do
			new_str = string.sub(str, i, i)
			if (string.byte(new_str) >= 48 and string.byte(new_str) <= 57) or (string.byte(new_str) >= 65 and string.byte(new_str) <= 90) or (string.byte(new_str) >= 97 and string.byte(new_str) <= 122) then
				table.insert(str_tb, string.sub(str, i, i))
			else
				return nil
			end
		end
		return str_tb
	else
		return nil
	end
end

-- 将数组用字符串连接
function string.join(table, delimiter)
	DoScriptAssert(type(table) == "table", "first parameter must be a table!")
	DoScriptAssert(type(delimiter) == "string", "second parameter must be a string!")
	local str = ""
	for i, v in ipairs(table) do
		if str ~= "" then
			str = str .. delimiter
		end
		str = str .. tostring(v)
	end
	return str
end

function IsLeapYear(iYear)
	return (iYear % 4 == 0 and iYear % 100 ~= 0) or (iYear % 400 == 0)
end

function toUnixTime(iYear, iMonth, iDay, iHour, iMin, iSec)
	local iTotalSec = iSec + iMin * 60 + iHour * 60 * 60 + (iDay - 1) * 86400

	-- 此年经过的秒
	local iTotalDay = 0
	local iTotalMonth = iMonth - 1
	for i = 1, iTotalMonth, 1 do
		if i == 1 or i == 3 or i == 5 or i == 7 or i == 8 or i == 10 or i == 12 then
			iTotalDay = iTotalDay + 31
		elseif i == 4 or i == 6 or i == 9 or i == 11 then
			iTotalDay = iTotalDay + 30
		else
			if IsLeapYear(iYear) then
				iTotalDay = iTotalDay + 29
			else
				iTotalDay = iTotalDay + 28
			end
		end
	end

	-- 之前的年经过的秒
	for i = 1970, iYear - 1, 1 do
		if IsLeapYear(i) then
			iTotalDay = iTotalDay + 366
		else
			iTotalDay = iTotalDay + 365
		end
	end

	iTotalSec = iTotalSec + iTotalDay * 86400

	return iTotalSec
end
-- 返回表的值数量
function TableCount(t)
	local n = 0
	for _ in pairs(t) do
		n = n + 1
	end
	return n
end

-- 获取表里随机一个值
function RandomValue(t)
	if TableCount(t) == 0 then
		return nil
	end
	local iRandom = RandomInt(1, TableCount(t))
	local n = 0
	for k, v in pairs(t) do
		n = n + 1
		if n == iRandom then
			return v
		end
	end
end

-- 获取数组里随机一个值
---@return any
function GetRandomElement(table)
	return table[RandomInt(1, #table)]
end

-- 从表里寻找值的键
function TableFindKey(t, v)
	if t == nil then
		return nil
	end

	for _k, _v in pairs(t) do
		if v == _v then
			return _k
		end
	end
	return nil
end

-- 数组合并
function ArrayConcat(t1, t2)
	if type(t1) ~= "table" then return end
	if type(t2) ~= "table" then return end
	for i, v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

-- 从表里移除值
function ArrayRemove(t, v)
	if t == nil then return end
	for i = #t, 1, -1 do
		if t[i] == v then
			table.remove(t, i)
			return v, i
		end
	end
end

-- 深拷贝
function deepcopy(orig)
	local copy
	if type(orig) == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

-- 浅拷贝
function shallowcopy(orig)
	local copy
	if type(orig) == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

-- 乱序
function ShuffledList(orig_list)
	local list = shallowcopy(orig_list)
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt(1, #list)
		result[#result + 1] = list[pick]
		table.remove(list, pick)
	end
	return result
end

-- table覆盖
function TableOverride(mainTable, table)
	if mainTable == nil then
		return table
	end
	if table == nil or type(table) ~= "table" then
		return mainTable
	end

	for k, v in pairs(table) do
		if type(v) == "table" then
			mainTable[k] = TableOverride(mainTable[k], v)
		else
			mainTable[k] = v
		end
	end
	return mainTable
end

-- table替换
function TableReplace(mainTable, table)
	if mainTable == nil then
		return table
	end
	if table == nil or type(table) ~= "table" then
		return mainTable
	end

	for k, v in pairs(table) do
		if mainTable[k] ~= nil then
			if type(v) == "table" then
				mainTable[k] = TableOverride(mainTable[k], v)
			else
				mainTable[k] = v
			end
		end
	end
	return mainTable
end

-- 四舍五入，s为小数点几位
function Round(n, s)
	s = math.pow(10, -s)
	local sign = 1
	if n < 0 then
		n = math.abs(n)
		sign = -1
	end
	s = s or 1
	if n ~= nil then
		local d = n / s
		local w = math.floor(d)
		if d - w >= 0.5 then
			return (w + 1) * s * sign
		else
			return w * s * sign
		end
	end
	return 0
end

-- 判断两条线是否相交
function IsLineCross(pt1_1, pt1_2, pt2_1, pt2_2)
	return math.min(pt1_1.x, pt1_2.x) <= math.max(pt2_1.x, pt2_2.x) and math.min(pt2_1.x, pt2_2.x) <= math.max(pt1_1.x, pt1_2.x) and math.min(pt1_1.y, pt1_2.y) <= math.max(pt2_1.y, pt2_2.y) and math.min(pt2_1.y, pt2_2.y) <= math.max(pt1_1.y, pt1_2.y)
end

-- 跨立实验
function IsCross(p1, p2, p3)
	local x1 = p2.x - p1.x
	local y1 = p2.y - p1.y
	local x2 = p3.x - p1.x
	local y2 = p3.y - p1.y
	return x1 * y2 - x2 * y1
end

-- 判断两条线段是否相交
function IsIntersect(p1, p2, p3, p4)
	if IsLineCross(p1, p2, p3, p4) then
		if IsCross(p1, p2, p3) * IsCross(p1, p2, p4) <= 0 and IsCross(p3, p4, p1) * IsCross(p3, p4, p2) <= 0 then
			return true
		end
	end
	return false
end

-- 计算两条线段的交点
function GetCrossPoint(p1, p2, q1, q2)
	if IsIntersect(p1, p2, q1, q2) then
		local x = 0
		local y = 0
		local left = (q2.x - q1.x) * (p1.y - p2.y) - (p2.x - p1.x) * (q1.y - q2.y)
		local right = (p1.y - q1.y) * (p2.x - p1.x) * (q2.x - q1.x) + q1.x * (q2.y - q1.y) * (p2.x - p1.x) - p1.x * (p2.y - p1.y) * (q2.x - q1.x)

		if left == 0 then
			return vec3_invalid
		end
		x = right / left

		left = (p1.x - p2.x) * (q2.y - q1.y) - (p2.y - p1.y) * (q1.x - q2.x)
		right = p2.y * (p1.x - p2.x) * (q2.y - q1.y) + (q2.x - p2.x) * (q2.y - q1.y) * (p1.y - p2.y) - q2.y * (q1.x - q2.x) * (p2.y - p1.y)
		if left == 0 then
			return vec3_invalid
		end
		y = right / left

		return Vector(x, y, 0)
	end

	return vec3_invalid
end

-- 贝塞尔曲线
function Bessel(t, ...)
	local tPoints = { ... }
	if #tPoints == 1 then
		return tPoints[1]
	elseif #tPoints > 1 then
		while #tPoints > 2 do
			local tNewPoints = {}
			for i = 1, #tPoints - 1, 1 do
				local vPoint = VectorLerp(t, tPoints[i], tPoints[i + 1])
				table.insert(tNewPoints, vPoint)
			end
			tPoints = tNewPoints
		end
		return VectorLerp(t, tPoints[1], tPoints[2])
	end
end

-- 将c++里传出来的str形式的vector转换为vector
function StringToVector(str)
	if str == nil then return end
	local table = string.split(str, " ")
	return Vector(tonumber(table[1] or "0"), tonumber(table[2] or "0"), tonumber(table[3] or "0"))
end

function VectorToString(v)
	if v == nil then return end
	return tostring(v.x) .. " " .. tostring(v.y) .. " " .. tostring(v.z)
end

---以逆时针方向旋转
function Rotation2D(vVector, radian)
	local fLength2D = vVector:Length2D()
	local vUnitVector2D = vVector / fLength2D
	local fCos = math.cos(radian)
	local fSin = math.sin(radian)
	return Vector(vUnitVector2D.x * fCos - vUnitVector2D.y * fSin, vUnitVector2D.x * fSin + vUnitVector2D.y * fCos, vUnitVector2D.z) * fLength2D
end

-- 判断点是否在不规则图形里（不规则图形里是点集，点集每个都是固定住的）
function IsPointInPolygon(point, polygonPoints)
	local j = #polygonPoints
	local bool = 0
	for i = 1, #polygonPoints, 1 do
		local polygonPoint1 = polygonPoints[j]
		local polygonPoint2 = polygonPoints[i]
		if ((polygonPoint2.y < point.y and polygonPoint1.y >= point.y) or (polygonPoint1.y < point.y and polygonPoint2.y >= point.y)) and (polygonPoint2.x <= point.x or polygonPoint1.x <= point.x) then
			bool = bit.bxor(bool, ((polygonPoint2.x + (point.y - polygonPoint2.y) / (polygonPoint1.y - polygonPoint2.y) * (polygonPoint1.x - polygonPoint2.x)) < point.x and 1 or 0))
		end
		j = i
	end
	return bool == 1
end

---判断一个handle是否为无效值
function IsValid(h)
	return h ~= nil and not h:IsNull()
end

---默认值（按参数顺序取第一个非空值）
function default(...)
	for i = 1, select('#', ...) do
		local v = select(i, ...)
		if v ~= nil then
			return v
		end
	end
end

--颜色
local __msg_type = {}
local __color = {
	red	= { 255, 0, 0 },
	orange	= { 255, 127, 0 },
	yellow	= { 255, 255, 0 },
	green	= { 0, 255, 0 },
	blue	= { 0, 0, 255 },
	indigo	= { 0, 255, 255 },
	purple	= { 255, 0, 255 },
}

--定义常量
MSG_BLOCK		= "particles/msg_fx/msg_block.vpcf"
MSG_ORIT		= "particles/msg_fx/msg_crit.vpcf"
MSG_DAMAGE		= "particles/msg_fx/msg_damage.vpcf"
MSG_EVADE		= "particles/msg_fx/msg_evade.vpcf"
MSG_GOLD		= "particles/msg_fx/msg_gold.vpcf"
MSG_HEAL		= "particles/msg_fx/msg_heal.vpcf"
MSG_MANA_ADD	= "particles/msg_fx/msg_mana_add.vpcf"
MSG_MANA_LOSS	= "particles/msg_fx/msg_mana_loss.vpcf"
MSG_MISS		= "particles/msg_fx/msg_miss.vpcf"
MSG_POISION		= "particles/msg_fx/msg_poison.vpcf"
MSG_SPELL		= "particles/msg_fx/msg_spell.vpcf"
MSG_XP			= "particles/msg_fx/msg_xp.vpcf"

table.insert(__msg_type, MSG_BLOCK)
table.insert(__msg_type, MSG_ORIT)
table.insert(__msg_type, MSG_DAMAGE)
table.insert(__msg_type, MSG_EVADE)
table.insert(__msg_type, MSG_GOLD)
table.insert(__msg_type, MSG_HEAL)
table.insert(__msg_type, MSG_MANA_ADD)
table.insert(__msg_type, MSG_MANA_LOSS)
table.insert(__msg_type, MSG_MISS)
table.insert(__msg_type, MSG_POISION)
table.insert(__msg_type, MSG_SPELL)
table.insert(__msg_type, MSG_XP)

--显示数字特效，可指定颜色，符号
function CreateNumberEffect(...)
	local entity, number, duration, msg_type, color, icon_type = ...
	--判断实体
	if entity:IsAlive() == nil then
		return
	end
	icon_type = icon_type or 9

	--对采用的特效进行判断
	local is_msg_type = false
	for k, v in pairs(__msg_type) do
		if msg_type == v then
			is_msg_type = true;
			break;
		end
	end

	--判断颜色
	if type(color) == "string" then
		color = __color[color] or { 255, 255, 255 }
	else
		if #color ~= 3 then
		end
	end
	local color_r = tonumber(color[1]) or 255;
	local color_g = tonumber(color[2]) or 255;
	local color_b = tonumber(color[3]) or 255;
	local color_vec = Vector(color_r, color_g, color_b);

	--处理数字
	number = math.floor(number)
	local number_count = #tostring(number) + 1

	--创建特效
	local particle = ParticleManager:CreateParticle(msg_type, PATTACH_CUSTOMORIGIN_FOLLOW, entity)
	ParticleManager:SetParticleControlEnt(particle, 0, entity, 5, "attach_hitloc", entity:GetOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, Vector(10, number, icon_type))
	ParticleManager:SetParticleControl(particle, 2, Vector(duration, number_count, 0))
	ParticleManager:SetParticleControl(particle, 3, color_vec)
	ParticleManager:ReleaseParticleIndex(particle)
end

---创建modifierthinker
---@return CDOTA_BaseNPC
function CreateThinker(hCaster, hAbility, vPosition, sModifierName, hModifierTable)
	return CreateModifierThinker(hCaster, hAbility, sModifierName, hModifierTable, vPosition, hCaster:GetTeamNumber(), false)
end

---获取单位战斗力
function GetPowerValue(hUnit)
	if type(hUnit) ~= "table" or not IsValid(hUnit) then
		return 0
	end
	local fHealth = GetHealth(hUnit)

	return (GetAttackDamage(hUnit) + GetArmor(hUnit) * 150 + GetAttackReduceArmor(hUnit) * (1 + GetAttackReduceArmorPercent(hUnit) * 0.01) * 500 + fHealth / 1.5) * 0.01
	* (1 + hUnit:GetIncreasedAttackSpeed() * 0.02)
	* (1 + (-GetIncomingPhysicalDamagePercent(hUnit) * 0.005 - GetIncomingPhysicalDamagePercent(hUnit) * 0.005) * 0.5)
	* (1 + (GetOutgoingPhysicalDamagePercent(hUnit) * 0.005 + GetOutgoingMagicalDamagePercent(hUnit) * 0.005) * 0.15)
	* (1 + GetEvasion(hUnit) * 0.5)
	* (1 + (GetPhysicalLifesteal(hUnit) * 0.005 + GetMagicalLifesteal(hUnit) * 0.005) * 0.001)
	* (1 + (GetPhysicalCriticalStrikeChance(hUnit) * 0.01 * GetPhysicalCriticalStrikeDamage(hUnit) * 0.01) / 300)
	* (1 + (GetMagicalCriticalStrikeChance(hUnit) * 0.01 * GetMagicalCriticalStrikeDamage(hUnit) * 0.01) / 300)
	* (1 + (GetHealthRegen(hUnit) / fHealth) * 0.02)
end
----------------------------------------CDOTA_BaseNPC----------------------------------------
local BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC

---获取弹道
function BaseNPC:GetProjectileName()
	return GetModifierProjectileName(self)
end

function BaseNPC:GetRebornTimes()
	return self:HasModifier("modifier_reborn") and self:GetModifierStackCount("modifier_reborn", self) or 0
end
function BaseNPC:GetScepterLevel()
	return (self:HasModifier("modifier_reborn") and self:HasScepter()) and self:GetRebornTimes() or 0
end

----------------------------------------CBaseEntity----------------------------------------
local BaseEntity = IsServer() and CBaseEntity or C_BaseEntity

--[[		计时器
	sContextName，计时器索引，可缺省
	fInterval，第一次运行延迟
	funcThink，回调函数，函数返回number将会再次延迟运行
	例：
	hUnit:GameTimer(0.5, function()
		hUnit:SetModelScale(1.5)
	end)
	GameRules:GetGameModeEntity():GameTimer(0.5, function()
		print(math.random())
		return 0.5
	end)
]]
--
function BaseEntity:Timer(sContextName, fInterval, funcThink)
	if funcThink == nil then
		funcThink = fInterval
		fInterval = sContextName
		sContextName = DoUniqueString("Timer")
	end
	self:SetContextThink(sContextName, function()
		local result = funcThink()
		if type(result) == "number" then
			result = math.max(FrameTime(), result)
		end
		return result
	end, fInterval)
	return sContextName
end
---游戏计时器，游戏暂停会停下
function BaseEntity:GameTimer(sContextName, fInterval, funcThink)
	if funcThink == nil then
		funcThink = fInterval
		fInterval = sContextName
		sContextName = DoUniqueString("GameTimer")
	end
	local fTime = GameRules:GetGameTime() + math.max(FrameTime(), fInterval)
	return self:Timer(sContextName, fInterval, function()
		if GameRules:GetGameTime() >= fTime then
			local result = funcThink()
			if type(result) == "number" then
				fTime = fTime + math.max(FrameTime(), result)
			end
			return result
		end
		return 0
	end)
end
---结束计时器
---@param sContextName 计时器名字
function BaseEntity:StopTimer(sContextName)
	self:SetContextThink(sContextName, nil, -1)
end

function GetHealthBarWidth(hUnit)
	return tonumber(KeyValues:GetUnitData(hUnit, "HealthBarWidth")) or -1
end

function GetHealthBarHeight(hUnit)
	return tonumber(KeyValues:GetUnitData(hUnit, "HealthBarHeight")) or -1
end

if IsClient() then
	function C_DOTA_BaseNPC:GetCustomMaxHealth()
		return GetHealth(self)
	end
end

if IsServer() then
	--- 游戏计时器，游戏暂停会停下 GameRules:GetGameModeEntity():GameTimer()
	function GameTimer(sContextName, fInterval, funcThink)
		return GameRules:GetGameModeEntity():GameTimer(sContextName, fInterval, funcThink)
	end
	function StopGameTimer(sContextName)
		return GameRules:GetGameModeEntity():StopTimer(sContextName)
	end
	--- 游戏计时器，游戏暂停bu会停下 GameRules:GetGameModeEntity():GameTimer()
	function Timer(sContextName, fInterval, funcThink)
		return GameRules:GetGameModeEntity():Timer(sContextName, fInterval, funcThink)
	end
	function StopTimer(sContextName)
		return GameRules:GetGameModeEntity():StopTimer(sContextName)
	end

	function DisplayCustomContextualTip(iPlayerID, sText, flDuration, tReferenceAbilities, tReferenceUnits, tPanoramaClasses)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "DisplayCustomContextualTip", { sText = sText, flDuration = flDuration, tReferenceAbilities = tReferenceAbilities, tReferenceUnits = tReferenceUnits, tPanoramaClasses = tPanoramaClasses })
	end

	function CBaseEntity:IsAbility()
		return false
	end
	function CBaseEntity:IsPositionInBounding(vPosition)
		local tBounds = self:GetBounds()
		local vMaxs = self:GetAbsOrigin() + tBounds.Maxs
		local vMins = self:GetAbsOrigin() + tBounds.Mins
		if vPosition.x <= vMaxs.x and vPosition.x >= vMins.x and vPosition.y <= vMaxs.y and vPosition.y >= vMins.y then
			return true
		end
		return false
	end

	function CDOTABaseAbility:IsAbility()
		return true
	end

	---获取物品在单位背包中的位置
	function CDOTA_BaseNPC:GetItemSlot(hItem)
		if hItem == nil or not hItem:IsItem() then
			return -1
		end
		for i = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
			local item = self:GetItemInSlot(i)
			if item ~= nil and item == hItem then
				return i
			end
		end
		return -1
	end

	function CDOTA_BaseNPC:ModifyMaxHealth(fChanged)
		if true then
			return
		end
		local fHealthPercent = self:GetHealth() / self:GetMaxHealth()
		self.fBaseHealth = (self.fBaseHealth or self:GetMaxHealth()) + fChanged
		local fAddHpPercent = GetHealthPercentage ~= nil and (GetHealthPercentage(self) or 0) * 0.01 or 0
		local fEnemyHpPercent = GetHealthPercentageEnemy ~= nil and (GetHealthPercentageEnemy(self) or 0) * 0.01 or 0
		local fBonusHealth = (fAddHpPercent + fEnemyHpPercent) * self.fBaseHealth
		local fHealth = self.fBaseHealth + fBonusHealth
		local fCorrectHealth = Clamp(fHealth, 0, MAX_HEALTH)
		self:SetBaseMaxHealth(fCorrectHealth)
		self:SetMaxHealth(fCorrectHealth)
		self:ModifyHealth(fHealthPercent * fCorrectHealth, nil, true, 0)
	end

	function CDOTA_BaseNPC:CalculateHealth()
		-- local hModifier = self:FindModifierByName("modifier_common")
		-- if IsValid(hModifier) then
		-- 	hModifier:CalculateHealth()
		-- end
	end
	if CDOTA_BaseNPC.ModifyHealth_Engine == nil then
		---@private
		CDOTA_BaseNPC.ModifyHealth_Engine = CDOTA_BaseNPC.ModifyHealth
	end
	function CDOTA_BaseNPC:ModifyHealth(iHealth, hAbility, bLethal, iAdditionalFlags)
		local fValue = iHealth / self:GetCustomMaxHealth() * self:GetMaxHealth()
		self:ModifyHealth_Engine(fValue, hAbility, bLethal, iAdditionalFlags)
	end
	function CDOTA_BaseNPC:GetCustomMaxHealth()
		return GetHealth(self)
	end
	if CDOTA_BaseNPC.GetHealthDeficit_Engine == nil then
		---@private
		CDOTA_BaseNPC.GetHealthDeficit_Engine = CDOTA_BaseNPC.GetHealthDeficit
	end
	function CDOTA_BaseNPC:GetHealthDeficit()
		return self:GetHealthDeficit_Engine() / self:GetMaxHealth() * GetHealth(self)
	end
	function CDOTA_BaseNPC:GetCustomHealth()
		return self:GetHealth() / self:GetMaxHealth() * GetHealth(self)
	end

	if CDOTA_BaseNPC.Heal_Engine == nil then
		CDOTA_BaseNPC.Heal_Engine = CDOTA_BaseNPC.Heal
	end
	function CDOTA_BaseNPC:Heal(flAmount, hInflictor, bShowOverhead)
		if IsValid(self) and self:IsAlive() then
			if bShowOverhead == nil then bShowOverhead = false end
			local fValue = math.min(flAmount / self:GetCustomMaxHealth(), (self:GetMaxHealth() - self:GetHealth()) / self:GetMaxHealth()) * self:GetMaxHealth()
			self:SetHealth(self:GetHealth() + fValue)
			if bShowOverhead and IsValid(hInflictor) and type(hInflictor.GetCaster) == "function" then
				local hCaster = hInflictor:GetCaster()
				if IsValid(hCaster) then
					SendOverheadEventMessage(self:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self, fValue / self:GetMaxHealth() * self:GetCustomMaxHealth(), hCaster:GetPlayerOwner())
				end
			end
		end
	end

	function CDOTA_BaseNPC:CalculateItemProperties()
		local hModifier = self:FindModifierByName("modifier_attribute")
		if IsValid(hModifier) then
			hModifier:CalculateItemProperties()
		end
	end

	function CDOTA_BaseNPC:FindModifierByNameAndAbility(sModifierName, hAbility)
		local tModifiers = self:FindAllModifiersByName(sModifierName)
		for _, hModifier in pairs(tModifiers) do
			if hModifier:GetAbility() == hAbility then
				return hModifier
			end
		end
	end

	function CDOTA_BaseNPC:GetDummyAbility()
		return self:FindAbilityByName("unit_state")
	end

	function CDOTA_BaseNPC:BonusesChangedProc(func)
		self:CalculateGenericBonuses()
		local fManaPercent = self:GetMana() / self:GetMaxMana()
		local result = func()
		self:CalculateGenericBonuses()
		self:SetMana(fManaPercent * self:GetMaxMana())
		self:CalculateHealth()
		return result
	end

	if CDOTA_BaseNPC.AddActivityModifier_Engine == nil then
		CDOTA_BaseNPC.AddActivityModifier_Engine = CDOTA_BaseNPC.AddActivityModifier
	end
	---@private
	function CDOTA_BaseNPC:_updateActivityModifier()
		if self._tActivityModifiers == nil then self._tActivityModifiers = {} end

		self:ClearActivityModifiers()

		for i = #self._tActivityModifiers, 1, -1 do
			self:AddActivityModifier_Engine(self._tActivityModifiers[i])
		end
	end

	function CDOTA_BaseNPC:AddActivityModifier(sName)
		if self._tActivityModifiers == nil then self._tActivityModifiers = {} end

		table.insert(self._tActivityModifiers, sName)

		self:_updateActivityModifier(self)
	end

	function CDOTA_BaseNPC:RemoveActivityModifier(sName)
		if self._tActivityModifiers == nil then self._tActivityModifiers = {} end

		ArrayRemove(self._tActivityModifiers, sName)

		self:_updateActivityModifier(self)
	end

	if CDOTA_BaseNPC._StartGesture == nil then
		---@private
		CDOTA_BaseNPC._StartGesture = CDOTA_BaseNPC.StartGesture
	end
	if CDOTA_BaseNPC._FadeGesture == nil then
		---@private
		CDOTA_BaseNPC._FadeGesture = CDOTA_BaseNPC.FadeGesture
	end
	function CDOTA_BaseNPC:StartGesture(nActivity)
		if not IsValid(self) then return end
		if self.tGestures == nil then self.tGestures = {} end

		for _, _nActivity in ipairs(self.tGestures) do
			self:_FadeGesture(_nActivity)
		end
		self.tGestures = {}

		table.insert(self.tGestures, nActivity)

		self:_StartGesture(nActivity)
	end
	function CDOTA_BaseNPC:FadeGesture(nActivity)
		if not IsValid(self) then return end
		if self.tGestures == nil then self.tGestures = {} end

		for i, _nActivity in ipairs(self.tGestures) do
			if nActivity == _nActivity then
				self:_FadeGesture(_nActivity)
				table.remove(self.tGestures, i)
				break
			end
		end
	end

	---获取附着点位置
	function CDOTA_BaseNPC:GetAttachmentPosition(sAttach)
		return self:GetAttachmentOrigin(self:ScriptLookupAttachment(sAttach))
	end

	---增加永久增加的属性
	---@param iCustomAttributeType string 常量，例如：CUSTOM_ATTRIBUTE_STRENGTH
	---@param flValue number 增加的值
	---@param bIncrease boolean 是否会受增益影响，默认不影响
	function CDOTA_BaseNPC:AddPermanentAttribute(iCustomAttributeType, flValue, bIncrease)
		if self.tPermanentAttribute == nil or not PlayerResource or not PlayerResource:IsValidPlayerID(self:GetPlayerOwnerID()) then
			return
		end
		bIncrease = default(bIncrease, false)
		if bIncrease then
			flValue = flValue * (1 + GetPlayerAttributeGainPercent(self:GetPlayerOwnerID()) * 0.01)
		end
		self.tPermanentAttribute[iCustomAttributeType] = self.tPermanentAttribute[iCustomAttributeType] + flValue

		local s = "AddPermanentAttribute" .. GetFrameCount()
		if self[s] == nil then
			self[s] = true
			self:Timer(s, 0, function()
				self[s] = nil
				local hModifier = self:FindModifierByName("modifier_attribute")
				if IsValid(hModifier) then
					hModifier:SendBuffRefreshToClients()
				end
			end)
		end
	end
	---获取永久增加的属性
	---@param iCustomAttributeType number 常量，例如：CUSTOM_ATTRIBUTE_STRENGTH
	function CDOTA_BaseNPC:GetPermanentAttribute(iCustomAttributeType)
		if self.hModifierAttribute.tPermanentAttribute == nil then
			return 0
		end
		return self.hModifierAttribute.tPermanentAttribute[iCustomAttributeType]
	end
	---增加护盾
	---@param hModifier CDOTA_Modifier_Lua 绑定的buff，可不填
	---@param flValue number 护盾生命值
	---@param iShieldType number 护盾类型，直接使用伤害类型常量指代抵挡该类型伤害，不填为DAMAGE_TYPE_ALL
	function CDOTA_BaseNPC:AddShield(flValue, hModifier, iShieldType)
		iShieldType = default(iShieldType, DAMAGE_TYPE_ALL)
		local tShieldList = {}
		if iShieldType == DAMAGE_TYPE_ALL then
			if self.hModifierAttribute then
				local tPhysicalShield = {
					iType = DAMAGE_TYPE_PHYSICAL,
					hModifier = hModifier,
					flValue = flValue,
				}
				table.insert(self.hModifierAttribute.tShieldData[DAMAGE_TYPE_PHYSICAL], tPhysicalShield)
				table.insert(tShieldList, tPhysicalShield)
				local tMagicalShield = {
					iType = DAMAGE_TYPE_MAGICAL,
					hModifier = hModifier,
					flValue = flValue,
				}
				table.insert(self.hModifierAttribute.tShieldData[DAMAGE_TYPE_MAGICAL], tMagicalShield)
				table.insert(tShieldList, tMagicalShield)
			end
		else
			if self.hModifierAttribute then
				local tData = {
					iType = iShieldType,
					hModifier = hModifier,
					flValue = flValue,
				}
				table.insert(self.hModifierAttribute.tShieldData[iShieldType], tData)
				table.insert(tShieldList, tData)
			end
		end
		return tShieldList
	end

	if CDOTA_BaseNPC._SpendMana == nil then
		---@private
		CDOTA_BaseNPC._SpendMana = CDOTA_BaseNPC.SpendMana
	end
	function CDOTA_BaseNPC:SpendMana(flManaSpent)
		self:SetMana(math.max(0, self:GetMana() - flManaSpent))
	end

	function CDOTABaseAbility:IsChargeable()
		return true
	end

	function CDOTABaseAbility:GetMaxCharges()
		return self.max_charges or 1
	end

	function CDOTABaseAbility:AddMaxCharges(max_charges)
		self:SetMaxCharges(self:GetMaxCharges() + max_charges)
	end

	function CDOTABaseAbility:AddCharges(iCharges)
		local hCaster = self:GetCaster()
		local iOldCharges = self:GetCharges()
		if iOldCharges + iCharges >= self:GetMaxCharges() then
			iCharges = self:GetMaxCharges() - iOldCharges
		end
		if iCharges > 0 then
			self:EndCooldown()
			local hModifier = hCaster:FindModifierByNameAndAbility("modifier_charges", self)
			if IsValid(hModifier) then
				hModifier:SetStackCount(iOldCharges + iCharges)
				if hModifier:GetStackCount() >= self:GetMaxCharges() then
					hModifier:StartIntervalThink(-1)
					hModifier:SetDuration(-1, true)
				end
			end
		end
	end

	function CDOTABaseAbility:GetCharges()
		local hCaster = self:GetCaster()
		local hModifier = hCaster:FindModifierByNameAndAbility("modifier_charges", self)
		if IsValid(hModifier) then
			return hModifier:GetStackCount()
		else
			if self:IsCooldownReady() then
				return 1
			else
				return 0
			end
		end
	end

	function CDOTABaseAbility:SetMaxCharges(max_charges, charge_restore_time)
		if self:IsChargeable() == false then
			return
		end

		self.max_charges = math.max(1, math.floor(max_charges))

		local hCaster = self:GetCaster()
		local params = {
			max_charges = max_charges,
			charge_restore_time = charge_restore_time,
		}
		local hModifier = hCaster:FindModifierByNameAndAbility("modifier_charges", self)
		if IsValid(hModifier) then
			hModifier:OnRefresh(params)
		else
			hCaster:AddNewModifier(hCaster, self, "modifier_charges", params)
		end
	end

	function EmitSoundForPlayer(sSoundName, iPlayerID)
		local hPlayer = PlayerResource:GetPlayer(iPlayerID)
		if hPlayer ~= nil then
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "emit_sound_for_player", { soundname = sSoundName })
		end
	end

	function EmitSoundForAll(sSoundName)
		CustomGameEventManager:Send_ServerToAllClients("emit_sound_for_player", { soundname = sSoundName })
	end

	-- 显示错误信息
	function ErrorMessage(playerID, message, sound)
		if message == nil then
			sound = message
			message = playerID
			playerID = nil
		else
			assert(type(playerID) == "number", "playerID is not a number")
		end
		if sound == nil then
			sound = "General.Cancel"
		end
		if playerID == nil then
			CustomGameEventManager:Send_ServerToAllClients("error_message", { message = message, sound = sound })
		else
			local player = PlayerResource:GetPlayer(playerID)
			CustomGameEventManager:Send_ServerToPlayer(player, "error_message", { message = message, sound = sound })
		end
	end

	-- 选择单位，unit可以为单位实体或单位index，也可以为单位实体数组或单位index数组
	function SelectUnit(playerID, unit)
		local units = ""
		if type(unit) == "table" then
			if type(unit.entindex) == "function" then
				units = tostring(unit:entindex())
			else
				for i, v in ipairs(unit) do
					if type(v) == "table" then
						if type(v.entindex) == "function" then
							if units ~= "" then units = units .. "," end
							units = units .. tostring(v:entindex())
						end
					elseif tonumber(v) ~= nil then
						if units ~= "" then units = units .. "," end
						units = units .. tostring(tonumber(v))
					end
				end
			end
		elseif tonumber(unit) ~= nil then
			units = tostring(tonumber(unit))
		end
		if playerID ~= nil then
			local player = PlayerResource:GetPlayer(playerID)
			CustomGameEventManager:Send_ServerToPlayer(player, "select_units", { units = units })
		end
	end

	---在单位周围丢下物品
	function DropItemAroundUnit(hDropUnit, item, hTargetUnit)
		if not IsValid(hDropUnit) then
			return
		end
		if not IsValid(hTargetUnit) then
			hTargetUnit = hDropUnit
		end
		local position = hTargetUnit:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0)
		hDropUnit:TakeItem(item)
		CreateItemOnPosition(position, item)
	end

	function CreateItemOnPosition(position, item)
		local hContainer = CreateItemOnPositionForLaunch(GetGroundPosition(position, item), item)

		return hContainer
	end

	-- 创建一个物品给单位，如果单位身上没地方放了，就扔在他附近随机位置
	function CreateItemToUnit(hUnit, sItemName)
		local hItem = CreateItem(sItemName, hUnit, hUnit)
		hItem:SetPurchaseTime(0)
		hUnit:AddItem(hItem)
		if IsValid(hItem) and hItem:GetParent() ~= hUnit and hItem:GetContainer() == nil then
			hItem:SetParent(hUnit, "")
			CreateItemOnPosition(hUnit:GetAbsOrigin() + Vector(RandomFloat(-50, 50), RandomFloat(-50, 50), 0), hItem)
		end
	end

	-- 控制台打印单位所有的modifier
	function PrintAllModifiers(hUnit)
		local modifiers = hUnit:FindAllModifiers()
		for n, modifier in pairs(modifiers) do
			local str = ""
			str = str .. "modifier name: " .. modifier:GetName()
			if modifier:GetCaster() ~= nil then
				str = str .. "\tcaster: " .. modifier:GetCaster():GetName()
				str = str .. "\t(" .. tostring(modifier:GetCaster()) .. ")"
			end
			if modifier:GetAbility() ~= nil then
				str = str .. "\tability: " .. modifier:GetAbility():GetName()
				str = str .. "\t(" .. tostring(modifier:GetAbility()) .. ")"
			end
			print(str)
		end
	end

	function CEntityInstance:Remove()
		FireGameEvent("custom_entity_removed", {
			entindex = self:entindex(),
		})
		if type(self.FindAllModifiers) == "function" then
			for k, v in pairs(self:FindAllModifiers()) do
				if IsValid(v) then
					v:Destroy()
				end
			end
		end

		UTIL_Remove(self)
	end

	if CCustomNetTableManager.SetTableValue_Engine == nil then
		CCustomNetTableManager.SetTableValue_Engine = CCustomNetTableManager.SetTableValue
	end
	CCustomNetTableManager.SetTableValue = function(self, stringTableName, stringKeyName, script_tableValue)
		local bSuccess = CCustomNetTableManager.SetTableValue_Engine(self, stringTableName, stringKeyName, script_tableValue)
		if bSuccess then
			if CCustomNetTableManager.TablesKeys == nil then
				CCustomNetTableManager.TablesKeys = {}
			end
			if CCustomNetTableManager.TablesKeys[stringTableName] == nil then
				CCustomNetTableManager.TablesKeys[stringTableName] = {}
			end
			if script_tableValue ~= nil and TableFindKey(CCustomNetTableManager.TablesKeys[stringTableName], stringKeyName) == nil then
				table.insert(CCustomNetTableManager.TablesKeys[stringTableName], stringKeyName)
			elseif script_tableValue == nil then
				ArrayRemove(CCustomNetTableManager.TablesKeys[stringTableName], stringKeyName)
			end
		end
		return bSuccess
	end
	CCustomNetTableManager.GetAllTableKeys = function(self, stringTableName)
		if CCustomNetTableManager.TablesKeys ~= nil and CCustomNetTableManager.TablesKeys[stringTableName] ~= nil then
			return shallowcopy(CCustomNetTableManager.TablesKeys[stringTableName])
		end
		return {}
	end

	function CDOTA_PlayerResource:ChangePlayerTeam(iPlayerID, iNewTeamNumber, funcCallback)
		local iOldTeamNumber = self:GetTeam(iPlayerID)
		local iReliableGold = self:GetReliableGold(iPlayerID)
		local iUnreliableGold = self:GetUnreliableGold(iPlayerID)

		local iOldTeamPlayerCount = self:GetPlayerCountForTeam(iOldTeamNumber)
		local iNewTeamPlayerCount = self:GetPlayerCountForTeam(iNewTeamNumber)

		self:SetGold(iPlayerID, 0, false)
		self:SetGold(iPlayerID, 0, true)

		GameRules:SetCustomGameTeamMaxPlayers(iNewTeamNumber, iNewTeamPlayerCount + 1)
		self:UpdateTeamSlot(iPlayerID, iNewTeamNumber, iNewTeamPlayerCount)
		GameRules:SetCustomGameTeamMaxPlayers(iOldTeamNumber, iOldTeamPlayerCount - 1)

		local hHero = self:GetSelectedHeroEntity(iPlayerID)
		if IsValid(hHero) then
			hHero:SetTeam(iNewTeamNumber)
		end
		local hPlayer = self:GetPlayer(iPlayerID)
		if IsValid(hPlayer) then
			hPlayer:SetTeam(iNewTeamNumber)
		end

		self:SetGold(iPlayerID, iUnreliableGold, false)
		self:SetGold(iPlayerID, iReliableGold, true)

		if type(funcCallback) == "function" then
			funcCallback(iPlayerID, iOldTeamNumber, iNewTeamNumber)
		end
	end
	function CEntities:FindByNameLike(lastEnt, searchString)
		if lastEnt then
			lastEnt = self:Next(lastEnt)
		else
			lastEnt = self:First()
		end
		while lastEnt do
			if string.find(lastEnt:GetName(), searchString) then
				return lastEnt
			end
			lastEnt = self:Next(lastEnt)
		end
	end
	function CEntities:FindAllByNameLike(searchString)
		local t = {}
		local hEnt = self:FindByNameLike(nil, searchString)
		while hEnt do
			table.insert(t, hEnt)
			hEnt = self:FindByNameLike(hEnt, searchString)
		end
		return t
	end

	---@param tOverrideData {} KV覆盖值
	function CreateUnitByNameWithNewData(sUnitName, vLocation, bFindClearSpace, hNpcOwner, hUnitOwner, iTeamNumber, tOverrideData)
		local hOwner = hNpcOwner or hUnitOwner
		local tData = {
			MapUnitName = sUnitName,
			teamnumber = iTeamNumber,
			vscripts = "units/common.lua",
			origin = tostring(vLocation.x) .. " " .. tostring(vLocation.y) .. " " .. tostring(vLocation.z),
			NeverMoveToClearSpace = not bFindClearSpace,
			StatusHealth = 1000,
		}
		if IsValid(hOwner) then
			tData.iOwnerIndex = hOwner:entindex()
		end
		if type(tOverrideData) == "table" then
			local s
			for k, v in pairs(tOverrideData) do
				if k == "StatusHealth" then
					tData["CustomStatusHealth"] = v
					if s == nil then
						s = "CustomStatusHealth"
					else
						s = s .. "," .. "CustomStatusHealth"
					end
				else
					tData[k] = v
					if s == nil then
						s = k
					else
						s = s .. "," .. k
					end
				end
			end
			if s then
				tData.OverrideKeys = s
			end
		end
		local hUnit = CreateUnitFromTable(tData, vLocation)
		if IsValid(hUnit) then
			hUnit:SetNeverMoveToClearSpace(false)
			if bFindClearSpace then
				FindClearSpaceForUnit(hUnit, vLocation, true)
			end
		end
		return hUnit
	end

	if CreateUnitByName_Engine == nil then
		CreateUnitByName_Engine = CreateUnitByName
	end
	function CreateUnitByName(sUnitName, vLocation, bFindClearSpace, hNpcOwner, hUnitOwner, iTeamNumber)
		return CreateUnitByNameWithNewData(sUnitName, vLocation, bFindClearSpace, hNpcOwner, hUnitOwner, iTeamNumber)
	end
	---判断单位是否为精英怪
	function CDOTA_BaseNPC:IsElite()
		local sUnitLabel = KeyValues:GetUnitData(self, "UnitLabel")
		if type(sUnitLabel) == "string" then
			return string.lower(sUnitLabel) == "elite"
		end
		return false
	end
	---判断单位是否为BOSS
	function CDOTA_BaseNPC:IsBoss()
		local sUnitLabel = KeyValues:GetUnitData(self, "UnitLabel")
		if type(sUnitLabel) == "string" then
			return string.lower(sUnitLabel) == "boss"
		end
		return false
	end

	---设置单位对基地造成的基础伤害，该值为基础值，不会受到精英怪或BOSS系数的影响
	function CDOTA_BaseNPC:SetBaseAttackDamageToBase(fDamage)
		self._BaseAttackDamageToBase = fDamage
	end
	---获取单位对基地造成的基础伤害
	function CDOTA_BaseNPC:GetBaseAttackDamageToBase()
		return self._BaseAttackDamageToBase or 1
	end
	---获取单位对基地造成的伤害
	function CDOTA_BaseNPC:GetAttackDamageToBase()
		local fAttackDamageToBase = self:GetBaseAttackDamageToBase()
		if self:IsElite() then
			fAttackDamageToBase = fAttackDamageToBase * 2
		elseif self:IsBoss() then
			fAttackDamageToBase = fAttackDamageToBase * 4
		end
		return fAttackDamageToBase
	end

	---设置单位的进攻目标实体
	function CDOTA_BaseNPC:SetGoalEntity(hGoalEntity)
		self._hGoalEntity = hGoalEntity

		if IsValid(self._hGoalEntity) then
			if self:IsCreature() then
				self:SetRequiresReachingEndPath(true)
			end
			self:SetInitialGoalEntity(self._hGoalEntity)
			self:GameTimer("Goal", 1, function()
				if self:IsIdle() then
					self:SetInitialGoalEntity(self._hGoalEntity)
				end
				return 1
			end)
			self:SetMustReachEachGoalEntity(false)
		else
			if self:IsCreature() then
				self:SetRequiresReachingEndPath(false)
			end
			self:SetInitialGoalEntity(nil)
			self:StopTimer("Goal")
		end
	end
	---获取单位的进攻目标实体
	function CDOTA_BaseNPC:GetGoalEntity()
		return self._hGoalEntity
	end
end

Hashtables = Hashtables or {}
function CreateHashtable(table)
	local new_hastable = {}
	local index = 1
	while Hashtables[index] ~= nil do
		index = index + 1
	end
	if table ~= nil then
		Hashtables[index] = table
	else
		Hashtables[index] = new_hastable
	end

	return Hashtables[index], index
end
function RemoveHashtable(hastable_or_index)
	local index
	if type(hastable_or_index) == "number" then
		index = hastable_or_index
	else
		index = GetHashtableIndex(hastable_or_index) or 0
	end
	Hashtables[index] = nil
end
function GetHashtableIndex(hastable)
	if hastable == nil then return nil end
	for index, h in pairs(Hashtables) do
		if h == hastable then
			return index
		end
	end
	return nil
end
function GetHashtableByIndex(index)
	return Hashtables[index]
end
function HashtableCount()
	local n = 0
	for index, h in pairs(Hashtables) do
		n = n + 1
	end
	return n
end
-- 获取表里的非零自然数key的数量
function TableNonzeroNaturalNumberKeyCount(t)
	local n = 0
	for k, v in pairs(t) do
		if type(k) == "number" then
			if k > 0 then
				if math.floor(k) == k then
					n = n + 1
				end
			end
		end
	end
	return n
end

function nnpairs(table)
	local key = 0
	local count = 0
	local maxCount = TableNonzeroNaturalNumberKeyCount(table)
	return function()
		if count < maxCount then
			key = key + 1
			while table[key] == nil do
				key = key + 1
			end
			count = count + 1
			return key, table[key]
		end
	end
end

-- 打印表
function PrintTable(table)
	print("----------------------------------------PrintTable----------------------------------------")
	for k, v in pairs(table) do
		print(k, v)
	end
	print("----------------------------------------End----------------------------------------")
end
--打印错误
_G._sErrorMsg = ""
function ErrorMsg(data)
	print("[Error]: ", data)
	if type(data) == "string" and _sErrorMsg ~= data then
		Notification:Upper({
			message = data
		})
		_sErrorMsg = data
	end
end
function GetRespawnPosition()
	local tEnt = Entities:FindAllByClassname("info_player_start_goodguys")
	return tEnt[1]:GetAbsOrigin()
end
function GetDayTime()
	local flTime = GameRules:GetTimeOfDay()
	local iHour, iMin = math.modf(flTime / (1 / 24))
	iMin = iMin * 60
	return iHour, iMin
end