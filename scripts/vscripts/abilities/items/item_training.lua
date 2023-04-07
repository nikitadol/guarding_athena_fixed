---@class item_training: eom_ability 练功
item_training = eom_ability({})
function item_training:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	Game:Teleport(hHero, "practice_" .. Game:GetNthByPlayerID(hHero:GetPlayerOwnerID()))
	SelectUnit(iPlayerID, hHero)
	Tutorial:SetQuickBuy("item_jian_1")
end