function RegisterCallbacks()
	Callbacks:RegisterServerCallback("Apartment:Validate", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		local pState = Player(source).state

		local isMyApartment = data.id == GlobalState[string.format("%s:Apartment", source)]

		if data.id then
			if data.type == "wardrobe" and isMyApartment then
				cb(char:GetData("SID") == GlobalState[string.format("%s:Apartment", source)])
			elseif data.type == "logout" and isMyApartment then
				cb(char:GetData("SID") == GlobalState[string.format("%s:Apartment", source)])
			elseif data.type == "stash" then
				local isRaid = false
				local invOwner = char:GetData("SID")
				local invType = 13
				local targetCharSID = nil
				
				
				if data.unit then
					
					targetCharSID = tonumber(data.unit)
					
					
					local targetAptId = GetCharacterApartment(targetCharSID)
					if not targetAptId and Fetch then
						
						local targetPlayer = Fetch:CharacterData("SID", targetCharSID)
						if targetPlayer then
							local targetChar = targetPlayer:GetData("Character")
							if targetChar then
								targetAptId = targetChar:GetData("Apartment")
							end
						end
					end
					
					
					if targetAptId and _raidedApartments and _raidedApartments[targetAptId] then
						
						if _aptData[targetAptId] then
							invType = _aptData[targetAptId].invEntity or 13
							invOwner = targetCharSID
							isRaid = true
						else
							cb(false)
							return
						end
					else
						
					local isPolice = (Player(source).state.onDuty == "police")

					if not isPolice then
    				cb(false)
    			return
			end

				local breachOk = true
				if Config.PoliceRaidRequiresBreach then
    				breachOk = Police and Police.IsInBreach and Police:IsInBreach(source, "apartment", targetCharSID, true)
				end

				if breachOk then
    			if targetAptId and _aptData[targetAptId] then
        			StartApartmentRaid(targetAptId, targetCharSID)
        			invType = _aptData[targetAptId].invEntity or 13
        			invOwner = targetCharSID
        			isRaid = true
    			else
        			cb(false)
        		return
    		end
			else
    			cb(false)
    		return
		end

		end
				elseif isMyApartment then
					
					local aptId = char:GetData("Apartment") or 1
					if _aptData[aptId] then
						invType = _aptData[aptId].invEntity or 13
					end
					
					
					if pState.inApartment ~= nil and pState.inApartment.id ~= char:GetData("SID") then
						cb(false)
						return
					end
					
					
					isRaid = false
					invOwner = char:GetData("SID")
				else
					
					cb(false)
					return
				end

				Callbacks:ClientCallback(source, "Inventory:Compartment:Open", {
					invType = invType,
					owner = invOwner,
				}, function()
					Inventory:OpenSecondary(source, invType, invOwner, false, false, isRaid)
				end)

				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Apartment:SpawnInside", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if not char then
			cb(false)
			return
		end
		
		
		local characterSID = char:GetData("SID")
		
		
		local aptId = GetCharacterApartment(characterSID)
		
		
		if not aptId or aptId == 0 then
			
			if UpdateAvailableApartments then
				UpdateAvailableApartments(true)
			end
			local characterID = char:GetData("ID")
			aptId = GetRandomAvailableApartment()
			if aptId then
				if AssignApartmentToCharacter(aptId, characterID, characterSID) then
					
					Database.Game:updateOne({
						collection = "characters",
						query = {
							_id = characterID
						},
						update = {
							["$set"] = {
								Apartment = aptId
							}
						}
					}, function(success)
						if success then
							char:SetData("Apartment", aptId)
							
							
							if SendApartmentAssignmentEmail then
								SendApartmentAssignmentEmail(source, aptId, characterSID)
							end
						end
					end)
				else
					aptId = nil
				end
			end
		end
		
		if aptId and aptId > 0 then
			if UpdateAvailableApartments then
				UpdateAvailableApartments(true)
			end
			
			EnsureCharacterDoorAccess(characterSID, aptId)
			
			local enterResult = Apartment:Enter(source, aptId, -1, true)
			cb(enterResult)
		else
			cb(false)
		end
	end)

	Callbacks:RegisterServerCallback("Apartment:Enter", function(source, data, cb)
		cb(Apartment:Enter(source, data.tier, data.id))
	end)

	Callbacks:RegisterServerCallback("Apartment:Exit", function(source, data, cb)
		cb(Apartment:Exit(source))
	end)

	Callbacks:RegisterServerCallback("Apartment:GetVisitRequests", function(source, data, cb)
		cb(Apartment.Reqeusts:Get(source))
	end)

	Callbacks:RegisterServerCallback("Apartment:Visit", function(source, data, cb)
		cb(Apartment:Enter(source, data.tier, data.id))
	end)

	
	Callbacks:RegisterServerCallback("Apartment:RequestApartment", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if not char then
			cb({ success = false, message = "Character not found" })
			return
		end

		local characterSID = char:GetData("SID")
		local characterID = char:GetData("ID")

		
		local existingApt = GetCharacterApartment(characterSID)
		local charAptId = char:GetData("Apartment") or 0
		
		if existingApt or (charAptId and charAptId > 0) then
			cb({ success = false, message = "You already have an apartment assigned" })
			return
		end

		
		local aptId = GetRandomAvailableApartment()
		if not aptId then
			cb({ success = false, message = "No apartments available at this time" })
			return
		end

		
		if AssignApartmentToCharacter(aptId, characterID, characterSID) then
			
			Database.Game:updateOne({
				collection = "characters",
				query = {
					_id = characterID
				},
				update = {
					["$set"] = {
						Apartment = aptId
					}
				}
			}, function(success)
				if success then
					
					char:SetData("Apartment", aptId)
					
					
					local apt = _aptData[aptId]
					local roomLabel = apt and apt.roomLabel or aptId
					local buildingLabel = apt and (apt.buildingLabel or apt.buildingName) or "Apartment Building"
					local floor = apt and apt.floor or "Unknown"
					
					
					if EnsureCharacterDoorAccess then
						EnsureCharacterDoorAccess(characterSID, aptId)
					end
					
					
					if SendApartmentAssignmentEmail then
						SendApartmentAssignmentEmail(source, aptId, characterSID)
					end
					
					if Logger then
						Logger:Info("Apartments", string.format("Assigned apartment %s (Room %s) to character %s via reception", aptId, roomLabel, characterSID))
					end
					cb({ success = true, apartmentId = aptId, roomLabel = roomLabel, buildingName = buildingLabel, floor = floor })
				else
					cb({ success = false, message = "Failed to update character" })
				end
			end)
		else
			cb({ success = false, message = "Failed to assign apartment" })
		end
	end)

	
	Callbacks:RegisterServerCallback("Apartment:GetMyRoom", function(source, data, cb)
		local char = Fetch:Source(source):GetData("Character")
		if not char then
			cb({ success = false, message = "Character not found" })
			return
		end

		local characterSID = char:GetData("SID")
		local aptId = GetCharacterApartment(characterSID)
		
		if not aptId and char:GetData("Apartment") and char:GetData("Apartment") > 0 then
			aptId = char:GetData("Apartment")
		end

		if not aptId or aptId == 0 then
			cb({ success = false, message = "You don't have an apartment assigned" })
			return
		end

		local apt = GlobalState[string.format("Apartment:%s", aptId)]
		if not apt then
			cb({ success = false, message = "Apartment data not found" })
			return
		end

		local buildingLabel = apt.buildingLabel or apt.buildingName or "Apartment Building"
		local roomLabel = apt.roomLabel or aptId
		local floor = apt.floor or "Unknown"

		cb({
			success = true,
			buildingName = buildingLabel, 
			roomLabel = roomLabel,
			floor = floor
		})
	end)

	Callbacks:RegisterServerCallback("Apartment:GetFloorApartments", function(source, data, cb)
		if not data or not data.buildingName or data.floor == nil then
			cb({})
			return
		end

		local floorApartments = {}
		if GlobalState["Apartments"] then
			for _, aptId in ipairs(GlobalState["Apartments"]) do
				local apt = GlobalState[string.format("Apartment:%s", aptId)]
				if apt and apt.buildingName == data.buildingName and apt.floor == data.floor then
					local charSID = nil
					if _apartmentAssignments then
						for sid, assignedAptId in pairs(_apartmentAssignments) do
							if assignedAptId == aptId then
								charSID = tonumber(sid) or sid
								break
							end
						end
					end
					table.insert(floorApartments, {
						aptId = aptId,
						unit = charSID,
						roomLabel = apt.roomLabel or aptId
					})
				end
			end
		end
		cb(floorApartments)
	end)
end
