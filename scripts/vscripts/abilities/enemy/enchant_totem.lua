---@class enchant_totem: eom_ability
enchant_totem = eom_ability({}, nil, ability_base_ai)
function enchant_totem:GetRadius()
	return self:GetSpecialValueFor("radius")
end
function enchant_totem:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = 1 })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:AddNewModifier(hCaster, self, "modifier_enchant_totem", { duration = duration })
	hCaster:EmitSound("Hero_EarthShaker.Totem")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_enchant_totem : eom_modifier
modifier_enchant_totem = eom_modifier({
	Name = "modifier_enchant_totem",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_enchant_totem:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.totem_damage_percentage = self:GetAbilitySpecialValueFor("totem_damage_percentage")
end
function modifier_enchant_totem:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_buff.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_totem", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_enchant_totem:OnAttackLanded(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = params.target
		local hAbility = self:GetAbility()
		local vLocation = hTarget:GetAbsOrigin()
		local iParticleID = ParticleManager:CreateParticle("particles/units/wave_23/enchant_totem_earth_shock.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:GameTimer(1.5, function()
			hParent:EmitSound("Hero_EarthShaker.EchoSlamSmall")
			local tTargets = FindUnitsInRadiusWithAbility(hParent, vLocation, 300, hAbility)
			---@param hUnit CDOTA_BaseNPC
			for _, hUnit in ipairs(tTargets) do
				hUnit:SpendHealth(hUnit:GetCustomMaxHealth() * 0.5, hAbility, true)
				hUnit:AddNewModifier(hCaster, hAbility, "modifier_stunned", { duration = self.stun_duration })
			end
		end)
		self:Destroy()
	end
end
function modifier_enchant_totem:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end
function modifier_enchant_totem:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND = "Hero_EarthShaker.Totem.Attack",
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = "enchant_totem",

	}
end
function modifier_enchant_totem:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = self.totem_damage_percentage,
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end