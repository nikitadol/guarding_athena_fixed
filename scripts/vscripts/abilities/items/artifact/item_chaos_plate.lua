---@class item_chaos_plate: eom_ability 混沌盘
item_chaos_plate = class({})
function item_chaos_plate:IsRefreshable()
	return false
end
function item_chaos_plate:GetIntrinsicModifierName()
	return "modifier_item_chaos_plate"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_chaos_plate : eom_modifier
modifier_item_chaos_plate = eom_modifier({
	Name = "modifier_item_chaos_plate",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_chaos_plate:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.shield = self:GetAbilitySpecialValueFor("shield")
	self.health_bonus = self:GetAbilitySpecialValueFor("health_bonus")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.avoid_duration = self:GetAbilitySpecialValueFor("avoid_duration")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_item_chaos_plate:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_chaos_plate_shield")
	end
end
function modifier_item_chaos_plate:OnIntervalThink()
	if IsServer() and self:GetParent():IsAlive() then
		local hParent = self:GetParent()
		hParent:Purge(false, true, false, true, true)
		if not hParent:HasModifier("modifier_item_chaos_plate_shield") then
			local hModifier = hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_chaos_plate_shield", nil)
			local tShieldList = hParent:AddShield(hParent:GetCustomMaxHealth() * self.shield * 0.01, hModifier)
			hModifier.tShieldList = tShieldList
		else
			local hModifier = hParent:FindModifierByName("modifier_item_chaos_plate_shield")
			for i, v in ipairs(hModifier.tShieldList) do
				v.flValue = hParent:GetCustomMaxHealth() * self.shield * 0.01
			end
		end
	end
end
function modifier_item_chaos_plate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION,
	}
end
function modifier_item_chaos_plate:ReincarnateTime()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			local hParent = self:GetParent()
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_chaos_plate_buff", { duration = self.avoid_duration })
			self:GetAbility():UseResources(true, true, true)
			self:GetParent():RefreshAbilities()
			self:GetParent():RefreshItems()
			local iParticleID = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:ReleaseParticleIndex(iParticleID)
			return 1
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_chaos_plate_shield : eom_modifier
modifier_item_chaos_plate_shield = eom_modifier({
	Name = "modifier_item_chaos_plate_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_chaos_plate_shield:OnCreated(params)
	self.shield = self:GetAbilitySpecialValueFor("shield")
	local hParent = self:GetParent()
	if IsServer() then
		-- self.flShieldHealth = hParent:GetCustomMaxHealth() * self.shield * 0.01
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/items/chaos_plate/chaos_plate_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_chaos_plate_shield:OnRefresh(params)
	self.shield = self:GetAbilitySpecialValueFor("shield")
	if IsServer() then
		-- self.flShieldHealth = self:GetParent():GetCustomMaxHealth() * self.shield * 0.01
	end
end
function modifier_item_chaos_plate_shield:OnShieldDestroy()
	self:Destroy()
end
function modifier_item_chaos_plate_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_chaos_plate_buff : eom_modifier
modifier_item_chaos_plate_buff = eom_modifier({
	Name = "modifier_item_chaos_plate_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_chaos_plate_buff:OnCreated(params)
	local hParent = self:GetParent()
end
function modifier_item_chaos_plate_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end
function modifier_item_chaos_plate_buff:GetAbsoluteNoDamagePhysical(params)
	return 1
end
function modifier_item_chaos_plate_buff:GetAbsoluteNoDamageMagical(params)
	return 1
end
function modifier_item_chaos_plate_buff:GetAbsoluteNoDamagePure(params)
	return 1
end