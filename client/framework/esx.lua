if Bridge.framework ~= 'esx' then return end

local ESX = exports['es_extended']:getSharedObject()
local accountMap = { cash = 'money', bank = 'bank', crypto = 'black_money' }

function Bridge.Client._getPlayerData()
    local pd = ESX.GetPlayerData()
    if not pd?.identifier then return end

    return {
        identifier = pd.identifier,
        firstName = pd.firstName or pd.firstname or '',
        lastName = pd.lastName or pd.lastname or '',
        dob = pd.dateofbirth or '',
        gender = pd.sex or 'male',
        phone = pd.phone_number or '',
        source = pd.source,
        raw = pd,
    }
end

function Bridge.Client._getJob()
    local pd = ESX.GetPlayerData()
    if not pd?.job then return end

    return {
        name = pd.job.name,
        label = pd.job.label,
        grade = pd.job.grade or 0,
        gradeLabel = pd.job.grade_label or pd.job.grade_name or '',
        onDuty = pd.job.onDuty ~= nil and pd.job.onDuty or true,
    }
end

function Bridge.Client._getGang()
    return nil
end

function Bridge.Client._getMoney(account)
    local pd = ESX.GetPlayerData()
    if not pd?.accounts then return 0 end

    local esxType = accountMap[account] or account
    for i = 1, #pd.accounts do
        if pd.accounts[i].name == esxType then
            return pd.accounts[i].money
        end
    end
    return 0
end

function Bridge.Client._getName()
    local pd = ESX.GetPlayerData()
    if not pd then return 'Unknown' end

    local first = pd.firstName or pd.firstname or ''
    local last = pd.lastName or pd.lastname or ''
    if first == '' and last == '' then return 'Unknown' end
    return ('%s %s'):format(first, last)
end

function Bridge.Client._isDead()
    local pd = ESX.GetPlayerData()
    if pd and pd.dead ~= nil then return pd.dead end
    return IsEntityDead(cache.ped)
end

RegisterNetEvent('esx:playerLoaded', function()
    TriggerEvent('aethra-bridge:client:playerLoaded')
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    TriggerEvent('aethra-bridge:client:playerUnloaded')
end)

RegisterNetEvent('esx:setJob', function(job)
    TriggerEvent('aethra-bridge:client:jobUpdated', {
        name = job.name,
        label = job.label,
        grade = job.grade or 0,
        gradeLabel = job.grade_label or job.grade_name or '',
        onDuty = job.onDuty ~= nil and job.onDuty or true,
    })
end)
