---@class modifier_guarding : eom_modifier
modifier_guarding = eom_modifier({
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	RemoveOnDeath = false,
})

local public = modifier_guarding

function public:GetTexture()
	return "omniknight_angelic_flight"
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP = self.iCount or 0
	}
end
function public:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BASE = self.iCount
	}
end

---@class modifier_guarding_1 : eom_modifier
modifier_guarding_1 = eom_modifier({}, nil, modifier_guarding)
function modifier_guarding_1:OnCreated(params)
	self.iCount = 50
end
---@class modifier_guarding_2 : eom_modifier
modifier_guarding_2 = eom_modifier({}, nil, modifier_guarding)
function modifier_guarding_2:OnCreated(params)
	self.iCount = 100
end
---@class modifier_guarding_3 : eom_modifier
modifier_guarding_3 = eom_modifier({}, nil, modifier_guarding)
function modifier_guarding_3:OnCreated(params)
	self.iCount = 200
end
---@class modifier_guarding_4 : eom_modifier
modifier_guarding_4 = eom_modifier({}, nil, modifier_guarding)
function modifier_guarding_4:OnCreated(params)
	self.iCount = 400
end