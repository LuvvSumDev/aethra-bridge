if Bridge.framework ~= 'qbox' then return end

local GetPlayerData = exports.qbx_core.GetPlayerData

local function charinfo(pd)
    return pd.charinfo or {}
end

function Bridge.Client._getPlayerData()
    local pd = GetPlayerData(exports.qbx_core)
    if not pd or not pd.citizenid then return end

    local ci = charinfo(pd)
    return {
        identifier = pd.citizenid,
        firstName = ci.firstname or '',
        lastName = ci.lastname or '',
        dob = ci.birthdate or '',
        gender = ci.gender or 0,
        phone = ci.phone or '',
        source = pd.source,
        raw = pd,
    }
end

function Bridge.Client._getJob()
    local pd = GetPlayerData(exports.qbx_core)
    if not pd?.job then return end

    local g = pd.job.grade
    return {
        name = pd.job.name,
        label = pd.job.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
        onDuty = pd.job.onduty,
    }
end

function Bridge.Client._getGang()
    local pd = GetPlayerData(exports.qbx_core)
    if not pd?.gang then return end

    local g = pd.gang.grade
    return {
        name = pd.gang.name,
        label = pd.gang.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
    }
end

function Bridge.Client._getMoney(account)
    local pd = GetPlayerData(exports.qbx_core)
    return pd and pd.money and pd.money[account] or 0
end

function Bridge.Client._getName()
    local pd = GetPlayerData(exports.qbx_core)
    local ci = pd and charinfo(pd)
    if not ci then return 'Unknown' end
    return ('%s %s'):format(ci.firstname or '', ci.lastname or '')
end

function Bridge.Client._isDead()
    local pd = GetPlayerData(exports.qbx_core)
    if pd?.metadata then
        return pd.metadata.isdead or pd.metadata.inlaststand or false
    end
    return IsEntityDead(cache.ped)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('aethra-bridge:client:playerLoaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('aethra-bridge:client:playerUnloaded')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    local g = job.grade
    TriggerEvent('aethra-bridge:client:jobUpdated', {
        name = job.name,
        label = job.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
        onDuty = job.onduty,
    })
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    local g = gang.grade
    TriggerEvent('aethra-bridge:client:gangUpdated', {
        name = gang.name,
        label = gang.label,
        grade = g and g.level or 0,
        gradeLabel = g and g.name or '',
    })
end)
