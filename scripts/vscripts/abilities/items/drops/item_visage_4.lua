---@class item_visage_4: eom_ability
item_visage_4 = class({})
function item_visage_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:RefreshAbilities()
	hCaster:RefreshItems()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_visage_4_buff", { duration = duration })
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CENTER_FOLLOW, hCaster)
	-- sound
	hCaster:EmitSound("DOTA_Item.Refresher.Activate")
end
function item_visage_4:GetIntrinsicModifierName()
	return "modifier_item_visage_4"
end
function item_visage_4:IsRefreshable()
	return false
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_4 : eom_modifier
modifier_item_visage_4 = eom_modifier({
	Name = "modifier_item_visage_4",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_4:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.shield = self:GetAbilitySpecialValueFor("shield")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_item_visage_4:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_visage_4_shield")
	end
end
function modifier_item_visage_4:OnIntervalThink()
	local hParent = self:GetParent()
	if not hParent:HasModifier("modifier_item_visage_4_shield") then
		local hModifier = hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_visage_4_shield", nil)
		local tShieldList = hParent:AddShield(hParent:GetCustomMaxHealth() * self.shield * 0.01, hModifier, DAMAGE_TYPE_MAGICAL)
		hModifier.tShieldList = tShieldList
	else
		local hModifier = hParent:FindModifierByName("modifier_item_visage_4_shield")
		for i, v in ipairs(hModifier.tShieldList) do
			v.flValue = hParent:GetCustomMaxHealth() * self.shield * 0.01
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_4_shield : eom_modifier
modifier_item_visage_4_shield = eom_modifier({
	Name = "modifier_item_visage_4_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_4_shield:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_visage_4_buff : eom_modifier
modifier_item_visage_4_buff = eom_modifier({
	Name = "modifier_item_visage_4_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_visage_4_buff:GetAbilitySpecialValue()
	self.damage_increase = self:GetAbilitySpecialValueFor("damage_increase")
end
function modifier_item_visage_4_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = self.damage_increase
	}
end