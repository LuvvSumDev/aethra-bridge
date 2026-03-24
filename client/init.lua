Bridge.Client = {}

local GetActivePlayers = GetActivePlayers
local GetPlayerPed = GetPlayerPed
local GetPlayerServerId = GetPlayerServerId
local GetEntityCoords = GetEntityCoords
local IsEntityDead = IsEntityDead

function Bridge.Client.GetPlayerData()
    return Bridge.Client._getPlayerData and Bridge.Client._getPlayerData() or nil
end

function Bridge.Client.GetIdentifier()
    local data = Bridge.Client.GetPlayerData()
    return data and data.identifier
end

function Bridge.Client.GetJob()
    return Bridge.Client._getJob and Bridge.Client._getJob() or nil
end

function Bridge.Client.GetGang()
    return Bridge.Client._getGang and Bridge.Client._getGang() or nil
end

function Bridge.Client.HasJob(name, minGrade)
    local job = Bridge.Client.GetJob()
    if not job then return false end

    minGrade = minGrade or 0

    if type(name) == 'table' then
        for i = 1, #name do
            if job.name == name[i] and job.grade >= minGrade then return true end
        end
        return false
    end

    return job.name == name and job.grade >= minGrade
end

function Bridge.Client.HasGang(name, minGrade)
    local gang = Bridge.Client.GetGang()
    if not gang then return false end

    minGrade = minGrade or 0

    if type(name) == 'table' then
        for i = 1, #name do
            if gang.name == name[i] and gang.grade >= minGrade then return true end
        end
        return false
    end

    return gang.name == name and gang.grade >= minGrade
end

function Bridge.Client.HasGroup(name, minGrade)
    return Bridge.Client.HasJob(name, minGrade) or Bridge.Client.HasGang(name, minGrade)
end

function Bridge.Client.GetMoney(account)
    return Bridge.Client._getMoney and Bridge.Client._getMoney(account or 'cash') or 0
end

function Bridge.Client.GetName()
    return Bridge.Client._getName and Bridge.Client._getName() or 'Unknown'
end

function Bridge.Client.IsDead()
    if Bridge.Client._isDead then return Bridge.Client._isDead() end
    return IsEntityDead(cache.ped)
end

function Bridge.Client.GetClosestPlayer(range)
    range = range or 5.0
    local coords = GetEntityCoords(cache.ped)
    local closest, closestDist

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= cache.playerId then
            local dist = #(coords - GetEntityCoords(GetPlayerPed(player)))
            if dist < range and (not closestDist or dist < closestDist) then
                closest = GetPlayerServerId(player)
                closestDist = dist
            end
        end
    end

    return closest, closestDist
end

function Bridge.Client.GetPlayersInRange(range)
    range = range or 10.0
    local coords = GetEntityCoords(cache.ped)
    local result = {}

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= cache.playerId then
            local dist = #(coords - GetEntityCoords(GetPlayerPed(player)))
            if dist <= range then
                result[#result + 1] = { id = GetPlayerServerId(player), distance = dist }
            end
        end
    end

    return result
end

function Bridge.Client.GetCurrentVehicle()
    return cache.vehicle or false
end

function Bridge.Client.GetVehicleSeat()
    return cache.seat or false
end

function Bridge.Client.IsInVehicle()
    return cache.vehicle and true or false
end

lib.callback.register('aethra-bridge:getPlayerData', function()
    return Bridge.Client.GetPlayerData()
end)

lib.callback.register('aethra-bridge:getJob', function()
    return Bridge.Client.GetJob()
end)

lib.callback.register('aethra-bridge:getGang', function()
    return Bridge.Client.GetGang()
end)

exports('GetBridge', function() return Bridge end)
