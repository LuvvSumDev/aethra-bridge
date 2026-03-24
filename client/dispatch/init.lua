Bridge.Dispatch = {}

local function blipData(data, key, default)
    return data.blip and data.blip[key] or default
end

function Bridge.Dispatch.Alert(data)
    local coords = data.coords or GetEntityCoords(cache.ped)
    local jobs = data.jobs or { 'police' }
    local code = data.code or '10-50'
    local sprite = blipData(data, 'sprite', 161)
    local color = blipData(data, 'color', 1)
    local scale = blipData(data, 'scale', 1.0)
    local duration = blipData(data, 'duration', 10)

    if Bridge.dispatch == 'ps-dispatch' then
        exports['ps-dispatch']:CustomAlert({
            coords = coords,
            message = data.message,
            dispatchCode = code,
            job = jobs,
            blipSprite = sprite,
            blipColour = color,
            blipScale = scale,
            blipLength = duration,
        })
    elseif Bridge.dispatch == 'cd_dispatch' then
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = jobs,
            coords = coords,
            title = code,
            message = data.message,
            flash = 0,
            unique_id = string.random('1111111'),
            blip = {
                sprite = sprite,
                scale = scale,
                colour = color,
                flashes = false,
                text = code,
                time = duration * 1000,
            },
        })
    elseif Bridge.dispatch == 'qs-dispatch' then
        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = jobs,
            callLocation = coords,
            callCode = { code = code, snippet = data.message },
            message = data.message,
            blip = {
                sprite = sprite,
                scale = scale,
                colour = color,
                flashes = false,
                text = code,
                time = duration * 1000,
            },
        })
    end
end
