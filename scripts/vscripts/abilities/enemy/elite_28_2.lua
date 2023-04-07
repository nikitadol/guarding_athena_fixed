---@class elite_28_2: eom_ability
elite_28_2 = eom_ability({}, nil, ability_base_ai)
function elite_28_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local count = self:GetSpecialValueFor("count")
	local delay = self:GetSpecialValueFor("delay")
	local vPosition = Game.tTeamBase[DOTA_TEAM_GOODGUYS]:GetAbsOrigin() + RandomVector(RandomInt(100, 1500))
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), -1, self)
	for _, hUnit in pairs(tTargets) do
		if hUnit:GetUnitName() == "wave_28" and count > 0 then
			count = count - 1
			hUnit:AddNewModifier(hCaster, self, "modifier_elite_28_2", { duration = delay, vPosition = vPosition })
		end
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_teleport_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(delay, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_28_2 : eom_modifier
modifier_elite_28_2 = eom_modifier({
	Name = "modifier_elite_28_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_28_2:OnCreated(params)
	if IsServer() then
		self.vPosition = StringToVector(params.vPosition)
	end
end
function modifier_elite_28_2:OnDestroy(params)
	if IsServer() then
		if self:GetParent():IsAlive() then
			FindClearSpaceForUnit(self:GetParent(), self.vPosition, true)
		end
	end
end
function modifier_elite_28_2:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end