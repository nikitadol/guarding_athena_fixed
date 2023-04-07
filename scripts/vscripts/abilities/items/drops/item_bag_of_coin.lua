---@class item_bag_of_coin: eom_ability
item_bag_of_coin = class({})
function item_bag_of_coin:OnSpellStart()
	local iPlayerID = self:GetCaster():GetOwner():GetPlayerID()
	self:GetCaster():EmitSound("ui.comp_coins_tick")
	PlayerData:ModifyGold(iPlayerID, self:GetSpecialValueFor("gold"))
	-- PlayerResource:ModifyGold(iPlayerID, self:GetSpecialValueFor("gold"), true, 0)
	self:Destroy()
end