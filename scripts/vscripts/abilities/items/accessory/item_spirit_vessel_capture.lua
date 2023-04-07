---@class item_spirit_vessel_capture: eom_ability
item_spirit_vessel_capture = class({})
function item_spirit_vessel_capture:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hTarget, self, "modifier_item_spirit_vessel_capture_buff", { duration = duration })
	hTarget:AddNewModifier(hCaster, self, "modifier_item_spirit_vessel_capture_debuff", { duration = duration })
	hCaster:EmitSound("DOTA_Item.SpiritVessel.Cast")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_spirit_vessel_capture_buff : eom_modifier
modifier_item_spirit_vessel_capture_buff = eom_modifier({
	Name = "modifier_item_spirit_vessel_capture_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_spirit_vessel_capture_buff:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
end
function modifier_item_spirit_vessel_capture_buff:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.flHealth = hCaster:GetCustomMaxHealth() * self.damage_percent * 0.01
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_spirit_vessel_capture_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = self.flHealth
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_spirit_vessel_capture_debuff : eom_modifier
modifier_item_spirit_vessel_capture_debuff = eom_modifier({
	Name = "modifier_item_spirit_vessel_capture_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_spirit_vessel_capture_debuff:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
end
function modifier_item_spirit_vessel_capture_debuff:OnCreated(params)
	local hParent = self:GetParent()
	self.flHealth = hParent:GetCustomMaxHealth() * self.damage_percent * 0.01
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hCaster:DealDamage(hParent, hAbility, self.flHealth, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_spirit_vessel_capture_debuff:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		if IsValid(hParent) and hParent:IsAlive() then
			hParent:Heal(self.flHealth, self:GetAbility())
		end
	end
end
function modifier_item_spirit_vessel_capture_debuff:OnDeath(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if IsValid(hAbility) and hCaster:HasItemInInventory(hAbility:GetAbilityName()) then
			hCaster:TakeItem(hAbility)
			local hItem = CreateItem("item_spirit_vessel_release", nil, hCaster)
			hItem.hItem = hAbility
			hItem.sUnitName = hParent:GetUnitName()
			hItem.CustomStatusHealth = hParent:GetCustomMaxHealth()
			hItem.AttackDamage = hParent:GetAttackDamage()
			hItem.Armor = hParent:GetArmor()
			hCaster:AddItem(hItem)
		end
	end
end
function modifier_item_spirit_vessel_capture_debuff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_spirit_vessel_capture_release : eom_modifier
modifier_item_spirit_vessel_capture_release = eom_modifier({
	Name = "modifier_item_spirit_vessel_capture_release",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_spirit_vessel_capture_release:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
end
function modifier_item_spirit_vessel_capture_release:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf", PATTACH_ABSORIGIN, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_abaddon_borrowed_time.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_item_spirit_vessel_capture_release:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL = 1,
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL = self:GetParent():GetAttackDamage(),
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 100,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = 150
	}
end
function modifier_item_spirit_vessel_capture_release:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = -50,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BONUS = self:GetCaster():GetAttackDamage() + self:GetCaster():GetPrimaryStats() * 10,
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = self:GetCaster():GetCustomMaxHealth(),
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self:GetCaster():GetArmor(),
	}
end