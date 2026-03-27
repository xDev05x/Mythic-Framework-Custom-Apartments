
_aptData = {}
_aptDataByRoomId = {}
_availableApartments = {}
_assignedApartments = {} 
_apartmentAssignments = {} 


if _raidedApartments then
	_raidedApartments = {}
end

function Startup()
	if not Logger then
		Logger = exports["mythic-base"]:FetchComponent("Logger")
	end
	
	if not Database then
		Database = exports["mythic-base"]:FetchComponent("Database")
	end
	
	
	local aptConfigs = GetApartmentDataFromConfig()
	
	_aptData = {}
	_aptDataByRoomId = {}
	_availableApartments = {}
	_assignedApartments = {}
	_apartmentAssignments = {}
	local aptIds = {}

	
	for _, aptData in ipairs(aptConfigs) do
		local index = #_aptData + 1
		aptData.id = index
		
		
		if aptData.roomId then
			_aptDataByRoomId[aptData.roomId] = aptData
		end
		
		table.insert(_aptData, aptData)
		GlobalState[string.format("Apartment:%s", index)] = aptData
		table.insert(aptIds, index)
	end

	GlobalState["Apartments"] = aptIds
	
	
	LoadApartmentAssignments()
	
	if Logger then
		Logger:Info("Apartments", string.format("Loaded ^2%d^7 apartment rooms", #aptIds))
	end
end


function LoadApartmentAssignments()
	if not Database then return end
	
	local thirtyDaysAgo = os.time() * 1000 - (30 * 24 * 60 * 60 * 1000) 
	
	Database.Game:find({
		collection = "apartment_assignments",
		query = {}
	}, function(success, assignments)
		if not success then
			Logger:Warn("Apartments", "Failed to load apartment assignments")
			UpdateAvailableApartments()
			return
		end
		
		
		_assignedApartments = {}
		_apartmentAssignments = {}
		
		
		if not assignments or #assignments == 0 then
			UpdateAvailableApartments()
			if Logger then
				local availableCount = #_availableApartments
				Logger:Info("Apartments", string.format("Loaded assignments: ^2%d^7 available, ^3%d^7 assigned", availableCount, 0))
			end
			return
		end
		
		
		for _, assignment in ipairs(assignments) do
			
			local p = promise.new()
			Database.Game:findOne({
				collection = "characters",
				query = {
					SID = assignment.characterSID
				},
				options = {
					projection = {
						LastPlayed = 1,
						SID = 1
					}
				}
			}, function(charSuccess, charResults)
				if charSuccess and charResults then
					
					local lastPlayed = charResults.LastPlayed
					
					
					
					if lastPlayed and lastPlayed ~= -1 and lastPlayed < thirtyDaysAgo then
						
						ReleaseApartmentAssignment(assignment.apartmentId, assignment.characterSID, true)
						p:resolve(false)
					else
						
					_assignedApartments[assignment.apartmentId] = {
						characterSID = assignment.characterSID,
						characterID = assignment.characterID,
						assignedAt = assignment.assignedAt
					}
					
					local charSID = assignment.characterSID
					_apartmentAssignments[charSID] = assignment.apartmentId
					_apartmentAssignments[tostring(charSID)] = assignment.apartmentId
					if tonumber(charSID) then
						_apartmentAssignments[tonumber(charSID)] = assignment.apartmentId
					end
					
					
					if EnsureCharacterDoorAccess then
						EnsureCharacterDoorAccess(assignment.characterSID, assignment.apartmentId)
					end
						
						p:resolve(true)
					end
				else
					
					ReleaseApartmentAssignment(assignment.apartmentId, assignment.characterSID, true)
					p:resolve(false)
				end
			end)
			Citizen.Await(p)
		end
		
		UpdateAvailableApartments()
		
		if Logger then
			local availableCount = #_availableApartments
			local assignedCount = 0
			for _ in pairs(_assignedApartments) do
				assignedCount = assignedCount + 1
			end
			Logger:Info("Apartments", string.format("Loaded assignments: ^2%d^7 available, ^3%d^7 assigned", availableCount, assignedCount))
		end
	end)
end


function UpdateAvailableApartments(showDebug)
	_availableApartments = {}
	
	if not _aptData then
		return
	end
	
	if not _assignedApartments then
		_assignedApartments = {}
	end
	
	
	local localAssignedCount = 0
	for _ in pairs(_assignedApartments) do
		localAssignedCount = localAssignedCount + 1
	end
	
	
	local dbAssignedAptIds = {}
	if showDebug and Database then
		local p = promise.new()
		Database.Game:find({
			collection = "apartment_assignments",
			query = {}
		}, function(success, assignments)
			if success and assignments then
				local dbAssignedCount = #assignments
				
				
				for _, assignment in ipairs(assignments) do
					if assignment.apartmentId then
						dbAssignedAptIds[assignment.apartmentId] = true
					end
				end
			end
			p:resolve(true)
		end)
		Citizen.Await(p)
	end
	
	
	local assignedAptIds = {}
	if showDebug and next(dbAssignedAptIds) ~= nil then
		
		local dbCount = 0
		for _ in pairs(dbAssignedAptIds) do
			dbCount = dbCount + 1
		end
		if dbCount ~= localAssignedCount then
			
			_assignedApartments = {}
			_apartmentAssignments = {}
			
			
			if Database then
				local p2 = promise.new()
				Database.Game:find({
					collection = "apartment_assignments",
					query = {}
				}, function(success, assignments)
					if success and assignments then
						for _, assignment in ipairs(assignments) do
							if assignment.apartmentId and assignment.characterSID then
								_assignedApartments[assignment.apartmentId] = {
									characterSID = assignment.characterSID,
									characterID = assignment.characterID,
									assignedAt = assignment.assignedAt or (os.time() * 1000)
								}
								local charSID = assignment.characterSID
								_apartmentAssignments[charSID] = assignment.apartmentId
								_apartmentAssignments[tostring(charSID)] = assignment.apartmentId
								if tonumber(charSID) then
									_apartmentAssignments[tonumber(charSID)] = assignment.apartmentId
								end
							end
						end
					end
					p2:resolve(true)
				end)
				Citizen.Await(p2)
			end
			
			
			assignedAptIds = dbAssignedAptIds
		else
			
			for aptId, _ in pairs(_assignedApartments) do
				assignedAptIds[aptId] = true
			end
		end
	else
		
		for aptId, _ in pairs(_assignedApartments) do
			assignedAptIds[aptId] = true
		end
	end
	
	for _, aptData in ipairs(_aptData) do
		if aptData and aptData.id then
			if not assignedAptIds[aptData.id] then
			table.insert(_availableApartments, aptData.id)
			end
		end
	end
	
	GlobalState["AvailableApartments"] = _availableApartments
end


function AssignApartmentToCharacter(apartmentId, characterID, characterSID)
	if _assignedApartments[apartmentId] then
		return false 
	end
	
	if _apartmentAssignments[characterSID] then
		return false 
	end
	
	
	local p = promise.new()
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
			_assignedApartments[apartmentId] = {
				characterSID = characterSID,
				characterID = characterID,
				assignedAt = os.time() * 1000
			}
			_apartmentAssignments[characterSID] = apartmentId
			UpdateAvailableApartments()
			p:resolve(true)
		else
			p:resolve(false)
		end
	end)
	
	return Citizen.Await(p)
end


function ReleaseApartmentAssignment(apartmentId, characterSID, silent)
	if not _assignedApartments[apartmentId] then
		return false 
	end
	
	if not Database then
		if Logger then
			Logger:Warn("Apartments", "Database component not available for ReleaseApartmentAssignment")
		end
		return false
	end
	
	local assignment = _assignedApartments[apartmentId]
	local characterID = assignment and assignment.characterID
	
	
	if RemoveCharacterDoorAccess then
		RemoveCharacterDoorAccess(characterSID, apartmentId)
	end
	
	
	local invType = 13 
	if _aptData[apartmentId] and _aptData[apartmentId].invEntity then
		invType = _aptData[apartmentId].invEntity
	end
	
	if Inventory then
		local stashName = string.format("%s-%s", characterSID, invType)
		if MySQL then
			MySQL.query.await("DELETE FROM inventory WHERE name = ?", { stashName })
			if Logger then
				Logger:Info("Apartments", "stash cleared for apartment " .. apartmentId .. " (character " .. characterSID .. ")")
			end
		end
	end
	
	Database.Game:delete({
		collection = "apartment_assignments",
		query = {
			apartmentId = apartmentId,
			characterSID = characterSID
		}
	}, function(success)
		if success then
			
			_assignedApartments[apartmentId] = nil
			_apartmentAssignments[characterSID] = nil
			_apartmentAssignments[tostring(characterSID)] = nil
			if tonumber(characterSID) then
				_apartmentAssignments[tonumber(characterSID)] = nil
			end
			
			
			if characterID then
				Database.Game:updateOne({
					collection = "characters",
					query = {
						_id = characterID
					},
					update = {
						["$set"] = {
							Apartment = 0
						}
					}
				}, function(charUpdateSuccess)
					if charUpdateSuccess and Logger then
						Logger:Info("Apartments", string.format("Cleared apartment %s from character %s (ID: %s) database record", apartmentId, characterSID, tostring(characterID)))
					end
				end)
			end
			
			
			UpdateAvailableApartments()
			
			if not silent and Logger then
				Logger:Info("Apartments", string.format("Released apartment %s from character %s - now available for assignment", apartmentId, characterSID))
			end
		end
	end)
	
	return true
end


function GetCharacterApartment(characterSID)
	return _apartmentAssignments[characterSID]
end


function GetApartmentByRoomId(roomId)
	return _aptDataByRoomId[roomId]
end


function GetRandomAvailableApartment()
	if _availableApartments and #_availableApartments > 0 then
		local randomIndex = math.random(1, #_availableApartments)
		local aptId = _availableApartments[randomIndex]
		return aptId
	end
	return nil 
end


function IsApartmentAvailable(apartmentId)
	return not _assignedApartments[apartmentId]
end
