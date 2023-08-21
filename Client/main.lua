
Citizen.CreateThread(function ()
    for KnoxDev_Key_NPC, KnoxDev_Value_NPC in pairs(KnoxDev_CarThief_Config.NPC) do
        if KnoxDev_Key_NPC then
            KnoxDev_CarThief.CreateNPC(KnoxDev_Key_NPC, KnoxDev_Value_NPC.coords, KnoxDev_Value_NPC.model)
            KnoxDev_CarThief_Config.Interaction(KnoxDev_Key_NPC)
            break
        end
    end

    for KnoxDev_Key, KnoxDev_Value in pairs(KnoxDev_CarThief_Config.Blip) do
        if KnoxDev_Key and KnoxDev_Value.coords then 
            KnoxDev_CarThief.CreateBlip(KnoxDev_Key, KnoxDev_Value.coords, KnoxDev_Value.sprite, KnoxDev_Value.color, KnoxDev_Value.name, KnoxDev_Value.size)
        end
    end
end)

local counter = 0
local pictureURL = nil
RegisterNetEvent('knoxdev_carthief:startjob', function ()
    ESX.TriggerServerCallback('KnoxDev_Carthief_Check', function (fai)
        if fai then
            local coords_player = GetEntityCoords(PlayerPedId())
            local distance = KnoxDev_CarThief.DistanceCoords(KnoxDev_CarThief_Config.NPC['NPC_Start']['coords'],coords_player)
        
            if distance <= KnoxDev_CarThief_Config.Distance then
                KnoxDev_CarThief.AnimStart(KnoxDev_CarThief.ReturnNPC('NPC_Start'), KnoxDev_CarThief_Config.NPC['NPC_Start']['anim_dict'], KnoxDev_CarThief_Config.NPC['NPC_Start']['anim'])
                KnoxDev_CarThief.AnimStart(PlayerPedId(), "amb@world_human_cop_idles@male@idle_b", "idle_d")
                local foto = DoPhoto(PlayerPedId())
                pictureURL = string.format("https://nui-img/%s/%s", foto, foto)
                KnoxDev_CarThief.CreateCamera('NPC_Start', KnoxDev_CarThief_Config.NPC['NPC_Start']['cam'])
                FreezeEntityPosition(PlayerPedId(), true)
                Wait(2000)
                local counter = 1
                ESX.TriggerServerCallback('KnoxDev_Carthief_Set', function (done)
                    
                end, 'Waiting', true)
                while KnoxDev_CarThief_Config.NPC['NPC_Start']['npc_dialog'][counter] do
                    SendNUIMessage({
                        type = "mostramessaggio",
                        image = KnoxDev_CarThief_Config.NPC['NPC_Start']['image'],
                        text = KnoxDev_CarThief_Config.NPC['NPC_Start']['npc_dialog'][counter],
                        duration = 3600
                    })
                    Citizen.Wait(3600)
                    SendNUIMessage({
                        type = "mostramessaggio",
                        image = pictureURL,
                        text = KnoxDev_CarThief_Config.NPC['NPC_Start']['player_dialog'][counter],
                        duration = 3600
                    })
                    Citizen.Wait(3600)
                    counter = counter + 1
                end
                while KnoxDev_CarThief_Config.NPC['NPC_Start']['npc_dialog'][counter] == nil do
                    SendNUIMessage({
                        type = "toglinui"
                    })
                    KnoxDev_CarThief.DeleteCamera('NPC_Start')
                    ClearPedTasksImmediately(PlayerPedId())
                    ClearPedTasksImmediately(KnoxDev_CarThief.ReturnNPC('NPC_Start'))
                    FreezeEntityPosition(PlayerPedId(), false)
                    KnoxDev_CarThief.Start()
                    Citizen.Wait(150)
                    break
                end
            else
                KnoxDev_CarThief_Config.Ban()
            end
        else
            KnoxDev_CarThief_Config.Notify(KnoxDev_CarThief_Config.Lang['AlredyCarThief'])
        end
    end)
end)

DoPhoto = function (ped)
    local headShot = RegisterPedheadshot(ped)
    local timeout = 10
    local texture = nil

    while timeout > 0 and (not IsPedheadshotReady(headShot) or not IsPedheadshotValid(headShot)) do
        timeout = timeout - 1
        Citizen.Wait(200)
    end

    if IsPedheadshotReady(headShot) and IsPedheadshotValid(headShot) then
        texture = GetPedheadshotTxdString(headShot)
    end

    UnregisterPedheadshot(headShot)

    return texture
end


