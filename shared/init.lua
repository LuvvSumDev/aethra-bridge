local Config = require 'data.config'

Bridge = {}
Bridge.Config = Config

local detectionMap = {
    framework = {
        ['qbox'] = 'qbx_core',
        ['qbcore'] = 'qb-core',
        ['esx'] = 'es_extended',
        ['ox_core'] = 'ox_core',
    },
    inventory = {
        ['ox_inventory'] = 'ox_inventory',
        ['qb-inventory'] = 'qb-inventory',
        ['qs-inventory'] = 'qs-inventory',
    },
    target = {
        ['ox_target'] = 'ox_target',
        ['qb-target'] = 'qb-target',
    },
    notify = {
        ['ox_lib'] = 'ox_lib',
        ['qbcore'] = 'qb-core',
        ['esx'] = 'es_extended',
    },
    fuel = {
        ['ox_fuel'] = 'ox_fuel',
        ['LegacyFuel'] = 'LegacyFuel',
        ['ps-fuel'] = 'ps-fuel',
        ['cdn-fuel'] = 'cdn-fuel',
    },
    clothing = {
        ['illenium-appearance'] = 'illenium-appearance',
        ['fivem-appearance'] = 'fivem-appearance',
        ['qb-clothing'] = 'qb-clothing',
        ['esx_skin'] = 'esx_skin',
    },
    dispatch = {
        ['ps-dispatch'] = 'ps-dispatch',
        ['cd_dispatch'] = 'cd_dispatch',
        ['qs-dispatch'] = 'qs-dispatch',
    },
}

local function detect(category, configVal)
    local options = detectionMap[category]
    if not options then return end

    if configVal and configVal ~= 'auto' and configVal ~= 'none' then
        local res = options[configVal]
        if not res then
            lib.print.error(('unknown %s value: "%s"'):format(category, configVal))
            return
        end
        if GetResourceState(res) ~= 'started' then
            lib.print.error(('%s set to "%s" but resource "%s" is not started'):format(category, configVal, res))
            return
        end
        lib.print.verbose(('%s: %s (config)'):format(category, configVal))
        return configVal
    end

    if configVal == 'none' then return end

    for key, res in pairs(options) do
        if GetResourceState(res) == 'started' then
            lib.print.verbose(('%s: %s (detected)'):format(category, key))
            return key
        end
    end
end

Bridge.framework = detect('framework', Config.framework)
Bridge.inventory = detect('inventory', Config.inventory)
Bridge.target = detect('target', Config.target)
Bridge.notify = detect('notify', Config.notify)
Bridge.fuel = detect('fuel', Config.fuel)
Bridge.clothing = detect('clothing', Config.clothing)
Bridge.dispatch = detect('dispatch', Config.dispatch)

if not Bridge.framework then
    lib.print.error('no supported framework detected - bridge will not function')
end

lib.print.info(('fw: %s | inv: %s | target: %s'):format(
    Bridge.framework or 'none',
    Bridge.inventory or 'none',
    Bridge.target or 'none'
))
