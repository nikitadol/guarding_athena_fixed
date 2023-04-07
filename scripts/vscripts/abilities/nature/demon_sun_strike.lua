---@class demon_sun_strike: eom_ability
demon_sun_strike = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetCaster():GetHealthPercent() < 70
	end
}, nil, ability_base_ai)
function demon_sun_strike:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCenter = hCaster:GetAbsOrigin()
	local distance = self:GetSpecialValueFor("distance")
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local delay = self:GetSpecialValueFor("delay")
	local tPosition = {}
	for i = 1, 24 do
		local vPosition = vCenter + RandomVector(RandomInt(0, distance))
		table.insert(tPosition, vPosition)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	self:GameTimer(delay, function()
		for i, v in ipairs(tPosition) do
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, v)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, v, radius, self)
			hCaster:DealDamage(tTargets, self, damage)
		end
	end)
end