---@class ring_2_6: eom_modifier 夜光
ring_2_6 = eom_modifier({
	Name = "ring_2_6",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function ring_2_6:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = { self:GetParent() },
	}
end
function ring_2_6:OnCreated(params)
	if IsServer() then
		self:SetStackCount(1)
	end
end
function ring_2_6:OnDeath(t)
	if IsServer() and self:GetStackCount() == 1 then
		self:SetStackCount(0)
		self:StartIntervalThink(1.5)
		local hParent = self:GetParent()
		for i = 1, 16 do
			if hParent:GetAbilityByIndex(i - 1) then
				local hAbility = hParent:GetAbilityByIndex(i - 1)
				if hAbility:GetCooldownTimeRemaining() > 0 then
					local flRemaining = hAbility:GetCooldownTimeRemaining()
					if flRemaining < 1 then
						flRemaining = 1
					end
					hAbility:EndCooldown()
					hAbility:StartCooldown(flRemaining - 1)
				end
			end
		end
		PlayerData:ModifyGold(hParent:GetPlayerOwnerID(), 36 * Rounds:GetRoundNumber())
	end
end

function ring_2_6:OnIntervalThink()
	self:SetStackCount(1)
	self:StartIntervalThink(-1)
end
function ring_2_6:GetTexture()
	return "item_ring_secret"
end