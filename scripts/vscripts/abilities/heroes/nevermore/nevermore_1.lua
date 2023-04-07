---@class nevermore_1 : eom_ability
nevermore_1 = eom_ability({})
function nevermore_1:GetCastAnimation()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_nevermore_1")
	local iStackCount = IsValid(hModifier) and hModifier:GetStackCount() + 1 or 1
	if iStackCount == 1 then
		return ACT_DOTA_RAZE_3
	elseif iStackCount == 2 then
		return ACT_DOTA_RAZE_2
	elseif iStackCount == 3 then
		return ACT_DOTA_RAZE_1
	end
end
-- function nevermore_1:OnAbilityPhaseStart()
-- 	local hCaster = self:GetCaster()
-- 	local tPosition = self:GetPosition()
-- 	for i, vPosition in ipairs(tPosition) do
-- 		local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
-- 		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
-- 		ParticleManager:ReleaseParticleIndex(iParticleID)
-- 	end
-- 	return true
-- end
function nevermore_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local tPosition = self:GetPosition()
	for i, vPosition in ipairs(tPosition) do
		self:Shadowraze(vPosition)
	end
	hCaster:EmitSound("Hero_Nevermore.Shadowraze")
	self:EndCooldown()
	hCaster:AddNewModifier(hCaster, self, "modifier_nevermore_1", { duration = self:GetSpecialValueFor("combo_duration") })
end
function nevermore_1:GetPosition()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_nevermore_1")
	local iStackCount = IsValid(hModifier) and hModifier:GetStackCount() + 1 or 1
	local vForward = hCaster:GetForwardVector()
	local tDistance = {
		self:GetLevelSpecialValueFor("shadowraze_range", 0),
		self:GetLevelSpecialValueFor("shadowraze_range", 1),
		self:GetLevelSpecialValueFor("shadowraze_range", 2),
	}
	local tPosition = {}
	if iStackCount == 1 then
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[2])
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[3])
	elseif iStackCount == 2 then
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(20)) * tDistance[2])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(-20)) * tDistance[2])
	else
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(60)) * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(-60)) * tDistance[1])
	end
	return tPosition
end
function nevermore_1:Shadowraze(vPosition)
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("shadowraze_radius")
	local flDamage = self:GetSpecialValueFor("damage")
	local flDuration = self:GetSpecialValueFor("duration")
	local flScepterBonusDamage = self:GetSpecialValueFor("scepter_bonus_damage")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in pairs(tTargets) do
		local flBonusDamagePct = 0
		-- if hCaster:GetScepterLevel() >= 2 then
		local hModifier = hUnit:FindModifierByName("modifier_nevermore_1_debuff")
		flBonusDamagePct = IsValid(hModifier) and hModifier:GetStackCount() * flScepterBonusDamage * 0.01 or 0
		-- end
		hCaster:DealDamage(hUnit, self, flDamage * (1 + flBonusDamagePct))
		hUnit:AddNewModifier(hCaster, self, "modifier_nevermore_1_debuff", { duration = flDuration })
	end

	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_1 : eom_modifier
modifier_nevermore_1 = eom_modifier({
	Name = "modifier_nevermore_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	DestroyOnExpire = false
})
function modifier_nevermore_1:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
		self:StartIntervalThink(0)
	end
end
function modifier_nevermore_1:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_nevermore_1:OnIntervalThink()
	if self:GetRemainingTime() <= 0 and self:GetParent():GetCurrentActiveAbility() == nil then
		self:Destroy()
	end
end
function modifier_nevermore_1:OnStackCountChanged(iStackCount)
	if iStackCount == 2 then
		self:Destroy()
	end
end
function modifier_nevermore_1:OnDestroy()
	if IsServer() then
		self:GetAbility():UseResources(false, false, true)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_nevermore_1_debuff : eom_modifier
modifier_nevermore_1_debuff = eom_modifier({
	Name = "modifier_nevermore_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_nevermore_1_debuff:GetAbilitySpecialValue()
	self.reduce_damage = self:GetAbilitySpecialValueFor("reduce_damage")
	self.stack_reduce_damage = self:GetAbilitySpecialValueFor("stack_reduce_damage")
	self.max_reduce_damage = self:GetAbilitySpecialValueFor("max_reduce_damage")
end
function modifier_nevermore_1_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_nevermore_1_debuff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_nevermore_1_debuff:EDeclareFunctions()
	return {
	-- EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE
	}
end
function modifier_nevermore_1_debuff:EOM_GetModifierOutgoingDamagePercentage(params)
	return math.min(-self.reduce_damage - self.stack_reduce_damage * self:GetStackCount(), -self.max_reduce_damage)
end