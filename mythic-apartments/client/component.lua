local _pzs = {}
local _inPoly = false
local _menu = false
local _currentElevator = nil 
local _currentFloor = nil 
local _currentWardrobe = nil 
local _currentShower = nil 
local _isShowering = false 
local _showerParticle = nil 

AddEventHandler("Apartment:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mythic-base"]:FetchComponent("Callbacks")
	Utils = exports["mythic-base"]:FetchComponent("Utils")
	Blips = exports["mythic-base"]:FetchComponent("Blips")
	Notification = exports["mythic-base"]:FetchComponent("Notification")
	Action = exports["mythic-base"]:FetchComponent("Action")
	Polyzone = exports["mythic-base"]:FetchComponent("Polyzone")
	Ped = exports["mythic-base"]:FetchComponent("Ped")
	Sounds = exports["mythic-base"]:FetchComponent("Sounds")
	Targeting = exports["mythic-base"]:FetchComponent("Targeting")
	Interaction = exports["mythic-base"]:FetchComponent("Interaction")
	Action = exports["mythic-base"]:FetchComponent("Action")
	ListMenu = exports["mythic-base"]:FetchComponent("ListMenu")
	Input = exports["mythic-base"]:FetchComponent("Input")
	Apartment = exports["mythic-base"]:FetchComponent("Apartment")
	Characters = exports["mythic-base"]:FetchComponent("Characters")
	Wardrobe = exports["mythic-base"]:FetchComponent("Wardrobe")
	Sync = exports["mythic-base"]:FetchComponent("Sync")
	Animations = exports["mythic-base"]:FetchComponent("Animations")
	Progress = exports["mythic-base"]:FetchComponent("Progress")
end

function CreateElevatorPolyzones()
	if not Config.HotelElevators then
		return
	end

	for buildingName, elevatorFloors in pairs(Config.HotelElevators) do
		for floor, floorElevators in pairs(elevatorFloors) do
			for elevatorIndex, elevatorData in pairs(floorElevators) do
				if type(elevatorData) ~= "table" then
					goto continue
				end
				if elevatorData.poly then
					local zoneId = string.format("elevator-%s-%s-%s", buildingName, floor, elevatorIndex)
					Polyzone.Create:Box(zoneId, elevatorData.poly.center, elevatorData.poly.length, elevatorData.poly.width, elevatorData.poly.options, {
						buildingName = buildingName,
						floor = floor,
						elevatorIndex = elevatorIndex
					})
				end
				::continue::
			end
		end
	end
end

