local creationHelper = false
local lastOutlineEntity = 0

local function GetCameraRay()
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local radX = math.rad(camRot.x)
    local radZ = math.rad(camRot.z)
    local dir = vector3(
        -math.sin(radZ) * math.abs(math.cos(radX)),
        math.cos(radZ) * math.abs(math.cos(radX)),
        math.sin(radX)
    )
    return camCoords, dir
end

local function RaycastFromCamera(camCoords, dir, maxDist)
    local dest = camCoords + dir * maxDist
    local ped = PlayerPedId()
    local ray = StartExpensiveSynchronousShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, dest.x, dest.y, dest.z, 17, ped, 7)
    local _, hit, hitCoords, _, entity = GetShapeTestResult(ray)
    return hit == 1, entity, hitCoords
end

local function FindObjectOnAimLine(camCoords, dir, maxDist, maxPerp)
    local best, bestDist = 0, maxDist + 1
    local handle, obj = FindFirstObject()
    local success = true

    repeat
        if DoesEntityExist(obj) then
            local objCoords = GetEntityCoords(obj)
            local toObj = objCoords - camCoords
            local t = toObj.x * dir.x + toObj.y * dir.y + toObj.z * dir.z

            if t > 0.0 and t < maxDist then
                local closestOnLine = camCoords + dir * t
                local perpDist = #(objCoords - closestOnLine)

                if perpDist < maxPerp and t < bestDist then
                    best = obj
                    bestDist = t
                end
            end
        end
        success, obj = FindNextObject(handle)
    until not success
    EndFindObject(handle)

    return best
end

local function DrawInstructionUI(text)
    SetTextFont(4)
    SetTextScale(0.0, 0.35)
    SetTextColour(255, 255, 255, 220)
    SetTextEdge(1, 0, 0, 0, 150)
    SetTextOutline()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.85, 0.928)

    DrawRect(0.85, 0.942, 0.28, 0.045, 10, 10, 18, 190)
    DrawRect(0.85, 0.9195, 0.28, 0.002, 32, 134, 146, 220)
end

RegisterNetEvent('Doors:Client:DoorHelper', function()
    if creationHelper then
        creationHelper = false
        return
    end

    creationHelper = true
    lastOutlineEntity = 0

    CreateThread(function()
        while creationHelper do
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            local camCoords, dir = GetCameraRay()
            local hit, rayEntity, hitCoords = RaycastFromCamera(camCoords, dir, 25.0)

            local searchDist = 25.0
            if hit then
                searchDist = #(hitCoords - camCoords) + 1.0
            end

            local entity = 0
            if rayEntity > 0 and DoesEntityExist(rayEntity) and GetEntityType(rayEntity) == 3 then
                entity = rayEntity
            else
                entity = FindObjectOnAimLine(camCoords, dir, searchDist, 1.0)
            end

            if lastOutlineEntity ~= 0 and lastOutlineEntity ~= entity then
                SetEntityDrawOutline(lastOutlineEntity, false)
                lastOutlineEntity = 0
            end

            local isValidObject = entity > 0 and DoesEntityExist(entity)

            if isValidObject then
                if lastOutlineEntity ~= entity then
                    SetEntityDrawOutlineColor(32, 134, 146, 255)
                    SetEntityDrawOutlineShader(1)
                    SetEntityDrawOutline(entity, true)
                    lastOutlineEntity = entity
                end

                local entityCoords = GetEntityCoords(entity)
                DrawMarker(28, entityCoords.x, entityCoords.y, entityCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 32, 134, 146, 120, false, true, 2, nil, nil, false)

                if hit then
                    DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.15, 0.15, 0.15, 255, 255, 255, 200, false, false, 0, true, false, false, false)
                end

                DrawInstructionUI("~b~E~s~ Capture Door  |  ~r~Right Click~s~ Cancel")

                if IsDisabledControlJustPressed(0, 38) then
                    local data = {
                        model = GetEntityModel(entity),
                        coords = GetEntityCoords(entity),
                        heading = GetEntityHeading(entity),
                    }

                    SetEntityDrawOutline(entity, false)
                    lastOutlineEntity = 0
                    creationHelper = false

                    TriggerServerEvent('Doors:Server:CapturedDoor', data)
                    Notification:Success('Door Captured')
                end
            else
                if hit then
                    DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 255, 255, 60, false, false, 0, true, false, false, false)
                end
                DrawInstructionUI("~b~Aim~s~ at a door  |  ~r~Right Click~s~ Cancel")
            end

            if IsDisabledControlJustPressed(0, 25) then
                if lastOutlineEntity ~= 0 then
                    SetEntityDrawOutline(lastOutlineEntity, false)
                    lastOutlineEntity = 0
                end
                creationHelper = false
                Notification:Error('Door Capture Cancelled')
                TriggerEvent('Admin:Client:Menu:Open')
            end

            Wait(0)
        end

        if lastOutlineEntity ~= 0 then
            SetEntityDrawOutline(lastOutlineEntity, false)
            lastOutlineEntity = 0
        end
    end)
