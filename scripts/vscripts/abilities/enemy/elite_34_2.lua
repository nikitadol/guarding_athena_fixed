---@class elite_34_2: eom_ability
elite_34_2 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetCaster():GetHealthPercent() <= 80
	end
}, nil, ability_base_ai)
function elite_34_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vDirection = -hCaster:GetForwardVector()
	local duration = self:GetSpecialValueFor("duration")
	local health_pct = self:GetSpecialValueFor("health_pct")
	local tPosition = {
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(45)) * 400,
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-45)) * 400,
	}
	for i = 1, 2 do
		local hUnit = hCaster:SummonUnit("elite_34_split", tPosition[i], true, duration, {
			CustomStatusHealth = hCaster:GetCustomMaxHealth() * health_pct * 0.01
		})
		hUnit:SetForwardVector(-vDirection)
		hUnit:AddNewModifier(hCaster, self, "modifier_elite_34_2", { duration = duration })
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		if i == 1 then
			hUnit:AddAbility("elite_34_3", 1)
		else
			hUnit:AddAbility("elite_34_4", 1)
		end
	end
	-- praticle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_QueenOfPain.Blink_out")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_elite_34_2 : eom_modifier
modifier_elite_34_2 = eom_modifier({
	Name = "modifier_elite_34_2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_elite_34_2:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_2_END)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hParent:EmitSound("Hero_QueenOfPain.Blink_in")
	else
	end
end
function modifier_elite_34_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_elite_34_2:OnRemoved()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		hParent:AddNoDraw()
		if hParent:IsAlive() and IsValid(hCaster) and IsValid(self:GetAbility()) then
			hParent:ForceKill(false)
			-- 回复主身血量
			local flAmount = hCaster:GetCustomMaxHealth() * self.health_pct * 0.01
			hCaster:Heal(flAmount, self:GetAbility())
			hCaster:RefreshAbilities()
		end
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end