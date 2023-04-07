---@class boss_chaos_land: eom_ability
boss_chaos_land = eom_ability({})
function boss_chaos_land:GetIntrinsicModifierName()
	return "modifier_boss_chaos_land"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_chaos_land : eom_modifier
modifier_boss_chaos_land = eom_modifier({
	Name = "modifier_boss_chaos_land",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, aura_base)
function modifier_boss_chaos_land:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		hParent:EmitSound("Hero_DoomBringer.ScorchedEarthAura")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/skills/chaos_weather.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.aura_radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_boss_chaos_land:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:StopSound("Hero_DoomBringer.ScorchedEarthAura")
	end
end
function modifier_boss_chaos_land:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 100,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = 40,
	}
end
function modifier_boss_chaos_land:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 5,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = 8000,
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_chaos_land_buff : eom_modifier
modifier_boss_chaos_land_buff = eom_modifier({
	Name = "modifier_boss_chaos_land_buff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_chaos_land_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_boss_chaos_land_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_boss_chaos_land_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	hCaster:DealDamage(hParent, hAbility, self.damage)
end