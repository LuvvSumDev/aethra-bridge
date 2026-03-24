if Bridge.framework ~= 'ox_core' then return end

local Ox = require '@ox_core.lib.init'

function Bridge.Server._getPlayer(source)
    local player = Ox.GetPlayer(source)
    if not player then return end

    return {
        identifier = tostring(player.stateId or player.charId),
        firstName = player.firstName or '',
        lastName = player.lastName or '',
        dob = player.dob or '',
        gender = player.gender or '',
        phone = player.phoneNumber or '',
        source = source,
        raw = player,
    }
end

function Bridge.Server._getJob(source)
    local player = Ox.GetPlayer(source)
    if not player then return end

    local groups = player.getGroups and player:getGroups() or {}
    for name, grade in pairs(groups) do
        return {
            name = name,
            label = name,
            grade = grade,
            gradeLabel = tostring(grade),
            onDuty = true,
        }
    end
end

function Bridge.Server._getGang()
    return nil
end

function Bridge.Server._getMoney(source, account)
    local ok, result = pcall(exports.ox_inventory.GetItem, exports.ox_inventory, source, account, nil, true)
    return ok and result or 0
end

function Bridge.Server._addMoney(source, account, amount)
    local ok, result = pcall(exports.ox_inventory.AddItem, exports.ox_inventory, source, account, amount)
    return ok and result or false
end

function Bridge.Server._removeMoney(source, account, amount)
    local ok, result = pcall(exports.ox_inventory.RemoveItem, exports.ox_inventory, source, account, amount)
    return ok and result or false
end

function Bridge.Server._getPlayers()
    local oxPlayers = Ox.GetPlayers()
    if not oxPlayers then return {} end

    local result = {}
    for _, player in pairs(oxPlayers) do
        result[#result + 1] = player.source
    end
    return result
end

AddEventHandler('ox:playerLoaded', function(source)
    TriggerEvent('aethra-bridge:server:playerLoaded', source)
end)

AddEventHandler('ox:playerLogout', function(source)
    TriggerEvent('aethra-bridge:server:playerUnloaded', source)
end)