KnoxDev_CarThief.Start = function ()
    local timer = 0
    local random = math.random(7000,25000)
    SendNUIMessage({
        type = "mostramessaggio",
        image = 'https://www.freeiconspng.com/thumbs/phone-icon/phone-icon-clip-art--royalty--7.png',
        text = KnoxDev_CarThief_Config.Lang['Wait_After_Start'],
        duration = 10000
    })
    while timer < random do
        timer = timer + 1000
        Citizen.Wait(1000)
    end
    while timer >= random do
        SendNUIMessage({
            type = "toglinui"
        })
        KnoxDev_CarThief.AnimStart(PlayerPedId(), "cellphone@", "cellphone_text_read_base")
        KnoxDev_CarThief.Request()
        break
    end
end

KnoxDev_CarThief.Request = function ()
    SendNUIMessage({
        type = "mostramessaggio",
        image = 'https://png.pngtree.com/png-vector/20220609/ourmid/pngtree-question-mark-and-background-png-image_4945630.png',
        text = KnoxDev_CarThief_Config.Lang['Request_Call'],
        duration = 10000
    })
    KnoxDev_CarThief.Doing = true
end

RegisterCommand('rejectcall_carthief', function()
    if KnoxDev_CarThief.Doing then
        ESX.TriggerServerCallback('KnoxDev_Carthief_Set', function (done)    
        end, 'Waiting', false)
        SendNUIMessage({
            type = "toglinui"
        })
        KnoxDev_CarThief_Config.Notify(KnoxDev_CarThief_Config.Lang['Rejected_Call'])
        ClearPedTasksImmediately(PlayerPedId())
        KnoxDev_CarThief.Doing = false
    end
end, false)
RegisterCommand('acceptcall_carthief', function()
    if KnoxDev_CarThief.Doing then
        KnoxDev_CarThief.Doing = false
        ClearPedTasksImmediately(PlayerPedId())
        KnoxDev_CarThief.DoCall()
    end
end, false)

KnoxDev_CarThief.DoCall = function ()
    SendNUIMessage({
        type = "toglinui"
    })
    KnoxDev_CarThief.AnimStart(PlayerPedId(), "cellphone@", "cellphone_call_listen_base")
    local counter_call = 1
    while KnoxDev_CarThief_Config.CallDialog['NPC'][counter_call] or KnoxDev_CarThief_Config.CallDialog['PLAYER'][counter_call] do
        if KnoxDev_CarThief_Config.CallDialog['NPC'][counter_call] then
            SendNUIMessage({
                type = "mostramessaggio",
                image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
                text = KnoxDev_CarThief_Config.CallDialog['NPC'][counter_call],
                duration = 3600
            })
            Citizen.Wait(3600)
        end
        if KnoxDev_CarThief_Config.CallDialog['PLAYER'][counter_call] then
            SendNUIMessage({
                type = "mostramessaggio",
                image = pictureURL,
                text = KnoxDev_CarThief_Config.CallDialog['PLAYER'][counter_call],
                duration = 3600
            })
            Citizen.Wait(3600)
        end
        counter_call = counter_call + 1
    end
    while KnoxDev_CarThief_Config.CallDialog['NPC'][counter_call] == nil and KnoxDev_CarThief_Config.CallDialog['PLAYER'][counter_call] == nil do
        SendNUIMessage({
            type = "toglinui"
        })
        KnoxDev_CarThief.CameraVehicle()
        break
    end
end

RegisterCommand('sdghsdgsd', function ()
    KnoxDev_CarThief.CameraVehicle()
end)

