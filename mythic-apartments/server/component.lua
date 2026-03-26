_requests = {}
_requestors = {}
_raidedApartments = {} 

AddEventHandler("Apartment:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Fetch = exports["mythic-base"]:FetchComponent("Fetch")
	Middleware = exports["mythic-base"]:FetchComponent("Middleware")
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Logger = exports["mythic-base"]:FetchComponent("Logger")
	Routing = exports["mythic-base"]:FetchComponent("Routing")
	Inventory = exports["mythic-base"]:FetchComponent("Inventory")
	Apartment = exports["mythic-base"]:FetchComponent("Apartment")
	Police = exports["mythic-base"]:FetchComponent("Police")
	Pwnzor = exports["mythic-base"]:FetchComponent("Pwnzor")
	Doors = exports["mythic-base"]:FetchComponent("Doors")
	Phone = exports["mythic-base"]:FetchComponent("Phone")
	if Middleware then
		RegisterMiddleware()
	end
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mythic-base"]:RequestDependencies("Apartment", {
		"Fetch",
		"Middleware",
		"Callbacks",
		"Logger",
		"Routing",
		"Inventory",
		"Apartment",
		"Police",
		"Pwnzor",
		"Phone",
        "Doors",
	}, function(error)
		if #error > 0 then
            
			return
		end
		RetrieveComponents()
		RegisterCallbacks()
		
		
		AddEventHandler('mythic-doors:stateChanged', function(source, doorId, isLocked)
			
			if isLocked and _aptData and source and source > 0 then
				
				for aptId, apt in ipairs(_aptData) do
					if apt and Doors and Doors:ResolveId(apt.doorId) == doorId then
						
						if IsApartmentRaided(aptId) then
							
							local player = Fetch:Source(source)
							if player then
								local char = player:GetData("Character")
								if char then
									local lockersSID = char:GetData("SID")
									
									
									local raidData = _raidedApartments[aptId]
									if raidData and raidData.characterSID then
										local ownerSID = raidData.characterSID
										
										
										if lockersSID == ownerSID then
											
											EndApartmentRaid(aptId)
										end
										
									end
								end
							end
						end
						break
					end
				end
			end
		end)
	end)
end)

AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Apartment", _APTS)
	Startup()
end)


function GetCharacterApartment(characterSID)
	if _apartmentAssignments then
		
		return _apartmentAssignments[characterSID] or _apartmentAssignments[tonumber(characterSID)] or _apartmentAssignments[tostring(characterSID)]
	end
	return nil
end


function EnsureCharacterDoorAccess(characterSID, apartmentId)
	if not characterSID or not apartmentId then return false end
	local apt = _aptData[apartmentId]
	if not apt or not apt.doorId then return false end
	local success = exports['mythic-doors']:AddCharacterAccess(apt.doorId, characterSID)
	if success and Logger then
		Logger:Info("Apartments", string.format("Ensured door access for character %s on apartment %s (door %s)", characterSID, apartmentId, tostring(apt.doorId)))
	end
	return success
end

function RemoveCharacterDoorAccess(characterSID, apartmentId)
	if not characterSID or not apartmentId then return false end
	local apt = _aptData[apartmentId]
	if not apt or not apt.doorId then return false end
	local success = exports['mythic-doors']:RemoveCharacterAccess(apt.doorId, characterSID)
	if success and Logger then
		Logger:Info("Apartments", string.format("Removed door access for character %s on apartment %s (door %s)", characterSID, apartmentId, tostring(apt.doorId)))
	end
	return success
end


function StartApartmentRaid(apartmentId, characterSID)
	if not apartmentId or not characterSID then
		return false
	end
	
	local apt = _aptData[apartmentId]
	if not apt or not apt.doorId or apt.doorId == nil then
		return false
	end
	
	
	if Doors and Doors:Exists(apt.doorId) then
		Doors:SetLock(apt.doorId, false)
	end
	
	
	if not _raidedApartments then
		_raidedApartments = {}
	end
	_raidedApartments[apartmentId] = {
		characterSID = characterSID,
		raidedAt = os.time(),
		doorId = apt.doorId
	}
	
	
	GlobalState[string.format("Apartment:Raid:%s", apartmentId)] = true
	
	
	TriggerClientEvent("Apartment:Client:RaidStateChanged", -1, apartmentId, true)
	
	if Logger then
		Logger:Info("Apartments", string.format("Apartment %s (character %s) is now being raided - door unlocked", apartmentId, characterSID))
	end
	
	return true
