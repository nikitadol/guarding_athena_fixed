---@class item_visage_1: eom_ability
item_visage_1 = class({})
function item_visage_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:RefreshAbilities()
	hCaster:RefreshItems()
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CENTER_FOLLOW, hCaster)
	-- sound
	hCaster:EmitSound("DOTA_Item.Refresher.Activate")
end
function item_visage_1:IsRefreshable()
	return false
end