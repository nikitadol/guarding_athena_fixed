-- Global name: Filters
if Filters == nil then
	Filters = {}
end
local public = Filters

function public:AbilityTuningValueFilter(params)
	return true
end

function public:BountyRunePickupFilter(params)
	return true
end

function public:DamageFilter(params)
	local hAttacker = EntIndexToHScript(params.entindex_attacker_const or -1)
	local hVictim = EntIndexToHScript(params.entindex_victim_const or -1)
	local fDamage = params.damage
	if IsValid(hVictim) then
		params.damage = params.damage / GetHealth(hVictim) * hVictim:GetMaxHealth()
		return true
	end
	return false
end

local ORDER = {
	DOTA_UNIT_ORDER_NONE = 0,
	DOTA_UNIT_ORDER_MOVE_TO_POSITION = 1,
	DOTA_UNIT_ORDER_MOVE_TO_TARGET = 2,
	DOTA_UNIT_ORDER_ATTACK_MOVE = 3,
	DOTA_UNIT_ORDER_ATTACK_TARGET = 4,
	DOTA_UNIT_ORDER_CAST_POSITION = 5,
	DOTA_UNIT_ORDER_CAST_TARGET = 6,
	DOTA_UNIT_ORDER_CAST_TARGET_TREE = 7,
	DOTA_UNIT_ORDER_CAST_NO_TARGET = 8,
	DOTA_UNIT_ORDER_CAST_TOGGLE = 9,
	DOTA_UNIT_ORDER_HOLD_POSITION = 10,
	DOTA_UNIT_ORDER_TRAIN_ABILITY = 11,
	DOTA_UNIT_ORDER_DROP_ITEM = 12,
	DOTA_UNIT_ORDER_GIVE_ITEM = 13,
	DOTA_UNIT_ORDER_PICKUP_ITEM = 14,
	DOTA_UNIT_ORDER_PICKUP_RUNE = 15,
	DOTA_UNIT_ORDER_PURCHASE_ITEM = 16,
	DOTA_UNIT_ORDER_SELL_ITEM = 17,
	DOTA_UNIT_ORDER_DISASSEMBLE_ITEM = 18,
	DOTA_UNIT_ORDER_MOVE_ITEM = 19,
	DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO = 20,
	DOTA_UNIT_ORDER_STOP = 21,
	DOTA_UNIT_ORDER_TAUNT = 22,
	DOTA_UNIT_ORDER_BUYBACK = 23,
	DOTA_UNIT_ORDER_GLYPH = 24,
	DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH = 25,
	DOTA_UNIT_ORDER_CAST_RUNE = 26,
	DOTA_UNIT_ORDER_PING_ABILITY = 27,
	DOTA_UNIT_ORDER_MOVE_TO_DIRECTION = 28,
	DOTA_UNIT_ORDER_PATROL = 29,
	DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION = 30,
	DOTA_UNIT_ORDER_RADAR = 31,
	DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK = 32,
	DOTA_UNIT_ORDER_CONTINUE = 33,
	DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED = 34,
	DOTA_UNIT_ORDER_CAST_RIVER_PAINT = 35,
	DOTA_UNIT_ORDER_PREGAME_ADJUST_ITEM_ASSIGNMENT = 36,
	DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN = 37,
	DOTA_UNIT_ORDER_TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH = 38,
}
local BUILDING_ALLOWED_ORDERS = {
	DOTA_UNIT_ORDER_DROP_ITEM,
	DOTA_UNIT_ORDER_GIVE_ITEM,
	DOTA_UNIT_ORDER_PICKUP_ITEM,
	DOTA_UNIT_ORDER_MOVE_ITEM,
}
function public:ExecuteOrderFilter(params)
	-- params.order_name = TableFindKey(ORDER, params.order_type)
	-- DeepPrintTable(params)
	-- local units = params["units"]
	-- local order_type = params["order_type"]
	-- local issuer = params["issuer_player_id_const"]
	-- local abilityIndex = params["entindex_ability"]
	-- local targetIndex = params["entindex_target"]
	-- local x = tonumber(params["position_x"])
	-- local y = tonumber(params["position_y"])
	-- local z = tonumber(params["position_z"])
	-- local point = Vector(x, y, z)
	-- local queue = params["queue"]
	local iOrderType = params.order_type
	local iPlayerID = params.issuer_player_id_const
	local iQueue = params.queue

	if params.units == nil or params.units["0"] == nil then
		return true
	end

	local hCaster = EntIndexToHScript(params.units["0"])

	-- for k, v in pairs(params.units) do
	-- 	local hUnit = EntIndexToHScript(v)
	-- 	if IsValid(hUnit) and hUnit:HasModifier("modifier_courier") then
	-- 		local vStartPosition = hUnit:GetAbsOrigin()
	-- 		local vTargetPosition = vec3_invalid
	-- 		if iOrderType == DOTA_UNIT_ORDER_MOVE_TO_POSITION then
	-- 			vTargetPosition = Vector(params["position_x"], params["position_y"], params["position_z"])
	-- 		end
	-- 		if iOrderType == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
	-- 			local hTarget = EntIndexToHScript(params.entindex_target)
	-- 			if IsValid(hTarget) then
	-- 				vTargetPosition = CalcClosestPointOnEntityOBB(hTarget, vStartPosition)
	-- 			end
	-- 		end
	-- 		if vTargetPosition ~= vec3_invalid then
	-- 			vTargetPosition = GetGroundPosition(vTargetPosition, hUnit)
	-- 			if vTargetPosition ~= vStartPosition then
	-- 				local vDirection = vTargetPosition - vStartPosition
	-- 				vDirection.z = 0
	-- 				hUnit:Interrupt()
	-- 				local iParticleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, hUnit)
	-- 				ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
	-- 				ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 				EmitSoundOnLocationWithCaster(vStartPosition, "DOTA_Item.BlinkDagger.Activate", hUnit)
	-- 				FindClearSpaceForUnit(hUnit, vTargetPosition, true)
	-- 				local iParticleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_CUSTOMORIGIN, hUnit)
	-- 				ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin())
	-- 				ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 				hUnit:EmitSound("DOTA_Item.BlinkDagger.NailedIt")
	-- 				hUnit:FaceTowards(hUnit:GetAbsOrigin() + vDirection:Normalized())
	-- 				hUnit:SetForwardVector(vDirection:Normalized())
	-- 				params.units[k] = nil
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- 矢量技能记录
	local hAbility = EntIndexToHScript(params.entindex_ability)
	if IsValid(hAbility) and type(hAbility.GetBehaviorInt) == "function" and bit.band(hAbility:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) and iQueue == 0 then
		if iOrderType == DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION then
			local vPosition = Vector(tonumber(params.position_x), tonumber(params.position_y), tonumber(params.position_z))
			hAbility.vVectorTargetEndPosition = vPosition
		end
	end

	-- 丢物品在地上
	if iOrderType == DOTA_UNIT_ORDER_DROP_ITEM and iQueue == 0 then
		local vTargetPosition = Items:FindClearGridPosition(Vector(params.position_x, params.position_y, params.position_z))
		if vTargetPosition then
			local hItem = EntIndexToHScript(params.entindex_ability)
			if not IsValid(hItem) or type(hItem.IsItem) ~= "function" or not hItem:IsItem() then
				return true
			end

			if hCaster:GetMainControllingPlayer() ~= iPlayerID then
				return true
			end

			if IsValid(hCaster) and hCaster:IsAlive() and not hCaster:IsIllusion() and not hCaster:IsTempestDouble() and not hCaster:IsClone() and hItem:IsDroppable() then
				local hParent = hItem:GetParent()
				if IsValid(hParent) then
					hParent:TakeItem(hItem)
				end
				CreateItemOnPosition(vTargetPosition, hItem)
			end
		end

		return false
	end

	-- 捡起物品
	if iOrderType == DOTA_UNIT_ORDER_PICKUP_ITEM and iQueue == 0 then
		local hTarget = EntIndexToHScript(params.entindex_target)

		if IsValid(hTarget) and type(hTarget.GetContainedItem) == "function" then
			local hItem = hTarget:GetContainedItem()
			if hItem:GetAbilityName() == "item_gem" then
				return true
			end

			if IsValid(hCaster) and hCaster:IsAlive() and not hCaster:IsIllusion() and not hCaster:IsTempestDouble() and not hCaster:IsClone() then
				if not Items:TryGiveItem(hCaster, hItem) then
					-- ErrorMessage(iPlayerID, "error_not_enough_slot")
					return false
					-- Items:DropItem(iPlayerID, hItem, hCaster:GetAbsOrigin())
				end
			end
			return false
		end

		return true
	end

	-- 给物品
	if iOrderType == DOTA_UNIT_ORDER_GIVE_ITEM and iQueue == 0 then
		local hTarget = EntIndexToHScript(params.entindex_target)
		local hItem = EntIndexToHScript(params.entindex_ability)
		if not IsValid(hTarget) or not IsValid(hItem) or type(hItem.IsItem) ~= "function" or not hItem:IsItem() then
			return true
		end

		if hCaster:GetMainControllingPlayer() ~= iPlayerID then
			return true
		end

		if not hTarget:HasInventory() or hTarget:IsIllusion() or hTarget:IsTempestDouble() or hTarget:IsClone() then
			return false
		end

		if IsValid(hCaster) and hCaster:IsAlive() and not hCaster:IsIllusion() and not hCaster:IsTempestDouble() and not hCaster:IsClone() then
			Items:TryGiveItem(hTarget, hItem)
		end

		return false
	end

	return true
