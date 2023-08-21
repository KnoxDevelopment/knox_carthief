

ESX.RegisterServerCallback('KnoxDev_Carthief_LockPick', function (source,cb,item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getInventoryItem(item).count >= 1 then
            xPlayer.removeInventoryItem(item, 1)
            KnoxDev_CarThief_SV.Player = xPlayer
            KnoxDev_CarThief_SV.CarThief = true
            cb(true)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('KnoxDev_Carthief_Check', function (source,cb,item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if not KnoxDev_CarThief_SV.CarThief and not KnoxDev_CarThief_SV.Waiting then
            cb(true)
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('KnoxDev_Carthief_Done', function (source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if KnoxDev_CarThief_SV.CarThief then
            KnoxDev_CarThief_SV.CarThief = false
            KnoxDev_CarThief_SV.Waiting = false
            KnoxDev_CarThief_SV.Coords = nil
            KnoxDev_CarThief_SV.Player = nil
            xPlayer.addInventoryItem(KnoxDev_CarThief_Config.Reward, KnoxDev_CarThief_Config.Quantity)
            local stringa = string.format(KnoxDev_CarThief_Config.Lang['Reward'], KnoxDev_CarThief_Config.Reward, KnoxDev_CarThief_Config.Quantity)
            print(stringa)
            cb(stringa)
        end
    end
end)

ESX.RegisterServerCallback('KnoxDev_Carthief_Set', function (source,cb,response,boolean)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if not KnoxDev_CarThief_SV.CarThief then
            if response == 'Waiting' then
                KnoxDev_CarThief_SV.Waiting = boolean
            elseif response == 'Carthief' then
                KnoxDev_CarThief_SV.CarThief = boolean
            end
        else
            cb(false)
        end
    end
end)

ESX.RegisterServerCallback('KnoxDev_Carthief_Notification', function (source, cb, tempo, veicolo)
    local xPlayer = ESX.GetPlayerFromId(source)
    local coord = veicolo
    TriggerClientEvent('CarThief_Refresh_Position', source)
    if xPlayer then
        if KnoxDev_CarThief_SV.CarThief then
            while tempo > 0 and KnoxDev_CarThief_SV.Coords do
                local coords = KnoxDev_CarThief_SV.Coords 
                tempo = tempo - KnoxDev_CarThief_Config.Time_Update_GPS  
                for k, v in pairs(KnoxDev_CarThief_Config.FDO) do
                    local xPlayers = ESX.GetExtendedPlayers('job', v)
                    for _, xPlayer in pairs(xPlayers) do
                        TriggerClientEvent('KnoxDev_Carthief_Blip_FDO', xPlayer.source, v, xPlayer.source, coords)
                    end
                end
                Wait(KnoxDev_CarThief_Config.Time_Update_GPS*1000)  
            end
            while tempo <= 0 or KnoxDev_CarThief_SV.Coords == nil do
                Wait(KnoxDev_CarThief_Config.Time_Remove_GPS*60000)
                local coords = KnoxDev_CarThief_SV.Coords 
                for k, v in pairs(KnoxDev_CarThief_Config.FDO) do
                    local xPlayers = ESX.GetExtendedPlayers('job', v)
                    for _, xPlayer in pairs(xPlayers) do
                        TriggerClientEvent('KnoxDev_Carthief_Blip_FDO_Kill', xPlayer.source, v, xPlayer.source, coords)
                    end
                end
                break
            end
        end
    end
end)

RegisterServerEvent('KnoxDev_Carthief_Refresh_Coords', function (coords)
    if KnoxDev_CarThief_SV.CarThief then
        KnoxDev_CarThief_SV.Coords = coords
    end
end)


