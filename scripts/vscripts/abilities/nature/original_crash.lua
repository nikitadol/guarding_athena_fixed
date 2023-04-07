---@class original_crash: eom_ability
original_crash = eom_ability({
	funcUnitsCallback = function(hAbility, tTargets)
		local hCaster = hAbility:GetCaster()
		for i = #tTargets, 1, -1 do
			if tTargets[i]:GetModifierStackCount("modifier_arcane_attack_debuff", hCaster) < 4 then
				table.remove(tTargets, i)
			end
		end
	end
}, nil, ability_base_ai)
function original_crash:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local base_damage = self:GetSpecialValueFor("base_damage")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, 600, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, base_damage * (hUnit:GetLevel() * 0.1 + 1) * (hUnit:GetModifierStackCount("modifier_arcane_attack_debuff", hCaster) * 0.1 + 1))
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(600, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(600, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_ObsidianDestroyer.SanityEclipse.Cast")
	EmitSoundOnLocationWithCaster(vPosition, "Hero_ObsidianDestroyer.SanityEclipse", hCaster)
end