end

function public:HealingFilter(params)
	return true
end

---@param params {inventory_parent_entindex_const:number,item_parent_entindex_const:number,item_entindex_const:number,suggested_slot:number}
function public:ItemAddedToInventoryFilter(params)
	local hItem = EntIndexToHScript(params.item_entindex_const)
	local sAbilityName = hItem:GetAbilityName()
	local hUnit = EntIndexToHScript(params.inventory_parent_entindex_const)

	if IsValid(hUnit) then
		-- 专属效果
		if ("item_" .. hUnit:GetUnitName()) == sAbilityName then
			hUnit:AddNewModifier(hUnit, hItem, "modifier_scepter", nil)
			return false
		end
	end
	return true
end

function public:ModifierGainedFilter(params)
	return true
end

function public:ModifyExperienceFilter(params)
	return true
end

function public:ModifyGoldFilter(params)
	return true
end

function public:RuneSpawnFilter(params)
	return true
end

function public:TrackingProjectileFilter(params)
	-- is_attack						= 1 (number)
	-- entindex_ability_const			= -1 (number)
	-- max_impact_time					= 0 (number)
	-- entindex_target_const			= 163 (number)
	-- move_speed						= 1250 (number)
	-- entindex_source_const			= 152 (number)
	-- dodgeable						= 1 (number)
	-- expire_time						= 0 (number)
	local hCaster = EntIndexToHScript(params.entindex_source_const)
	local hTarget = EntIndexToHScript(params.entindex_target_const)
	if params.is_attack and params.is_attack == 1 and HasAttackProjectileDisabled(hCaster) then
		FireModifierEvent(MODIFIER_EVENT_ON_ATTACK_PROJECTILE_DISABLED, {
			unit = hCaster,
			target = hTarget
		}, hCaster)
		return false
	end
	return true
