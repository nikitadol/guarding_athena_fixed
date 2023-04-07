---@class lightning_attack: eom_ability
lightning_attack = eom_ability({}, nil, ability_base_ai)

function lightning_attack:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local damage = self:GetSpecialValueFor("damage")
	if RollPercentage(50) then
		local radius = self:GetSpecialValueFor("radius")
		local jump_count = self:GetSpecialValueFor("jump_count")
		local jump_delay = self:GetSpecialValueFor("jump_delay")
		hCaster:EnergyStrike(hTarget, self, damage, "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", {
			sSoundName = "Hero_Zuus.ArcLightning.Cast",
			iJumpCount = jump_count,
			flJumpDelay = jump_delay,
			flJumpRadius = radius,
		})
	else
		local iCount = 0
		hTarget:KnockBack(RandomVector(1), RandomInt(0, 300), 150, 1)
		hCaster:GameTimer(0, function()
			if iCount < 10 then
				iCount = iCount + 1
				hCaster:EnergyStrike(hTarget, self, damage * 0.1, "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", {
					sSoundName = "Hero_Zuus.ArcLightning.Cast",
				})
				return 0.1
			end
		end)
	end
end