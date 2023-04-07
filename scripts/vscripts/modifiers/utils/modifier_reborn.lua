---@class modifier_reborn : eom_modifier
modifier_reborn = eom_modifier({
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_reborn:GetTexture()
	return "skeleton_king_reincarnation"
end
function modifier_reborn:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_reborn:OnCreated(params)
	if IsServer() then
		self:SetStackCount(1)
	else
		if self.iParticleID == nil then
			local hParent = self:GetParent()
			local wingsType = "particles/skills/wing_sky.vpcf"
			if hParent:GetUnitName() == "npc_dota_hero_omniknight" then wingsType = "particles/skills/wing_thunder.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_windrunner" then wingsType = "particles/skills/wing_wind.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_rubick" then wingsType = "particles/skills/wing_space.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_lina" then wingsType = "particles/skills/wing_fire.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_nevermore" then wingsType = "particles/skills/wing_hell.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_legion_commander" then wingsType = "particles/skills/wing_hell.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_fire_spirit" then wingsType = "particles/skills/wing_fire.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_revelater" then wingsType = "particles/skills/wing_sky.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_juggernaut" then wingsType = "particles/skills/wing_sky.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_antimage" then wingsType = "particles/skills/wing_sky.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_crystal_maiden" then wingsType = "particles/skills/wing_ice.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_monkey_king" then wingsType = "particles/skills/wing_sky.vpcf" end
			if hParent:GetUnitName() == "npc_dota_hero_spectre" then wingsType = "particles/skills/wing_sky.vpcf" end
			local iParticleID = ParticleManager:CreateParticle(wingsType, PATTACH_ABSORIGIN_FOLLOW, hParent)
			self:AddParticle(iParticleID, false, false, -1, false, false)
			self.iParticleID = iParticleID
		end
	end
end
function modifier_reborn:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_reborn:OnStackCountChanged(iStackCount)
	FireModifierEvent(MODIFIER_EVENT_ON_REBORN, {
		unit = self:GetParent(),
		level = self:GetStackCount()
	}, self:GetParent())
end
function modifier_reborn:AllowIllusionDuplicate()
	return true
end
function modifier_reborn:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = 30,
	}
end
function modifier_reborn:EDeclareFunctions()
	return {
		EOM_MODIFIER_PROPERTY_STATS_ALL_BONUS,
		EOM_MODIFIER_PROPERTY_COOLDOWN_CONSTANT = 2,
	}
end
function modifier_reborn:EOM_GetModifierBonusStats_All()
	return self:GetStackCount() * 100
end
function modifier_reborn:OnTooltip()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 5
	if 0 == self._iTooltip then
		return self:GetStackCount()
	elseif 1 == self._iTooltip then
		return self:EOM_GetModifierBonusStats_All()
	elseif 2 == self._iTooltip then
		return 30
	elseif 3 == self._iTooltip then
		return 2
	elseif 4 == self._iTooltip then
		return 20
	end
	return 0
end