---@class item_mirror: eom_ability
item_mirror = class({})
function item_mirror:OnSpellStart()
	local hCaster = self:GetCaster()
	Items:DevourItem(hCaster, self)
end