KnoxDev_CarThief.CameraVehicle = function ()
    local randomico = math.random(1, #KnoxDev_CarThief_Config.VehicleSpawn)
    KnoxDev_CarThief.CreateCamera('NPC_VEHICLE', KnoxDev_CarThief_Config.VehicleSpawn[randomico]['cam'])
    local playerCoords = nil 
    playerCoords = GetEntityCoords(PlayerPedId())
    KnoxDev_CarThief.CreateNPC('NPC_VEHICLE', KnoxDev_CarThief_Config.VehicleSpawn[randomico]['npcspawn'], KnoxDev_CarThief_Config.CallDialog['NPC_MODEL'])
    KnoxDev_CarThief.ScenarioStart(KnoxDev_CarThief.ReturnNPC('NPC_VEHICLE'), 'WORLD_HUMAN_MOBILE_FILM_SHOCKING')
    SendNUIMessage({
        type = "mostramessaggio",
        image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
        text = KnoxDev_CarThief_Config.Lang['Do_not_look_at_me'],
        duration = 3600
    })
    Wait(400)
    SetEntityVisible(PlayerPedId(), false)
    SetEntityCoords(PlayerPedId(), KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][1], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][2],KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][3])
    KnoxDev_CarThief.CreateVehicle('NPC_VEHICLE', KnoxDev_CarThief_Config.VehicleSpawn[randomico]['vehiclespawn'], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'])
    local vehicle = KnoxDev_CarThief.ReturnVehicle('NPC_VEHICLE')
    SetVehicleDoorsLocked(vehicle, 2)
    FreezeEntityPosition(vehicle,true)
    Citizen.Wait(11000)
    SendNUIMessage({
        type = "toglinui"
    })
    KnoxDev_CarThief.DeleteCamera('NPC_VEHICLE')
    SetEntityVisible(PlayerPedId(), true)
    SetEntityCoords(PlayerPedId(), playerCoords[1], playerCoords[2], playerCoords[3]-1) 
    KnoxDev_CarThief.StartJob(randomico)
end


KnoxDev_CarThief.StartJob = function (randomico)
    KnoxDev_CarThief.DoingJob = true
    local vehicledone = false
    if KnoxDev_CarThief.DoingJob then
        KnoxDev_CarThief.CreateBlip('Destination', KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'], KnoxDev_CarThief_Config.Blip['Destination']['sprite'], KnoxDev_CarThief_Config.Blip['Destination']['color'], KnoxDev_CarThief_Config.Blip['Destination']['name'], KnoxDev_CarThief_Config.Blip['Destination']['size'])
        KnoxDev_CarThief.DeleteNPC('NPC_VEHICLE')
        KnoxDev_CarThief.SetNewWaypoint(KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'])
        SendNUIMessage({
            type = "mostramessaggio",
            image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
            text = KnoxDev_CarThief_Config.Lang['Destination'],
            duration = 3600
        })
        Citizen.Wait(2000)
        SendNUIMessage({
            type = "toglinui"
        })
        vehicledone = true
        local pizzetta = 1000
        while vehicledone do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = KnoxDev_CarThief.DistanceCoords(playerCoords, KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'])
            if distance < 4 then
                pizzetta = 0
                DrawMarker(36, KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][1], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][2], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][3] + 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 255, 128, 0, 50, false, true, 2, nil, nil, false)
                ESX.Game.Utils.DrawText3D(vec3( KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][1], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][2], KnoxDev_CarThief_Config.VehicleSpawn[randomico]['spawnvehicle'][3] + 0.8), KnoxDev_CarThief_Config.Lang['Key_LockPicking'], 1.0, 0)
                if IsControlJustPressed(0, 46) then
                    KnoxDev_CarThief.LockPicking(randomico)
                    vehicledone = false
                end
            end
            Citizen.Wait(pizzetta)
        end
    end
end



