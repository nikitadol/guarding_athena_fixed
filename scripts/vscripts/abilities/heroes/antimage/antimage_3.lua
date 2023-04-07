---@class antimage_3: eom_ability
antimage_3 = eom_ability({})
function antimage_3:GetIntrinsicModifierName()
	return "modifier_antimage_3"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_antimage_3 : eom_modifier
modifier_antimage_3 = eom_modifier({
	Name = "modifier_antimage_3",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_3:GetAbilitySpecialValue()
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.max_attack = self:GetAbilitySpecialValueFor("max_attack")
end
function modifier_antimage_3:OnTakeDamage(params)
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local hParent = self:GetParent()
		local hTarget = params.unit
		local hAbility = self:GetAbility()
		local flDamage = self:GetAbilitySpecialValueFor("damage")
		if hParent:IsIllusion() then
			hParent.caster:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, self.attack)
			hParent.caster:DealDamage(hTarget, hAbility, flDamage, nil, DOTA_DAMAGE_FLAG_REFLECTION)
		else
			hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, self.attack)
			hParent:DealDamage(hTarget, hAbility, flDamage, nil, DOTA_DAMAGE_FLAG_REFLECTION)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:EmitSound("Hero_Antimage.ManaBreak")
	end
end
function modifier_antimage_3:OnAttackLanded(params)
	local hParent = self:GetParent()
	if hParent:GetScepterLevel() >= 3 and not AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		self.hTarget = params.target
		self:StartIntervalThink(0.25)
		self:SetStackCount(2)
	end
end
function modifier_antimage_3:OnIntervalThink()
	if IsValid(self.hTarget) and self.hTarget:IsAlive() then
		local hParent = self:GetParent()
		hParent:Attack(self.hTarget, ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOOLDOWN)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/time_lock_bash.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:StartIntervalThink(-1)
		end
	else
		self:StartIntervalThink(-1)
	end
end
function modifier_antimage_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = { self:GetParent() },
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end