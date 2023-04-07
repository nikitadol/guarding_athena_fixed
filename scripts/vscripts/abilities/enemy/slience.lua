---@class slience: eom_ability
slience = eom_ability({}, nil, ability_base_ai)
function slience:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_silence", { duration = duration })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_DeathProphet.Silence")
end