end

function public:init(bReload)
	local GameMode = GameRules:GetGameModeEntity()

	GameMode:SetAbilityTuningValueFilter(Dynamic_Wrap(public, "AbilityTuningValueFilter"), public)
	GameMode:SetBountyRunePickupFilter(Dynamic_Wrap(public, "BountyRunePickupFilter"), public)
	GameMode:SetDamageFilter(Dynamic_Wrap(public, "DamageFilter"), public)
	GameMode:SetExecuteOrderFilter(Dynamic_Wrap(public, "ExecuteOrderFilter"), public)
	GameMode:SetHealingFilter(Dynamic_Wrap(public, "HealingFilter"), public)
	GameMode:SetItemAddedToInventoryFilter(Dynamic_Wrap(public, "ItemAddedToInventoryFilter"), public)
	GameMode:SetModifierGainedFilter(Dynamic_Wrap(public, "ModifierGainedFilter"), public)
	GameMode:SetModifyExperienceFilter(Dynamic_Wrap(public, "ModifyExperienceFilter"), public)
	GameMode:SetModifyGoldFilter(Dynamic_Wrap(public, "ModifyGoldFilter"), public)
	GameMode:SetRuneSpawnFilter(Dynamic_Wrap(public, "RuneSpawnFilter"), public)
	GameMode:SetTrackingProjectileFilter(Dynamic_Wrap(public, "TrackingProjectileFilter"), public)
end

return public