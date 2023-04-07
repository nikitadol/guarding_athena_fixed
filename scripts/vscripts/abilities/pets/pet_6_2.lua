---@class pet_6_2: eom_ability
pet_6_2 = eom_ability({})
function pet_6_2:GetIntrinsicModifierName()
	return "modifier_pet_6_2"
end
function pet_6_2:IsHiddenWhenStolen()
	return false
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_6_2 : eom_modifier
modifier_pet_6_2 = eom_modifier({
	Name = "modifier_pet_6_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_6_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_6_2:OnIntervalThink()
	local hParent = self:GetParent()
	local item = CreateItem("item_gold_egg", nil, nil)
	item:SetPurchaseTime(GameRules:GetGameTime() - 10)
	local pos = hParent:GetAbsOrigin()
	local drop = CreateItemOnPositionSync(pos, item)
	local pos_launch = pos + RandomVector(RandomFloat(0, 50))
	item:LaunchLoot(item:IsCastOnPickup(), 200, 0.75, pos_launch)
	self:GetAbility():UseResources(false, false, true)
	-- hParent:EmitSound("Hero_SkywrathMage.ChickenTaunt")
end