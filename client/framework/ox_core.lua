if Bridge.framework ~= 'ox_core' then return end

local Ox = require '@ox_core.lib.init'

function Bridge.Client._getPlayerData()
    local player = Ox.GetPlayer()
    if not player then return end

    return {
        identifier = tostring(player.stateId or player.charId),
        firstName = player.firstName or '',
        lastName = player.lastName or '',
        dob = player.dob or '',
        gender = player.gender or '',
        phone = player.phoneNumber or '',
        source = cache.serverId,
        raw = player,
    }
end

function Bridge.Client._getJob()
    local player = Ox.GetPlayer()
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

function Bridge.Client._getGang()
    return nil
end

function Bridge.Client._getMoney(account)
    local ok, result = pcall(exports.ox_inventory.GetItemCount, exports.ox_inventory, account)
    return ok and result or 0
end

function Bridge.Client._getName()
    local player = Ox.GetPlayer()
    if not player then return 'Unknown' end
    return ('%s %s'):format(player.firstName or '', player.lastName or '')
end

function Bridge.Client._isDead()
    return IsEntityDead(cache.ped)
end

AddEventHandler('ox:playerLoaded', function()
    TriggerEvent('aethra-bridge:client:playerLoaded')
end)

AddEventHandler('ox:playerLogout', function()
    TriggerEvent('aethra-bridge:client:playerUnloaded')
end)
