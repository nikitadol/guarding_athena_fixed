---@class elite_30_1: eom_ability
elite_30_1 = eom_ability({}, nil, ability_base_ai)
function elite_30_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local mana_burn = self:GetSpecialValueFor("mana_burn")
	local flMana = hTarget:GetMana() * mana_burn * 0.01
	hTarget:SpendMana(flMana, self)
	hCaster:DealDamage(hTarget, self, flMana * self:GetSpecialValueFor("damage_pct") * 0.01)
	SendOverheadEventMessage(hCaster:GetPlayerOwner(), OVERHEAD_ALERT_MANA_LOSS, hTarget, flMana, hCaster:GetPlayerOwner())
	local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/necronomicon_archer_manaburn.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hTarget:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
end