KnoxDev_CarThief.LockPicking = function (randomico)  
    if KnoxDev_CarThief_Config.UseItem and KnoxDev_CarThief_Config.UseItem ~= '' then
        if KnoxDev_CarThief_Config.UseESX then
            local vehicle = KnoxDev_CarThief.ReturnVehicle('NPC_VEHICLE')
            ESX.TriggerServerCallback('KnoxDev_Carthief_LockPick', function (done)
                if done then
                    KnoxDev_CarThief.AnimStart(PlayerPedId(), "mini@repair","fixing_a_ped")
                    local random = KnoxDev_CarThief_Config.LockPick_Time
                    local timer = 0
                    SendNUIMessage({
                        type = "mostramessaggio",
                        image = 'https://cdn-icons-png.flaticon.com/512/9148/9148708.png',
                        text = KnoxDev_CarThief_Config.Lang['Lockpicking'],
                        duration = 3600
                    })
                    FreezeEntityPosition(PlayerPedId(), true)
                    while timer < random do
                        timer = timer + 1000
                        Citizen.Wait(1000)
                    end
                    while timer > random do
                        SendNUIMessage({
                            type = "toglinui"
                        })
                        SetVehicleDoorsLocked(vehicle, 1)
                        FreezeEntityPosition(vehicle,false)
                        FreezeEntityPosition(PlayerPedId(), false)
                        ClearPedTasksImmediately(PlayerPedId())
                        SendNUIMessage({
                            type = "mostramessaggio",
                            image = 'https://cdn.discordapp.com/attachments/1134973139915382805/1142959849920004196/image-removebg-preview.png',
                            text = 'Completed!',
                            duration = 3600
                        })
                        Citizen.Wait(3000)
                        SendNUIMessage({
                            type = "toglinui"
                        })
                        break
                    end
                    local gived = false
                    local gived_status = false
                    local time = KnoxDev_CarThief_Config.Time_Remaining
                    local timewaiting = KnoxDev_CarThief_Config.Time_Remaining_Vehicle
                    KnoxDev_CarThief.EnteredInVehicle = true
                    while KnoxDev_CarThief.EnteredInVehicle do
                        if not gived then
                            KnoxDev_CarThief.Position = true
                            SendNUIMessage({
                                type = "mostramessaggio",
                                image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
                                text = KnoxDev_CarThief_Config.Lang['Do_Not_Abandon_Vehicle'],
                                duration = 3600
                            })
                            Citizen.Wait(5000)
                            SendNUIMessage({
                                type = "toglinui"
                            })
                            TriggerServerEvent('KnoxDev_Carthief_Refresh_Coords', GetEntityCoords(vehicle))
                            ESX.TriggerServerCallback('KnoxDev_Carthief_Notification', function ()
                            end,time,GetEntityCoords(vehicle))
                            gived = true
                        end
                        if not IsPedInVehicle(PlayerPedId(), vehicle, false) then
                            timewaiting = timewaiting-1
                            if timewaiting <= 0 then
                                SendNUIMessage({
                                    type = "toglinui"
                                })
                                KnoxDev_CarThief.CleanTables()
                                break
                            end
                            SendNUIMessage({
                                type = "mostramessaggio2",
                                image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
                                text = KnoxDev_CarThief_Config.Lang['Time_Vehicle']..' '..timewaiting,
                                duration = 3600
                            })
                            Citizen.Wait(1000)
                        end
                        if IsPedInVehicle(PlayerPedId(), vehicle, false) then
                            time = time - 1
                            if time <= 0 then
                                SendNUIMessage({
                                    type = "toglinui"
                                })
                                KnoxDev_CarThief.EnteredInVehicle = false
                                KnoxDev_CarThief.Position = false
                                KnoxDev_CarThief.CanGiveDestination = true
                                KnoxDev_CarThief.GiveLocation()
                                break
                            end
                            SendNUIMessage({
                                type = "mostramessaggio2",
                                image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
                                text = KnoxDev_CarThief_Config.Lang['Time']..' '..time,
                                duration = 3600
                            })
                            Citizen.Wait(1000)
                        end
                    end
                else
                    SendNUIMessage({
                        type = "mostramessaggio",
                        image = KnoxDev_CarThief_Config.NPC['NPC_Start']['image'],
                        text = KnoxDev_CarThief_Config.Lang['Failed_NoItem'],
                        duration = 3600
                    })
                    Wait(3500)
                    SendNUIMessage({
                        type = "toglinui"
                    })
                    KnoxDev_CarThief.CleanTables()
                end
            end,  KnoxDev_CarThief_Config.UseItem)
        end
    end
end

RegisterNetEvent('CarThief_Refresh_Position', function ()
    while KnoxDev_CarThief.Position do
        TriggerServerEvent('KnoxDev_Carthief_Refresh_Coords', GetEntityCoords(KnoxDev_CarThief.ReturnVehicle('NPC_VEHICLE')))
        Citizen.Wait(KnoxDev_CarThief_Config.Time_Update_GPS*1000)  
    end
end)

