function Spawn(tEntityKeyValues)
	if IsServer() then
		if not thisEntity.bIsNotFirstSpawn then
			local hOwner = EntIndexToHScript(tonumber(tEntityKeyValues:GetValue("iOwnerIndex")) or -1)
			if IsValid(hOwner) then
				thisEntity:SetOwner(hOwner)
				if thisEntity:IsHero() then
					thisEntity:SetPlayerID(hOwner:GetPlayerOwnerID())
				end
			end
			local tKV = {}
			for i, key in ipairs(SYNC_UNIT_KEY) do
				tKV[i] = tEntityKeyValues:GetValue(key)
			end
			CustomNetTables:SetTableValue("unit_kv", tostring(thisEntity:entindex()), { _ = json.encode(tKV) })

			local sOverrideKeys = tEntityKeyValues:GetValue("OverrideKeys")
			if type(sOverrideKeys) == "string" then
				local tOverrideKeys = string.split(sOverrideKeys, ",")
				for _, k in ipairs(tOverrideKeys) do
					if type(thisEntity._tOverrideData) ~= "table" then
						thisEntity._tOverrideData = {}
					end
					thisEntity._tOverrideData[k] = tEntityKeyValues:GetValue(k)
				end
			end

			local sAIScriptsPath = tEntityKeyValues:GetValue("AIScripts")
			if type(sAIScriptsPath) == "string" then
				if pcall(DoIncludeScript, sAIScriptsPath, getfenv(1)) then
					AIStart(tEntityKeyValues)
				end
			end
		end
	end
end

function UpdateOnRemove()
	if IsServer() then
		CustomNetTables:SetTableValue("unit_kv", tostring(thisEntity:entindex()), nil)
	end
end