if KeyValues == nil then
	KeyValues = class({})
end

KeyValues.AssetModifiersKv = LoadKeyValues("scripts/npc/kv/gameplay/asset_modifiers.kv")
if IsServer() then
	KeyValues.ReservoirsKv = LoadKeyValues("scripts/npc/kv/reservoirs.kv")
	KeyValues.PoolsKv = LoadKeyValues("scripts/npc/kv/pools.kv")

	KeyValues.PetsKv = LoadKeyValues("scripts/npc/kv/units/npc_pet.kv")
	KeyValues.HerolistKv = LoadKeyValues("scripts/npc/herolist.txt")
	KeyValues.UnitsKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	KeyValues.AbilitiesKv = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	KeyValues.ItemsKv = TableReplace(TableOverride(LoadKeyValues("scripts/npc/items.txt"), LoadKeyValues("scripts/npc/npc_items_custom.txt")), LoadKeyValues("scripts/npc/npc_abilities_override.txt"))
	KeyValues.HeroesKv = {}
	for sHeroName, _ in pairs(KeyValues.HerolistKv) do
		KeyValues.HeroesKv[sHeroName] = DOTAGameManager:GetHeroDataByName_Script(sHeroName)
	end

	KeyValues.RoundKvs = LoadKeyValues("scripts/npc/kv/gameplay/round.kv")
	KeyValues.SpawnerGroupKvs = LoadKeyValues("scripts/npc/kv/gameplay/spawner_group.kv")
	KeyValues.DialogEventsKV = LoadKeyValues("scripts/npc/kv/gameplay/dialog_events.kv")
	KeyValues.NeutralSpawnersKvs = LoadKeyValues("scripts/npc/kv/gameplay/neutral_spawners.kv")

	KeyValues.AbilityUpgradesKvs = LoadKeyValues("scripts/npc/kv/abilities/ability_upgrades.kv")
	KeyValues.PlayerItemsKV = LoadKeyValues("scripts/npc/kv/gameplay/player_items.kv")
	KeyValues.PrivilegeKvs = LoadKeyValues("scripts/npc/kv/abilities/privilege.kv")
	KeyValues.TasksKv = LoadKeyValues("scripts/npc/kv/gameplay/tasks.kv")
	KeyValues.NpcTaskKv = LoadKeyValues("scripts/npc/kv/units/npc_quest.kv")
	KeyValues.CouriersKV = LoadKeyValues("scripts/npc/kv/gameplay/courier_list.kv")
else
	KeyValues.AbilitiesKv = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	KeyValues.ItemsKv = TableReplace(TableOverride(LoadKeyValues("scripts/npc/items.txt"), LoadKeyValues("scripts/npc/npc_items_custom.txt")), LoadKeyValues("scripts/npc/npc_abilities_override.txt"))
	KeyValues.HerolistKv = LoadKeyValues("scripts/npc/herolist.txt")
	KeyValues.HeroesKv = {}
	for sHeroName, _ in pairs(KeyValues.HerolistKv) do
		KeyValues.HeroesKv[sHeroName] = DOTAGameManager:GetHeroDataByName_Script(sHeroName)
	end
	KeyValues.UnitsKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
end

---@param default any @默认值，如果索引到空值则会返回默认值
---@param ... string @名字，不定参数，全部为string类，按名字顺序分别索引
---@vararg string
---@return any @返回索引出的值或者默认值
function GetKV(default, ...)
	local temp = KeyValues
	for i, v in ipairs { ... } do
		if temp[v] == nil then
			return default
		end
		temp = temp[v]
	end
	return temp
end

_G.SYNC_UNIT_KEY = {
	"AttackDamage",
	"AttackRate",
	"Armor",
	"CustomStatusHealth",
}

---@param unit string | number | CDOTA_BaseNPC 单位，实体、实体index或者单位名字
---@param key string 键值名字
---@return nil | any 成功则会返回非nil值
function KeyValues:GetUnitData(unit, key)
	local sUnitName
	if type(unit) == "number" then
		unit = EntIndexToHScript(unit)
	end
	if type(unit) == "table" and IsValid(unit) then
		if IsServer() then
			if type(unit._tOverrideData) == "table" and unit._tOverrideData[key] ~= nil then
				return unit._tOverrideData[key]
			end
		else
			local index = TableFindKey(SYNC_UNIT_KEY, key)
			if index ~= nil then
				local nettable = CustomNetTables:GetTableValue("unit_kv", tostring(unit:entindex()))
				if nettable then
					local tOverrideKV = json.decode(nettable._)
					if tOverrideKV then
						return tOverrideKV[index]
					end
				end
			end
		end
		sUnitName = unit:GetUnitName()
		local tData = unit:IsHero() and KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
		return tData and tData[key] or nil
	elseif type(unit) == "string" then
		sUnitName = unit
		local tData = KeyValues.HeroesKv[sUnitName] or KeyValues.UnitsKv[sUnitName]
		return tData and tData[key] or nil
	end
end
function KeyValues:GetAbilityData(hAbility, key)
	local sItemName
	if type(hAbility) == "number" then
		hAbility = EntIndexToHScript(hAbility)
	end
	if type(hAbility) == "table" and IsValid(hAbility) then
		sItemName = hAbility:GetAbilityName()
		return KeyValues.AbilitiesKv[sItemName] and KeyValues.AbilitiesKv[sItemName][key] or nil
	elseif type(hAbility) == "string" then
		sItemName = hAbility
		return KeyValues.AbilitiesKv[sItemName] and KeyValues.AbilitiesKv[sItemName][key] or nil
	end
end
function KeyValues:GetItemData(hItem, key)
	local sItemName
	if type(hItem) == "number" then
		hItem = EntIndexToHScript(hItem)
	end
	if type(hItem) == "table" and IsValid(hItem) then
		sItemName = hItem:GetAbilityName()
		return KeyValues.ItemsKv[sItemName][key]
	elseif type(hItem) == "string" then
		sItemName = hItem
		return KeyValues.ItemsKv[sItemName][key]
	end
end
function KeyValues:GetItemSpecialFor(hItem, sKey)
	local sItemName
	if type(hItem) == "number" then
		hItem = EntIndexToHScript(hItem)
	end
	if type(hItem) == "table" and IsValid(hItem) then
		sItemName = hItem:GetAbilityName()
		for _, v in pairs(KeyValues.ItemsKv[sItemName].AbilitySpecial) do
			for key, value in pairs(v) do
				if key == sKey then
					return value
				end
			end
		end
	elseif type(hItem) == "string" then
		sItemName = hItem
		for _, v in pairs(KeyValues.ItemsKv[sItemName].AbilitySpecial) do
			for key, value in pairs(v) do
				if key == sKey then
					return value
				end
			end
		end
	end
end