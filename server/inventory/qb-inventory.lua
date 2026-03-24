if Bridge.inventory ~= 'qb-inventory' then return end

local QBCore
if Bridge.framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function getPlayer(source)
    if Bridge.framework == 'qbcore' then
        return QBCore.Functions.GetPlayer(source)
    elseif Bridge.framework == 'qbox' then
        return exports.qbx_core:GetPlayer(source)
    end
end

local function getItems(source)
    local player = getPlayer(source)
    return player and player.PlayerData.items or {}
end

function Bridge.Inventory._getItemCount(source, item)
    local total = 0
    for _, v in pairs(getItems(source)) do
        if v and v.name == item then
            total = total + (v.amount or v.count or 0)
        end
    end
    return total
end

function Bridge.Inventory._addItem(source, item, count, metadata)
    local player = getPlayer(source)
    if not player then return false end
    return player.Functions.AddItem(item, count, nil, metadata)
end

function Bridge.Inventory._removeItem(source, item, count)
    local player = getPlayer(source)
    if not player then return false end
    return player.Functions.RemoveItem(item, count)
end

function Bridge.Inventory._getItems(source)
    local result = {}
    for _, v in pairs(getItems(source)) do
        local qty = v and (v.amount or v.count or 0)
        if qty > 0 then
            result[#result + 1] = {
                name = v.name,
                label = v.label,
                count = qty,
                weight = v.weight or 0,
                metadata = v.info or {},
                slot = v.slot,
            }
        end
    end
    return result
end

function Bridge.Inventory._registerUsableItem(item, cb)
    if Bridge.framework == 'qbcore' then
        QBCore.Functions.CreateUseableItem(item, cb)
    elseif Bridge.framework == 'qbox' then
        exports.qbx_core:CreateUseableItem(item, cb)
    end
end
