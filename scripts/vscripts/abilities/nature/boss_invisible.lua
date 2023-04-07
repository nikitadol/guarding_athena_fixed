---@class boss_invisible: eom_ability
boss_invisible = eom_ability({})
function boss_invisible:GetIntrinsicModifierName()
	return "modifier_boss_invisible"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_invisible : eom_modifier
modifier_boss_invisible = eom_modifier({
	Name = "modifier_boss_invisible",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_invisible:OnCreated(params)
	if IsServer() then
		self.tUnitRemainingList = {}
		for i, v in ipairs(NeutralSpawners.tSpawnerData) do
			if v.sNPCClassName == "zombie_stand" then
				table.insert(self.tUnitRemainingList, v.tUnitRemaining)
			end
		end
		self:StartIntervalThink(1)
		-- self:OnIntervalThink()
		local hParent = self:GetParent()
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_boss_invisible_buff", nil)
	end
end
function modifier_boss_invisible:OnIntervalThink()
	local hParent = self:GetParent()
	if self:IsZombieEmpty() then
		if hParent:HasModifier("modifier_boss_invisible_buff") then
			hParent:RemoveModifierByName("modifier_boss_invisible_buff")
		end
	else
		-- if not hParent:HasModifier("modifier_boss_invisible_buff") then
		-- 	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_boss_invisible_buff", nil)
		-- end
	end
end
function modifier_boss_invisible:IsZombieEmpty()
	if self.tUnitRemainingList then
		for i, v in ipairs(self.tUnitRemainingList) do
			if #v > 0 then
				return false
			end
		end
	end
	return true
end
----------------------------------------Modifier----------------------------------------
---@class modifier_boss_invisible_buff : eom_modifier
modifier_boss_invisible_buff = eom_modifier({
	Name = "modifier_boss_invisible_buff",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_boss_invisible_buff:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_boss_invisible_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
end
function modifier_boss_invisible_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	hParent:DealDamage(tTargets, hAbility, self.damage)
end
function modifier_boss_invisible_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL = 1
	}
end
function modifier_boss_invisible_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end