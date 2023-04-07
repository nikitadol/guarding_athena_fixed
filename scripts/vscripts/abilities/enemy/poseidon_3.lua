---@class poseidon_3: eom_ability
poseidon_3 = eom_ability({}, nil, ability_base_ai)
function poseidon_3:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function poseidon_3:Ravage(IsReturn)
	local caster = self:GetCaster()
	local distance = 0
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local speed = self:GetSpecialValueFor("speed")

	local width = 250
	if IsReturn == true then
		distance = radius - width
		speed = -speed
	end

	local particle_speed = radius / 1.3
	local particleID = ParticleManager:CreateParticle("particles/econ/items/tidehunter/tide_2021_immortal/tide_2021_ravage.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particleID, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particleID, 1, Vector(width, 1, 1))
	ParticleManager:SetParticleControl(particleID, 2, Vector(particle_speed * 0.35, 1, 1))
	ParticleManager:SetParticleControl(particleID, 3, Vector(particle_speed * 0.7, 1, 1))
	ParticleManager:SetParticleControl(particleID, 4, Vector(particle_speed * 1.05, 1, 1))
	ParticleManager:SetParticleControl(particleID, 5, Vector(particle_speed * 1.3, 1, 1))
	ParticleManager:ReleaseParticleIndex(particleID)

	local record_targets = {}
	local position = caster:GetAbsOrigin()
	self:GameTimer(0, function()
		if not GameRules:IsGamePaused() then
			distance = distance + speed * FrameTime()
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, distance + width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, 1, false)
			---@param hUnit CDOTA_BaseNPC
			for n, hUnit in pairs(targets) do
				if hUnit:GetUnitName() ~= "npc_dota_roshan" and not hUnit:IsPositionInRange(position, distance) and TableFindKey(record_targets, hUnit) == nil then
					local particleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", caster), PATTACH_ABSORIGIN_FOLLOW, hUnit)
					ParticleManager:ReleaseParticleIndex(particleID)

					-- hUnit:AddNewModifier(caster, self, "modifier_poseidon_3_debuff", { duration = duration * hUnit:GetStatusResistanceFactor(caster) })
					-- hUnit:RemoveModifierByName("modifier_poseidon_3_motion")
					hUnit:KnockBack((hUnit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized(), 200, 0, 0.5)
					caster:DealDamage(hUnit, self, self:GetAbilityDamage())
					-- hUnit:AddNewModifier(caster, self, "modifier_poseidon_3_motion", { duration = duration * hUnit:GetStatusResistanceFactor(caster) })
					table.insert(record_targets, hUnit)
				end
			end
			if distance + width >= radius then
				return nil
			end
		end
		return 0
	end)
	if not IsReturn then
		caster:EmitSound("Ability.GushCast")
	end
end
function poseidon_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local iCount = 6
	hCaster:GameTimer(0, function()
		if iCount > 0 then
			iCount = iCount - 1
			self:Ravage()
			return 1.2
		end
	end)
end