Bridge.Progress = {}

local defaultDisable = { move = true, car = true, combat = true }

function Bridge.Progress.Bar(data, cb)
    local result = lib.progressBar({
        duration = data.duration,
        label = data.label,
        position = data.position or 'bottom',
        useWhileDead = data.useWhileDead or false,
        canCancel = data.canCancel or false,
        anim = data.anim,
        prop = data.prop,
        disable = data.disable or defaultDisable,
    })
    if cb then cb(result) end
    return result
end

function Bridge.Progress.Circle(data, cb)
    local result = lib.progressCircle({
        duration = data.duration,
        label = data.label,
        position = data.position or 'middle',
        useWhileDead = data.useWhileDead or false,
        canCancel = data.canCancel or false,
        anim = data.anim,
        prop = data.prop,
        disable = data.disable or defaultDisable,
    })
    if cb then cb(result) end
    return result
end

function Bridge.Progress.Cancel()
    lib.cancelProgress()
end

function Bridge.Progress.IsActive()
    return lib.progressActive()
end
