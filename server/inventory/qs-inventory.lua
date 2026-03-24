if Bridge.inventory ~= 'qs-inventory' then return end

local inv = exports['qs-inventory']

function Bridge.Inventory._getItemCount(source, item)
    local data = inv:GetItemByName(source, item)
    return data and (data.amount or data.count or 0) or 0
end

function Bridge.Inventory._addItem(source, item, count, metadata)
    return inv:AddItem(source, item, count, nil, metadata) or false
end

function Bridge.Inventory._removeItem(source, item, count)
    return inv:RemoveItem(source, item, count) or false
end

function Bridge.Inventory._getItems(source)
    local items = inv:GetInventory(source)
    if not items then return {} end

    local result = {}
    for _, v in pairs(items) do
        local qty = v and (v.amount or v.count or 0)
        if qty > 0 then
            result[#result + 1] = {
                name = v.name,
                label = v.label,
                count = qty,
                weight = v.weight or 0,
                metadata = v.info or v.metadata or {},
                slot = v.slot,
            }
        end
    end
    return result
end

function Bridge.Inventory._registerUsableItem(item, cb)
    if Bridge.framework == 'qbcore' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.CreateUseableItem(item, cb)
    elseif Bridge.framework == 'qbox' then
        exports.qbx_core:CreateUseableItem(item, cb)
    elseif Bridge.framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        ESX.RegisterUsableItem(item, cb)
    end
end
