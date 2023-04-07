---@class item_spirit_vessel_release: eom_ability
item_spirit_vessel_release = class({})
function item_spirit_vessel_release:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local hUnit = CreateUnitByNameWithNewData(self.sUnitName, vPosition, true, hCaster, hCaster, hCaster:GetTeamNumber(), {
		CustomStatusHealth = self.CustomStatusHealth,
		Armor = self.Armor,
		AttackDamage = self.AttackDamage,
	})
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	hUnit:AddNewModifier(hCaster, self.hItem, "modifier_kill", { duration = duration })
	hUnit:AddNewModifier(hCaster, self.hItem, "modifier_item_spirit_vessel_capture_release", { duration = duration })
	hCaster:TakeItem(self)
	hCaster:AddItem(self.hItem)
	if IsValid(self.hItem.hUnit) and self.hItem.hUnit:IsAlive() then
		self.hItem.hUnit:Kill(self.hItem, hCaster)
	end
	self.hItem.hUnit = hUnit
	self:Remove()
end