AddEventHandler("Core:Shared:Ready", function()
		exports["mythic-base"]:RequestDependencies("Apartment", {
		"Callbacks",
		"Utils",
		"Blips",
		"Notification",
		"Action",
		"Polyzone",
		"Ped",
		"Sounds",
		"Targeting",
		"Interaction",
		"Action",
		"ListMenu",
		"Input",
		"Apartment",
		"Characters",
		"Wardrobe",
			"Sync",
			"Animations",
			"Progress",
	}, function(error)
		if #error > 0 then
			return
		end 
		RetrieveComponents()

		
		CreateElevatorPolyzones()

		
		local buildingBlips = {}

		for k, v in ipairs(GlobalState["Apartments"]) do
			local aptId = string.format("apt-%s", v)
			local apt = GlobalState[string.format("Apartment:%s", v)]

			
			Polyzone.Create:Box(aptId, apt.coords, apt.length, apt.width, apt.options, {
				tier = k
			})

			

			
			if apt.buildingName and not buildingBlips[apt.buildingName] then
				local buildingLabel = apt.buildingLabel or apt.buildingName
				Blips:Add("apt-building-" .. apt.buildingName, buildingLabel, apt.coords, 475, 25)
				buildingBlips[apt.buildingName] = true
			end

			_pzs[aptId] = {
				name = apt.name,
				id = apt.id,
			}
		end

		

		
		if Config.ReceptionPed then
			local PedInteraction = exports["mythic-base"]:FetchComponent("PedInteraction")
			if PedInteraction then
				
				RegisterNetEvent("Apartment:Reception:RequestApartment", function()
					if LocalPlayer.state.Character then
						local char = LocalPlayer.state.Character
						local aptId = char:GetData("Apartment") or 0
						
						if aptId > 0 then
							Notification:Error("You already have an apartment assigned")
						else
							Callbacks:ServerCallback("Apartment:RequestApartment", {}, function(result)
								if result.success then
									local displayLabel = result.roomLabel or result.apartmentId
									local buildingName = result.buildingName or "Apartment Building"
									Notification:Success(string.format("You have been assigned Room %s at %s", displayLabel, buildingName))
									
									char:SetData("Apartment", result.apartmentId)
								else
									Notification:Error(result.message or "Failed to request apartment")
								end
							end)
						end
					end
				end)

				RegisterNetEvent("Apartment:Reception:GetMyRoom", function()
					if LocalPlayer.state.Character then
						Callbacks:ServerCallback("Apartment:GetMyRoom", {}, function(result)
							if result.success then
								local message = string.format("Your room is %s, Room %s on Floor %s", result.buildingName, result.roomLabel, result.floor)
								Notification:Info(message)
							else
								Notification:Error(result.message or "Unable to find your room information")
							end
						end)
					end
				end)

				local receptionMenu = {
					{
						text = "Request Apartment",
						event = "Apartment:Reception:RequestApartment",
						icon = "house",
						data = {}
					},
					{
						text = "Where's My Room?",
						event = "Apartment:Reception:GetMyRoom",
						icon = "map-location-dot",
						data = {}
					}
				}

				PedInteraction:Add(
					"apartment_reception",
					Config.ReceptionPed.model,
					vector3(Config.ReceptionPed.coords.x, Config.ReceptionPed.coords.y, Config.ReceptionPed.coords.z),
					Config.ReceptionPed.coords.w or Config.ReceptionPed.coords[4] or 0.0,
					50.0, 
					receptionMenu,
					"user", 
					Config.ReceptionPed.scenario,
					true, 
					nil, 
					nil 
				)
			end
		end
	end)
end)


AddEventHandler("Proxy:Shared:RegisterReady", function()
	exports["mythic-base"]:RegisterComponent("Apartment", _APTS)
end)


local _apartmentTargetsSetup = {}

local _apartmentPolyzonesSetup = {}

