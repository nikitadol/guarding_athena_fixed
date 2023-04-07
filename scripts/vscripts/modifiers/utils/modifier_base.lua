---@class modifier_base:eom_modifier
modifier_base = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})

local public = modifier_base

function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE = 1,
	}
end
function public:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent() },
		EOM_MODIFIER_PROPERTY_HEALTH_BONUS = (self:GetParent():GetLevel() - 1) * 2,
		EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = (self:GetParent():GetLevel() - 1) * 0.1,
	}
end
function public:OnCreated(params)
	if IsServer() then
		self.tEnemies = {}
		self.tSounds = {
			"crystalmaiden_cm_lose_01",
			"crystalmaiden_cm_lose_05",
			"crystalmaiden_cm_anger_01",
			"crystalmaiden_cm_anger_02",
			"crystalmaiden_cm_anger_03",
			"crystalmaiden_cm_anger_04",
			"crystalmaiden_cm_anger_05",
			"crystalmaiden_cm_anger_06",
			"crystalmaiden_cm_anger_07",
			"crystalmaiden_cm_anger_08",
			"crystalmaiden_cm_anger_09",
			"crystalmaiden_cm_anger_10",
			"crystalmaiden_cm_anger_11",
			"crystalmaiden_cm_anger_12",
			"crystalmaiden_cm_anger_13",
			"crystalmaiden_cm_anger_14",
			"crystalmaiden_cm_death_02",
			"crystalmaiden_cm_pain_01",
			"crystalmaiden_cm_pain_02",
			"crystalmaiden_cm_pain_03",
			"crystalmaiden_cm_pain_04",
			"crystalmaiden_cm_pain_05",
			"crystalmaiden_cm_scream_01",
			"crystalmaiden_cm_scream_02",
			-- "crystalmaiden_cm_scream_03",
			"crystalmaiden_cm_underattack_01"
		}
		self.bReborn = true
	end
end
function public:OnTakeDamage(params)
	local hParent = self:GetParent()
	local fLoss = hParent:GetAttackDamageToBase()
	if self:GetStackCount() == 0 then
		self:SetStackCount(1)
		self:StartIntervalThink(1)
		EmitGlobalSound(GetRandomElement(self.tSounds))
	end
	if math.floor(hParent:GetCustomHealth() - fLoss) > 0 then
		hParent:ModifyHealth(hParent:GetCustomHealth() - fLoss, params.ability, false, 0)
	else
		if self.bReborn then
			self.bReborn = false
			hParent:AddNewModifier(hParent, nil, "modifier_base_invulnerable", { duration = 60 })
			hParent:SummonUnit("ciba", hParent:GetAbsOrigin(), true, 60)
		else
			hParent:Kill(params.ability, params.attacker)
		end
	end
end
function public:OnIntervalThink()
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end