if HPack == nil then
	---@class HPack 压缩数据
	HPack = class({})
end

local public = HPack

---@private
function public:init(bReload)
	if not bReload then
		self.tDigitLetter = {}
		self.iDigit = 1
		for i = 1, 4 do
			self.tDigitLetter[i] = self:GetInitLetter()
		end
		self.tHeaderTable = {}
	end
end

---获取独一无二的字符
---@return string
function public:GetUniqueString()
	local sLetter = ""
	local bRemove = true
	for i = 1, self.iDigit do
		local s, b = self:GetLetter(self.tDigitLetter[i], i, bRemove)
		bRemove = b
		sLetter = sLetter .. s
	end
	return sLetter
end

---压缩表
---@param tData table 要压缩的表
---@param sTagName string 标记名字，用于索引转化表
function public:Compress(tData, sTagName)
	sTagName = default(sTagName, "global")
	self.tHeaderTable[sTagName] = default(self.tHeaderTable[sTagName] or {})
	self:Recursive(self.tHeaderTable[sTagName], tData)
	self:UpdateNetTable(sTagName)
	return self:Transform(self.tHeaderTable[sTagName], tData)
end

---解压缩表
---@param tData table 要解压缩的表
---@param sTagName string 标记名字，用于索引转化表
function public:Decompress(tData, sTagName)
	local tHeader = {}
	for k, v in pairs(self.tHeaderTable[sTagName]) do
		tHeader[v] = k
	end
	return self:Transform(tHeader, tData)
end

---打包数组
function public:PackArray(tData)
	local tHeader = {}
	local tPack = {}
	if IsArray(tData) then
		for _, v in ipairs(tData) do
			if type(v) == "table" and not IsArray(v) then
				for key, value in pairs(v) do
					if TableFindKey(tHeader, key) == nil then
						table.insert(tHeader, key)
					end
				end
			end
		end
		table.insert(tPack, tHeader)
		for _, v in ipairs(tData) do
			local tElement = {}
			if type(v) == "table" and not IsArray(v) then
				for i, sHeader in ipairs(tHeader) do
					tElement[i] = v[sHeader]
				end
			end
			table.insert(tPack, tElement)
		end
	end
	return tPack
end

---转化表
---@private
function public:Transform(tHeader, orig)
	local copy
	if type(orig) == "table" then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[self:Transform(tHeader, tHeader[orig_key] or orig_key)] = self:Transform(tHeader, tHeader[orig_value] or orig_value)
		end
		setmetatable(copy, self:Transform(tHeader, tHeader[getmetatable(orig)] or getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

---@private
function public:UpdateNetTable(sTagName)
	local tHeader = {}
	for k, v in pairs(self.tHeaderTable[sTagName]) do
		tHeader[v] = k
	end
	CustomNetTables:SetTableValue("header", sTagName, tHeader)
end

---@private
function public:Recursive(tHeader, tData)
	if IsArray(tData) then
		for i, v in ipairs(tData) do
			if type(v) == "table" then
				self:Recursive(tHeader, v)
			elseif (type(v) == "string" or type(v) == "number") and tHeader[v] == nil then
				tHeader[v] = self:GetUniqueString()
			end
		end
	else
		for k, v in pairs(tData) do
			if (type(k) == "string" or type(k) == "number") and tHeader[k] == nil then
				tHeader[k] = self:GetUniqueString()
			end
			if type(v) == "table" then
				self:Recursive(tHeader, v)
			elseif (type(v) == "string" or type(v) == "number") and tHeader[v] == nil then
				tHeader[v] = self:GetUniqueString()
			end
		end
	end
end

---@private
function public:GetInitLetter()
	return { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "a", "s", "d", "f", "g", "h", "j", "k", "l", "z", "x", "c", "v", "b", "n", "m", "_" }
end

---@private
function public:GetLetter(tLetter, iLetterIndex, bRemove)
	local sLetter = tLetter[1]
	if bRemove then
		table.remove(tLetter, 1)
	end
	bRemove = false
	if #tLetter == 0 then
		if #self.tDigitLetter[self.iDigit] == 0 then
			self.iDigit = self.iDigit + 1
		end
		self.tDigitLetter[iLetterIndex] = self:GetInitLetter()
		bRemove = true
	end
	return sLetter, bRemove
end

return public