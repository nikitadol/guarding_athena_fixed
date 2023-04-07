---@class 	item_blink_dev : eom_ability 测试用跳刀
item_blink_dev = eom_ability({})

function item_blink_dev:OnSpellStart()
	local caster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local targetPosition = VectorIsZero(vPosition) and KeyboardControl:GetCursorPosition(caster:GetPlayerOwnerID()) or self:GetCursorPosition()
	local startPosition = self:GetAbsOrigin()

	local particleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleID, 0, startPosition)
	ParticleManager:ReleaseParticleIndex(particleID)

	EmitSoundOnLocationWithCaster(startPosition, "DOTA_Item.BlinkDagger.Activate", caster)

	ProjectileManager:ProjectileDodge(caster)
	FindClearSpaceForUnit(caster, targetPosition, true)

	particleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleID, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particleID)

	caster:EmitSound("DOTA_Item.BlinkDagger.NailedIt")
end

function item_blink_dev:ProcsMagicStick()
	return false
end