---@class alien_line: eom_ability
alien_line = eom_ability({})
function alien_line:GetIntrinsicModifierName()
	return "modifier_alien_line"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_alien_line : eom_modifier
modifier_alien_line = eom_modifier({
	Name = "modifier_alien_line",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_alien_line:GetAbilitySpecialValue()
	self.hp = self:GetAbilitySpecialValueFor("hp")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_alien_line:OnTakeDamage(params)
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local hParent = self:GetParent()
		local flDamage = math.min(hParent:GetCustomMaxHealth(), params.damage)
		local iPct = flDamage / hParent:GetCustomMaxHealth()
		if iPct >= self.hp * 0.01 then
			local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(1200, 1800))
			local iParticleID = ParticleManager:CreateParticle("particles/units/alien_line_tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 9, hParent:GetAttachmentPosition("attach_hitloc"))
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			hParent:EmitSound("Hero_Tinker.Laser")
			local tTargets = FindUnitsInLineWithAbility(hParent, hParent:GetAbsOrigin(), vPosition, 200, hAbility)
			hParent:DealDamage(tTargets, hAbility, self.damage)
		end
	end
end
function modifier_alien_line:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end