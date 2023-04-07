courier_give_item_to_hero = eom_ability({})
function courier_give_item_to_hero:GetAOERadius()
	if IsClient() then
		if iHoverItem ~= -1 then
			return 0
		end
	end
	return 64
end
function courier_give_item_to_hero:CastFilterResultLocation(vLocation)
	if IsClient() then
		if iHoverItem ~= -1 and iActiveAbility ~= self:entindex() then
			SendToConsole("ability_behavior_item_target " .. self:entindex() .. " " .. iHoverItem)
			return UF_FAIL_INVALID_LOCATION
		end
	end
	return UF_SUCCESS
end
function courier_give_item_to_hero:OnSpellStart()
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
	if IsValid(hItem) then
		Items:TryGiveItem(hHero, hItem)
	end
end
function courier_give_item_to_hero:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end