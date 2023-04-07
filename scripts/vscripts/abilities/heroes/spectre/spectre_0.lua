---@class spectre_0 : eom_ability
spectre_0 = eom_ability({})
function spectre_0:OnSpellStart()
	local hCaster = self:GetCaster()
	for i = #self.tIllusions, 1, -1 do
		self.tIllusions[i]:RemoveModifierByName("modifier_spectre_0_show")
	end
	self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
end
function spectre_0:GetIntrinsicModifierName()
	return "modifier_spectre_0"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_0 : eom_modifier
modifier_spectre_0 = eom_modifier({
	Name = "modifier_spectre_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_0:GetAbilitySpecialValue()
	self.unit_limit = self:GetAbilitySpecialValueFor("unit_limit")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_spectre_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_spectre_0:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hAbility.tIllusions = {}
	end
end
function modifier_spectre_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_spectre_0:SummonIllusion()
	if #self:GetAbility().tIllusions < self.unit_limit then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		local hTarget = RandomValue(tTargets)
		if IsValid(hTarget) then
			local vPosition = hTarget:GetAbsOrigin() + RandomVector(125)
			local hUnit = hParent:SummonUnit("spectre", vPosition, true, self.duration, {
				CustomStatusHealth = hParent:GetCustomMaxHealth()
			})
			hUnit:SetHealth(hUnit:GetMaxHealth() * self.health * 0.01)
			hUnit:SetForwardVector((hTarget:GetAbsOrigin() - vPosition):Normalized())
			hUnit:AddNewModifier(hParent, hAbility, "modifier_spectre_0_show", { duration = self.duration })
			-- hUnit:AddAbility("spectre_2"):SetLevel(hParent:FindAbilityByName("spectre_2"):GetLevel())
			-- hUnit:AddAbility("spectre_3"):SetLevel(hParent:FindAbilityByName("spectre_3"):GetLevel())
			hUnit:AddNewModifier(hParent, hParent:FindAbilityByName("spectre_2"), "modifier_spectre_2", nil)
			hUnit:AddNewModifier(hParent, hParent:FindAbilityByName("spectre_3"), "modifier_spectre_3", nil)
			table.insert(hAbility.tIllusions, hUnit)
		end
	end
end
function modifier_spectre_0:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:SummonIllusion()
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_spectre_0_show : eom_modifier
modifier_spectre_0_show = eom_modifier({
	Name = "modifier_spectre_0_show",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_spectre_0_show:GetAbilitySpecialValue()
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
end
function modifier_spectre_0_show:OnCreated(params)
	self.damage = self:GetCaster():GetScepterLevel() >= 1 and self:GetAbilitySpecialValueFor("scepter_illusion_damage") or self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_0_show:OnRemoved()
	if IsServer() then
		-- 伤害
		local hParent = self:GetParent()
		local hModifier = hParent:FindModifierByName("modifier_spectre_3")
		if IsValid(hModifier) then
			hModifier:OnTakeDamage({ unit = hParent, damage = hParent:GetHealth() })
		end
		hParent:ForceKill(false)
		hParent:AddNoDraw()
		ArrayRemove(self:GetAbility().tIllusions, self:GetParent())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_spectre_0_show:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_OUTGOING_DAMAGE_PERCENTAGE = self.damage - 100
	}
end
function modifier_spectre_0_show:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
function modifier_spectre_0_show:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function modifier_spectre_0_show:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if self.attack_count > 0 then
				self.attack_count = self.attack_count - 1
			end
			if self.attack_count <= 0 then
				self:Destroy()
			end
		end
	end
end