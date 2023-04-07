---@class item_mystletainn: eom_ability 米斯特汀
item_mystletainn = class({})
function item_mystletainn:GetIntrinsicModifierName()
	return "modifier_item_mystletainn"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_mystletainn : eom_modifier
modifier_item_mystletainn = eom_modifier({
	Name = "modifier_item_mystletainn",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_mystletainn:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.absorb = self:GetAbilitySpecialValueFor("absorb")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.critical_rate = self:GetAbilitySpecialValueFor("critical_rate")
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	if IsServer() then
		local hParent = self:GetParent()
		if self:GetAbility().iAttack == nil then
			self:GetAbility().iAttack = 0
		end

		self:StartIntervalThink(self.interval)
	end
end
function modifier_item_mystletainn:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
	end
end
function modifier_item_mystletainn:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local flDamage = self.absorb * hParent:GetCustomMaxHealth() * 0.01
		if hParent:GetCustomHealth() > flDamage then
			-- local tDamageInfo = CreateDamageTable(hParent, hParent, self:GetAbility(), flDamage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION)
			-- ApplyDamage(tDamageInfo)
			-- RemoveHealth(hParent, flDamage)
			self:GetAbility().iAttack = self:GetAbility().iAttack + 1
			hParent:SpendHealth(flDamage, self:GetAbility(), false, 0)
			hParent:AddPermanentAttribute(CUSTOM_ATTRIBUTE_ATTACK, self.attack_increase)
		end
	end
end
function modifier_item_mystletainn:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_item_mystletainn:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		if RollPercentage(self.critical_rate) then
			params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_item_mystletainn_debuff", { duration = self.duration })
			CreateNumberEffect(params.target, params.damage * self.critical, 1.5, MSG_ORIT, "orange", 4)
			-- return params.damage * self.critical
			params.attacker:DealDamage(params.target, self:GetAbility(), params.damage * self.critical, DAMAGE_TYPE_PHYSICAL)
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, params.target, PATTACH_ABSORIGIN_FOLLOW, "", params.target:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlForward(iParticleID, 1, (params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized())
			params.attacker:EmitSound("Hero_Mars.Shield.Cast")
		end
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_item_mystletainn_debuff : eom_modifier
modifier_item_mystletainn_debuff = eom_modifier({
	Name = "modifier_item_mystletainn_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_mystletainn_debuff:OnCreated(params)
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
end
function modifier_item_mystletainn_debuff:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = self.damage_deepen,
	}
end