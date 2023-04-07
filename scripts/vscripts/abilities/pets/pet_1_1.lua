---@class pet_1_1: eom_ability
pet_1_1 = eom_ability({})
function pet_1_1:GetIntrinsicModifierName()
	return "modifier_pet_1_1"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_1_1 : eom_modifier
modifier_pet_1_1 = eom_modifier({
	Name = "modifier_pet_1_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_1_1:IsHidden()
	return true
end
function modifier_pet_1_1:OnCreated(params)
	self.tItems = {
		"item_bag_of_coin",
		"item_str_book",
		"item_agi_book",
		"item_int_book",
		"item_essence_small",
		"item_essence_medium",
		"item_essence_big",
		"item_clarity4",
		"item_salve4",
	}
	if IsServer() then
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	end
end
function modifier_pet_1_1:OnIntervalThink()
	local hParent = self:GetParent()
	local sItemName = RandomValue(self.tItems)
	local item = CreateItem(sItemName, nil, nil)
	item:SetPurchaseTime(GameRules:GetGameTime() - 10)
	local pos = hParent:GetAbsOrigin()
	local drop = CreateItemOnPositionSync(pos, item)
	local pos_launch = pos + RandomVector(RandomFloat(0, 50))
	item:LaunchLoot(item:IsCastOnPickup(), 200, 0.75, pos_launch)
	hParent:EmitSound("Hero_SkywrathMage.ChickenTaunt")
end