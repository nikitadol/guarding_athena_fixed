---@class legion_commander_2: eom_ability
legion_commander_2 = eom_ability({})
function legion_commander_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local health = self:GetSpecialValueFor("health")
	local flHealthCost = hCaster:GetCustomHealth() * health * 0.01
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_2_buff", { duration = duration })
	hCaster:SpendHealth(flHealthCost, self, false)
	hCaster:FindModifierByName("modifier_legion_commander_0"):OnTakeDamage({ damage = flHealthCost })
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 2, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 3, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 15, Vector(255, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 16, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Huskar.Life_Break.Impact")
end
function legion_commander_2:ScepterAction()
	local hCaster = self:GetCaster()
	local scepter_duration = self:GetSpecialValueFor("scepter_duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_2_buff", { duration = scepter_duration })
end
function legion_commander_2:GetIntrinsicModifierName()
	return "modifier_legion_commander_2"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_2 : eom_modifier
modifier_legion_commander_2 = eom_modifier({
	Name = "modifier_legion_commander_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_2:GetAbilitySpecialValue()
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_legion_commander_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.attackspeed or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.movespeed or 0,
	}
end
function modifier_legion_commander_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.damage_percent
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_legion_commander_2_buff : eom_modifier
modifier_legion_commander_2_buff = eom_modifier({
	Name = "modifier_legion_commander_2_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_legion_commander_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH = 1
	}
end