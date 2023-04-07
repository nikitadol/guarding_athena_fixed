---@class nevermore_2 : eom_ability
nevermore_2 = eom_ability({})
function nevermore_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hThinker = CreateModifierThinker(hCaster, self, "modifier_nevermore_2_thinker", { duration = self:GetSpecialValueFor("duration") }, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	hThinker.hCaster = hCaster
	hCaster:EmitSound("Hero_Warlock.Upheaval")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_2_thinker : eom_modifier
modifier_nevermore_2_thinker = eom_modifier({
	Name = "modifier_nevermore_2_thinker",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, ModifierThinker)
function modifier_nevermore_2_thinker:IsAura()
	return true
end
function modifier_nevermore_2_thinker:GetAuraRadius()
	return self.radius
end
function modifier_nevermore_2_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_nevermore_2_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_nevermore_2_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_nevermore_2_thinker:GetModifierAura()
	return "modifier_nevermore_2"
end
function modifier_nevermore_2_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_2_aura", nil)
		self:StartIntervalThink(0.1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/skills/hell_field_hellborn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 2, 5))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_nevermore_2_thinker:OnIntervalThink()
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/hell_field_hand.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, self.radius)))
	self:AddParticle(iParticleID, false, false, -1, false, false)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_2_aura : eom_modifier
modifier_nevermore_2_aura = eom_modifier({
	Name = "modifier_nevermore_2_aura",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_nevermore_2_aura:IsAura()
	return true
end
function modifier_nevermore_2_aura:GetAuraRadius()
	return self.radius
end
function modifier_nevermore_2_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_nevermore_2_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_nevermore_2_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_nevermore_2_aura:GetModifierAura()
	return "modifier_nevermore_2_debuff"
end
function modifier_nevermore_2_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_interval = self:GetAbilitySpecialValueFor("scepter_interval")
	if IsServer() then
		if self:GetCaster():GetScepterLevel() >= 3 then
			self:StartIntervalThink(self.scepter_interval)
			self.hAbility = self:GetCaster():FindAbilityByName("nevermore_1")
			self.shadowraze_radius = self.hAbility:GetSpecialValueFor("shadowraze_radius")
		end
	end
end
function modifier_nevermore_2_aura:OnIntervalThink()
	local iDistance = RandomInt(self.shadowraze_radius, self.radius - self.shadowraze_radius)
	local vStart = RandomVector(iDistance)
	for i = 1, 3 do
		self.hAbility:Shadowraze(self:GetParent():GetAbsOrigin() + Rotation2D(vStart, math.rad(120 * i)))
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_2 : eom_modifier
modifier_nevermore_2 = eom_modifier({
	Name = "modifier_nevermore_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_nevermore_2:GetAbilitySpecialValue()
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
end
function modifier_nevermore_2:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.health_regen_pct
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_2_debuff : eom_modifier
modifier_nevermore_2_debuff = eom_modifier({
	Name = "modifier_nevermore_2_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_nevermore_2_debuff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
end
function modifier_nevermore_2_debuff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_nevermore_2_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	hCaster:DealDamage(self:GetParent(), self:GetAbility(), self.damage)
end
function modifier_nevermore_2_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.damage_deepen
	}
end
function modifier_nevermore_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end
function modifier_nevermore_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed_reduce
end
function modifier_nevermore_2_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end