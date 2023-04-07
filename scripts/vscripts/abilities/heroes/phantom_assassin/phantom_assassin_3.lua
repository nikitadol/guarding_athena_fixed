---@class phantom_assassin_3: eom_ability
phantom_assassin_3 = eom_ability({})
function phantom_assassin_3:OnSpellStart(hTarget)
	local hCaster = self:GetCaster()
	hTarget = default(hTarget, self:GetCursorTarget())
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	hCaster:DealDamage(hTarget, self, damage)
	hCaster:EmitSound("DOTA_Item.AbyssalBlade.Activate")
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/warden/clusters_stars_active.vpcf", PATTACH_ABSORIGIN, hTarget)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hTarget:AddNewModifier(hCaster, self, "modifier_phantom_assassin_3_debuff", { duration = duration })
	hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = duration })
end
function phantom_assassin_3:GetIntrinsicModifierName()
	return "modifier_phantom_assassin_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_3 : eom_modifier
modifier_phantom_assassin_3 = eom_modifier({
	Name = "modifier_phantom_assassin_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_phantom_assassin_3:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not hParent:HasModifier("modifier_phantom_assassin_3_buff") then
		hParent:AddNewModifier(hParent, hAbility, "modifier_phantom_assassin_3_buff", { duration = 2 })
	end
end
function modifier_phantom_assassin_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_3_buff : eom_modifier
modifier_phantom_assassin_3_buff = eom_modifier({
	Name = "modifier_phantom_assassin_3_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_phantom_assassin_3_buff:GetAbilitySpecialValue()
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_phantom_assassin_3_buff:OnCreated(params)
	if IsServer() then
		self:SetStackCount(2)
	end
end
function modifier_phantom_assassin_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = 0.1,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 1000
	}
end
function modifier_phantom_assassin_3_buff:OnDamageCalculated(params)
	local hParent = self:GetParent()
	local hTarget = params.target
	local hAbility = self:GetAbility()
	if PRD(self, self.chance, "modifier_phantom_assassin_3_buff") then
		self:IncrementStackCount()
	end
	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end
function modifier_phantom_assassin_3_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DAMAGE_CALCULATED = { self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_3_debuff : eom_modifier
modifier_phantom_assassin_3_debuff = eom_modifier({
	Name = "modifier_phantom_assassin_3_debuff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_phantom_assassin_3_debuff:GetAbilitySpecialValue()
	self.reduce_armor = self:GetAbilitySpecialValueFor("reduce_armor")
end
function modifier_phantom_assassin_3_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = -self.reduce_armor
	}
end