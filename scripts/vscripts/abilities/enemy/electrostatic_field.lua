---@class electrostatic_field: eom_ability
electrostatic_field = eom_ability({})
function electrostatic_field:GetIntrinsicModifierName()
	return "modifier_electrostatic_field"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_electrostatic_field : eom_modifier
modifier_electrostatic_field = eom_modifier({
	Name = "modifier_electrostatic_field",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_electrostatic_field:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.silence_per_stack = self:GetAbilitySpecialValueFor("silence_per_stack")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
end
function modifier_electrostatic_field:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED
	}
end
function modifier_electrostatic_field:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end
function modifier_electrostatic_field:OnValidAbilityExecuted()
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		---@param hUnit CDOTA_BaseNPC
		for _, hUnit in ipairs(tTargets) do
			hUnit:SpendHealth(self.damage * hUnit:GetCustomMaxHealth() * 0.01, hAbility, false)
			hUnit:AddNewModifier(hParent, hAbility, "modifier_silence", { duration = self.silence_per_stack * self:GetStackCount() })
		end
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/disruptor/disruptor_ti8_immortal_weapon/disruptor_ti8_immortal_thunder_strike_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 7, Vector(self.radius - 50, 0, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:EmitSound("Hero_Disruptor.ThunderStrike.Target")
		self:IncrementStackCount()
		if self:GetStackCount() >= self.max_stack then
			self:SetStackCount(0)
			local hAbility = hParent:FindAbilityByName("thunder_wrath")
			if IsValid(hAbility) then
				hAbility:OnSpellStart()
			end
		end
	end
end