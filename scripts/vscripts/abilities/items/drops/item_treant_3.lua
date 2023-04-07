---@class item_treant_3: eom_ability
item_treant_3 = class({})
function item_treant_3:OnSpellStart()
	CreateTempTree(self:GetCursorPosition(), self:GetSpecialValueFor("duration"))
end