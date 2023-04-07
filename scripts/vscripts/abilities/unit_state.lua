if unit_state == nil then
	unit_state = class({})
end
function unit_state:GetAbilityTextureName()
	if _G.GetAbilityCooldown_AbilityEntIndex ~= -1 then
		local hAbility = EntIndexToHScript(_G.GetAbilityCooldown_AbilityEntIndex)
		local iLevel = _G.GetAbilityCooldown_Level

		_G.GetAbilityCooldown_AbilityEntIndex = -1
		_G.GetAbilityCooldown_Level = -1

		if IsValid(hAbility) and type(hAbility.GetCooldown) == "function" then
			return tostring(hAbility:GetCooldown(iLevel))
		else
			return ""
		end
	end

	if _G.GetAbilityManaCost_AbilityEntIndex ~= -1 then
		local hAbility = EntIndexToHScript(_G.GetAbilityManaCost_AbilityEntIndex)
		local iLevel = _G.GetAbilityManaCost_Level

		_G.GetAbilityManaCost_AbilityEntIndex = -1
		_G.GetAbilityManaCost_Level = -1

		if IsValid(hAbility) and type(hAbility.GetManaCost) == "function" then
			return tostring(hAbility:GetManaCost(iLevel))
		else
			return ""
		end
	end

	if _G.GetAbilityGoldCost_AbilityEntIndex ~= -1 then
		local hAbility = EntIndexToHScript(_G.GetAbilityGoldCost_AbilityEntIndex)
		local iLevel = _G.GetAbilityGoldCost_Level

		_G.GetAbilityGoldCost_AbilityEntIndex = -1
		_G.GetAbilityGoldCost_Level = -1

		if IsValid(hAbility) and type(hAbility.GetGoldCost) == "function" then
			return tostring(hAbility:GetGoldCost(iLevel))
		else
			return ""
		end
	end

	if _G.GetAbilitySpecialValue_AbilityEntIndex ~= -1 then
		local hAbility = EntIndexToHScript(_G.GetAbilitySpecialValue_AbilityEntIndex)
		local iLevel = _G.GetAbilitySpecialValue_Level
		local sKeyName = _G.GetAbilitySpecialValue_KeyName

		_G.GetAbilitySpecialValue_AbilityEntIndex = -1
		_G.GetAbilitySpecialValue_Level = -1
		_G.GetAbilitySpecialValue_KeyName = ""

		if IsValid(hAbility) and type(hAbility.GetLevelSpecialValueFor) == "function" then
			return tostring(hAbility:GetLevelSpecialValueFor(sKeyName, iLevel))
		else
			return ""
		end
	end

	if _G.GetUnitData_UnitEntIndex ~= -1 then
		local hUnit = EntIndexToHScript(_G.GetUnitData_UnitEntIndex)
		local sFunctionName = _G.GetUnitData_FunctionName

		_G.GetUnitData_UnitEntIndex = -1
		_G.GetUnitData_FunctionName = ""

		if IsValid(hUnit) and type(_G[sFunctionName]) == "function" then
			return tostring(_G[sFunctionName](hUnit) or 0)
		else
			return ""
		end
	end

	return ""
end

function unit_state:OnInventoryContentsChanged()
	local hCaster = self:GetCaster()
	hCaster:CalculateItemProperties()
	if hCaster:IsHero() then
		hCaster:CalculateStatBonus(false)
	else
		hCaster:CalculateGenericBonuses()
	end
	if hCaster._tItemList == nil then hCaster._tItemList = {} end
	local tSwitchItemList = {}
	local hDropItem
	local hPickItem
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6, 1 do
		local hItem = hCaster:GetItemInSlot(i)
		if hCaster._tItemList[i] ~= hItem then
			table.insert(tSwitchItemList, hCaster._tItemList[i] or hItem)
			hCaster._tItemList[i] = hItem
		end
	end
	for i = #tSwitchItemList, 1, -1 do
		if not hCaster:HasItemInInventory(tSwitchItemList[i]:GetAbilityName()) then
			hDropItem = tSwitchItemList[i]
			table.remove(tSwitchItemList, i)
			break
		else
			hPickItem = tSwitchItemList[i]
			break
		end
	end
	local iEventType
	if hDropItem then
		iEventType = CUSTOM_INVENTORY_CHANGE_LOSE
	elseif #tSwitchItemList == 2 then
		iEventType = CUSTOM_INVENTORY_CHANGE_SWITCH
	elseif hPickItem then
		iEventType = CUSTOM_INVENTORY_CHANGE_RECEIVE
	end

	if iEventType then
		FireGameEvent("custom_inventory_contents_changed", {
			EntityIndex = hCaster:entindex(),
			EventType = iEventType,
			SwitchItemIndex1 = tSwitchItemList[1] and tSwitchItemList[1]:entindex() or nil,
			SwitchItemIndex2 = tSwitchItemList[2] and tSwitchItemList[2]:entindex() or nil,
			DropItemIndex = hDropItem and hDropItem:entindex() or nil,
			PickItemIndex = hPickItem and hPickItem:entindex() or nil,
		})
	end
end