---@class ring_5_6: eom_modifier 血夜
ring_5_6 = eom_modifier({
	Name = "ring_5_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	IsIndependent = true,
	StackDuration = 10
})
function ring_5_6:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE
	}
end
function ring_5_6:OnValidAbilityExecuted(params)
	if IsServer() then
		self:IncrementStackCount()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/items/ring/ring_5_6.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		for i = 0, 10 do
			local hAbility = hParent:GetAbilityByIndex(i)
			if IsValid(hAbility) and hAbility:GetCooldownTimeRemaining() > 0 and hAbility:IsRefreshable() then
				local flRemaining = hAbility:GetCooldownTimeRemaining()
				hAbility:EndCooldown()
				if flRemaining > 2 then
					hAbility:StartCooldown(flRemaining - 2)
				end
				break
			end
		end
	end
end
function ring_5_6:EOM_GetModifierOutgoingDamagePercentage()
	return self:GetStackCount() * 25
end
function ring_5_6:GetTexture()
	return "item_ring_secret"
end