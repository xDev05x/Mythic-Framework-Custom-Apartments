function RegisterMiddleware()
    if not Middleware then
        return
    end
    
    Middleware:Add("Characters:Creating", function(source, cData)
			return {{
            Apartment = 1
		}}
	end)

    Middleware:Add('Characters:Spawning', function(source)
        local player = exports['mythic-base']:FetchComponent('Fetch'):Source(source)
        local char = player:GetData('Character')
        if not char then
            return
        end
        
        local characterSID = char:GetData("SID")
        local aptId = char:GetData("Apartment") or 0
        
        
        if aptId > 0 then
            local assignedApt = GetCharacterApartment(characterSID)
            if not assignedApt or assignedApt ~= aptId then
                
                local characterID = char:GetData("ID")
                if AssignApartmentToCharacter and AssignApartmentToCharacter(aptId, characterID, characterSID) then
                    
                end
            end
        end
        
		GlobalState[string.format("Apartment:Interior:%s", characterSID)] = aptId
        
        
        local finalAptId = GetCharacterApartment(characterSID)
        if finalAptId and finalAptId > 0 then
            EnsureCharacterDoorAccess(characterSID, finalAptId)
        end
    end, 2)

	Middleware:Add("Characters:Logout", function(source)
		local char = Fetch:Source(source):GetData("Character")
		if char ~= nil then
			TriggerClientEvent("Apartment:Client:Cleanup", source, GlobalState[string.format("%s:Apartment", source)])
			GlobalState[string.format("%s:Apartment", source)] = nil
			GlobalState[string.format("Apartment:Interior:%s", char:GetData("SID"))] = char:GetData("Apartment")
			-- Fully clear apartment state
			Player(source).state.inApartment = nil
			Player(source).state.tpLocation = nil
			
			-- Route player back to global route (clears elevator floor state)
			if Routing then
				Routing:RoutePlayerToGlobalRoute(source)
			end
		end
	end)

	Middleware:Add("Characters:GetSpawnPoints", function(source, charId, cData)
		local spawns = {}
		
		
		if cData.New then
			return spawns
		end
		
		
		local aptId = GetCharacterApartment(cData.SID)
		if aptId and aptId > 0 then
			local apt = _aptData[aptId]
			if apt then
				local roomLabel = apt.roomLabel or aptId
				local buildingLabel = apt.buildingLabel or apt.buildingName or "Apartment"
				local label = string.format("%s - Room %s", buildingLabel, roomLabel)
				
				table.insert(spawns, {
					id = string.format("APT:%s:%s", aptId, cData.SID),
					label = label,
					location = {
						x = apt.interior.wakeup.x,
						y = apt.interior.wakeup.y,
						z = apt.interior.wakeup.z,
						h = apt.interior.wakeup.h or 0.0
					},
					icon = "building",
					event = "Apartment:SpawnInside",
				})
			end
		end

		return spawns
	end, 2)
end
