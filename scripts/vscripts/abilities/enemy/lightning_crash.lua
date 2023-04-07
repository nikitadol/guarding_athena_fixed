---@class lightning_crash: eom_ability
lightning_crash = eom_ability({}, nil, ability_base_ai)
function lightning_crash:OnSpellStart(vPosition)
	local hCaster = self:GetCaster()
	vPosition = default(vPosition, self:GetCursorPosition())
	local iPct = RandomInt(0, 100)
	if iPct <= 33 then
		local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
		local vStart = hCaster:GetAbsOrigin()
		local damage = self:GetSpecialValueFor("damage")
		local iCount = 0
		hCaster:GameTimer(0, function()
			if iCount < 4 then
				iCount = iCount + 1
				local vLocation = vStart + vDirection * 300 * iCount
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vLocation + Vector(0, 0, 1200))
				ParticleManager:SetParticleControl(iParticleID, 1, vLocation)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, 350, self)
				hCaster:DealDamage(tTargets, self, damage)
				---@param hUnit CDOTA_BaseNPC
				for _, hUnit in ipairs(tTargets) do
					hUnit:AddNewModifier(hCaster, self, "modifier_lightning_crash_debuff", { duration = 3 })
				end
				EmitSoundOnLocationWithCaster(vLocation, "Hero_Zuus.LightningBolt", hCaster)
				return 0.25
			end
		end)
	elseif iPct <= 66 then
		local iCount = 0
		hCaster:GameTimer(0, function()
			if iCount < 8 then
				iCount = iCount + 1
				local vLocation = vPosition + RandomVector(RandomInt(0, 250))
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vLocation + Vector(0, 0, 1200))
				ParticleManager:SetParticleControl(iParticleID, 1, vLocation)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_discharge.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, 350, self)
				hCaster:DealDamage(tTargets, self, damage)
				---@param hUnit CDOTA_BaseNPC
				for _, hUnit in ipairs(tTargets) do
					hUnit:AddNewModifier(hCaster, self, "modifier_lightning_crash_debuff", { duration = 3 })
				end
				EmitSoundOnLocationWithCaster(vLocation, "Hero_Zuus.LightningBolt", hCaster)
				return 0.25
			end
		end)
	else
		local hCloud = hCaster:SummonUnit("npc_dota_zeus_cloud", vPosition, true, 20)
		hCloud:SetForwardVector(Vector(0, 1, 0))
		hCloud:AddNewModifier(hCaster, self, "modifier_lightning_crash_thinker", nil)
		hCaster:EmitSound("Hero_Zuus.Righteous.Layer")
	end
end
function lightning_crash:GetIntrinsicModifierName()
	return "modifier_lightning_crash"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_lightning_crash : eom_modifier
modifier_lightning_crash = eom_modifier({
	Name = "modifier_lightning_crash",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lightning_crash:GetAbilitySpecialValue()
	self.att_rate = self:GetAbilitySpecialValueFor("att_rate")
	self.def_rate = self:GetAbilitySpecialValueFor("def_rate")
end
function modifier_lightning_crash:OnCreated(params)
	if IsServer() then
	end
end
function modifier_lightning_crash:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lightning_crash:OnDestroy()
	if IsServer() then
	end
end
function modifier_lightning_crash:OnTakeDamage(params)
	if PRD(self, self.def_rate, "modifier_lightning_crash") then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(50, 100))
		FindClearSpaceForUnit(hParent, vPosition, false)
		hParent:Purge(false, true, false, true, true)

		hParent:StartGesture(ACT_DOTA_TELEPORT_END)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		hParent:EmitSound("Hero_Zuus.Righteous.Layer")
	end
end
function modifier_lightning_crash:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_lightning_crash_debuff : eom_modifier
modifier_lightning_crash_debuff = eom_modifier({
	Name = "modifier_lightning_crash_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lightning_crash_debuff:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_lightning_crash_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end
----------------------------------------Modifier----------------------------------------
---@class modifier_lightning_crash_thinker : eom_modifier
modifier_lightning_crash_thinker = eom_modifier({
	Name = "modifier_lightning_crash_thinker",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lightning_crash_thinker:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_lightning_crash_thinker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(350, 0, 0))
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "flame_attachment", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lightning_crash_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hAbility) then
		hParent:ForceKill(false)
		self:Destroy()
		return
	end
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), 350, hAbility)
	local hTarget = tTargets[1]
	if IsValid(hTarget) then
		hParent:EmitSound("Hero_Zuus.LightningBolt")
		hParent:DealDamage(hTarget, hAbility, self.damage)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_lightning_crash_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end