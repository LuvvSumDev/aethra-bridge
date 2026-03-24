Bridge.Target = {}

local function toOxOptions(options)
    local result = {}
    for i = 1, #options do
        local opt = options[i]
        result[i] = {
            label = opt.label,
            icon = opt.icon,
            distance = opt.distance or 2.5,
            canInteract = opt.canInteract,
            onSelect = opt.onSelect,
            groups = opt.groups,
            items = opt.items,
        }
    end
    return result
end

local function toQbOptions(options)
    local result = {}
    for i = 1, #options do
        local opt = options[i]
        result[i] = {
            type = 'client',
            label = opt.label,
            icon = opt.icon,
            action = opt.onSelect,
            canInteract = opt.canInteract,
            job = opt.groups,
            item = opt.items,
        }
    end
    return result, options[1] and options[1].distance or 2.5
end

function Bridge.Target.AddEntity(entity, options)
    if Bridge.target == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, toOxOptions(options))
    elseif Bridge.target == 'qb-target' then
        local qbOpts, dist = toQbOptions(options)
        exports['qb-target']:AddTargetEntity(entity, { options = qbOpts, distance = dist })
    end
end

function Bridge.Target.RemoveEntity(entity, labels)
    if Bridge.target == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, labels)
    elseif Bridge.target == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity, labels)
    end
end

function Bridge.Target.AddBoxZone(name, coords, size, rotation, options)
    if Bridge.target == 'ox_target' then
        exports.ox_target:addBoxZone({
            name = name,
            coords = coords,
            size = size,
            rotation = rotation and rotation.z or 0,
            options = toOxOptions(options),
        })
    elseif Bridge.target == 'qb-target' then
        local qbOpts, dist = toQbOptions(options)
        exports['qb-target']:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            heading = rotation and rotation.z or 0,
            minZ = coords.z - (size.z / 2),
            maxZ = coords.z + (size.z / 2),
        }, { options = qbOpts, distance = dist })
    end
end

function Bridge.Target.RemoveZone(name)
    if Bridge.target == 'ox_target' then
        exports.ox_target:removeZone(name)
    elseif Bridge.target == 'qb-target' then
        exports['qb-target']:RemoveZone(name)
    end
end

function Bridge.Target.AddModel(models, options)
    if type(models) ~= 'table' then models = { models } end

    if Bridge.target == 'ox_target' then
        exports.ox_target:addModel(models, toOxOptions(options))
    elseif Bridge.target == 'qb-target' then
        local qbOpts, dist = toQbOptions(options)
        exports['qb-target']:AddTargetModel(models, { options = qbOpts, distance = dist })
    end
end

function Bridge.Target.RemoveModel(models, labels)
    if type(models) ~= 'table' then models = { models } end

    if Bridge.target == 'ox_target' then
        exports.ox_target:removeModel(models, labels)
    elseif Bridge.target == 'qb-target' then
        exports['qb-target']:RemoveTargetModel(models, labels)
    end
end

function Bridge.Target.AddPlayer(options)
    if Bridge.target == 'ox_target' then
        exports.ox_target:addGlobalPlayer(toOxOptions(options))
    elseif Bridge.target == 'qb-target' then
        local qbOpts, dist = toQbOptions(options)
        exports['qb-target']:AddGlobalPlayer({ options = qbOpts, distance = dist })
    end
end