end


function EndApartmentRaid(apartmentId)
	if not apartmentId or not _raidedApartments or not _raidedApartments[apartmentId] then
		return false
	end
	
	local raidData = _raidedApartments[apartmentId]
	local doorId = raidData.doorId
	
	
	if doorId then
		if Doors and Doors:Exists(doorId) then
			Doors:SetLock(doorId, true)
		end
	end
	
	
	_raidedApartments[apartmentId] = nil
	GlobalState[string.format("Apartment:Raid:%s", apartmentId)] = nil
	
	
	TriggerClientEvent("Apartment:Client:RaidStateChanged", -1, apartmentId, false)
	
	if Logger then
		Logger:Info("Apartments", string.format("Apartment %s raid ended - door locked", apartmentId))
	end
	
	return true
end


function IsApartmentRaided(apartmentId)
	return _raidedApartments and _raidedApartments[apartmentId] ~= nil
end


RegisterNetEvent("Apartment:Server:StartShowerParticle", function(showerHeadPos, aptId)
	local source = source
	TriggerClientEvent("Apartment:Client:StartShowerParticle", -1, source, showerHeadPos, aptId)
end)

RegisterNetEvent("Apartment:Server:StopShowerParticle", function()
	local source = source
	TriggerClientEvent("Apartment:Client:StopShowerParticle", -1, source)
end)


function SendApartmentAssignmentEmail(source, apartmentId, characterSID)
	if not source or source <= 0 or not apartmentId then
		return false
	end
	
	
	if not Phone then
		Phone = exports["mythic-base"]:FetchComponent("Phone")
	end
	
	if not Phone or not Phone.Email then
		return false
	end
	
	local apt = _aptData[apartmentId]
	if not apt then
		return false
	end
	
	local roomLabel = apt.roomLabel or apartmentId
	local buildingLabel = apt.buildingLabel or apt.buildingName or "Apartment Building"
	local floor = apt.floor or "Unknown"
	
	local subject = "Apartment Assignment Confirmation"
	local body = string.format(
		"Dear Resident,\n\n" ..
		"We are pleased to inform you that your apartment has been assigned.\n\n" ..
		"Apartment Details:\n" ..
		"Building: %s\n" ..
		"Room Number: %s\n" ..
		"Floor: %s\n\n" ..
		"Your apartment is now ready for you to move in. You can access your apartment using the elevator system.\n\n" ..
		"If you have any questions or concerns, please contact the building management.\n\n" ..
		"Thank you for choosing our apartments.\n\n" ..
		"Best regards,\n" ..
		"Apartment Management",
		buildingLabel,
		roomLabel,
		floor
	)
	
	
	Phone.Email:Send(source, "apartments@management.gov", os.time() * 1000, subject, body)
	return true
end

function AssignApartmentToCharacter(apartmentId, characterID, characterSID)
	
	if _assignedApartments and _assignedApartments[apartmentId] then
		return false 
	end
	
	if _apartmentAssignments and _apartmentAssignments[characterSID] then
		return false 
	end
	
	if not Database then
		Database = exports["mythic-base"]:FetchComponent("Database")
	end
	
	if not Database then
		return false
	end
	
	
	local p = promise.new()
	Database.Game:findOne({
		collection = "apartment_assignments",
		query = {
			apartmentId = apartmentId
		}
	}, function(exists, result)
		if exists and result then
			
			p:resolve(false)
			return
		end
		
		
		Database.Game:findOne({
			collection = "apartment_assignments",
			query = {
				characterSID = characterSID
			}
		}, function(charExists, charResult)
			if charExists and charResult then
				
				p:resolve(false)
				return
			end
			
			
			Database.Game:insertOne({
				collection = "apartment_assignments",
				document = {
					apartmentId = apartmentId,
					characterID = characterID,
					characterSID = characterSID,
					assignedAt = os.time() * 1000
				}
			}, function(success)
				if success then
					if not _assignedApartments then _assignedApartments = {} end
					if not _apartmentAssignments then _apartmentAssignments = {} end
					
					_assignedApartments[apartmentId] = {
						characterSID = characterSID,
						characterID = characterID,
						assignedAt = os.time() * 1000
					}
					
					_apartmentAssignments[characterSID] = apartmentId
					_apartmentAssignments[tostring(characterSID)] = apartmentId
					if tonumber(characterSID) then
						_apartmentAssignments[tonumber(characterSID)] = apartmentId
					end
					
					
					EnsureCharacterDoorAccess(characterSID, apartmentId)
					
					if UpdateAvailableApartments then
						UpdateAvailableApartments()
					end
					p:resolve(true)
				else
					p:resolve(false)
				end
			end)
		end)
	end)
	
	return Citizen.Await(p)
