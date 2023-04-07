---@class item_urn_of_shadow: eom_ability
item_urn_of_shadow = eom_item({})
function item_urn_of_shadow:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	hTarget:AddNewModifier(hCaster, self, "modifier_item_urn_of_shadow_debuff", { duration = duration })
	hCaster:AddNewModifier(hTarget, self, "modifier_item_urn_of_shadow_buff", { duration = duration })
	hCaster:EmitSound("DOTA_Item.UrnOfShadows.Activate")
end
function item_urn_of_shadow:GetIntrinsicModifierName()
	return "modifier_item_urn_of_shadow"
end
function item_urn_of_shadow:Spawn()
	if IsServer() then
		self:ToggleAutoCast()
		self:GameTimer(0, function()
			if self:IsAbilityReady() and self:GetAutoCastState() then
				local hCaster = self:GetCaster()
				local flCastRange = self:GetCastRange(vec3_invalid, nil)
				local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, flCastRange, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				if IsValid(tTargets[1]) then
					ExecuteOrder(hCaster, DOTA_UNIT_ORDER_CAST_TARGET, self, tTargets[1])
				end
			end
			return AI_THINK_TICK_TIME
		end)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_urn_of_shadow : eom_modifier
modifier_item_urn_of_shadow = eom_modifier({
	Name = "modifier_item_urn_of_shadow",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_urn_of_shadow:GetAbilitySpecialValue()
	self.attribute_per_soul = self:GetAbilitySpecialValueFor("attribute_per_soul")
end
function modifier_item_urn_of_shadow:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS
	}
end
function modifier_item_urn_of_shadow:EOM_GetModifierBonusStats_All()
	return self:GetAbility():GetCurrentCharges() * self.attribute_per_soul
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_urn_of_shadow_buff : eom_modifier
modifier_item_urn_of_shadow_buff = eom_modifier({
	Name = "modifier_item_urn_of_shadow_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_urn_of_shadow_buff:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
	self.damage_per_soul = self:GetAbilitySpecialValueFor("damage_per_soul")
end
function modifier_item_urn_of_shadow_buff:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.flHealth = hCaster:GetCustomMaxHealth() * (self.damage_percent + self.damage_per_soul * self:GetAbility():GetCurrentCharges()) * 0.01
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/urn_of_shadows_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_urn_of_shadow_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = self.flHealth
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_urn_of_shadow_debuff : eom_modifier
modifier_item_urn_of_shadow_debuff = eom_modifier({
	Name = "modifier_item_urn_of_shadow_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_item_urn_of_shadow_debuff:GetAbilitySpecialValue()
	self.max_soul = self:GetAbilitySpecialValueFor("max_soul")
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
	self.damage_per_soul = self:GetAbilitySpecialValueFor("damage_per_soul")
end
function modifier_item_urn_of_shadow_debuff:OnCreated(params)
	local hParent = self:GetParent()
	self.flHealth = hParent:GetCustomMaxHealth() * (self.damage_percent + self.damage_per_soul * self:GetAbility():GetCurrentCharges()) * 0.01
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		hCaster:DealDamage(hParent, hAbility, self.flHealth, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/urn_of_shadows_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_urn_of_shadow_debuff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) and hParent:IsAlive() then
			hParent:Heal(self.flHealth, self:GetAbility())
		end
	end
end
function modifier_item_urn_of_shadow_debuff:OnDeath(params)
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		hAbility:SetCurrentCharges(hAbility:GetCurrentCharges() + 1)
		if hAbility:GetCurrentCharges() >= self.max_soul then
			hCaster:TakeItem(hAbility)
			local hItem = CreateItem("item_spirit_vessel_capture", nil, hCaster)
			if not Items:TryGiveItem(hCaster, hItem) then
				Items:DropItem(hCaster:GetPlayerOwnerID(), hItem, hCaster:GetAbsOrigin())
			end
			hAbility:Remove()
		end
	end
end
function modifier_item_urn_of_shadow_debuff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end