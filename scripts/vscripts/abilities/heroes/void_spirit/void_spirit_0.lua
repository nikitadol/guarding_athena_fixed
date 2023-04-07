---@class void_spirit_0 : eom_ability
void_spirit_0 = eom_ability({})
function void_spirit_0:Spawn()
	local hCaster = self:GetCaster()
	self.tIllusion = {}
	hCaster.tAetherRemnant = self.tIllusion
	hCaster.AetherRemnant = function(hCaster, vPosition)
		self:AetherRemnant(vPosition)
	end
	hCaster:GameTimer(0, function()
		if self:IsFullyCastable() and self:GetAutoCastState() == true then
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetCastRange(vec3_invalid, nil), DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			if IsValid(tTargets[1]) then
				hCaster:SetCursorPosition(tTargets[1]:GetAbsOrigin())
				hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
				self:OnSpellStart()
				self:UseResources(true, false, true)
				-- ExecuteOrder(self:GetCaster(), DOTA_UNIT_ORDER_CAST_POSITION, niil, self, tTargets[1]:GetAbsOrigin())
			end
		end
		return AI_THINK_TICK_TIME
	end)
end
function void_spirit_0:OnUpgrade()
	if self:GetLevel() == 1 and not self:GetCaster():IsIllusion() then
		self:ToggleAutoCast()
	end
end
function void_spirit_0:AetherRemnant(vPosition)
	local hCaster = self:GetCaster()
	local flDuration = self:GetSpecialValueFor("duration")
	local illusions = hCaster:CreateIllusions(hCaster, { duration = flDuration, outgoing_damage = 0, incoming_damage = 0 }, 1, 100, false, false)
	illusions[1].caster_hero = hCaster
	illusions[1]:SetAbsOrigin(GetGroundPosition(vPosition, illusions[1]))
	illusions[1]:AddNewModifier(hCaster, self, "modifier_void_spirit_0", nil)
	table.insert(self.tIllusion, illusions[1])
	return illusions[1]
end
function void_spirit_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDistance = (vPosition - hCaster:GetAbsOrigin()):Length2D()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local tInfo = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf",
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vDirection = vDirection,
		iMoveSpeed = 900,
		flDistance = flDistance,
		OnProjectileDestroy = function(vPosition, tInfo)
			self:AetherRemnant(vPosition)
		end
	}
	ProjectileSystem:CreateLinearProjectile(tInfo)
	ParticleManager:SetParticleControlEnt(tInfo.iParticleID, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, "", hCaster:GetAbsOrigin(), false)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_void_spirit_0 : eom_modifier
modifier_void_spirit_0 = eom_modifier({
	Name = "modifier_void_spirit_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_void_spirit_0:GetAbilitySpecialValue()
	self.scepter_cooldown = self:GetAbilitySpecialValueFor("scepter_cooldown")
end
function modifier_void_spirit_0:OnCreated(params)
	if IsServer() then
		self:SetStackCount(1)
		self.hAbility = self:GetParent():FindAbilityByName("void_spirit_3")
		self.max_travel_distance = self.hAbility:GetSpecialValueFor("max_travel_distance")
		self.bScepter = self:GetCaster():GetScepterLevel() >= 4
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10001, false, false)
	end
end
function modifier_void_spirit_0:OnIntervalThink()
	self:SetStackCount(1)
	self:StartIntervalThink(-1)
end
function modifier_void_spirit_0:OnDestroy()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			ArrayRemove(self:GetAbility().tIllusion, self:GetParent())
		end
	end
end
function modifier_void_spirit_0:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
	}
end
function modifier_void_spirit_0:EOM_GetModifierAttackRangeBonus()
	if self:GetStackCount() == 1 and self.bScepter then
		return self.max_travel_distance * 0.5
	end
end
function modifier_void_spirit_0:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
	}
end
function modifier_void_spirit_0:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function modifier_void_spirit_0:OnAttackLanded(params)
	if IsServer() then
		if self:GetStackCount() == 1 and self.bScepter then
			self:SetStackCount(0)
			self:StartIntervalThink(self.scepter_cooldown)
			self.hAbility:AstralStepScepter(params.target:GetAbsOrigin())
		end
	end
end