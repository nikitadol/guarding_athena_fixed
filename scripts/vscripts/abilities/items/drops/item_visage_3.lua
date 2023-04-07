---@class item_visage_3: eom_ability
item_visage_3 = class({})
function item_visage_3:GetIntrinsicModifierName()
	return "modifier_item_visage_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_3 : eom_modifier
modifier_item_visage_3 = eom_modifier({
	Name = "modifier_item_visage_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_3:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.shield = self:GetAbilitySpecialValueFor("shield")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_item_visage_3:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_visage_3_shield")
	end
end
function modifier_item_visage_3:OnIntervalThink()
	local hParent = self:GetParent()
	if not hParent:HasModifier("modifier_item_visage_3_shield") then
		local hModifier = hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_visage_3_shield", nil)
		local tShieldList = hParent:AddShield(hParent:GetCustomMaxHealth() * self.shield * 0.01, hModifier, DAMAGE_TYPE_MAGICAL)
		hModifier.tShieldList = tShieldList
	else
		local hModifier = hParent:FindModifierByName("modifier_item_visage_3_shield")
		for i, v in ipairs(hModifier.tShieldList) do
			v.flValue = hParent:GetCustomMaxHealth() * self.shield * 0.01
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_3_shield : eom_modifier
modifier_item_visage_3_shield = eom_modifier({
	Name = "modifier_item_visage_3_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_3_shield:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end