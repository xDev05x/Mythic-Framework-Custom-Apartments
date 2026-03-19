DOORS_CACHE = {}
DOORS_IDS = {}
ELEVATOR_CACHE = {}

DYNAMIC_DOOR_INDICES = {}
DYNAMIC_ELEVATOR_INDICES = {}

AddEventHandler('Doors:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Chat = exports['mythic-base']:FetchComponent('Chat')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Inventory = exports['mythic-base']:FetchComponent('Inventory')
    Execute = exports['mythic-base']:FetchComponent('Execute')
    Fetch = exports['mythic-base']:FetchComponent('Fetch')
    Doors = exports['mythic-base']:FetchComponent('Doors')
    Pwnzor = exports['mythic-base']:FetchComponent('Pwnzor')
    Properties = exports['mythic-base']:FetchComponent('Properties')
    Database = exports['mythic-base']:FetchComponent('Database')
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Doors', {
        'Callbacks',
        'Logger',
        'Utils',
        'Chat',
        'Inventory',
        'Jobs',
        'Execute',
        'Fetch',
        'Doors',
        'Pwnzor',
        'Properties',
        'Database',
    }, function(error)
        if #error > 0 then return end
        RetrieveComponents()
        RegisterCallbacks()
        LoadDynamicDoors()
        LoadDynamicElevators()
        RegisterItems()
        RegisterChatCommands()

        RunStartup()
    end)
end)

