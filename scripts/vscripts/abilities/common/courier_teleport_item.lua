---@class courier_teleport_item: eom_ability 传送物品到自己的练功房且自动分类
courier_teleport_item = eom_ability({})
function courier_teleport_item:GetAOERadius()
	return 200
end
function courier_teleport_item:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local hHero = PlayerResource:GetSelectedHeroEntity(hCaster:GetPlayerOwnerID())
	local tEntities = Entities:FindAllByClassnameWithin("dota_item_drop", vPosition, 200)
	table.sort(tEntities, function(a, b)
		return (a:GetAbsOrigin() - vPosition):Length2D() < (b:GetAbsOrigin() - vPosition):Length2D()
	end)
	for i = #tEntities, 1, -1 do
		local hItem = tEntities[i]:GetContainedItem()
		if not IsValid(hItem) then
			table.remove(tEntities, i)
		end
	end
	for i, v in ipairs(tEntities) do
		local hItem = tEntities[i]:GetContainedItem()
		if IsValid(hItem) then
			Items:TryGiveItem(hCaster, hItem)
		end
	end
end