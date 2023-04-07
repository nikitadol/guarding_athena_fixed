modifier_dummy_damage = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	DestroyOnExpire = false,
	IsPermanent = true,
})

local public = modifier_dummy_damage

function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH = 1
	}
end
function public:OnTakeDamage(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:StartGesture(ACT_DOTA_FLINCH)
	end
end
function public:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() }
	}
end