local function SetupApartmentTargets(aptId, unit)
	local p = GlobalState[string.format("Apartment:%s", aptId)]
	if not p or not p.interior then
		return
	end
	
	
	local targetKey = string.format("%s_%s", aptId, unit)
	local polyzoneKey = string.format("%s_%s", aptId, unit)
	
	
	
	local needPolyzones = not _apartmentPolyzonesSetup[polyzoneKey]
	local needTargets = not _apartmentTargetsSetup[targetKey]
	
	if not needTargets and not needPolyzones then
		return 
	end
	
	
	Targeting.Zones:AddBox(
		string.format("apt-%s-raid", aptId),
		"shield-halved",
		p.interior.locations.exit.coords,
		p.interior.locations.exit.length,
		p.interior.locations.exit.width,
		p.interior.locations.exit.options,
		{
			{
				icon = "shield-halved",
				text = "Raid Apartment",
				event = "Apartment:Client:Raid",
				data = {
					aptId = aptId,
					unit = unit
				},
				isEnabled = function(data)
					return LocalPlayer.state.onDuty == "police"
				end,
			},
		},
		3.0,
		true
	)

	
	if p.interior.locations.logout then
		Targeting.Zones:AddBox(
			string.format("apt-%s-logout", aptId),
			"bed",
			p.interior.locations.logout.coords,
			p.interior.locations.logout.length,
			p.interior.locations.logout.width,
			p.interior.locations.logout.options,
			{
				{
					icon = "bed",
					text = "Switch Characters",
					event = "Apartment:Client:Logout",
					data = unit,
					isEnabled = function(data)
						return unit == LocalPlayer.state.Character:GetData("SID")
					end,
				},
			},
			3.0,
			true
		)
	end

	
	if needPolyzones and p.interior.locations.wardrobe then
		local wardrobeZoneId = string.format("apt-%s-wardrobe", aptId)
		Polyzone.Create:Box(wardrobeZoneId, p.interior.locations.wardrobe.coords, p.interior.locations.wardrobe.length, p.interior.locations.wardrobe.width, p.interior.locations.wardrobe.options, {
			aptId = aptId,
			unit = unit,
			type = "wardrobe"
		})
	end
	
	
	if needPolyzones and p.interior.locations.shower then
		local showerZoneId = string.format("apt-%s-shower", aptId)
		Polyzone.Create:Box(showerZoneId, p.interior.locations.shower.coords, p.interior.locations.shower.length, p.interior.locations.shower.width, p.interior.locations.shower.options, {
			aptId = aptId,
			unit = unit,
			type = "shower"
		})
	end

	
	if p.interior.locations.stash then
		Targeting.Zones:AddBox(
			string.format("apt-%s-stash", aptId),
			"toolbox",
			p.interior.locations.stash.coords,
			p.interior.locations.stash.length,
			p.interior.locations.stash.width,
			p.interior.locations.stash.options,
			{
				{
					icon = "toolbox",
					text = "Stash",
					event = "Apartment:Client:Stash",
					data = unit,
					isEnabled = function(data)
						local char = LocalPlayer.state.Character
						if not char then
							return false
						end
						
						local mySID = char:GetData("SID")
						
						if unit == mySID then
							return true
						end
						
						if LocalPlayer.state.onDuty == "police" then
							local raidState = GlobalState[string.format("Apartment:Raid:%s", aptId)]
							return raidState == true
						end
						
						return false
					end,
				},
			},
			3.0,
			true
		)
	end

	
	if needTargets then
		_apartmentTargetsSetup[targetKey] = true
	end
	if needPolyzones then
		_apartmentPolyzonesSetup[polyzoneKey] = true
	end

	Targeting.Zones:Refresh()
end

RegisterNetEvent("Apartment:Client:InnerStuff", function(aptId, unit, wakeUp)
	while GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)] == nil do
		Wait(10)
	end
	
	local p = GlobalState[string.format("Apartment:%s", aptId)]
	if not p or not p.interior then
		return
	end
	
	if p.floor and p.buildingName and LocalPlayer.state.inApartment and LocalPlayer.state.inApartment.type == aptId then
		if _currentFloor ~= p.floor then
			_currentFloor = p.floor
			TriggerServerEvent("Apartment:Server:ElevatorFloorChanged", p.buildingName, p.floor)
		end
	end
	
	TriggerEvent("Interiors:Enter", vector3(p.interior.spawn.x, p.interior.spawn.y, p.interior.spawn.z))

	if wakeUp then
		SetTimeout(250, function()
			Animations.Emotes:WakeUp(p.interior.wakeup)
		end)
	end

	
	SetupApartmentTargets(aptId, unit)

	Targeting.Zones:Refresh()
	Wait(1000)
	Sync:Stop(1)
end)

AddEventHandler("Characters:Client:Spawn", function()
	if not LocalPlayer.state.Character then
		return
	end
	local char = LocalPlayer.state.Character
	local mySID = char:GetData("SID")
	local aptId = char:GetData("Apartment") or 0
	
	if aptId > 0 then
		local inApartmentState = LocalPlayer.state.inApartment
		if inApartmentState and inApartmentState.type == aptId and inApartmentState.id == mySID then
			SetupApartmentTargets(aptId, mySID)
		end
	end
end)