local _startup = false
function RunStartup()
    if _startup then return; end
    _startup = true

    for k, v in ipairs(_doorConfig) do
        if v.model and v.coords then
            if v.id and not DOORS_IDS[v.id] then
                DOORS_IDS[v.id] = k
            end

            DOORS_CACHE[k] = {
                locked = v.locked,
            }
        else
            Logger:Warn('Doors', 'Door: '.. (v.id and v.id or k), ' Missing Required Data')
        end
    end

    for k, v in ipairs(_elevatorConfig) do
        ELEVATOR_CACHE[k] = {
            floors = {}
        }

        for k2,v2 in pairs(v.floors) do
            ELEVATOR_CACHE[k].floors[k2] = {
                locked = v2.defaultLocked or false
            }
        end
    end

    Logger:Trace('Doors', 'Loaded ^2'.. #_doorConfig .. '^7 Doors & ^2'.. #_elevatorConfig .. '^7 Elevators')
end

local function SerializeElevatorFloorsForDB(floors)
    local dbFloors = {}
    for floorKey, floorData in pairs(floors) do
        local key = tostring(floorKey)
        dbFloors[key] = {
            name = floorData.name,
            coords = {
                x = floorData.coords.x + 0.0,
                y = floorData.coords.y + 0.0,
                z = floorData.coords.z + 0.0,
                w = floorData.coords.w + 0.0,
            },
            defaultLocked = floorData.defaultLocked or false,
            restricted = floorData.restricted or nil,
            bypassLock = floorData.bypassLock or nil,
        }
        if floorData.zone then
            dbFloors[key].zone = {
                center = {
                    x = floorData.zone.center.x + 0.0,
                    y = floorData.zone.center.y + 0.0,
                    z = floorData.zone.center.z + 0.0,
                },
                length = floorData.zone.length + 0.0,
                width = floorData.zone.width + 0.0,
                heading = floorData.zone.heading + 0.0,
                minZ = floorData.zone.minZ + 0.0,
                maxZ = floorData.zone.maxZ + 0.0,
            }
        end
    end
    return dbFloors
end

function RegisterChatCommands()
    Chat:RegisterAdminCommand('doorhelp', function(source, args, rawCommand)
        TriggerClientEvent('Doors:Client:DoorHelper', source)
    end, {
        help = '[Developer] Toggle Door Creation Helper'
    })

    Chat:RegisterAdminCommand('migratedoors', function(source, args, rawCommand)
        local player = Fetch:Source(source)
        if not player or not player.Permissions:IsAdmin() then
            return
        end

        Logger:Info('Doors', string.format('%s [%s] Started Door Migration To Database', player:GetData('Name'), player:GetData('AccountID')), { console = true })
        TriggerClientEvent('chat:addMessage', source, { args = { '^3[Doors]', 'Starting migration... clearing old DB doors first.' } })

        local clearP = promise.new()
        Database.Game:delete({
            collection = 'doors_custom',
            query = {},
        }, function(success)
            clearP:resolve(success)
        end)
        Citizen.Await(clearP)

        local count = 0
        local skipped = 0
        local failed = 0

        for k, v in ipairs(_doorConfig) do
            if v.removed then
                skipped = skipped + 1
            elseif v.model and v.coords then
                local doc = {
                    id = v.id or false,
                    model = v.model,
                    coords = { x = v.coords.x + 0.0, y = v.coords.y + 0.0, z = v.coords.z + 0.0 },
                    locked = v.locked or false,
                    maxDist = v.maxDist and (v.maxDist + 0.0) or nil,
                    canLockpick = v.canLockpick or false,
                    holdOpen = v.holdOpen or false,
                    autoRate = v.autoRate and (v.autoRate + 0.0) or nil,
                    autoDist = v.autoDist and (v.autoDist + 0.0) or nil,
                    autoLock = v.autoLock and (v.autoLock + 0.0) or nil,
                    double = v.double or nil,
                    special = v.special or nil,
                    restricted = v.restricted or nil,
                }

                local p = promise.new()
                Database.Game:insertOne({
                    collection = 'doors_custom',
                    document = doc,
                }, function(success)
                    p:resolve(success)
                end)

                if Citizen.Await(p) then
                    count = count + 1
                else
                    failed = failed + 1
                end
            else
                skipped = skipped + 1
            end
        end

        local msg = string.format('Door Migration Complete: %d migrated, %d skipped, %d failed (out of %d total). Restart resource to use DB doors.', count, skipped, failed, #_doorConfig)
        Logger:Info('Doors', msg, { console = true })
        TriggerClientEvent('chat:addMessage', source, { args = { '^2[Doors]', msg } })
    end, {
        help = '[Admin] Migrate all doors to database (safe to re-run, clears DB first)'
    })

    Chat:RegisterAdminCommand('migrateelevators', function(source, args, rawCommand)
        local player = Fetch:Source(source)
        if not player or not player.Permissions:IsAdmin() then
            return
        end

        Logger:Info('Doors', string.format('%s [%s] Started Elevator Migration To Database', player:GetData('Name'), player:GetData('AccountID')), { console = true })
        TriggerClientEvent('chat:addMessage', source, { args = { '^3[Elevators]', 'Starting migration... clearing old DB elevators first.' } })

        local clearP = promise.new()
        Database.Game:delete({
            collection = 'elevators_custom',
            query = {},
        }, function(success)
            clearP:resolve(success)
        end)
        Citizen.Await(clearP)

        local count = 0
        local skipped = 0
        local failed = 0

        for k, v in ipairs(_elevatorConfig) do
            if v.removed then
                skipped = skipped + 1
            elseif v.floors then
                local dbFloors = SerializeElevatorFloorsForDB(v.floors)
                local doc = {
                    id = v.id or false,
                    name = v.name or ('Elevator ' .. k),
                    canLock = v.canLock or nil,
                    floors = dbFloors,
                }

                local p = promise.new()
                Database.Game:insertOne({
                    collection = 'elevators_custom',
                    document = doc,
                }, function(success)
                    p:resolve(success)
                end)

                if Citizen.Await(p) then
                    count = count + 1
                else
                    failed = failed + 1
                end
            else
                skipped = skipped + 1
            end
        end

        local msg = string.format('Elevator Migration Complete: %d migrated, %d skipped, %d failed (out of %d total). Restart resource to use DB elevators.', count, skipped, failed, #_elevatorConfig)
        Logger:Info('Doors', msg, { console = true })
        TriggerClientEvent('chat:addMessage', source, { args = { '^2[Elevators]', msg } })
    end, {
        help = '[Admin] Migrate all elevators to database (safe to re-run, clears DB first)'
    })
end

_activeLockpicks = {}

function RegisterItems()
    Inventory.Items:RegisterUse('lockpick', 'Doors', function(source, item)
        _activeLockpicks[source] = { time = os.time(), item = item }
        TriggerClientEvent('Doors:Client:AttemptLockpick', source, item)
    end)
end

RegisterNetEvent('Doors:Server:LockpickFailed', function()
    _activeLockpicks[source] = nil
end)

AddEventHandler('playerDropped', function()
    _activeLockpicks[source] = nil
end)

function RegisterCallbacks()
    Callbacks:RegisterServerCallback('Doors:Fetch', function(source, data, cb)
        while not _startup do
            Wait(100)
        end
        cb(DOORS_CACHE, ELEVATOR_CACHE, _doorConfig, _elevatorConfig)
    end)

    Callbacks:RegisterServerCallback('Doors:ToggleLocks', function(source, doorId, cb)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local targetDoor = _doorConfig[doorId]
        if targetDoor and CheckPlayerAuth(source, targetDoor.restricted) then
            local newState = Doors:SetLock(doorId)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Doors:Lockpick', function(source, doorId, cb)
        local session = _activeLockpicks[source]
        if not session then
            cb(false)
            return
        end

        if os.time() - session.time < 3 then
            cb(false)
            return
        end

        _activeLockpicks[source] = nil

        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local targetDoor = _doorConfig[doorId]
        if targetDoor and targetDoor.canLockpick then
            local newState = Doors:SetLock(doorId, false)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback('Doors:Elevators:ToggleLocks', function(source, data, cb)
        local targetElevator = _elevatorConfig[data.elevator]
        if targetElevator and targetElevator.canLock and CheckPlayerAuth(source, targetElevator.canLock) then
            local newState = Doors:SetElevatorLock(data.elevator, data.floor)
            if newState == nil then
                cb(false, false)
            else
                cb(true, newState)
            end
        else
            cb(false)
        end
    end)

    Callbacks:RegisterServerCallback("Doors:Elevator:Validate", function(source, data, cb)
        Pwnzor.Players:TempPosIgnore(source)
        cb()
    end)
end

local function _ResolveDoorId(doorId)
    if type(doorId) == 'string' then
        return DOORS_IDS[doorId]
    end
    return doorId
end

local function _NormalizeSID(sid)
    local n = tonumber(sid)
    return n or sid
end

local function _SyncRestriction(doorId)
    if type(doorId) == "string" then
        doorId = DOORS_IDS and DOORS_IDS[doorId] or nil
    end

    if not doorId then return end

    TriggerClientEvent(
        'Doors:Client:UpdateRestriction',
        -1,
        doorId,
        _doorConfig[doorId] and _doorConfig[doorId].restricted or nil
    )
end

DOORS = {
    SetLock = function(self, doorId, newState, doneDouble)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local doorData = _doorConfig[doorId]

        if doorData then
            local isLocked = DOORS_CACHE[doorId].locked
            if newState == nil then
                newState = not isLocked
            end

            if newState ~= isLocked then
                DOORS_CACHE[doorId].locked = newState

                if DOORS_CACHE[doorId].forcedOpen then
                    DOORS_CACHE[doorId].forcedOpen = false
                end

                TriggerClientEvent('Doors:Client:UpdateState', -1, doorId, newState)

                if doorData.double and not doneDouble then
                    Doors:SetLock(doorData.double, newState, true)
                end

                if not newState and doorData.autoLock and doorData.autoLock > 0 then
                    local lockDoorId = doorId
                    SetTimeout(doorData.autoLock * 1000, function()
                        if DOORS_CACHE[lockDoorId] and not DOORS_CACHE[lockDoorId].locked then
                            Doors:SetLock(lockDoorId, true)
                        end
                    end)
                end
            end
            return newState
        end
        return nil
    end,
    IsLocked = function(self, doorId)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        local doorData = _doorConfig[doorId]
        if doorData then
            return DOORS_CACHE[doorId].locked
        end
        return false
    end,
    SetForcedOpen = function(self, doorId)
        if type(doorId) == 'string' then
            doorId = DOORS_IDS[doorId]
        end

        if DOORS_CACHE[doorId] then
            DOORS_CACHE[doorId].forcedOpen = true

            TriggerClientEvent('Doors:Client:SetForcedOpen', -1, doorId)
        end
    end,
    SetElevatorLock = function(self, elevatorId, floorId, newState)
        local data = _elevatorConfig[elevatorId]

        if data and ELEVATOR_CACHE[elevatorId] and ELEVATOR_CACHE[elevatorId].floors and ELEVATOR_CACHE[elevatorId].floors[floorId] then
            local isLocked = ELEVATOR_CACHE[elevatorId].floors[floorId].locked
            if newState == nil then
                newState = not isLocked
            end

            if data and newState ~= isLocked then
                ELEVATOR_CACHE[elevatorId].floors[floorId].locked = newState
                TriggerClientEvent('Doors:Client:UpdateElevatorState', -1, elevatorId, floorId, newState)
            end
            return newState
        end
        return nil
    end,
    Exists = function(self, doorId)
        doorId = _ResolveDoorId(doorId)
        return doorId ~= nil and _doorConfig[doorId] ~= nil
    end,
    ResolveId = function(self, doorId)
        return _ResolveDoorId(doorId)
    end,
    SetRestricted = function(self, doorId, restricted)
        doorId = _ResolveDoorId(doorId)
        if not doorId or not _doorConfig[doorId] then
            return false
        end
        if restricted == nil then
            _doorConfig[doorId].restricted = nil
        elseif type(restricted) == 'table' then
            _doorConfig[doorId].restricted = restricted
        else
            return false
        end
        _SyncRestriction(doorId)
        return true
    end,
    AddCharacterAccess = function(self, doorId, sid)
        doorId = _ResolveDoorId(doorId)
        if not doorId or not _doorConfig[doorId] then
            return false
        end

        local normSid = _NormalizeSID(sid)
        if _doorConfig[doorId].restricted == nil then
            _doorConfig[doorId].restricted = {}
        elseif type(_doorConfig[doorId].restricted) ~= 'table' then
            _doorConfig[doorId].restricted = {}
        end

        for _, v in ipairs(_doorConfig[doorId].restricted) do
            if v.type == 'character' and v.SID == normSid then
                _SyncRestriction(doorId)
                return true
            end
        end

        table.insert(_doorConfig[doorId].restricted, {
            type = 'character',
            SID = normSid,
        })

        _SyncRestriction(doorId)
        return true
    end,
    RemoveCharacterAccess = function(self, doorId, sid)
        doorId = _ResolveDoorId(doorId)
        if not doorId or not _doorConfig[doorId] then
            return false
        end
        if type(_doorConfig[doorId].restricted) ~= 'table' then
            return true
        end

        local normSid = _NormalizeSID(sid)
        local newRestricted = {}
        for _, v in ipairs(_doorConfig[doorId].restricted) do
            if not (v.type == 'character' and v.SID == normSid) then
                table.insert(newRestricted, v)
            end
        end

        _doorConfig[doorId].restricted = (#newRestricted > 0) and newRestricted or {}
        _SyncRestriction(doorId)
        return true
    end
}

AddEventHandler('Proxy:Shared:RegisterReady', function()
    exports['mythic-base']:RegisterComponent('Doors', DOORS)
end)

function CheckPlayerAuth(source, doorPermissionData)
    if type(doorPermissionData) ~= 'table' then
        return true
    end

    local player = Fetch:Source(source)
    if player then
        local char = player:GetData('Character')
        if char then
            local stateId = char:GetData('SID')

            if Jobs.Permissions:HasJob(source, 'dgang', false, false, 99, true) then
				return true
			end

            for k, v in ipairs(doorPermissionData) do
				if v.type == 'character' then
					if stateId == v.SID then
						return true
					end
				elseif v.type == 'job' then
					if v.job then
						local wp = (v.workplace and v.workplace ~= '' and v.workplace ~= 'false') and v.workplace or false
						local gr = (v.grade and v.grade ~= '' and v.grade ~= 'false') and v.grade or false
						local gl = (v.gradeLevel and tonumber(v.gradeLevel) and tonumber(v.gradeLevel) > 0) and tonumber(v.gradeLevel) or false
						if Jobs.Permissions:HasJob(source, v.job, wp, gr, gl, v.reqDuty, v.jobPermission) then
							return true
						end
					elseif v.jobPermission then
						if Jobs.Permissions:HasPermission(source, v.jobPermission) then
							return true
						end
					end
                elseif v.type == 'propertyData' then
					if Properties.Keys:HasAccessWithData(source, v.key, v.value) then
						return true
					end
				end
			end
        end
    end
    return false
end

RegisterNetEvent('Doors:Server:PrintDoor', function(data)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end

    local output = GetDoorOutput(data)
    local file = io.open('created_doors_data.txt', "a")
    if file then
        file:write(output)
        file:close()
    end
end)

RegisterNetEvent('Doors:Server:CapturedDoor', function(data)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end
    TriggerClientEvent('Admin:Client:DoorCaptured', src, data)
end)

RegisterNetEvent('Doors:Server:CapturedElevatorZone', function(data)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end
    TriggerClientEvent('Admin:Client:ElevatorZoneCaptured', src, data)
end)

RegisterNetEvent('Doors:Server:CapturedElevatorPosition', function(data)
    local src = source
    local player = Fetch:Source(src)
    if not player.Permissions:IsAdmin() then return end
    TriggerClientEvent('Admin:Client:ElevatorPositionCaptured', src, data)
end)

function GetDoorOutput(data)
    local printout = "{\n\tid = \"" .. data.name .. "\",\n\tmodel = " .. data.model .. ","

    printout = printout .. "\n\tcoords = vector3(" .. tostring(Utils:Round(data.coords.x, 2)) .. ", " .. tostring(Utils:Round(data.coords.y, 2))  .. ", " .. tostring(Utils:Round(data.coords.z, 2)) .."),"
    printout = printout .. "\n}\n\n"
    return printout
end

function LoadDynamicDoors()
    local p = promise.new()
    Database.Game:find({
        collection = 'doors_custom',
        query = {},
    }, function(success, results)
        if success and results and #results > 0 then
            local staticCount = #_doorConfig
            _doorConfig = {}
            DYNAMIC_DOOR_INDICES = {}

            for _, doc in ipairs(results) do
                local door = {
                    id = doc.id,
                    model = doc.model,
                    coords = vector3(doc.coords.x + 0.0, doc.coords.y + 0.0, doc.coords.z + 0.0),
                    locked = doc.locked or false,
                    isDynamic = true,
                    dbId = tostring(doc._id),
                    maxDist = doc.maxDist and (doc.maxDist + 0.0) or nil,
                    canLockpick = doc.canLockpick or false,
                    holdOpen = doc.holdOpen or false,
                    autoRate = doc.autoRate and (doc.autoRate + 0.0) or nil,
                    autoDist = doc.autoDist and (doc.autoDist + 0.0) or nil,
                    autoLock = doc.autoLock and (doc.autoLock + 0.0) or nil,
                    double = doc.double or nil,
                    special = doc.special or nil,
                    restricted = (doc.restricted and #doc.restricted > 0) and doc.restricted or nil,
                }
                table.insert(_doorConfig, door)
            end

            for i = 1, #_doorConfig do
                DYNAMIC_DOOR_INDICES[i] = true
            end

            p:resolve(#_doorConfig)

            if staticCount > 0 then
                Logger:Trace('Doors', 'Database has doors - replaced ^3' .. staticCount .. '^7 static configs with ^2' .. #_doorConfig .. '^7 DB doors')
            end
        else
            p:resolve(0)
        end
    end)
    local count = Citizen.Await(p)
    if count > 0 then
        Logger:Trace('Doors', 'Loaded ^2' .. count .. '^7 Doors From Database')
    else
        Logger:Trace('Doors', 'No DB doors found - using static config files. Run /migratedoors to migrate.')
    end
end

exports('GetAllDoors', function()
    local result = {}
    for k, v in ipairs(_doorConfig) do
        local door = {
            index = k,
            id = v.id or false,
            model = v.model,
            coords = { x = v.coords.x, y = v.coords.y, z = v.coords.z },
            locked = DOORS_CACHE[k] and DOORS_CACHE[k].locked or v.locked,
            isDynamic = DYNAMIC_DOOR_INDICES[k] or false,
            maxDist = v.maxDist or 2.0,
            canLockpick = v.canLockpick or false,
            holdOpen = v.holdOpen or false,
            autoRate = v.autoRate or 0,
            autoDist = v.autoDist or false,
            autoLock = v.autoLock or 0,
            double = v.double or false,
            special = v.special or false,
            restricted = v.restricted or {},
            dbId = v.dbId or false,
        }
        table.insert(result, door)
    end
    return result
end)

exports('AddDynamicDoor', function(doorData)
    local p = promise.new()
    Database.Game:insertOne({
        collection = 'doors_custom',
        document = {
            id = doorData.id,
            model = doorData.model,
            coords = { x = doorData.coords.x, y = doorData.coords.y, z = doorData.coords.z },
            locked = doorData.locked or false,
            maxDist = doorData.maxDist,
            canLockpick = doorData.canLockpick,
            holdOpen = doorData.holdOpen,
            autoRate = doorData.autoRate,
            autoDist = doorData.autoDist,
            autoLock = doorData.autoLock,
            double = doorData.double,
            special = doorData.special,
            restricted = doorData.restricted or {},
        }
    }, function(success, insertedCount, insertedIds)
        if success and insertedIds then
            local dbId = nil
            for _, v in pairs(insertedIds) do
                dbId = tostring(v)
                break
            end

            local door = {
                id = doorData.id,
                model = doorData.model,
                coords = vector3(doorData.coords.x + 0.0, doorData.coords.y + 0.0, doorData.coords.z + 0.0),
                locked = doorData.locked or false,
                isDynamic = true,
                dbId = dbId,
                maxDist = doorData.maxDist and (doorData.maxDist + 0.0) or nil,
                canLockpick = doorData.canLockpick or false,
                holdOpen = doorData.holdOpen or false,
                autoRate = doorData.autoRate and (doorData.autoRate + 0.0) or nil,
                autoDist = doorData.autoDist and (doorData.autoDist + 0.0) or nil,
                autoLock = doorData.autoLock and (doorData.autoLock + 0.0) or nil,
                double = doorData.double or nil,
                special = doorData.special or nil,
                restricted = (doorData.restricted and #doorData.restricted > 0) and doorData.restricted or nil,
            }

            table.insert(_doorConfig, door)
            local newIndex = #_doorConfig
            DYNAMIC_DOOR_INDICES[newIndex] = true

            if door.id and not DOORS_IDS[door.id] then
                DOORS_IDS[door.id] = newIndex
            end

            DOORS_CACHE[newIndex] = { locked = door.locked }
            TriggerClientEvent('Doors:Client:AddDynamicDoor', -1, newIndex, door)
            p:resolve({ success = true, index = newIndex })
        else
            p:resolve({ success = false })
        end
    end)
    return Citizen.Await(p)
end)

exports('RemoveDynamicDoor', function(doorIndex)
    if not DYNAMIC_DOOR_INDICES[doorIndex] then return false end
    local door = _doorConfig[doorIndex]
    if not door then return false end

    if door.id then
        Database.Game:deleteOne({
            collection = 'doors_custom',
            query = { id = door.id },
        })
    end

    if door.id and DOORS_IDS[door.id] then
        DOORS_IDS[door.id] = nil
    end
    DOORS_CACHE[doorIndex] = nil
    DYNAMIC_DOOR_INDICES[doorIndex] = nil
    _doorConfig[doorIndex] = { model = 0, coords = vector3(0, 0, 0), removed = true }

    TriggerClientEvent('Doors:Client:RemoveDynamicDoor', -1, doorIndex)
    return true
end)

exports('UpdateDynamicDoor', function(doorIndex, doorData)
    if not DYNAMIC_DOOR_INDICES[doorIndex] then return false end
    local door = _doorConfig[doorIndex]
    if not door or not door.id then return false end

    Database.Game:updateOne({
        collection = 'doors_custom',
        query = { id = door.id },
        update = {
            ['$set'] = {
                id = doorData.id,
                model = doorData.model,
                coords = { x = doorData.coords.x, y = doorData.coords.y, z = doorData.coords.z },
                locked = doorData.locked or false,
                maxDist = doorData.maxDist,
                canLockpick = doorData.canLockpick,
                holdOpen = doorData.holdOpen,
                autoRate = doorData.autoRate,
                autoDist = doorData.autoDist,
                autoLock = doorData.autoLock,
                double = doorData.double,
                special = doorData.special,
                restricted = doorData.restricted or {},
            }
        }
    })

    if door.id and DOORS_IDS[door.id] then
        DOORS_IDS[door.id] = nil
    end

    door.id = doorData.id
    door.model = doorData.model
    door.coords = vector3(doorData.coords.x + 0.0, doorData.coords.y + 0.0, doorData.coords.z + 0.0)
    door.locked = doorData.locked or false
    door.maxDist = doorData.maxDist and (doorData.maxDist + 0.0) or 2.0
    door.canLockpick = doorData.canLockpick or false
    door.holdOpen = doorData.holdOpen or false
    door.autoRate = doorData.autoRate and (doorData.autoRate + 0.0) or 0
    door.autoDist = doorData.autoDist and (doorData.autoDist + 0.0) or false
    door.autoLock = doorData.autoLock and (doorData.autoLock + 0.0) or 0
    door.double = doorData.double or false
    door.special = doorData.special or false
    door.restricted = doorData.restricted or {}

    if door.id and not DOORS_IDS[door.id] then
        DOORS_IDS[door.id] = doorIndex
    end

    DOORS_CACHE[doorIndex] = { locked = door.locked }
    TriggerClientEvent('Doors:Client:UpdateDynamicDoor', -1, doorIndex, door)
    return true
end)

function LoadDynamicElevators()
    local p = promise.new()
    Database.Game:find({
        collection = 'elevators_custom',
        query = {},
    }, function(success, results)
        if success and results and #results > 0 then
            local staticCount = #_elevatorConfig
            _elevatorConfig = {}
            DYNAMIC_ELEVATOR_INDICES = {}

            for _, doc in ipairs(results) do
                local elevator = {
                    id = doc.id or false,
                    name = doc.name or 'Unnamed Elevator',
                    canLock = doc.canLock or nil,
                    isDynamic = true,
                    dbId = tostring(doc._id),
                    floors = {},
                }

                if doc.floors then
                    for floorKey, floorDoc in pairs(doc.floors) do
                        local floorNum = tonumber(floorKey)
                        if floorNum then
                            local floor = {
                                name = floorDoc.name or ('Floor ' .. floorNum),
                                coords = vector4(
                                    (floorDoc.coords and floorDoc.coords.x or 0) + 0.0,
                                    (floorDoc.coords and floorDoc.coords.y or 0) + 0.0,
                                    (floorDoc.coords and floorDoc.coords.z or 0) + 0.0,
                                    (floorDoc.coords and floorDoc.coords.w or 0) + 0.0
                                ),
                                defaultLocked = floorDoc.defaultLocked or false,
                                restricted = floorDoc.restricted or nil,
                                bypassLock = floorDoc.bypassLock or nil,
                            }

                            if floorDoc.zone then
                                floor.zone = {
                                    center = vector3(
                                        (floorDoc.zone.center and floorDoc.zone.center.x or 0) + 0.0,
                                        (floorDoc.zone.center and floorDoc.zone.center.y or 0) + 0.0,
                                        (floorDoc.zone.center and floorDoc.zone.center.z or 0) + 0.0
                                    ),
                                    length = (floorDoc.zone.length or 1.5) + 0.0,
                                    width = (floorDoc.zone.width or 1.5) + 0.0,
                                    heading = (floorDoc.zone.heading or 0) + 0.0,
                                    minZ = (floorDoc.zone.minZ or 0) + 0.0,
                                    maxZ = (floorDoc.zone.maxZ or 0) + 0.0,
                                }
                            end

                            elevator.floors[floorNum] = floor
                        end
                    end
                end

                table.insert(_elevatorConfig, elevator)
            end

            for i = 1, #_elevatorConfig do
                DYNAMIC_ELEVATOR_INDICES[i] = true
            end

            p:resolve(#_elevatorConfig)

            if staticCount > 0 then
                Logger:Trace('Doors', 'Database has elevators - replaced ^3' .. staticCount .. '^7 static configs with ^2' .. #_elevatorConfig .. '^7 DB elevators')
            end
        else
            p:resolve(0)
        end
    end)
    local count = Citizen.Await(p)
    if count > 0 then
        Logger:Trace('Doors', 'Loaded ^2' .. count .. '^7 Elevators From Database')
    end
end

local function ParseElevatorDataFromAdmin(data)
    local elevator = {
        id = data.id or false,
        name = data.name or 'Unnamed Elevator',
        canLock = (data.canLock and #data.canLock > 0) and data.canLock or nil,
        isDynamic = true,
        floors = {},
    }

    if data.floors then
        for floorKey, floorData in pairs(data.floors) do
            local floorNum = tonumber(floorKey)
            if floorNum and floorData.coords then
                local floor = {
                    name = floorData.name or ('Floor ' .. floorNum),
                    coords = vector4(
                        (floorData.coords.x or 0) + 0.0,
                        (floorData.coords.y or 0) + 0.0,
                        (floorData.coords.z or 0) + 0.0,
                        (floorData.coords.w or 0) + 0.0
                    ),
                    defaultLocked = floorData.defaultLocked or false,
                    restricted = (floorData.restricted and #floorData.restricted > 0) and floorData.restricted or nil,
                    bypassLock = (floorData.bypassLock and #floorData.bypassLock > 0) and floorData.bypassLock or nil,
                }

                if floorData.zone and floorData.zone.center then
                    floor.zone = {
                        center = vector3(
                            (floorData.zone.center.x or 0) + 0.0,
                            (floorData.zone.center.y or 0) + 0.0,
                            (floorData.zone.center.z or 0) + 0.0
                        ),
                        length = (floorData.zone.length or 1.5) + 0.0,
                        width = (floorData.zone.width or 1.5) + 0.0,
                        heading = (floorData.zone.heading or 0) + 0.0,
                        minZ = (floorData.zone.minZ or 0) + 0.0,
                        maxZ = (floorData.zone.maxZ or 0) + 0.0,
                    }
                end

                elevator.floors[floorNum] = floor
            end
        end
    end

    return elevator
end

exports('GetAllElevators', function()
    local result = {}
    for k, v in ipairs(_elevatorConfig) do
        local elevator = {
            index = k,
            id = v.id or false,
            name = v.name or 'Unnamed',
            canLock = v.canLock or {},
            isDynamic = DYNAMIC_ELEVATOR_INDICES[k] or false,
            dbId = v.dbId or false,
            floors = {},
        }

        for floorKey, floorData in pairs(v.floors) do
            elevator.floors[tostring(floorKey)] = {
                name = floorData.name,
                coords = {
                    x = floorData.coords.x,
                    y = floorData.coords.y,
                    z = floorData.coords.z,
                    w = floorData.coords.w,
                },
                zone = floorData.zone and {
                    center = {
                        x = floorData.zone.center.x,
                        y = floorData.zone.center.y,
                        z = floorData.zone.center.z,
                    },
                    length = floorData.zone.length,
                    width = floorData.zone.width,
                    heading = floorData.zone.heading,
                    minZ = floorData.zone.minZ,
                    maxZ = floorData.zone.maxZ,
                } or nil,
                defaultLocked = floorData.defaultLocked or false,
                locked = ELEVATOR_CACHE[k] and ELEVATOR_CACHE[k].floors[floorKey] and ELEVATOR_CACHE[k].floors[floorKey].locked or false,
                restricted = floorData.restricted or {},
                bypassLock = floorData.bypassLock or {},
            }
        end

        table.insert(result, elevator)
    end
    return result
end)

exports('AddDynamicElevator', function(data)
    local elevator = ParseElevatorDataFromAdmin(data)

    local dbFloors = SerializeElevatorFloorsForDB(elevator.floors)

    local p = promise.new()
    Database.Game:insertOne({
        collection = 'elevators_custom',
        document = {
            id = elevator.id,
            name = elevator.name,
            canLock = elevator.canLock,
            floors = dbFloors,
        }
    }, function(success, insertedCount, insertedIds)
        if success and insertedIds then
            local dbId = nil
            for _, v in pairs(insertedIds) do
                dbId = tostring(v)
                break
            end

            elevator.dbId = dbId
            table.insert(_elevatorConfig, elevator)
            local newIndex = #_elevatorConfig
            DYNAMIC_ELEVATOR_INDICES[newIndex] = true

            ELEVATOR_CACHE[newIndex] = { floors = {} }
            for floorKey, floorData in pairs(elevator.floors) do
                ELEVATOR_CACHE[newIndex].floors[floorKey] = {
                    locked = floorData.defaultLocked or false
                }
            end

            TriggerClientEvent('Doors:Client:AddDynamicElevator', -1, newIndex, elevator)
            p:resolve({ success = true, index = newIndex })
        else
            p:resolve({ success = false })
        end
    end)
    return Citizen.Await(p)
end)

exports('UpdateDynamicElevator', function(elevatorIndex, data)
    if not DYNAMIC_ELEVATOR_INDICES[elevatorIndex] then return false end
    local existing = _elevatorConfig[elevatorIndex]
    if not existing then return false end

    local elevator = ParseElevatorDataFromAdmin(data)
    elevator.dbId = existing.dbId

    local dbFloors = SerializeElevatorFloorsForDB(elevator.floors)

    local query = {}
    if existing.dbId then
        query._id = existing.dbId
    elseif existing.id then
        query.id = existing.id
    else
        return false
    end

    Database.Game:updateOne({
        collection = 'elevators_custom',
        query = query,
        update = {
            ['$set'] = {
                id = elevator.id,
                name = elevator.name,
                canLock = elevator.canLock,
                floors = dbFloors,
            }
        }
    })

    _elevatorConfig[elevatorIndex] = elevator

    ELEVATOR_CACHE[elevatorIndex] = { floors = {} }
    for floorKey, floorData in pairs(elevator.floors) do
        ELEVATOR_CACHE[elevatorIndex].floors[floorKey] = {
            locked = floorData.defaultLocked or false
        }
    end

    TriggerClientEvent('Doors:Client:UpdateDynamicElevator', -1, elevatorIndex, elevator)
    return true
end)

exports('RemoveDynamicElevator', function(elevatorIndex)
    if not DYNAMIC_ELEVATOR_INDICES[elevatorIndex] then return false end
    local elevator = _elevatorConfig[elevatorIndex]
    if not elevator then return false end

    local query = {}
    if elevator.dbId then
        query._id = elevator.dbId
    elseif elevator.id then
        query.id = elevator.id
    end

    if next(query) then
        Database.Game:deleteOne({
            collection = 'elevators_custom',
            query = query,
        })
    end

    ELEVATOR_CACHE[elevatorIndex] = nil
    DYNAMIC_ELEVATOR_INDICES[elevatorIndex] = nil
    _elevatorConfig[elevatorIndex] = { name = 'removed', floors = {}, removed = true }

    TriggerClientEvent('Doors:Client:RemoveDynamicElevator', -1, elevatorIndex)
    return true
end)
