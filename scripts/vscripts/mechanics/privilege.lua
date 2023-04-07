if Privilege == nil then
	---特权
	---@module Privilege
	Privilege = class({})
end

local public = Privilege

function public:init(bReload)
	if not bReload then
		self.tPrivileges = {}
		self.tValues = {}
		self.tScriptFiles = {}
		require("abilities/privilege/privilege_base")
	end
	for sPrivilegeName, v in pairs(KeyValues.PrivilegeKvs) do
		-- 存键值
		self.tValues[sPrivilegeName] = {}
		local tAbilitySpecial = v.AbilitySpecial
		if type(tAbilitySpecial) == "table" then
			for _, tSpecial in pairs(tAbilitySpecial) do
				local key
				local bOnlyValue = true
				for _k, _v in pairs(tSpecial) do
					if _k ~= "var_type" then
						key = _k
						if type(_v) == "number" then
							self.tValues[sPrivilegeName][key] = Round(_v, 5)
						else
							self.tValues[sPrivilegeName][key] = _v
						end
						break
					end
				end
			end
		end
		-- 初始化
		if self.tPrivileges[sPrivilegeName] == nil then
			if _G[v.type] == CUSTOM_PRIVILEGE_TYPE_GLOBAL then
				self.tPrivileges[sPrivilegeName] = 0
			end
			if _G[v.type] == CUSTOM_PRIVILEGE_TYPE_PLAYER then
				self.tPrivileges[sPrivilegeName] = {}
				self.tScriptFiles[sPrivilegeName] = {}
			end
		end
	end
end
---激活特权
---@param sPrivilegeName string 特权名
---@param iPlayerID number|CDOTA_BaseNPC|CDOTA_BaseNPC_Hero 玩家ID或者玩家控制的英雄单位
function public:ActivatePrivilege(sPrivilegeName, iPlayerID)
	if self:GetPrivilegeType(sPrivilegeName) == CUSTOM_PRIVILEGE_TYPE_GLOBAL then
		self.tPrivileges[sPrivilegeName] = default(self.tPrivileges[sPrivilegeName], 0) + 1
		-- 调用脚本
		local sScriptFile = self:GetScriptFile(sPrivilegeName)
		if sScriptFile then
			if self.tScriptFiles[sPrivilegeName] == nil then
				local hPrivilegeClass = require(sScriptFile)
				self.tScriptFiles[sPrivilegeName] = hPrivilegeClass(sPrivilegeName, iPlayerID)
				self.tScriptFiles[sPrivilegeName]:OnCreated()
			else
				self.tScriptFiles[sPrivilegeName]:OnRefresh()
			end
		end
	else
		if type(iPlayerID) == "table" and iPlayerID.IsHero ~= nil then
			iPlayerID = iPlayerID:GetPlayerOwnerID()
		end
		if type(iPlayerID) == "number" and iPlayerID > -1 then
			self.tPrivileges[sPrivilegeName][iPlayerID] = default(self.tPrivileges[sPrivilegeName][iPlayerID], 0) + 1
			-- 调用脚本
			local sScriptFile = self:GetScriptFile(sPrivilegeName)
			if sScriptFile then
				if self.tScriptFiles[sPrivilegeName][iPlayerID] == nil then
					local hPrivilegeClass = require(sScriptFile)
					self.tScriptFiles[sPrivilegeName][iPlayerID] = hPrivilegeClass(sPrivilegeName, iPlayerID)
					self.tScriptFiles[sPrivilegeName][iPlayerID]:OnCreated()
				else
					self.tScriptFiles[sPrivilegeName][iPlayerID]:OnRefresh()
				end
			end
		end
	end
end
---取消特权
---@param sPrivilegeName string 特权名
---@param iPlayerID number|CDOTA_BaseNPC|CDOTA_BaseNPC_Hero 玩家ID或者玩家控制的英雄单位
function public:CancelPrivilege(sPrivilegeName, iPlayerID)
	if self:GetPrivilegeType(sPrivilegeName) == CUSTOM_PRIVILEGE_TYPE_GLOBAL then
		self.tPrivileges[sPrivilegeName] = self.tPrivileges[sPrivilegeName] - 1
	else
		if type(iPlayerID) == "table" and iPlayerID.IsHero ~= nil then
			iPlayerID = iPlayerID:GetPlayerOwnerID()
		end
		if type(iPlayerID) == "number" and iPlayerID > -1 then
			self.tPrivileges[sPrivilegeName][iPlayerID] = self.tPrivileges[sPrivilegeName][iPlayerID] - 1
		end
	end
end
---是否激活特权
---@param sPrivilegeName string 特权名
---@param iPlayerID number|CDOTA_BaseNPC|CDOTA_BaseNPC_Hero 玩家ID或者玩家控制的英雄单位
---@return boolean
function public:HasPrivilege(sPrivilegeName, iPlayerID)
	if self:GetPrivilegeType(sPrivilegeName) == CUSTOM_PRIVILEGE_TYPE_GLOBAL then
		return default(self.tPrivileges[sPrivilegeName], 0) > 0
	else
		if type(iPlayerID) == "table" and iPlayerID.IsHero ~= nil then
			iPlayerID = iPlayerID:GetPlayerOwnerID()
		end
		if type(iPlayerID) == "number" and iPlayerID > -1 then
			return default(self.tPrivileges[sPrivilegeName][iPlayerID], 0) > 0
		end
	end
	return false
end
---调用特权脚本
function public:CallScriptFile(sPrivilegeName, iPlayerID)
	local sScriptFile = self:GetScriptFile(sPrivilegeName)
	if sScriptFile then
		local hPrivilegeClass = require(sScriptFile)
	end
end
---修改特权数值
function public:SetPrivilegeSpecialValue(sPrivilegeName, key, value)
	self.tValues[sPrivilegeName][key] = value
end
---获取特权数值
function public:GetPrivilegeSpecialValue(sPrivilegeName, key)
	return self.tValues[sPrivilegeName][key]
end
---获取特权类型
function public:GetPrivilegeType(sPrivilegeName)
	return _G[KeyValues.PrivilegeKvs[sPrivilegeName].type]
end
---获取特权叠加类型
function public:IsStackable(sPrivilegeName)
	return KeyValues.PrivilegeKvs[sPrivilegeName].IsStackable == 1
end
---获取特权脚本
function public:GetScriptFile(sPrivilegeName)
	return KeyValues.PrivilegeKvs[sPrivilegeName].ScriptFile
end
----------------------------------------Debug----------------------------------------
---取消所有特权
function public:Debug_CancelPrivilege()
	for k, v in pairs(KeyValues.PrivilegeKvs) do
		if _G[v.type] == CUSTOM_PRIVILEGE_TYPE_GLOBAL then
			self.tPrivileges[k] = 0
			if self.tScriptFiles[k] then
				self.tScriptFiles[k]:OnDestroy()
				self.tScriptFiles[k] = nil
			end
		end
		if _G[v.type] == CUSTOM_PRIVILEGE_TYPE_PLAYER then
			self.tPrivileges[k] = {}
			if self.tScriptFiles[k] then
				for _k, _v in pairs(self.tScriptFiles[k]) do
					_v:OnDestroy()
				end
				self.tScriptFiles[k] = {}
			end
		end
	end
end
return public