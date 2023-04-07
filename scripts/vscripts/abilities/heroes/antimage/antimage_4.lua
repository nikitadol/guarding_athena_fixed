---@class antimage_4: eom_ability
antimage_4 = eom_ability({})
function antimage_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	return true
end
function antimage_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_antimage_4", { duration = duration })
	hCaster:EmitSound("Hero_DeathProphet.Exorcism.Cast")
	if hCaster:GetScepterLevel() >= 4 then
		local hAbility = hCaster:FindAbilityByName("antimage_0")
		hCaster:AddNewModifier(hCaster, hAbility, "modifier_antimage_0_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
---@class modifier_antimage_4 : eom_modifier
modifier_antimage_4 = eom_modifier({
	Name = "modifier_antimage_4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	DestroyOnExpire = false,
})
function modifier_antimage_4:GetAbilitySpecialValue()
	self.transformation_time = self:GetAbilitySpecialValueFor("transformation_time")
	self.base_attack_time = self:GetAbilitySpecialValueFor("base_attack_time")
	self.bonus_range = self:GetAbilitySpecialValueFor("bonus_range")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
	self.heal_percent = self:GetAbilitySpecialValueFor("heal_percent")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.spirits = self:GetAbilitySpecialValueFor("spirits")
	self.spirit_speed = self:GetAbilitySpecialValueFor("spirit_speed")
	self.max_distance = self:GetAbilitySpecialValueFor("max_distance")
	self.give_up_distance = self:GetAbilitySpecialValueFor("give_up_distance")
	self.ghost_spawn_rate = self:GetAbilitySpecialValueFor("ghost_spawn_rate")
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_antimage_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = self.base_attack_time,
		MODIFIER_PROPERTY_MODEL_CHANGE = "models/heroes/terrorblade/demon.vmdl",
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND = "Hero_Terrorblade_Morphed.Attack",
		MODIFIER_PROPERTY_PROJECTILE_NAME = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf",
	}
end
function modifier_antimage_4:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = self.bonus_range,
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE = self.bonus_damage,
		EOM_MODIFIER_PROPERTY_CLEAVE_DAMAGE = self.cleave_damage,
		EOM_MODIFIER_PROPERTY_CLEAVE_RADIUS = self.cleave_radius,
	}
end
function modifier_antimage_4:DestroyOnExpire()
	return false
