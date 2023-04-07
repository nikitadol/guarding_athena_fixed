dialog_event_ability_1 = eom_ability({})
function dialog_event_ability_1:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_1:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
dialog_event_ability_2 = eom_ability({})
function dialog_event_ability_2:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_2:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
dialog_event_ability_3 = eom_ability({})
function dialog_event_ability_3:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_3:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
dialog_event_ability_4 = eom_ability({})
function dialog_event_ability_4:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_4:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
dialog_event_ability_5 = eom_ability({})
function dialog_event_ability_5:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_5:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end
dialog_event_ability_6 = eom_ability({})
function dialog_event_ability_6:CastFilterResult()
	if IsClient() then
		SendToConsole("on_active_dialog_event_ability " .. self:entindex())
	end
	return UF_SUCCESS
end
function dialog_event_ability_6:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end