end

_APTS = {
	Enter = function(self, source, targetType, target, wakeUp)
		local f = false
		local rTarget = target
		if rTarget == -1 then
			local char = Fetch:Source(source):GetData("Character")
			rTarget = char:GetData("SID")
			f = true
		end

		if not f then
			if _requestors[source] ~= nil then
				for k, v in ipairs(_requests[_requestors[source]]) do
					if v.source == source then
						f = true
					end
				end
			end

			if Police:IsInBreach(source, "apartment", rTarget) then
				f = true
			end
		end

		if f then

			Player(source).state.inApartment = {
				type = targetType,
				id = rTarget
			}

			
			
			local apt = _aptData[targetType or 1]
			if not apt then
				return false
			end
			
			local buildingName = apt.buildingName or apt.buildingLabel
			local floor = apt.floor
			
			if not buildingName or not floor then
				return false
			end
			
			local routeId = Routing:RequestRouteId(string.format("Apartment:Floor:%s:%s", buildingName, floor), false)
			if Pwnzor and Pwnzor.Players then
				Pwnzor.Players:TempPosIgnore(source)
			end
			Routing:AddPlayerToRoute(source, routeId)
		
			GlobalState[string.format("%s:Apartment", source)] = rTarget
			TriggerClientEvent("Apartment:Client:InnerStuff", source, targetType or 1, rTarget, wakeUp)

			local apartment = GlobalState[string.format("Apartment:%s", targetType or 1)]
			if apartment?.coords then
				Player(source).state.tpLocation = {
					x = apartment.coords.x,
					y = apartment.coords.y,
					z = apartment.coords.z,
				}
			end

			return targetType
		end

		return false
	end,
	Exit = function(self, source)
		
		Routing:RoutePlayerToGlobalRoute(source)
		GlobalState[string.format("%s:Apartment", source)] = nil
		if Pwnzor and Pwnzor.Players then
			Pwnzor.Players:TempPosIgnore(source)
		end
		Player(source).state.inApartment = nil
		Player(source).state.tpLocation = nil

		return true
	end,
	GetInteriorLocation = function(self, apartment)
		local apartment = GlobalState[string.format("Apartment:%s", apartment or 1)]
		return apartment?.interior?.spawn
	end,
	Requests = {
		Get = function(self, source)
			if GlobalState[string.format("%s:Apartment", source)] ~= nil then
				return _requests[GlobalState[string.format("%s:Apartment", source)]]
			else
				return {}
			end
		end,
		Create = function(self, source, target, inZone)
			if source == target then return end

			local char = Fetch:Source(source):GetData("Character")
			local tPlyr = Fetch:CharacterData("SID", target)

			if tPlyr ~= nil then
				local tChar = tPlyr:GetData("Character")

				if tChar ~= nil and string.format("apt-%s", tChar:GetData("Apartment") or 1) == inZone then
					_requests[target] = _requests[target] or {}
					for k, v in ipairs(_requests[target]) do
						if v.source == source then
							return
						end
					end
		
					_requestors[source] = target
					table.insert(_requests[target], {
						source = source,
						SID = char:GetData("SID"),
						First = char:GetData("First"),
						Last = char:GetData("Last"),
					})
				end
			end
		end,
	},
}
