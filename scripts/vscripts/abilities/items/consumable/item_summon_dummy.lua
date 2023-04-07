---@class item_summon_dummy: eom_ability
item_summon_dummy = class({})
function item_summon_dummy:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:IsRealHero() then
		local vPosition = self:GetCursorPosition()

		local hDummy = CreateUnitByName("demo_dummy", vPosition, true, hCaster, hCaster, ENEMY_TEAM)

		hDummy:AddNewModifier(hDummy, nil, "modifier_dummy_damage", nil)
		hDummy:AddNewModifier(hDummy, nil, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })
		-- hDummy:SetAbilityPoints(0)
		hDummy:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
		hDummy:Hold()
		hDummy:SetIdleAcquire(false)
		hDummy:SetAcquisitionRange(0)

		self:SpendCharge()
	end
end