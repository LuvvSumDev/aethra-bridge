if Bridge.inventory ~= 'ox_inventory' then return end

local inv = exports.ox_inventory

function Bridge.Inventory._getItemCount(source, item)
    return inv:GetItem(source, item, nil, true) or 0
end

function Bridge.Inventory._addItem(source, item, count, metadata)
    return inv:AddItem(source, item, count, metadata) or false
end

function Bridge.Inventory._removeItem(source, item, count, metadata)
    return inv:RemoveItem(source, item, count, metadata) or false
end

function Bridge.Inventory._getItems(source)
    local items = inv:GetInventoryItems(source)
    if not items then return {} end

    local result = {}
    for _, v in pairs(items) do
        if v and v.count > 0 then
            result[#result + 1] = {
                name = v.name,
                label = v.label,
                count = v.count,
                weight = v.weight,
                metadata = v.metadata,
                slot = v.slot,
            }
        end
    end
    return result
end

function Bridge.Inventory._registerUsableItem(item, cb)
    inv:RegisterHook('usingItem', function(payload)
        if payload.itemName == item then
            cb(payload.source)
        end
    end)
end
