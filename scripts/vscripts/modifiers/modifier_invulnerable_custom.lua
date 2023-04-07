modifier_invulnerable_custom = eom_modifier({})

local public = modifier_invulnerable_custom

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DODGE_PROJECTILE,
	}
end
function public:GetModifierDodgeProjectile(params)
	return 1
end
