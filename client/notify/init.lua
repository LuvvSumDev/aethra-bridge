Bridge.Notify = {}

local notifyTypeMap = { info = 'inform', warning = 'warn' }

function Bridge.Notify.Send(msg, type, duration, title)
    type = type or 'info'
    duration = duration or 5000

    if Bridge.notify == 'ox_lib' then
        lib.notify({ title = title, description = msg, type = notifyTypeMap[type] or type, duration = duration })
    elseif Bridge.notify == 'qbcore' then
        if Bridge.framework == 'qbox' then
            exports.qbx_core:Notify(msg, type, duration)
        else
            local QBCore = exports['qb-core']:GetCoreObject()
            QBCore.Functions.Notify(msg, type, duration)
        end
    elseif Bridge.notify == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        ESX.ShowNotification(msg, type, duration)
    else
        lib.notify({ title = title, description = msg, type = notifyTypeMap[type] or type, duration = duration })
    end
end

function Bridge.Notify.Help(msg)
    AddTextEntry('aethraHelp', msg)
    DisplayHelpTextThisFrame('aethraHelp', false)
end

function Bridge.Notify.Advanced(title, subject, msg, icon, iconType)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(msg)
    if icon then
        SetNotificationMessage(icon, icon, true, iconType or 4, title, subject)
    else
        DrawNotification(false, true)
    end
end

RegisterNetEvent('aethra-bridge:client:notify', function(msg, type, duration, title)
    Bridge.Notify.Send(msg, type, duration, title)
end)