AddEventHandler("Characters:Client:Logout", function()
	_currentFloor = nil
	_currentElevator = nil
	
	if LocalPlayer.state.inApartment then
		local aptId = LocalPlayer.state.inApartment.type
		local unit = LocalPlayer.state.inApartment.id
		
		if aptId then
			local p = GlobalState[string.format("Apartment:%s", aptId)]
			if p and p.interior then
				
				for k, v in pairs(p.interior.locations) do
					Targeting.Zones:RemoveZone(string.format("apt-%s-%s", k, aptId))
				end
				Targeting.Zones:RemoveZone(string.format("apt-%s-raid", aptId))
				
				
				if p.interior.locations.wardrobe then
					Polyzone:RemoveZone(string.format("apt-%s-wardrobe", aptId))
				end
				if p.interior.locations.shower then
					Polyzone:RemoveZone(string.format("apt-%s-shower", aptId))
				end
				
				
				if unit then
					local exitKey = string.format("%s_%s", aptId, unit)
					_apartmentTargetsSetup[exitKey] = nil
					_apartmentPolyzonesSetup[exitKey] = nil
				end
				
				Targeting.Zones:Refresh()
			end
		end
		
		
		for buildingName, buildingData in pairs(_floorRaidTargets) do
			for floor, aptIds in pairs(buildingData) do
				for _, floorAptId in ipairs(aptIds) do
					Targeting.Zones:RemoveZone(string.format("apt-%s-raid-floor", floorAptId))
				end
			end
		end
		_floorRaidTargets = {}
	end
	
	
	_currentFloor = nil
	_currentElevator = nil
	_currentWardrobe = nil
	_currentShower = nil
	Action:Hide()
	TriggerServerEvent("Apartment:Server:LogoutCleanup")
end)

AddEventHandler("Apartment:Client:Raid", function(data)
	if not data or not data.aptId or not data.unit then
		return
	end
	
	
	Callbacks:ServerCallback("Apartment:Validate", {
		id = data.aptId,
		type = "stash",
		unit = data.unit
	})
end)


RegisterNetEvent("Apartment:Client:RaidStateChanged", function(aptId, isRaided)
	
	if Targeting and Targeting.Zones then
		Targeting.Zones:Refresh()
	end
end)

local _floorRaidTargets = {}

function CreateFloorRaidTargets(buildingName, floor)
	if not buildingName or floor == nil then
		return
	end
	
	
	if _floorRaidTargets[buildingName] and _floorRaidTargets[buildingName][floor] then
		for _, aptId in ipairs(_floorRaidTargets[buildingName][floor]) do
			Targeting.Zones:RemoveZone(string.format("apt-%s-raid-floor", aptId))
		end
	end
	
	
	Callbacks:ServerCallback("Apartment:GetFloorApartments", {
		buildingName = buildingName,
		floor = floor
	}, function(floorApartments)
		if not floorApartments or #floorApartments == 0 then
			return
		end
		
		
		_floorRaidTargets[buildingName] = _floorRaidTargets[buildingName] or {}
		_floorRaidTargets[buildingName][floor] = {}
		
		
		for _, aptData in ipairs(floorApartments) do
			local aptId = aptData.aptId
			local apt = GlobalState[string.format("Apartment:%s", aptId)]
			if apt then
				local doorEntry = nil
				if apt.zones and apt.zones.doorEntry then
					doorEntry = apt.zones.doorEntry
				elseif apt.doorEntry then
					doorEntry = apt.doorEntry
				elseif apt.coords then
					doorEntry = apt.coords
				end
				
				if doorEntry then
					
					Targeting.Zones:AddBox(
						string.format("apt-%s-raid-floor", aptId),
						"shield-halved",
						doorEntry,
						1.5,
						1.5,
						{
							heading = 0,
							minZ = doorEntry.z - 1.0,
							maxZ = doorEntry.z + 2.0
						},
						{
							{
								icon = "shield-halved",
								text = "Raid Apartment",
								event = "Apartment:Client:Raid",
								data = {
									aptId = aptId,
									unit = aptData.unit
								},
								isEnabled = function(data)
									return LocalPlayer.state.onDuty == "police"
								end,
							},
						},
						3.0,
						true
					)
					table.insert(_floorRaidTargets[buildingName][floor], aptId)
				end
			end
		end
		
		Targeting.Zones:Refresh()
	end)
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
	
	if data and data.buildingName and data.floor ~= nil then
		_currentElevator = {
			buildingName = data.buildingName,
			floor = data.floor,
			elevatorIndex = data.elevatorIndex
		}
		Action:Show("{keybind}primary_action{/keybind} Use Elevator")
		
		
		CreateFloorRaidTargets(data.buildingName, data.floor)
	
	elseif data and data.type == "wardrobe" then
		local char = LocalPlayer.state.Character
		if char and data.unit == char:GetData("SID") then
			_currentWardrobe = {
				aptId = data.aptId,
				unit = data.unit
			}
			Action:Show("{keybind}primary_action{/keybind} Use Wardrobe")
		end
	
	elseif data and data.type == "shower" then
		local char = LocalPlayer.state.Character
		if char and data.unit == char:GetData("SID") then
			_currentShower = {
				aptId = data.aptId,
				unit = data.unit
			}
			Action:Show("{keybind}primary_action{/keybind} Use Shower")
		end
	
	elseif _pzs[id] and string.format("apt-%s", LocalPlayer.state.Character:GetData("Apartment") or 1) == id then
		while GetVehiclePedIsIn(LocalPlayer.state.ped) ~= 0 do
			Wait(10)
		end

		_inPoly = {
			id = id,
			data = data.tier
		}
	end
