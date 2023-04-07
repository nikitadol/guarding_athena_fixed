---@class item_prestige_pipe: eom_ability
item_prestige_pipe = class({})
function item_prestige_pipe:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function item_prestige_pipe:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(hHero, self, "modifier_item_prestige_pipe_thinker", { duration = duration }, vPosition, hHero:GetTeamNumber(), false)
	EmitSoundOnLocationWithCaster(vPosition, "Hero_Riki.Smoke_Screen", hHero)
end
function item_prestige_pipe:GetIntrinsicModifierName()
	return "modifier_item_prestige_pipe"
end
---@class item_prestige_pipe_2: eom_ability
item_prestige_pipe_2 = class({}, nil, item_prestige_pipe)
---@class item_prestige_pipe_3: eom_ability
item_prestige_pipe_3 = class({}, nil, item_prestige_pipe)
---@class item_prestige_pipe_4: eom_ability
item_prestige_pipe_4 = class({}, nil, item_prestige_pipe)
----------------------------------------Modifier----------------------------------------
---@class modifier_item_prestige_pipe : eom_modifier
modifier_item_prestige_pipe = eom_modifier({
	Name = "modifier_item_prestige_pipe",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
}, nil, aura_base)
function modifier_item_prestige_pipe:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("aura_radius")
end
function modifier_item_prestige_pipe:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_prestige_pipe_buff : eom_modifier
modifier_item_prestige_pipe_buff = eom_modifier({
	Name = "modifier_item_prestige_pipe_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_prestige_pipe_buff:GetAbilitySpecialValue()
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
end
function modifier_item_prestige_pipe_buff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.bonus_damage,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.health_regen_pct,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_prestige_pipe_thinker : eom_modifier
modifier_item_prestige_pipe_thinker = eom_modifier({
	Name = "modifier_item_prestige_pipe_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	IsModifierThinker = true,
}, nil, aura_base)
function modifier_item_prestige_pipe_thinker:GetAbilitySpecialValue()
	self.aura_radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbility():GetSpecialValueForUnit("damage", self:GetCaster())
end
function modifier_item_prestige_pipe_thinker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/items_fx/item_prestige_pipe.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aura_radius, self.aura_radius, self.aura_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_prestige_pipe_thinker:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.aura_radius, hAbility)
		hCaster:DealDamage(tTargets, hAbility, self.damage)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_prestige_pipe_thinker_buff : eom_modifier
modifier_item_prestige_pipe_thinker_buff = eom_modifier({
	Name = "modifier_item_prestige_pipe_thinker_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_prestige_pipe_thinker_buff:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_item_prestige_pipe_thinker_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end