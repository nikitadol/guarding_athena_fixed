---@class life_absorb: eom_ability
life_absorb = eom_ability({}, nil, ability_base_ai)
function life_absorb:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_life_absorb", { duration = 15 })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_life_absorb : eom_modifier
modifier_life_absorb = eom_modifier({
	Name = "modifier_life_absorb",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_life_absorb:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_life_absorb:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_life_absorb:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		self:StartIntervalThink(0.2)
		hCaster:EmitSound("Hero_Pugna.LifeDrain.Target")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_life_absorb:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster:StopSound("Hero_Pugna.LifeDrain.Target")
	end
end
function modifier_life_absorb:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hCaster) or not hCaster:IsAlive() then
		self:Destroy()
		return
	end
	hCaster:DealDamage(hParent, hAbility, self.damage * 0.2, DAMAGE_TYPE_MAGICAL)
	hCaster:Heal(self.heal * 0.2, hAbility)
	if (hCaster:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D() > 1200 then
		self:Destroy()
	end
end