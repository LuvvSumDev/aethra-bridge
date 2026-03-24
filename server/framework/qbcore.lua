if Bridge.framework ~= 'qbcore' then return end

local QBCore = exports['qb-core']:GetCoreObject()

local function getPlayer(source)
    return QBCore.Functions.GetPlayer(source)
end

function Bridge.Server._getPlayer(source)
    local player = getPlayer(source)
    if not player then return end

    local pd = player.PlayerData
    local ci = pd.charinfo or {}
    return {
        identifier = pd.citizenid,
        firstName = ci.firstname or '',
        lastName = ci.lastname or '',
        dob = ci.birthdate or '',
        gender = ci.gender or 0,
        phone = ci.phone or '',
        source = source,
        raw = player,
    }
end

function Bridge.Server._getJob(source)
    local player = getPlayer(source)
    if not player then return end

    local job = player.PlayerData.job
    local g = job.grade
    return {
        name = job.name,
        label = job.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
        onDuty = job.onduty,
    }
end

function Bridge.Server._getGang(source)
    local player = getPlayer(source)
    if not player then return end

    local gang = player.PlayerData.gang
    if not gang then return end

    local g = gang.grade
    return {
        name = gang.name,
        label = gang.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
    }
end

function Bridge.Server._getMoney(source, account)
    local player = getPlayer(source)
    return player and player.PlayerData.money[account] or 0
end

function Bridge.Server._addMoney(source, account, amount, reason)
    local player = getPlayer(source)
    if not player then return false end
    return player.Functions.AddMoney(account, amount, reason)
end

function Bridge.Server._removeMoney(source, account, amount, reason)
    local player = getPlayer(source)
    if not player then return false end
    return player.Functions.RemoveMoney(account, amount, reason)
end

function Bridge.Server._getPlayers()
    local result = {}
    for src in pairs(QBCore.Functions.GetQBPlayers()) do
        result[#result + 1] = src
    end
    return result
end

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    TriggerEvent('aethra-bridge:server:playerLoaded', source)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(src)
    TriggerEvent('aethra-bridge:server:playerUnloaded', src)
end)

RegisterNetEvent('QBCore:Server:OnJobUpdate', function(src, job)
    local g = job.grade
    TriggerEvent('aethra-bridge:server:jobUpdated', src, {
        name = job.name,
        label = job.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
        onDuty = job.onduty,
    })
end)

RegisterNetEvent('QBCore:Server:OnGangUpdate', function(src, gang)
    local g = gang.grade
    TriggerEvent('aethra-bridge:server:gangUpdated', src, {
        name = gang.name,
        label = gang.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
    })
end)
