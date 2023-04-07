---@class item_back: eom_ability 回城
item_back = eom_ability({})
function item_back:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	Game:Teleport(hHero, "athena")
	SelectUnit(iPlayerID, hHero)
end