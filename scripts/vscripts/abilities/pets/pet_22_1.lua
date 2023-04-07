---@class pet_22_1: eom_ability
pet_22_1 = eom_ability({
	funcCondition = function(hAbility)
		return hAbility:GetAutoCastState()
	end
}, nil, ability_base_ai)
function pet_22_1:GetRadius()
	return 400
end
function pet_22_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_1", nil)
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_1 : eom_modifier
modifier_pet_22_1 = eom_modifier({
	Name = "modifier_pet_22_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_pet_22_1:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end
function modifier_pet_22_1:OnIntervalThink()
	if self.count > 0 then
		self.count = self.count - 1
		local hParent = self:GetParent()
		local hMaster = hParent:GetMaster()
		local hTargets = FindUnitsInRadiusWithAbility(hMaster, hParent:GetAbsOrigin(), 400, self:GetAbility())
		local vPosition = hParent:GetAbsOrigin() + RandomVector(100)
		if IsValid(hTargets[1]) then
			vPosition = hTargets[1]:GetAbsOrigin()
		end
		CreateModifierThinker(hParent, self:GetAbility(), "modifier_pet_22_1_thinker", { duration = self:GetAbility():GetDuration() + self.delay }, vPosition, hMaster:GetTeamNumber(), false)
	else
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_pet_22_1_thinker : eom_modifier
modifier_pet_22_1_thinker = eom_modifier({
	Name = "modifier_pet_22_1_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_pet_22_1_thinker:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hMaster = hCaster:GetMaster()
		self.flDamage = self:GetAbilityDamage() * hMaster:GetPrimaryStats() * self.interval
		self:StartIntervalThink(self.delay)
		self:GetParent():EmitSound("SeasonalConsumable.Firecrackers.Explode")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/new_bloom/firecracker_explode.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pet_22_1_thinker:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	hCaster:DealDamage(tTargets, self:GetAbility(), self.flDamage)
	self:StartIntervalThink(self.interval)
end