end)

AddEventHandler("Polyzone:Exit", function(id, testedPoint, insideZones, data)
	
	if data and data.buildingName and data.floor ~= nil and _currentElevator and _currentElevator.buildingName == data.buildingName and _currentElevator.floor == data.floor and _currentElevator.elevatorIndex == data.elevatorIndex then
		_currentElevator = nil
		Action:Hide()
	
	elseif data and data.type == "wardrobe" and _currentWardrobe and _currentWardrobe.aptId == data.aptId then
		_currentWardrobe = nil
		Action:Hide()
	
	elseif data and data.type == "shower" and _currentShower and _currentShower.aptId == data.aptId then
		_currentShower = nil
		Action:Hide()
	
	elseif id == _inPoly?.id then
		_inPoly = nil
		Action:Hide()
	end
end)


AddEventHandler("Keybinds:Client:KeyUp:primary_action", function()
	if _currentElevator and _currentElevator.buildingName and Config.HotelElevators and Config.HotelElevators[_currentElevator.buildingName] then
		OpenElevatorMenu(_currentElevator.buildingName)
	elseif _currentWardrobe then
		
		Apartment.Extras:Wardrobe()
	elseif _currentShower then
		
		TriggerEvent("Apartment:Client:Shower", _currentShower.unit)
	end
end)

function OpenElevatorMenu(buildingName)
	local elevatorFloors = Config.HotelElevators[buildingName]
	local floorDescriptions = Config.HotelElevatorsDesc and Config.HotelElevatorsDesc[buildingName] or {}
	
	if not elevatorFloors then
		return
	end

	
	local buildingLabel = buildingName
	if Config.HotelRooms and Config.HotelRooms[buildingName] and Config.HotelRooms[buildingName].label then
		buildingLabel = Config.HotelRooms[buildingName].label
	end

	local menu = {
		main = {
			label = buildingLabel,
			items = {}
		}
	}

	
	local sortedFloors = {}
	for floorId, _ in pairs(elevatorFloors) do
		table.insert(sortedFloors, floorId)
	end
	table.sort(sortedFloors, function(a, b) return a < b end)

	
	for _, floorId in ipairs(sortedFloors) do
		local isDisabled = false
		local description = nil

		if _currentFloor == floorId and LocalPlayer.state.inApartment then
			isDisabled = true
			description = "You are currently on this floor"
		end

		
		local floorLabel = floorDescriptions[floorId] or ("Floor " .. floorId)
		if floorId == 0 then
			floorLabel = floorDescriptions[0] or "Lobby"
		end

		table.insert(menu.main.items, {
			level = floorId,
			label = floorLabel,
			disabled = isDisabled,
			description = description,
			event = "Apartment:Client:UseElevator",
			data = {
				buildingName = buildingName,
				floor = floorId
			}
		})
	end

	ListMenu:Show(menu)
