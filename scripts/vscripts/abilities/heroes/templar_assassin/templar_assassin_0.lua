---@class templar_assassin_0 : eom_ability
templar_assassin_0 = eom_ability({})
function templar_assassin_0:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_0_shield", nil)
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")
end
function templar_assassin_0:GetIntrinsicModifierName()
	return "modifier_templar_assassin_0"
end
function templar_assassin_0:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_0 : eom_modifier
modifier_templar_assassin_0 = eom_modifier({
	Name = "modifier_templar_assassin_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_0:GetAbilitySpecialValue()
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
end
function modifier_templar_assassin_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_templar_assassin_0:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
		self.tGroup = {}
	end
end
function modifier_templar_assassin_0:OnIntervalThink()
	local hParent = self:GetParent()
	local bNotMaxShield = not hParent:HasModifier("modifier_templar_assassin_0_shield") or hParent:FindModifierByName("modifier_templar_assassin_0_shield"):GetStackCount() < self.max_charges
	if self:GetAbility():GetAutoCastState() == true and
	self:GetAbility():GetCharges() > 0 and
	bNotMaxShield then
		self:GetAbility():CastAbility()
	end
end
function modifier_templar_assassin_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_CHARGE_CHANGED = { self:GetParent() }
	}
end
function modifier_templar_assassin_0:OnAbilityChargeChanged(params)
	if IsServer() then
		local hParent = self:GetParent()
		if #self.tGroup < params.charge then
			local tGroup = ProjectileSystem:CreateGroupSurroundProjectile({
				hCaster = hParent,
				hAbility = self:GetAbility(),
				flCircleRadius = 100,
				flAngularVelocity = 90,
				iCount = params.charge - #self.tGroup,
				flOffset = 64,
				sGroupName = "modifier_templar_assassin_0",
				flRadius = 75,
				sEffectName = "particles/heroes/revelater/revelater_orb_b.vpcf",
			})
			self.tGroup = ArrayConcat(self.tGroup, tGroup)
		else
			for i = #self.tGroup, params.charge + 1, -1 do
				ProjectileSystem:DestroyProjectile(self.tGroup[i], true)
				table.remove(self.tGroup, i)
			end
		end
	end
end
function modifier_templar_assassin_0:OnDestroy()
	if IsServer() then
		ProjectileSystem:DestroyPartOfSurroundProjectileWithGroup("modifier_templar_assassin_0", self.tGroup)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_templar_assassin_0_shield : eom_modifier
modifier_templar_assassin_0_shield = eom_modifier({
	Name = "modifier_templar_assassin_0_shield",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
})
function modifier_templar_assassin_0_shield:GetAbilitySpecialValue()
	self.max_charges = self:GetAbilitySpecialValueFor("max_charges")
	self.cost_pct_per_stack = self:GetAbilitySpecialValueFor("cost_pct_per_stack")
	self.scepter_damage = self:GetAbilitySpecialValueFor("scepter_damage")
	self.scepter_radius = self:GetAbilitySpecialValueFor("scepter_radius")
end
function modifier_templar_assassin_0_shield:OnCreated(params)
	if IsServer() then
		self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_shield_0.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:SetStackCount(1)
	end
end
function modifier_templar_assassin_0_shield:OnRefresh(params)
	if IsServer() then
		if self:GetStackCount() < self.max_charges then
			self:IncrementStackCount()
		else
			-- self:Broken()
		end
	end
end
function modifier_templar_assassin_0_shield:Broken()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:GetScepterLevel() >= 2 then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.scepter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		hParent:DealDamage(tTargets, hAbility, hParent:GetAgility() * self.scepter_damage, DAMAGE_TYPE_MAGICAL)
	end
end
function modifier_templar_assassin_0_shield:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
	end
end
function modifier_templar_assassin_0_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_templar_assassin_0_shield:OnTooltip()
	return self:GetStackCount() * self.cost_pct_per_stack
end
function modifier_templar_assassin_0_shield:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	if IsServer() then
		if hParent == params.target and self:GetStackCount() > 0 then
			if params.damage > self.cost_pct_per_stack * hParent:GetCustomMaxHealth() * 0.01 * self:GetStackCount() then
				self:DecrementStackCount()
				hParent:Purge(false, true, false, true, true)
			end
			return 1
		end
	end
end
function modifier_templar_assassin_0_shield:OnStackCountChanged(iStackCount)
	local hParent = self:GetParent()
	if IsServer() then
		ParticleManager:DestroyParticle(self.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = ParticleManager:CreateParticle("particles/heroes/revelater/revelater_shield_" .. self:GetStackCount() .. ".vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- self:Broken()
	end
end