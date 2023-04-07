---@class item_last_prism: eom_ability 最终棱镜
item_last_prism = class({})
function item_last_prism:GetIntrinsicModifierName()
	return "modifier_item_last_prism"
end
---------------------------------------------------------------------
--Modifiers
modifier_item_last_prism = eom_modifier({
	Name = "modifier_item_last_prism",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
})
function modifier_item_last_prism:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_bonus = self:GetAbilitySpecialValueFor("damage_bonus")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_item_last_prism:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			self.tData = {}
			self:StartIntervalThink(0)
			self.tProjectileData = {
				hCaster = hParent,
				hAbility = self:GetAbility(),
				flCircleRadius = 100,
				flAngularVelocity = 60,
				iCount = 1,
				-- flAngle = 360 / iCount * i,
				flOffset = 96,
				sGroupName = hParent:entindex() .. "modifier_item_last_prism",
				flRadius = 75,
				sEffectName = "particles/items_fx/last_prism.vpcf",
			}
			self.tGroup = ProjectileSystem:CreateGroupSurroundProjectile(self.tProjectileData)
			for _, iProjectileIndex in ipairs(self.tGroup) do
				ParticleManager:SetParticleControl(ProjectileSystem:GetParticle(iProjectileIndex), 1, Vector(1, 0, 0))
			end
		end
	end
end
function modifier_item_last_prism:OnIntervalThink()
	if IsServer() then
		local flTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if self.tData[i] <= flTime then
				self:DecrementStackCount()
				table.remove(self.tData, i)
			end
		end
	end
end
function modifier_item_last_prism:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			ProjectileSystem:DestroyPartOfSurroundProjectileWithGroup(hParent:entindex() .. "modifier_item_last_prism", self.tGroup)
		end
	end
end
function modifier_item_last_prism:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() },
		EOM_MODIFIER_PROPERTY_OUTGOING_MAGICAL_DAMAGE_PERCENTAGE
	}
end
function modifier_item_last_prism:EOM_GetModifierOutgoingMagicalDamagePercentage()
	return self:GetStackCount() * self.damage_bonus
end
function modifier_item_last_prism:OnValidAbilityExecuted(params)
	if IsServer() then
		self:IncrementStackCount()
		table.insert(self.tData, GameRules:GetGameTime() + self.duration)
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTarget = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, iProjectileIndex in ipairs(self.tGroup) do
			local hTarget = GetRandomElement(tTarget)
			if IsValid(hTarget) then
				local hThinker = ProjectileSystem:GetThinker(iProjectileIndex)
				hParent:EnergyStrike(hTarget, hAbility, self:GetAbilitySpecialValueFor("damage"), function(hSource, hUnit, bFirst)
					local iParticleID = ParticleManager:CreateParticle("particles/items_fx/last_prism_laser.vpcf", PATTACH_CUSTOMORIGIN, nil)
					if bFirst then
						ParticleManager:SetParticleControlEnt(iParticleID, 9, hSource, PATTACH_ABSORIGIN_FOLLOW, "", hSource:GetAbsOrigin(), false)
					else
						ParticleManager:SetParticleControlEnt(iParticleID, 9, hSource, PATTACH_POINT_FOLLOW, "attach_hitloc", hSource:GetAbsOrigin(), false)
					end
					ParticleManager:SetParticleControlEnt(iParticleID, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
					ParticleManager:ReleaseParticleIndex(iParticleID)
				end, { hSource = hThinker, flJumpDelay = 0 })
				hParent:EmitSound("Hero_Tinker.LaserImpact")
				-- hParent:DealDamage(hTarget, hAbility, (self.damage_pct + self.damage_bonus * self:GetStackCount()) * params.cost * 0.01, DAMAGE_TYPE_MAGICAL)
				-- ParticleManager:SetParticleControl(ProjectileSystem:GetParticle(iProjectileIndex), 1, Vector(1 + self:GetStackCount() * 0.05, 0, 0))
			end
		end

	end
end