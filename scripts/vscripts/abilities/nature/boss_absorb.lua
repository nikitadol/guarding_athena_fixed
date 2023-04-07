---@class boss_absorb: eom_ability
boss_absorb = eom_ability({}, nil, ability_base_ai)
function boss_absorb:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hCaster:DealDamage(hTarget, self, self:GetSpecialValueFor("damage"))
	hCaster:Heal(self:GetSpecialValueFor("heal"), self)
	hCaster:EmitSound("Greevil.LeechSeed.Target")
	local iParticleID = ParticleManager:CreateParticle("particles/skills/seed_absorb.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	hTarget:AddNewModifier(hCaster, self, BUILT_IN_MODIFIER.TREANT_OVERGROWTH, { duration = 4 })
end