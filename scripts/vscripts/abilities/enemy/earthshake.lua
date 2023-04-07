---@class earthshake: eom_ability
earthshake = eom_ability({}, nil, ability_base_ai)
function earthshake:GetRadius()
	return 1000
end
function earthshake:OnSpellStart()
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage") * 0.01
	local damageType = self:GetAbilityDamageType()
	local vStart = hCaster:GetAbsOrigin()
	local distance = 2000
	local angle = 0
	local delay = self:GetSpecialValueFor("delay")
	local iCount = 16
	local flAngle = 360 / iCount
	for i = 1, iCount do
		local vDirection = RotatePosition(vec3_zero, QAngle(0, flAngle * i + RandomInt(-15, 15), 0), Vector(0, 1, 0))
		local vEnd = vStart + vDirection * distance
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vStart)
		ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(0, delay, 0))
		ParticleManager:SetParticleControl(iParticleID, 11, vEnd)
		ParticleManager:SetParticleControl(iParticleID, 12, vEnd)
	end
	hCaster:GameTimer(delay, function()
		for i = 1, iCount do
			local vDirection = RotatePosition(vec3_zero, QAngle(0, flAngle * i + RandomInt(-15, 15), 0), Vector(0, 1, 0))
			local vEnd = vStart + vDirection * distance
			local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vEnd, 100, self)
			---@param hUnit CDOTA_BaseNPC
			for _, hUnit in ipairs(tTargets) do
				hCaster:DealDamage(hUnit, self, hUnit:GetCustomMaxHealth() * damage)
			end
		end
		hCaster:EmitSound("Hero_ElderTitan.EarthSplitter.Destroy")
	end)
	hCaster:EmitSound("Hero_ElderTitan.EarthSplitter.Cast")
	hCaster:EmitSound("Hero_ElderTitan.EarthSplitter.Projectile")
end