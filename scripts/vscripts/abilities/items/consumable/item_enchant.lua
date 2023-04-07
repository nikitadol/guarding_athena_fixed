---@class item_enchant: eom_ability
item_enchant = class({})
function item_enchant:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	if iPlayerID ~= -1 and PlayerResource:IsValidPlayer(iPlayerID) then
		local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		Selection:AddCommonSelection(iPlayerID, {
			critical = {
				src = "s2r://panorama/images/challenges/icon_challenges_critdamage_png.vtex",
				title = "Selection_critical",
				description = "Selection_critical_description",
				callback = function()
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_CHANCE, 5)
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_MAGICAL_CRIT_CHANCE, 5)
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_PHYSICAL_CRIT_DAMAGE, 40)
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_MAGICAL_CRIT_DAMAGE, 40)
				end
			},
			armour = {
				src = "s2r://panorama/images/challenges/icon_challenges_puredamage_png.vtex",
				title = "Selection_armour",
				description = "Selection_armour_description",
				callback = function()
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ARMOR_IGNORE, 10)
				end
			},
			lifesteal = {
				src = "s2r://panorama/images/challenges/icon_challenges_lifestolen_png.vtex",
				title = "Selection_lifesteal",
				description = "Selection_lifesteal_description",
				callback = function()
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ALL_LIFESTEAL, 4)
				end
			},
			attack = {
				src = "s2r://panorama/images/challenges/icon_challenges_physicaldamage_png.vtex",
				title = "Selection_attack",
				description = "Selection_attack_description",
				callback = function()
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_FINALLY_DAMAGE, 5)
				end
			},
			armor = {
				src = "s2r://panorama/images/challenges/icon_challenges_killswitharmorreduce_png.vtex",
				title = "Selection_armor",
				description = "Selection_armor_description",
				callback = function()
					hHero:AddPermanentAttribute(CUSTOM_ATTRIBUTE_DAMAGE_REDUCE, 5)
				end
			},
		})
		self:Destroy()
	end
end