end

AddEventHandler("Apartment:Client:UseElevator", function(data)
	if not data or not data.buildingName or not data.floor then
		return
	end

	local elevatorFloors = Config.HotelElevators[data.buildingName]
	if not elevatorFloors or not elevatorFloors[data.floor] then
		return
	end

	
	local floorElevators = elevatorFloors[data.floor]
	local targetElevator = floorElevators[1] 
	
	if not targetElevator or not targetElevator.pos then
		return
	end

	ListMenu:Close()

	
	CreateThread(function()
		local shakeDuration = 800
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < shakeDuration do
			ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.015)
			Wait(100)
		end
	end)

	Wait(800)

	
	DoScreenFadeOut(1200)
	while not IsScreenFadedOut() do Wait(10) end

	Wait(300)

	
	SetEntityCoords(LocalPlayer.state.ped, targetElevator.pos.x, targetElevator.pos.y, targetElevator.pos.z)
	SetEntityHeading(LocalPlayer.state.ped, targetElevator.pos.w or 0.0)
	
	
	Sounds.Play:Distance(5.0, "elevator-bell.ogg", 0.4)
	
	Wait(200)
	
	DoScreenFadeIn(1200)

	
	TriggerServerEvent("Apartment:Server:ElevatorFloorChanged", data.buildingName, data.floor)
	
	
	CreateFloorRaidTargets(data.buildingName, data.floor)

	if LocalPlayer.state.Character then
		local char = LocalPlayer.state.Character
		local mySID = char:GetData("SID")
		local aptId = char:GetData("Apartment") or 0
		
		if aptId > 0 then
			local apt = GlobalState[string.format("Apartment:%s", aptId)]
			-- If this is the player's apartment floor, set _currentFloor (this IS their apartment)
			if apt and apt.buildingName == data.buildingName and apt.floor == data.floor then
				_currentFloor = data.floor
				
				local inApartmentState = LocalPlayer.state.inApartment
				if inApartmentState and inApartmentState.type == aptId and inApartmentState.id == mySID then
					
					TriggerEvent("Apartment:Client:InnerStuff", aptId, mySID, false)
				end
			else
				_currentFloor = nil
			end
		else
			_currentFloor = nil
		end
	end
end)

AddEventHandler("Apartment:Client:Enter", function(data)
	Apartment:Enter(data)
end)

AddEventHandler("Apartment:Client:RequestEntry", function(data)
	Input:Show("Request Entry", "Unit Number (Owner State ID)", {
		{
			id = "unit",
			type = "number",
			options = {
				inputProps = {
					maxLength = 4,
				},
			},
		},
	}, "Apartment:Client:DoRequestEntry", _inPoly)
end)

AddEventHandler("Apartment:Client:DoRequestEntry", function(values, data)
	Callbacks:ServerCallback("Apartment:RequestEntry", {
		inZone = data,
		target = values.unit,
	})
end)

AddEventHandler("Apartment:Client:Stash", function(t, data)
	Apartment.Extras:Stash()
end)

AddEventHandler("Apartment:Client:Wardrobe", function(t, data)
	Apartment.Extras:Wardrobe()
end)


local function LoadPtfxAsset(assetName)
	if not HasNamedPtfxAssetLoaded(assetName) then
		RequestNamedPtfxAsset(assetName)
		while not HasNamedPtfxAssetLoaded(assetName) do
			Wait(1)
		end
	end
end

local _showerParticles = {} 

