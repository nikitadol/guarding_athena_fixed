---@class thunder_wrath: eom_ability
thunder_wrath = eom_ability({
	funcCondition = function(hAbility)
		local hCaster = hAbility:GetCaster()
		if hCaster:GetUnitName() == "zeus" and hCaster:GetHealthPercent() <= 70 then
			return true
		end
		if hCaster:GetUnitName() == "zeus_reborn" and hCaster:GetHealthPercent() <= 90 then
			return true
		end
		return false
	end
}, nil, ability_base_ai)
function thunder_wrath:GetRadius()
	return 2000
end
function thunder_wrath:OnSpellStart()
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	local cooldown_increase = self:GetSpecialValueFor("cooldown_increase")
	hCaster:EmitSound("Hero_Zuus.GodsWrath.PreCast.Arcana")
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_spawn", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 3, hCaster:GetAbsOrigin())
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 2000, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin() + Vector(0, 0, 2000))
		ParticleManager:SetParticleControl(iParticleID, 1, hUnit:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		EmitSoundOnLocationWithCaster(hUnit:GetAbsOrigin(), "Hero_Zuus.LightningBolt", hCaster)
		hCaster:DealDamage(hUnit, self, damage)
		hUnit:AddNewModifier(hCaster, self, "modifier_thunder_wrath", { duration = duration })
		for i = 0, 6 do
			local hAbility = hUnit:GetAbilityByIndex(i)
			if IsValid(hAbility) and not hAbility:IsToggle() and KeyValues:GetAbilityData(hAbility, "IgnoreCooldownReduction") ~= "1" then
				if hAbility:IsCooldownReady() then
					hAbility:UseResources(false, false, true)
				else
					local cd = hAbility:GetCooldownTimeRemaining() + cooldown_increase
					hAbility:StartCooldown(cd)
				end
			end
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_thunder_wrath : eom_modifier
modifier_thunder_wrath = eom_modifier({
	Name = "modifier_thunder_wrath",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_thunder_wrath:GetAbilitySpecialValue()
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_thunder_wrath:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = -(self.attackspeed or 0),
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = -(self.movespeed or 0)
	}
end