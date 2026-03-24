Bridge.Server = {}
Bridge.Inventory = {}

lib.versionCheck('AethraStudios/aethra-bridge')

function Bridge.Server.GetPlayer(source)
    return Bridge.Server._getPlayer and Bridge.Server._getPlayer(source) or nil
end

function Bridge.Server.GetIdentifier(source)
    local data = Bridge.Server.GetPlayer(source)
    return data and data.identifier
end

function Bridge.Server.GetName(source)
    local data = Bridge.Server.GetPlayer(source)
    if not data then return 'Unknown' end
    return ('%s %s'):format(data.firstName or '', data.lastName or '')
end

function Bridge.Server.GetJob(source)
    return Bridge.Server._getJob and Bridge.Server._getJob(source) or nil
end

function Bridge.Server.GetGang(source)
    return Bridge.Server._getGang and Bridge.Server._getGang(source) or nil
end

function Bridge.Server.HasJob(source, name, minGrade)
    local job = Bridge.Server.GetJob(source)
    if not job then return false end

    minGrade = minGrade or 0

    if type(name) == 'table' then
        for i = 1, #name do
            if job.name == name[i] and job.grade >= minGrade then return true end
        end
        return false
    end

    return job.name == name and job.grade >= minGrade
end

function Bridge.Server.HasGang(source, name, minGrade)
    local gang = Bridge.Server.GetGang(source)
    if not gang then return false end

    minGrade = minGrade or 0

    if type(name) == 'table' then
        for i = 1, #name do
            if gang.name == name[i] and gang.grade >= minGrade then return true end
        end
        return false
    end

    return gang.name == name and gang.grade >= minGrade
end

function Bridge.Server.HasGroup(source, name, minGrade)
    return Bridge.Server.HasJob(source, name, minGrade) or Bridge.Server.HasGang(source, name, minGrade)
end

function Bridge.Server.GetMoney(source, account)
    return Bridge.Server._getMoney and Bridge.Server._getMoney(source, account or 'cash') or 0
end

function Bridge.Server.AddMoney(source, account, amount, reason)
    return Bridge.Server._addMoney and Bridge.Server._addMoney(source, account, amount, reason) or false
end

function Bridge.Server.RemoveMoney(source, account, amount, reason)
    return Bridge.Server._removeMoney and Bridge.Server._removeMoney(source, account, amount, reason) or false
end

function Bridge.Inventory.GetItemCount(source, item)
    return Bridge.Inventory._getItemCount and Bridge.Inventory._getItemCount(source, item) or 0
end

function Bridge.Inventory.HasItem(source, item, count)
    return Bridge.Inventory.GetItemCount(source, item) >= (count or 1)
end

function Bridge.Inventory.AddItem(source, item, count, metadata)
    return Bridge.Inventory._addItem and Bridge.Inventory._addItem(source, item, count, metadata) or false
end

function Bridge.Inventory.RemoveItem(source, item, count, metadata)
    return Bridge.Inventory._removeItem and Bridge.Inventory._removeItem(source, item, count, metadata) or false
end

function Bridge.Inventory.GetItems(source)
    return Bridge.Inventory._getItems and Bridge.Inventory._getItems(source) or {}
end

function Bridge.Inventory.RegisterUsableItem(item, cb)
    if Bridge.Inventory._registerUsableItem then
        Bridge.Inventory._registerUsableItem(item, cb)
    end
end

function Bridge.Server.GetPlayers()
    if Bridge.Server._getPlayers then return Bridge.Server._getPlayers() end

    local players = {}
    for _, id in ipairs(GetPlayers()) do
        players[#players + 1] = tonumber(id)
    end
    return players
end

function Bridge.Server.KickPlayer(source, reason)
    DropPlayer(source, reason or 'You have been kicked.')
end

lib.callback.register('aethra-bridge:getPlayer', function(source)
    return Bridge.Server.GetPlayer(source)
end)

lib.callback.register('aethra-bridge:getIdentifier', function(source)
    return Bridge.Server.GetIdentifier(source)
end)

lib.callback.register('aethra-bridge:hasGroup', function(source, name, minGrade)
    return Bridge.Server.HasGroup(source, name, minGrade)
end)

lib.callback.register('aethra-bridge:hasItem', function(source, item, count)
    return Bridge.Inventory.HasItem(source, item, count)
end)

lib.callback.register('aethra-bridge:getItemCount', function(source, item)
    return Bridge.Inventory.GetItemCount(source, item)
end)

exports('GetBridge', function() return Bridge end)