local function StartShowerParticle(showerHeadPos, aptId)
	LoadPtfxAsset("core")
	
	
	UseParticleFxAssetNextCall("core")
	_showerParticle = StartParticleFxLoopedAtCoord(
		"ent_sht_steam",
		showerHeadPos.x,
		showerHeadPos.y,
		showerHeadPos.z,
		-180.0,
		0.0,
		0.0,
		1.0,
		false,
		false,
		false
	)
	
	
	TriggerServerEvent("Apartment:Server:StartShowerParticle", showerHeadPos, aptId)
end

local function StopShowerParticle()
	if _showerParticle then
		StopParticleFxLooped(_showerParticle, false)
		_showerParticle = nil
	end
	TriggerServerEvent("Apartment:Server:StopShowerParticle")
end


RegisterNetEvent("Apartment:Client:StartShowerParticle", function(source, showerHeadPos, aptId)
	if source == LocalPlayer.state.ID then
		return 
	end
	
	LoadPtfxAsset("core")
	UseParticleFxAssetNextCall("core")
	local particle = StartParticleFxLoopedAtCoord(
		"ent_sht_steam",
		showerHeadPos.x,
		showerHeadPos.y,
		showerHeadPos.z,
		-180.0,
		0.0,
		0.0,
		1.0,
		false,
		false,
		false
	)
	
	_showerParticles[source] = particle
end)

RegisterNetEvent("Apartment:Client:StopShowerParticle", function(source)
	if _showerParticles[source] then
		StopParticleFxLooped(_showerParticles[source], false)
		_showerParticles[source] = nil
	end
end)

