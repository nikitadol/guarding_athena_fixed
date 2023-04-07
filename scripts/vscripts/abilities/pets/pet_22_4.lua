---@class pet_22_4: eom_ability
pet_22_4 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_22_4:GetRadius()
	return 600
end
function pet_22_4:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Lycan.Shapeshift.Cast")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	return true
end
function pet_22_4:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_Lycan.Shapeshift.Cast")
end
function pet_22_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_stunned", { duration = self:GetDuration() })
	local hUnit = hMaster:SummonUnit("nian", hCaster:GetAbsOrigin(), true, self:GetDuration(), {
		CustomStatusHealth = hMaster:GetPrimaryStats() * 1000,
		AttackDamage = hMaster:GetPrimaryStats() * 100,
		Armor = hMaster:GetPrimaryStats() / 100
	})
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
	hUnit.GetMaster = function(hUnit)
		return hMaster
	end
	hCaster:AddNoDraw()
	hCaster:GameTimer(self:GetDuration(), function()
		hCaster:RemoveNoDraw()
		if IsValid(hUnit) then
			hCaster:SetAbsOrigin(hUnit:GetAbsOrigin())
			hUnit:AddNoDraw()
		end
	end)
end