---@class 单位出生示例
modifier_spawn_example = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	Super = true,
}, nil, EnemySpawnModifier)
local public = modifier_spawn_example
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		hParent:AddNoDraw()
		hParent:EmitSound("SeasonalConsumable.TI10.Portal.Loop")
		self:SetDuration(3, true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/portal/portal_open_good.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
end
function public:OnRefresh(params)
	if IsServer() then
	end
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveNoDraw()
		hParent:StopSound("SeasonalConsumable.TI10.Portal.Loop")
		local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/portal/portal_revealed_nothing_good_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	else
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end