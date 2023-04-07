---@class solar_magic_fire: eom_ability
solar_magic_fire = eom_ability({}, nil, ability_base_ai)
function solar_magic_fire:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_solar_magic_fire", { duration = self:GetChannelTime() })
end
function solar_magic_fire:OnChannelFinish(bInterrupted)
	if IsServer() then
		self:GetCursorTarget():RemoveModifierByName("modifier_solar_magic_fire")
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_solar_magic_fire : eom_modifier
modifier_solar_magic_fire = eom_modifier({
	Name = "modifier_solar_magic_fire",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_solar_magic_fire:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_solar_magic_fire:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_solar_magic_fire:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		self:StartIntervalThink(0.2)
		hCaster:EmitSound("Hero_Pugna.LifeDrain.Target")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/solar_magic_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_solar_magic_fire:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster:StopSound("Hero_Pugna.LifeDrain.Target")
	end
end
function modifier_solar_magic_fire:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hCaster) or not hCaster:IsAlive() then
		self:Destroy()
		return
	end
	hCaster:DealDamage(hParent, hAbility, self.damage * 0.2, DAMAGE_TYPE_MAGICAL)
	if (hCaster:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D() > 1200 then
		self:Destroy()
	end
end
function modifier_solar_magic_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING = 1
	}
end