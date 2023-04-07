---@class item_treant_2: eom_ability
item_treant_2 = class({})
function item_treant_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hUnit = hCaster:SummonUnit("tree_2", self:GetCursorPosition(), true, self:GetSpecialValueFor("duration"))
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	hUnit:EmitSound("Hero_Furion.Sprout")
end