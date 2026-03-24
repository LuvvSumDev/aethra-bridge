if Bridge.framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()
local accountMap = { cash = 'money', bank = 'bank', crypto = 'black_money' }

function Bridge.Server._getPlayer(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    return {
        identifier = xPlayer.getIdentifier(),
        firstName = xPlayer.get('firstName') or '',
        lastName = xPlayer.get('lastName') or '',
        dob = xPlayer.get('dateofbirth') or '',
        gender = xPlayer.get('sex') or 'male',
        phone = xPlayer.get('phone_number') or '',
        source = source,
        raw = xPlayer,
    }
end

function Bridge.Server._getJob(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local job = xPlayer.getJob()
    return {
        name = job.name,
        label = job.label,
        grade = job.grade or 0,
        gradeLabel = job.grade_label or job.grade_name or '',
        onDuty = job.onDuty ~= nil and job.onDuty or true,
    }
end

function Bridge.Server._getGang()
    return nil
end

function Bridge.Server._getMoney(source, account)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return 0 end

    local esxType = accountMap[account] or account
    local acc = xPlayer.getAccount(esxType)
    return acc and acc.money or 0
end

function Bridge.Server._addMoney(source, account, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local esxType = accountMap[account] or account
    if esxType == 'money' then
        xPlayer.addMoney(amount, reason)
    else
        xPlayer.addAccountMoney(esxType, amount, reason)
    end
    return true
end

function Bridge.Server._removeMoney(source, account, amount, reason)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return false end

    local esxType = accountMap[account] or account
    if esxType == 'money' then
        xPlayer.removeMoney(amount, reason)
    else
        xPlayer.removeAccountMoney(esxType, amount, reason)
    end
    return true
end

function Bridge.Server._getPlayers()
    local result = {}
    for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        result[#result + 1] = xPlayer.source
    end
    return result
end

RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('aethra-bridge:server:playerLoaded', source)
end)

RegisterNetEvent('esx:playerDropped', function(playerId)
    TriggerEvent('aethra-bridge:server:playerUnloaded', playerId)
end)

RegisterNetEvent('esx:setJob', function(playerId, job)
    TriggerEvent('aethra-bridge:server:jobUpdated', playerId, {
        name = job.name,
        label = job.label,
        grade = job.grade or 0,
        gradeLabel = job.grade_label or job.grade_name or '',
        onDuty = job.onDuty ~= nil and job.onDuty or true,
    })
end)
