demo_take_no_damage = eom_modifier({})

local public = demo_take_no_damage

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
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function public:GetAbsoluteNoDamageMagical(params)
	return 1
end
function public:GetAbsoluteNoDamagePhysical(params)
	return 1
end
function public:GetAbsoluteNoDamagePure(params)
	return 1
end
function public:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end