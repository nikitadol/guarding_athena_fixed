---@class thunder_cloud: eom_ability
thunder_cloud = eom_ability({}, nil, ability_base_ai)
function thunder_cloud:GetRadius()
	return 800
end
function thunder_cloud:OnSpellStart()
	local hCaster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local iParticleID = ParticleManager:CreateParticle("particles/units/wave_38/thunder_cloud.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(512, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(800, 0, 0))
	hCaster:EmitSound("Hero_Razor.Storm.Cast")
	local iCount = 0
	hCaster:GameTimer(2, function()
		if iCount <= 50 then
			-- 随机点，控制点0控制落雷起始点，控制点1控制落雷结束点。
			local vPosition = hCaster:GetAbsOrigin() + RandomVector(RandomInt(0, 900))
			local iParticleID = ParticleManager:CreateParticle("particles/units/wave_38/thunder_cloud_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			-- 重复
			local vPosition = hCaster:GetAbsOrigin() + RandomVector(RandomInt(0, 900))
			local iParticleID = ParticleManager:CreateParticle("particles/units/wave_38/thunder_cloud_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			local vPosition = hCaster:GetAbsOrigin() + RandomVector(RandomInt(0, 900))
			local iParticleID = ParticleManager:CreateParticle("particles/units/wave_38/thunder_cloud_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
			ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
			iCount = iCount + 1
			EmitSoundOnLocationWithCaster(vPosition, "Hero_Zuus.ArcLightning.Cast", hCaster)
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 800, self)
			---@param hUnit CDOTA_BaseNPC
			for _, hUnit in ipairs(tTargets) do
				hCaster:DealDamage(hUnit, self, damage)
				hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = 1 })
			end
			return 0.03
		end
	end)
end