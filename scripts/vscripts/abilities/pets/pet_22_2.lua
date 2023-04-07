---@class pet_22_2: eom_ability
pet_22_2 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_22_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_2", { duration = self:GetDuration() })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_2 : eom_modifier
modifier_pet_22_2 = eom_modifier({
	Name = "modifier_pet_22_2",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_2:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/pets/pet_22_2.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bag", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_22_2:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hMaster = hCaster:GetMaster()
	local iRound = Rounds:GetRoundNumber()
	if iRound == nil or iRound == 0 then
		iRound = 1
	end
	local iGold = RandomInt(20, 80) * iRound
	-- print(iGold)
	-- hMaster:ModifyGold(iGold, true, 0)
	PlayerData:ModifyGold(hMaster:GetPlayerOwnerID(), iGold)
	SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_GOLD, self:GetParent():GetMaster(), iGold, self:GetParent():GetPlayerOwner())
	self:GetParent():EmitSound("ui.comp_coins_tick")
end