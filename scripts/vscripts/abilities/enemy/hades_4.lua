---@class hades_4: eom_ability
hades_4 = eom_ability({
	funcUnitsCallback = function(hAbility, tTargets)
		for i = #tTargets, 1, -1 do
			if tTargets[i]:GetHealthPercent() > 60 then
				table.remove(tTargets, i)
			end
		end
	end
}, nil, ability_base_ai)
function hades_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	if not hTarget:TriggerSpellAbsorb(self) then
		hTarget:AddNewModifier(hCaster, self, "modifier_hades_4", { duration = stun_duration })
		-- particle chain
		local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticle, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		-- particle scythe
		local iParticle = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", hCaster), PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticle, 0, hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticle, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticle, 0, (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized())
		ParticleManager:SetParticleControlForward(iParticle, 1, (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized())
		-- sound
		hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_hades_4 : eom_modifier
modifier_hades_4 = eom_modifier({
	Name = "modifier_hades_4",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_hades_4:OnCreated(params)
	self.damage_per_health = self:GetAbilitySpecialValueFor("damage_per_health")
	if IsServer() then
		self.flHealth = math.max(self:GetParent():GetCustomHealth(), 1)
		self:StartIntervalThink(0)
	end
end
function modifier_hades_4:OnIntervalThink()
	if IsValid(self:GetParent()) and self:GetParent():IsAlive() then
		if self:GetParent():GetCustomHealth() > self.flHealth then
			self:GetParent():ModifyHealth(self.flHealth, self, false, 0)
		else
			self.flHealth = self:GetParent():GetCustomHealth()
		end
	end
end
function modifier_hades_4:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local flDamage = hParent:GetHealthDeficit() * self.damage_per_health
		self:GetCaster():DealDamage(hParent, self:GetAbility(), flDamage)
	end
end
function modifier_hades_4:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end