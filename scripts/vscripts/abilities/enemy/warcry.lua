---@class warcry: eom_ability
warcry = eom_ability({}, nil, ability_base_ai)
function warcry:GetRadius()
	return 900
end
function warcry:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_warcry", { duration = self:GetDuration() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_POINT_FOLLOW, "attach_head", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Sven.WarCry")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_warcry : eom_modifier
modifier_warcry = eom_modifier({
	Name = "modifier_warcry",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_warcry:GetAbilitySpecialValue()
	self.warcry_armor = self:GetAbilitySpecialValueFor("warcry_armor")
	self.warcry_movespeed = self:GetAbilitySpecialValueFor("warcry_movespeed")
	self.warcry_attackspeed = self:GetAbilitySpecialValueFor("warcry_attackspeed")
end
function modifier_warcry:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_warcry:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.warcry_attackspeed or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = self.warcry_movespeed or 0
	}
end
function modifier_warcry:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ARMOR_BONUS = self.warcry_armor
	}
end