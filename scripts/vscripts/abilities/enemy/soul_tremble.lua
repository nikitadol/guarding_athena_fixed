---@class soul_tremble: eom_ability
soul_tremble = eom_ability({
	funcUnitsCallback = function(hAbility, tTargets)
		for i = #tTargets, 1, -1 do
			if tTargets[i]:HasModifier("modifier_soul_tremble") then
				table.remove(tTargets, i)
			end
		end
	end
}, nil, ability_base_ai)
function soul_tremble:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_soul_tremble", { duration = 20 })
	hCaster:EmitSound("Hero_Bane.Enfeeble")
end
----------------------------------------Modifier----------------------------------------
---@class modifier_soul_tremble : eom_modifier
modifier_soul_tremble = eom_modifier({
	Name = "modifier_soul_tremble",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_soul_tremble:GetAbilitySpecialValue()
	self.reduce = self:GetAbilitySpecialValueFor("reduce")
end
function modifier_soul_tremble:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_enfeeble.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_soul_tremble:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_ATTACK_DAMAGE_BASE_PERCENTAGE = -self.reduce
	}
end