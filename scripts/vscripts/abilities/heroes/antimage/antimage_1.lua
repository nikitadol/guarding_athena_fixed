---@class antimage_1: eom_ability
antimage_1 = eom_ability({})
function antimage_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local radius = self:GetSpecialValueFor("radius")
	local scale = 1
	if hCaster:HasModifier("modifier_antimage_4") then
		radius = radius * 2
		scale = 2
	end
	local angle = self:GetSpecialValueFor("angle")
	local damage = self:GetSpecialValueFor("damage")
	local regen = self:GetSpecialValueFor("regen")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_1.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 5, Vector(1, 1, scale))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Terrorblade_Morphed.Attack")
	local iStackCount = hCaster:GetModifierStackCount("modifier_antimage_0", hCaster)
	local tTargets = FindUnitsInSector(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin() - vDirection * 32, radius, vDirection, angle, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER)
	---@param hUnit CDOTA_BaseNPC
	for _, hUnit in ipairs(tTargets) do
		local flDamage = damage
		local vForward = (hUnit:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
		if hCaster:HasModifier("modifier_antimage_0_buff") then
			flDamage = flDamage + hUnit:GetCustomHealth() * iStackCount * 0.01
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_1_soul.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_ABSORIGIN, "", hUnit:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlForward(iParticleID, 0, -vForward)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:KnockBack(vForward, radius - (hUnit:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D(), 0, 0.3)
	end
	if #tTargets > 0 then
		if hCaster:HasModifier("modifier_antimage_0_buff") then
			hCaster:EmitSound("DOTA_Item.EtherealBlade.Target")
		end
		hCaster:Heal(damage * regen * #tTargets * 0.01, self, true)
	end
end
----------------------------------------Modifier----------------------------------------
---@class modifier_antimage_1 : eom_modifier
modifier_antimage_1 = eom_modifier({
	Name = "modifier_antimage_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_antimage_1:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_antimage_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_antimage_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_antimage_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_antimage_1:DeclareFunctions()
	return {
	}
end
function modifier_antimage_1:EDeclareFunctions()
	return {
	}
end