KnoxDev_CarThief.GiveLocation = function ()
    local doneminigame = false
    while KnoxDev_CarThief.CanGiveDestination do
        if IsPedInVehicle(PlayerPedId(), KnoxDev_CarThief.ReturnVehicle('NPC_VEHICLE'), false) then
            local randomico = math.random(1, #KnoxDev_CarThief_Config.Delivery)
            if randomico then
                SendNUIMessage({
                    type = "mostramessaggio",
                    image = KnoxDev_CarThief_Config.CallDialog['NPC_IMAGE'],
                    text = KnoxDev_CarThief_Config.Lang['Press_E_For_Remove_GPS'],
                    duration = 3600
                })
                KnoxDev_CarThief.Minigame = true
                break
            end
        end
        Citizen.Wait(1000)
    end
end

Begin = function(icons, time)
    if MinigameActive then return end
    MinigameActive = true
    SetNuiFocus(true, true)
    SendNUIMessage({show = true, icons = icons, time = time})
    
    while MinigameActive do
        Citizen.Wait(100)
    end

    return Result
end


RegisterNetEvent('knoxdev_carthief:delivery', function ()
    if KnoxDev_CarThief.Doing or KnoxDev_CarThief.DoingJob then
        DoScreenFadeOut(1000)
        ESX.TriggerServerCallback('KnoxDev_Carthief_Done', function (done)
            if type(done) == "string" then
                KnoxDev_CarThief_Config.Notify(done)
            else
                KnoxDev_CarThief_Config.Ban()
            end
        end)
        Wait(1000)
        DoScreenFadeIn(1000)
        KnoxDev_CarThief.DeleteBlip('CAR_THIEF')
        KnoxDev_CarThief.DeleteBlip('Delivery')
        KnoxDev_CarThief.DeleteBlip('Destination')
        KnoxDev_CarThief.DeleteNPC('Delivery')
        KnoxDev_CarThief.DeleteVehicle(KnoxDev_CarThief.ReturnVehicle('NPC_VEHICLE'))
        KnoxDev_CarThief.CleanTables()
    end
end)

RegisterNetEvent('KnoxDev_Carthief_Blip_FDO', function (lavoro,s,c)
    for k, v in pairs(KnoxDev_CarThief_Config.FDO) do
        if v == lavoro then
            KnoxDev_CarThief.DeleteBlip('CAR_THIEF')
            KnoxDev_CarThief.CreateBlip('CAR_THIEF', c, KnoxDev_CarThief_Config.Blip['CarThief']['sprite'], KnoxDev_CarThief_Config.Blip['CarThief']['color'], KnoxDev_CarThief_Config.Blip['CarThief']['name'], KnoxDev_CarThief_Config.Blip['CarThief']['size'])
        end
    end
end)

RegisterNetEvent('KnoxDev_Carthief_Blip_FDO_Kill', function (lavoro,s,c)
    for k, v in pairs(KnoxDev_CarThief_Config.FDO) do
        if v == lavoro then
            KnoxDev_CarThief.DeleteBlip('CAR_THIEF'..s)
        end
    end
end)

RegisterNUICallback('hacking_finished', function(data, cb)
    Result = data.result
    SetNuiFocus(false, false)
    if Result then
        local randomico = math.random(1, #KnoxDev_CarThief_Config.Delivery)
        randomico = KnoxDev_CarThief_Config.Delivery[randomico]
        SendNUIMessage({
            type = "toglinui"
        })
        KnoxDev_CarThief.CreateBlip('Delivery', randomico, KnoxDev_CarThief_Config.Blip['Delivery']['sprite'], KnoxDev_CarThief_Config.Blip['Delivery']['color'], KnoxDev_CarThief_Config.Blip['Delivery']['name'], KnoxDev_CarThief_Config.Blip['Delivery']['size'])
        KnoxDev_CarThief.SetNewWaypoint(randomico)
        KnoxDev_CarThief_Config.Notify(KnoxDev_CarThief_Config.Lang['Delivery'])
        KnoxDev_CarThief.Minigame = false
        ESX.TriggerServerCallback('KnoxDev_Carthief_Set', function (done)    
        end, 'Waiting', false)
        KnoxDev_CarThief.CreateNPC('Delivery', vec4(randomico[1], randomico[2], randomico[3]-1, randomico[4]), 's_m_y_dealer_01')
        KnoxDev_CarThief_Config.Interaction('Delivery')
    else
        KnoxDev_CarThief_Config.Notify(KnoxDev_CarThief_Config.Lang['Failed'])
        Citizen.Wait(2000)
        ESX.TriggerServerCallback('KnoxDev_Carthief_Set', function (done)    
        end, 'Waiting', false)
        ESX.TriggerServerCallback('KnoxDev_Carthief_Set', function (done)    
        end, 'Carthief', false)
        SendNUIMessage({
            type = "toglinui"
        })
        KnoxDev_CarThief.CleanTables()
    end
end)

RegisterCommand('accept_minigame_carthief', function ()
    if KnoxDev_CarThief.Minigame then
        local timer = KnoxDev_CarThief_Config.Time_Hacking*1000
        SendNUIMessage({
            type = "toglinui"
        })
        local doneminigame = Begin(math.random(2, 3), timer)
        if doneminigame then
        end
    end
end)

RegisterKeyMapping('rejectcall_carthief', 'Reject Call Carthief', 'keyboard', KnoxDev_CarThief_Config.Key['Reject_Call'])
RegisterKeyMapping('acceptcall_carthief', 'Accept Call Carthief', 'keyboard', KnoxDev_CarThief_Config.Key['Accept_Call'])
RegisterKeyMapping('accept_minigame_carthief', 'Accept Minigame Carthief', 'keyboard', 'E')