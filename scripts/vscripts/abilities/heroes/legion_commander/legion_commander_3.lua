---@class legion_commander_3: eom_ability
legion_commander_3 = eom_ability({})
function legion_commander_3:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_legion_commander_1") then
		return 0.5
	end
	return self.BaseClass.GetCooldown(self, iLevel)
end
function legion_commander_3:MomentOfCourage(hTarget)
	local hCaster = self:GetCaster()
	local flDamage = self:GetSpecialValueFor("damage")
	local heal = self:GetSpecialValueFor("heal")
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	if hCaster:HasModifier("modifier_legion_commander_4") then
		distance = distance * 2
		flDamage = flDamage * 2
	end
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	ProjectileSystem:CreateLinearProjectile({
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/units/heroes/hero_legion_commander/legion_commander_3_shockwave.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = speed,
		flDistance = distance,
		flRadius = width,
		OnProjectileHit = function(hUnit, vPosition, tInfo)
			hCaster:DealDamage(hUnit, self, flDamage)
			hCaster:Heal(heal * flDamage * 0.01, self)
		end
	})
end
function legion_commander_3:GetIntrinsicModifierName()
	return "modifier_legion_commander_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_3 : eom_modifier
modifier_legion_commander_3 = eom_modifier({
	Name = "modifier_legion_commander_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_3:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		hParent:AddNewModifier(hParent, hAbility, "modifier_legion_commander_3_buff", { duration = 2 })
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_3.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:EmitSound("Hero_LegionCommander.Courage")
	end
end
function modifier_legion_commander_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_3_buff : eom_modifier
modifier_legion_commander_3_buff = eom_modifier({
	Name = "modifier_legion_commander_3_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})

function modifier_legion_commander_3_buff:GetAbilitySpecialValue()
	self.refresh_chance = self:GetAbilitySpecialValueFor("refresh_chance")
	self.scepter_attack = self:GetAbilitySpecialValueFor("scepter_attack")
end
function modifier_legion_commander_3_buff:OnCreated(params)
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_legion_commander_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = 0.01,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 1000
	}
end
function modifier_legion_commander_3_buff:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hTarget = params.target
	local hAbility = self:GetAbility()
	hAbility:MomentOfCourage(hTarget)
	local chance = hParent:HasModifier("modifier_legion_commander_4") and self.refresh_chance * 2 or self.refresh_chance
	if PRD(self, chance, "modifier_legion_commander_3_buff") then
		self:IncrementStackCount()
	end
	if hParent:GetScepterLevel() >= 1 then
		hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, self.scepter_attack)
	end
	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end
function modifier_legion_commander_3_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end