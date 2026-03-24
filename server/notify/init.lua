Bridge.Notify = {}

function Bridge.Notify.Send(source, msg, type, duration, title)
    TriggerClientEvent('aethra-bridge:client:notify', source, msg, type or 'info', duration or 5000, title)
end

function Bridge.Notify.SendAll(msg, type, duration, title)
    TriggerClientEvent('aethra-bridge:client:notify', -1, msg, type or 'info', duration or 5000, title)
end
