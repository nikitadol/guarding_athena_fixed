---@class god_body: eom_ability
god_body = eom_ability({})
function god_body:GetIntrinsicModifierName()
	return "modifier_god_body"
end
----------------------------------------Modifier----------------------------------------
---@class modifier_god_body : eom_modifier
modifier_god_body = eom_modifier({
	Name = "modifier_god_body",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_god_body:GetAbilitySpecialValue()
	self.max_damage = self:GetAbilitySpecialValueFor("max_damage")
	self.regen = self:GetAbilitySpecialValueFor("regen")
end
function modifier_god_body:OnCreated(params)
	if IsServer() then
		self.flMinHealth = self:GetParent():GetHealth() - self:GetParent():GetMaxHealth() * self.max_damage * 0.01
	end
end
function modifier_god_body:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_god_body:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = self.regen,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent() }
	}
end
function modifier_god_body:GetMinHealth(params)
	return self.flMinHealth
end
function modifier_god_body:OnDeath(params)
	if IsServer() and self:GetParent():GetUnitName() == "zeus" then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		hParent:EmitSound("Hero_Zuus.Righteous.Layer")
		hParent:AddNoDraw()
		hParent:GameTimer(1, function()
			CreateUnitByNameWithNewData("zeus_reborn", hParent:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		end)
	end
end
function modifier_god_body:OnTakeDamage(params)
	if IsServer() then
		if params.damage > self:GetParent():GetCustomMaxHealth() * self.max_damage * 0.01 then
			local hParent = self:GetParent()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 128))
			local hAbility = hParent:FindAbilityByName("lightning_crash")
			if IsValid(hAbility) then
				hAbility:OnSpellStart(params.attacker:GetAbsOrigin())
			end
		end
		self.flMinHealth = self:GetParent():GetHealth() - self:GetParent():GetMaxHealth() * self.max_damage * 0.01
	end
end