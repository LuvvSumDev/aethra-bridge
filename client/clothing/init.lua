Bridge.Clothing = {}

function Bridge.Clothing.OpenMenu()
    if Bridge.clothing == 'illenium-appearance' then
        exports['illenium-appearance']:startPlayerCustomization(function() end)
    elseif Bridge.clothing == 'fivem-appearance' then
        exports['fivem-appearance']:startPlayerCustomization(function() end)
    elseif Bridge.clothing == 'qb-clothing' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif Bridge.clothing == 'esx_skin' then
        TriggerEvent('esx_skin:openMenu')
    end
end

function Bridge.Clothing.OpenOutfits()
    if Bridge.clothing == 'illenium-appearance' then
        TriggerEvent('illenium-appearance:client:openOutfitMenu')
    elseif Bridge.clothing == 'fivem-appearance' then
        TriggerEvent('fivem-appearance:client:openOutfitMenu')
    elseif Bridge.clothing == 'qb-clothing' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif Bridge.clothing == 'esx_skin' then
        TriggerEvent('esx_skin:openSavedOutfits')
    end
end
