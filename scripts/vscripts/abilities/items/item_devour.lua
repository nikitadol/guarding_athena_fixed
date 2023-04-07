---@class item_devour: eom_ability
item_devour = eom_ability({})
function item_devour:GetAOERadius()
	if IsClient() then
		if iHoverItem ~= -1 then
			return 0
		end
	end
	return 64
end
function item_devour:CastFilterResultLocation(vLocation)
	if IsClient() then
		if iHoverItem ~= -1 and iActiveAbility ~= self:entindex() then
			SendToConsole("ability_behavior_item_target " .. self:entindex() .. " " .. iHoverItem)
			return UF_FAIL_INVALID_LOCATION
		end
	end
	return UF_SUCCESS
end
function item_devour:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local hHero = PlayerResource:GetSelectedHeroEntity(hCaster:GetPlayerOwnerID())

	local hItem
	if vPosition.y == 16300 then
		hItem = EntIndexToHScript(vPosition.x)
	else
		local tEntities = Entities:FindAllByClassnameWithin("dota_item_drop", vPosition, 64)
		table.sort(tEntities, function(a, b)
			return (a:GetAbsOrigin() - vPosition):Length2D() < (b:GetAbsOrigin() - vPosition):Length2D()
		end)
		if #tEntities > 0 then
			hItem = tEntities[1]:GetContainedItem()
		end
	end
	if IsValid(hItem) and Items:GetCustomType(hItem:GetAbilityName()) == CUSTOM_ITEM_TYPE_EQUIPMENT and hItem:GetRarity() == "5" then
		if Items:DevourItem(hHero, hItem) then
			self:SpendCharge()
			return
		end
	end
	ErrorMessage(hCaster:GetPlayerOwnerID(), "error_devour")
end
function item_devour:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end