local function PlayShowerAnimation()
	local playerPed = LocalPlayer.state.ped
	local animDict = "anim@mp_yacht@shower@male@"
	
	
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Wait(1)
		end
	end
	
	CreateThread(function()
		while _isShowering do
			TaskPlayAnim(playerPed, animDict, "male_shower_idle_d", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
			Wait(GetAnimDuration(animDict, "male_shower_idle_d") * 1000)
			if not _isShowering then break end
			
			TaskPlayAnim(playerPed, animDict, "male_shower_idle_a", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
			Wait(GetAnimDuration(animDict, "male_shower_idle_a") * 1000)
			if not _isShowering then break end
			
			TaskPlayAnim(playerPed, animDict, "male_shower_idle_c", 8.0, -8.0, 5.0, 0, 0.0, 0, 0, 0)
			Wait(GetAnimDuration(animDict, "male_shower_idle_c") * 1000)
		end
		
		
		RemoveAnimDict(animDict)
	end)
end

function TakeShower(aptId, showerHeadPos, showerTime)
	if not showerHeadPos then
		showerHeadPos = GetEntityCoords(LocalPlayer.state.ped) + vector3(0.0, 0.0, 1.0)
	end
	
	if not aptId then
		Notification:Error("Can't start showering without an apartment ID")
		return
	end
	
	
	_isShowering = true
	StartShowerParticle(showerHeadPos, aptId)
	PlayShowerAnimation()
	
	
	local defaultShowerTime = (showerTime or 2) * 60 * 1000
	
	
	Progress:Progress({
		name = "apartment_shower_" .. aptId,
		duration = defaultShowerTime,
		label = "Showering",
		useWhileDead = false,
		canCancel = true,
		vehicle = false,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableCombat = true,
		},
		animation = {
			animDict = "anim@mp_yacht@shower@male@",
			anim = "male_shower_idle_d",
			flags = 1,
		},
	}, function(success)
		_isShowering = false
		
		
		StopShowerParticle()
		
		
		ClearPedTasks(LocalPlayer.state.ped)
		
		if success then
			
			ClearPedBloodDamage(LocalPlayer.state.ped)
			ClearPedEnvDirt(LocalPlayer.state.ped)
			
			
			if LocalPlayer.state.GSR then
				LocalPlayer.state:set("GSR", nil, true)
			end
			
			Notification:Success("You feel clean and refreshed!", 5000)
		else
			Notification:Info("Shower cancelled", 3000)
		end
	end)
end

AddEventHandler("Apartment:Client:Shower", function(unit)
	if not LocalPlayer.state.Character or LocalPlayer.state.Character:GetData("SID") ~= unit then
		return
	end
	
	if _isShowering then
		Notification:Error("You are already showering", 3000)
		return
	end
	
	
	local aptId = LocalPlayer.state.inApartment and LocalPlayer.state.inApartment.type
	if not aptId then
		Notification:Error("You must be in your apartment to shower", 3000)
		return
	end
	
	local p = GlobalState[string.format("Apartment:%s", aptId)]
	if not p or not p.interior or not p.interior.locations or not p.interior.locations.shower then
		Notification:Error("Shower location not found", 3000)
		return
	end
	
	local showerPos = p.interior.locations.shower.coords
	local showerHeadPos = vector3(showerPos.x, showerPos.y, showerPos.z + 1.0)
	
	
	TakeShower(aptId, showerHeadPos, 2) 
end)

AddEventHandler("Apartment:Client:Logout", function(t, data)
	Apartment.Extras:Logout()
end)

_APTS = {
	Enter = function(self, tier, id)
		
		
		Callbacks:ServerCallback("Apartment:Enter", {
			id = id or -1,
			tier = tier,
		}, function(s)
			if s then
				Sounds.Play:One("door_open.ogg", 0.15)
				
			end
		end)
	end,
	Exit = function(self)
		local apartmentId = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)]
		local p = GlobalState[string.format(
			"Apartment:%s",
			LocalPlayer.state.inApartment.type
		)]

		if not p then return end

		Callbacks:ServerCallback("Apartment:Exit", {}, function()
			
			TriggerEvent("Interiors:Exit")
			Sync:Start()

			Sounds.Play:One("door_close.ogg", 0.3)

			
			for k, v in pairs(p.interior.locations) do
				Targeting.Zones:RemoveZone(string.format("apt-%s-%s", k, LocalPlayer.state.inApartment.type))
			end
			
			Targeting.Zones:RemoveZone(string.format("apt-%s-raid", LocalPlayer.state.inApartment.type))
			
			
			if p.interior.locations.wardrobe then
				Polyzone:RemoveZone(string.format("apt-%s-wardrobe", LocalPlayer.state.inApartment.type))
			end
			if p.interior.locations.shower then
				Polyzone:RemoveZone(string.format("apt-%s-shower", LocalPlayer.state.inApartment.type))
			end
			
			
			local exitAptId = LocalPlayer.state.inApartment.type
			local exitUnit = LocalPlayer.state.inApartment.id
			if exitAptId and exitUnit then
				local exitKey = string.format("%s_%s", exitAptId, exitUnit)
				_apartmentTargetsSetup[exitKey] = nil
				_apartmentPolyzonesSetup[exitKey] = nil
			end
			
			
			_currentWardrobe = nil
			_currentShower = nil
			_currentFloor = nil
			_currentElevator = nil
			Action:Hide()

			Targeting.Zones:Refresh()
		end)
	end,
	GetNearApartment = function(self)
		if _inPoly?.id ~= nil and _pzs[_inPoly?.id]?.id ~= nil then
			return GlobalState[string.format("Apartment:%s", _pzs[_inPoly?.id].id)]
		else
			return nil
		end
	end,
	Extras = {
		Stash = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "stash",
			})
		end,
		Wardrobe = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "wardrobe",
			}, function(state)
				if state then
					Wardrobe:Show()
				end
			end)
		end,
		Logout = function(self)
			Callbacks:ServerCallback("Apartment:Validate", {
				id = GlobalState[string.format("%s:Apartment", LocalPlayer.state.ID)],
				type = "logout",
			}, function(state)
				if state then
					Characters:Logout()
				end
			end)
		end,
	},
}


RegisterNetEvent("Apartment:Client:ExitElevator", function()
	
	TriggerEvent("Interiors:Exit")
	if Sync then
		Sync:Start()
	end
end)
