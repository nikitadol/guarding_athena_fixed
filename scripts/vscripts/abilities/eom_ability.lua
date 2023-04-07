---@class eom_ability : CDOTA_Ability_Lua
eom_ability = {}
local mt = {}
mt.__call = function(class_tbl, ...)
	local c = class(...)

	c.constructor = function(self)
		local _OnUpgrade = self.OnUpgrade
		if type(_OnUpgrade) == "function" then
			self.OnUpgrade = function(...)
				local result = _OnUpgrade(...)
				if type(eom_ability.OnUpgrade) == "function" then
					eom_ability.OnUpgrade(...)
				end
				return result
			end
		else
			self.OnUpgrade = eom_ability.OnUpgrade
		end
	end
	return c
end
function eom_ability:OnUpgrade()
	local sAbilityName = self:GetAbilityName()
	if self:GetLevel() == 1 and KeyValues.AbilitiesKv[sAbilityName].CustomAbilityCharges then
		-- self:SetMaxCharges(KeyValues.AbilitiesKv[sAbilityName].CustomAbilityCharges, KeyValues.AbilitiesKv[sAbilityName].AbilityChargeRestoreTime)
		self:SetMaxCharges(KeyValues.AbilitiesKv[sAbilityName].CustomAbilityCharges)
	end
end
setmetatable(eom_ability, mt)

---@class eom_item : CDOTA_Item_Lua
eom_item = {}
local mt = {}
mt.__call = function(class_tbl, ...)
	local c = class(...)

	c.constructor = function(self)
	end
	return c
end
setmetatable(eom_item, mt)