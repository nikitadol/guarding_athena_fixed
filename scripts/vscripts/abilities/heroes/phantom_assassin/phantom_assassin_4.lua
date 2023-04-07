---@class phantom_assassin_4: eom_ability
phantom_assassin_4 = eom_ability({})
function phantom_assassin_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local count = self:GetSpecialValueFor("count")
	local interval = self:GetSpecialValueFor("interval")
	hCaster:AddNewModifier(hCaster, self, "modifier_phantom_assassin_4", { duration = count * interval })
end
----------------------------------------Modifier----------------------------------------
---@class modifier_phantom_assassin_4 : eom_modifier
modifier_phantom_assassin_4 = eom_modifier({
	Name = "modifier_phantom_assassin_4",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_phantom_assassin_4:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.width = self:GetAbilitySpecialValueFor("width")
end
function modifier_phantom_assassin_4:OnCreated(params)
	if IsServer() then
		self.iCount = 0
		self:StartIntervalThink(self.interval)
		self.vCenter = self:GetParent():GetAbsOrigin()
	end
end
function modifier_phantom_assassin_4:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local vStart = hCaster:GetAbsOrigin()
	local tTargetsOuter = FindUnitsInRadiusWithAbility(hCaster, self.vCenter, self.range, hAbility)
	local tTargetsInner = FindUnitsInRadiusWithAbility(hCaster, self.vCenter, self.range * 0.5, hAbility)
	local range = self.range
	if #tTargetsOuter <= 10 and #tTargetsInner == #tTargetsOuter and #tTargetsInner ~= 0 then
		range = self.range * 0.5
	end
	local vPosition = self.vCenter + RandomVector(RandomInt(0, range))
	local vDirection = (vPosition - vStart):Normalized()
	hCaster:SetForwardVector(vDirection)

	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vPosition, self.width, hAbility)
	hCaster:DealDamage(tTargets, hAbility, self.damage)
	FindClearSpaceForUnit(hCaster, vPosition, false)
	EmitSoundOnLocationWithCaster(vStart, "Hero_QueenOfPain.Blink_out", hCaster)
	EmitSoundOnLocationWithCaster(vPosition, "Hero_QueenOfPain.Blink_in", hCaster)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 2, vDirection * (vPosition - vStart):Length2D())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	ProjectileSystem:ProjectileDodge(hCaster)
	self.iCount = self.iCount + 1
	if self.iCount >= 10 then
		self.iCount = 0
		hCaster:FindAbilityByName("phantom_assassin_1"):OnSpellStart()
	end
end
function modifier_phantom_assassin_4:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = 1
	}
end
function modifier_phantom_assassin_4:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = -100
	}
end