end
function modifier_antimage_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_antimage_4:OnCreated(params)
	local hCaster = self:GetCaster()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		local flDamage = self.damage
		self:StartIntervalThink(self.ghost_spawn_rate)

		self.sSoundName = "Hero_DeathProphet.Exorcism"
		hParent:EmitSound(self.sSoundName)

		self.tGhosts = {}

		self.unique_str = DoUniqueString("modifier_antimage_4")

		hParent:GameTimer(0, function()
			if not IsValid(self) then
				return
			end
			if not IsValid(hAbility) or not IsValid(hCaster) then
				return
			end
			if self:GetRemainingTime() <= -10 then
				self:Destroy()
				return
			end
			local hAttackTarget = hParent:GetAttackTarget()
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility(), FIND_CLOSEST)
			for i = #self.tGhosts, 1, -1 do
				local hGhost = self.tGhosts[i]

				if self:GetRemainingTime() <= 0 then
					hGhost.bReturning = true
					hGhost.hTarget = hParent
				end
				if hGhost.bReturning == false then
					local hTarget = hGhost.hTarget
					if IsValid(hTarget) and IsValid(hParent) then
						if not hTarget:IsAlive() or not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.give_up_distance) then
							hTarget = nil
						end
					end
					if not IsValid(hTarget) then
						hTarget = hAttackTarget
						if not IsValid(hTarget) then
							hTarget = GetRandomElement(tTargets)
						end
					end
					hGhost.hTarget = hTarget
					if not IsValid(hGhost.hTarget) then
						if hGhost.vTargetPosition == nil then
							hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
						end
					else
						hGhost.vTargetPosition = nil
					end
				end

				if IsValid(hParent) and IsValid(hGhost.hUnit) and not hParent:IsPositionInRange(hGhost.hUnit:GetAbsOrigin(), self.max_distance) then
					hGhost.hUnit:SetAbsOrigin(hParent:GetAbsOrigin())
				end

				local fAngularSpeed = self:GetRemainingTime() <= 0 and (1 / (1 / 30) * FrameTime()) or ((1 / 9) / (1 / 30) * FrameTime())
				local vTargetPosition = IsValid(hGhost.hTarget) and hGhost.hTarget:GetAbsOrigin() or hGhost.vTargetPosition
				local vDirection = vTargetPosition - hGhost.hUnit:GetAbsOrigin()
				vDirection.z = 0
				vDirection = vDirection:Normalized()

				local vForward = hGhost.hUnit:GetForwardVector()

				local fAngle = math.acos(Clamp(vDirection.x * vForward.x + vDirection.y * vForward.y, -1, 1))

				fAngularSpeed = math.min(fAngularSpeed, fAngle)

				local vCross = vForward:Cross(vDirection)
				if vCross.z < 0 then
					fAngularSpeed = -fAngularSpeed
				end
				vForward = Rotation2D(vForward, fAngularSpeed)

				hGhost.hUnit:SetForwardVector(vForward)

				local vPosition = GetGroundPosition(hGhost.hUnit:GetAbsOrigin() + hGhost.hUnit:GetForwardVector() * (self.spirit_speed * FrameTime()), hParent)
				hGhost.hUnit:SetAbsOrigin(vPosition)

				if hGhost.hUnit:IsPositionInRange(vTargetPosition, 32) then
					if hGhost.hTarget ~= nil then
						if hGhost.bReturning then
							hGhost.hTarget = nil
							hGhost.bReturning = false
							if self:GetRemainingTime() <= 0 then
								hGhost.hUnit:RemoveModifierByName("modifier_antimage_4_ghost")
								table.remove(self.tGhosts, i)
								if #self.tGhosts == 0 then
									self:Destroy()
									return
								end
							end
						else
							-- 诅咒
							if IsValid(hGhost.hTarget) then
								hCaster:DealDamage(hGhost.hTarget, hAbility, flDamage)
								hCaster:Heal(self.heal_percent * flDamage * 0.01, hAbility)
								hGhost.hTarget = hParent
								hGhost.bReturning = true
							end
						end
					else
						hGhost.vTargetPosition = hParent:GetAbsOrigin() + RandomVector(1) * RandomFloat(0, self.radius)
					end
				end
			end
			return 0
		end
		)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_antimage_4:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if IsValid(hParent) then
			hParent:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			hParent:StartGesture(ACT_DOTA_TELEPORT_END)
			hParent:StopSound(self.sSoundName)
		end

		for n, hGhost in pairs(self.tGhosts) do
			if IsValid(hGhost.hUnit) then
				hGhost.hUnit:RemoveModifierByName("modifier_antimage_4_ghost")
			end
		end
	end
end
function modifier_antimage_4:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		if #(self.tGhosts) < self.spirits then
			local vPosition = hCaster:GetAbsOrigin()
			local vForward = RandomVector(1)
			local hGhost = {
				hUnit = CreateModifierThinker(hCaster, hAbility, "modifier_antimage_4_ghost", nil, vPosition, hCaster:GetTeamNumber(), false),
				vTargetPosition = nil,
				hTarget = nil,
				bReturning = false
			}
			hGhost.hUnit:SetForwardVector(vForward)

			table.insert(self.tGhosts, hGhost)
		end
	end
end
---------------------------------------------------------------------
---@class modifier_antimage_4_ghost : eom_modifier
modifier_antimage_4_ghost = eom_modifier({
	Name = "modifier_antimage_4_ghost",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_4_ghost:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		self:GetParent():SetModelScale(0.9)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_4_ghost.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_antimage_4_ghost:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_antimage_4_ghost:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function modifier_antimage_4_ghost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA = 128
	}
end
function modifier_antimage_4_ghost:GetModifierModelChange(params)
	return "models/development/invisiblebox.vmdl"
end
function modifier_antimage_4_ghost:GetOverrideAnimation(params)
	return ACT_DOTA_RUN
end
---------------------------------------------------------------------
---@class modifier_antimage_4_poison : eom_modifier
modifier_antimage_4_poison = eom_modifier({
	Name = "modifier_antimage_4_poison",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_4_poison:GetAbilitySpecialValue()
	self.poison_damage = self:GetAbilitySpecialValueFor("poison_damage")
end
function modifier_antimage_4_poison:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_antimage_4_poison:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hCaster:DealDamage(hParent, hAbility, self.poison_damage)
end