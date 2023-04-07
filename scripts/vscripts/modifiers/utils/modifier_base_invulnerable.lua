---@class modifier_base_invulnerable:eom_modifier
modifier_base_invulnerable = eom_modifier({
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})

local public = modifier_base_invulnerable

function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:EmitSound("Hero_Dazzle.Shallow_Grave")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/athena/athena_invulnerable.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:ModifyHealth(hParent:GetMaxHealth(), self:GetAbility(), false, 0)
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:ECheckState()
	return {
		[EOM_MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end