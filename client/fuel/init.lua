Bridge.Fuel = {}

local DoesEntityExist = DoesEntityExist
local GetVehicleFuelLevel = GetVehicleFuelLevel
local SetVehicleFuelLevel = SetVehicleFuelLevel

local fuelExports = {
    ['ox_fuel'] = function() return exports.ox_fuel end,
    ['LegacyFuel'] = function() return exports.LegacyFuel end,
    ['ps-fuel'] = function() return exports['ps-fuel'] end,
    ['cdn-fuel'] = function() return exports['cdn-fuel'] end,
}

local fuelResource = Bridge.fuel and fuelExports[Bridge.fuel] and fuelExports[Bridge.fuel]()

function Bridge.Fuel.GetLevel(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    if fuelResource then return fuelResource:GetFuel(vehicle) end
    return GetVehicleFuelLevel(vehicle)
end

function Bridge.Fuel.SetLevel(vehicle, level)
    if not DoesEntityExist(vehicle) then return end
    level = math.max(0.0, math.min(100.0, level))

    if fuelResource then
        fuelResource:SetFuel(vehicle, level)
    else
        SetVehicleFuelLevel(vehicle, level + 0.0)
    end
end