end)

local elevatorZoneHelper = false

RegisterNetEvent('Doors:Client:ElevatorZoneHelper', function()
    if elevatorZoneHelper then
        elevatorZoneHelper = false
        return
    end

    elevatorZoneHelper = true

    CreateThread(function()
        while elevatorZoneHelper do
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            local camCoords, dir = GetCameraRay()
            local hit, _, hitCoords = RaycastFromCamera(camCoords, dir, 25.0)

            if hit then
                DrawMarker(28, hitCoords.x, hitCoords.y, hitCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 32, 134, 146, 150, false, false, 0, true, false, false, false)

                DrawInstructionUI("~b~E~s~ Capture Zone Center  |  ~r~Right Click~s~ Cancel")

                if IsDisabledControlJustPressed(0, 38) then
                    local playerHeading = GetEntityHeading(PlayerPedId())
                    local data = {
                        center = { x = hitCoords.x, y = hitCoords.y, z = hitCoords.z },
                        heading = playerHeading,
                        length = 1.5,
                        width = 1.5,
                        minZ = hitCoords.z - 1.0,
                        maxZ = hitCoords.z + 2.0,
                    }

                    elevatorZoneHelper = false
                    TriggerServerEvent('Doors:Server:CapturedElevatorZone', data)
                    Notification:Success('Elevator Zone Captured')
                end
            else
                DrawInstructionUI("~b~Aim~s~ at elevator area  |  ~r~Right Click~s~ Cancel")
            end

            if IsDisabledControlJustPressed(0, 25) then
                elevatorZoneHelper = false
                Notification:Error('Zone Capture Cancelled')
                TriggerEvent('Admin:Client:Menu:Open')
            end

            Wait(0)
        end
    end)
end)

local elevatorPositionHelper = false

RegisterNetEvent('Doors:Client:ElevatorPositionHelper', function()
    if elevatorPositionHelper then
        elevatorPositionHelper = false
        return
    end

    elevatorPositionHelper = true

    CreateThread(function()
        while elevatorPositionHelper do
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 38, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local pedHeading = GetEntityHeading(ped)

            DrawMarker(28, pedCoords.x, pedCoords.y, pedCoords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.2, 32, 134, 146, 150, false, false, 0, true, false, false, false)

            DrawInstructionUI("~b~E~s~ Capture Position  |  ~r~Right Click~s~ Cancel")

            if IsDisabledControlJustPressed(0, 38) then
                local data = {
                    x = pedCoords.x,
                    y = pedCoords.y,
                    z = pedCoords.z,
                    w = pedHeading,
                }

                elevatorPositionHelper = false
                TriggerServerEvent('Doors:Server:CapturedElevatorPosition', data)
                Notification:Success('Elevator Position Captured')
            end

            if IsDisabledControlJustPressed(0, 25) then
                elevatorPositionHelper = false
                Notification:Error('Position Capture Cancelled')
                TriggerEvent('Admin:Client:Menu:Open')
            end

            Wait(0)
        end
    end)
end)
