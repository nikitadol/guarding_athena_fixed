---@class modifier_summoned:eom_modifier
modifier_summoned = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})

local public = modifier_summoned

function public:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end