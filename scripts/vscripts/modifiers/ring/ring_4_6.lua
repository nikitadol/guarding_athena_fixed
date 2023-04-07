---@class ring_4_6: eom_modifier 石像鬼
ring_4_6 = eom_modifier({
	Name = "ring_4_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_4_6:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() },
	}
end
function ring_4_6:OnValidAbilityExecuted(params)
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(1)
		local iParticleID = ParticleManager:CreateParticle("particles/items/ring/ring_4_6.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local hParent = self:GetParent()
		for i = 0, 10 do
			local hAbility = hParent:GetAbilityByIndex(i)
			if IsValid(hAbility) and hAbility:GetCooldownTimeRemaining() > 0 and hAbility:IsRefreshable() and PRD(self, 25, "ring_4_6") then
				hAbility:EndCooldown()
				break
			end
		end
	end
end
function ring_4_6:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function ring_4_6:GetAbsoluteNoDamagePhysical()
	if self:GetStackCount() == 1 then
		return 1
	end
end
function ring_4_6:GetAbsoluteNoDamageMagical()
	if self:GetStackCount() == 1 then
		return 1
	end
end
function ring_4_6:GetAbsoluteNoDamagePure()
	if self:GetStackCount() == 1 then
		return 1
	end
end
function ring_4_6:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = self:GetStackCount() == 1,
	}
end
function ring_4_6:OnIntervalThink()
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end
function ring_4_6:GetTexture()
	return "item_ring_secret"
end