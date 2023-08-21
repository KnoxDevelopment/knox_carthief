ESX = exports['es_extended']:getSharedObject()

KnoxDev_CarThief = {}
KnoxDev_CarThief.Blip = {}
KnoxDev_CarThief.NPCList = {}
KnoxDev_CarThief.VehicleList = {}
KnoxDev_CarThief.CameraList = {}
KnoxDev_CarThief.Doing = false
KnoxDev_CarThief.DoingJob = false
KnoxDev_CarThief.Position = false
KnoxDev_CarThief.CanGiveDestination = false
KnoxDev_CarThief.Minigame = false


KnoxDev_CarThief.CreateBlip = function (nome, coordinate, sprite, colore, testo, grandezza)
    local blip = AddBlipForCoord(coordinate.x, coordinate.y)

    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, grandezza)
    SetBlipColour(blip, colore)
    
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(testo)
    EndTextCommandSetBlipName(blip)

    KnoxDev_CarThief.Blip[nome] = blip
end

KnoxDev_CarThief.CreateVehicle = function (nome, vehicleModel, coords)
    local vehicleHash = GetHashKey(vehicleModel)

    if not IsModelInCdimage(vehicleHash) or not IsModelAVehicle(vehicleHash) then
        print("Modello del veicolo non valido.")
        return
    end

    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(vehicleHash, vec3(coords.x, coords.y, coords.z), coords[4], true, false)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetModelAsNoLongerNeeded(vehicleModel)
    SetVehRadioStation(vehicle, 'OFF')

    KnoxDev_CarThief.VehicleList[nome] = vehicle
end

KnoxDev_CarThief.DeleteVehicle = function (nome)
    local vehicle = KnoxDev_CarThief.VehicleList[nome]
    if vehicle then
        DeleteVehicle(vehicle)
        KnoxDev_CarThief.VehicleList[nome] = nil
    end
end

KnoxDev_CarThief.DeleteBlip = function (nome)
    local blip = KnoxDev_CarThief.Blip[nome]
    if blip then
        RemoveBlip(blip)
        KnoxDev_CarThief.Blip[nome] = nil
    end
end


KnoxDev_CarThief.SetNewWaypointWithBlip = function(nome)
    local blip = KnoxDev_CarThief.Blip[nome]
    if blip then
        local blipCoords = GetBlipCoords(blip)
        SetNewWaypoint(blipCoords.x, blipCoords.y)
    end
end

KnoxDev_CarThief.SetNewWaypoint = function(coords)
    SetNewWaypoint(coords.x, coords.y)
end

KnoxDev_CarThief.NpcCreated = {}
KnoxDev_CarThief.CreateNPC = function(nome, coordinate, modello)
    local aggiunto = false
    for a, b in pairs(KnoxDev_CarThief.NpcCreated) do
        if a == nome then
            aggiunto = true
            break
        end
    end

    if not aggiunto then
        local modello = GetHashKey(modello)
        RequestModel(modello)
        while not HasModelLoaded(modello) do
            RequestModel(modello)
             Citizen.Wait(1)
        end
        local npc = CreatePed(4, modello, coordinate[1], coordinate[2], coordinate[3], coordinate[4], true, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        KnoxDev_CarThief.NPCList[nome] = npc
        table.insert(KnoxDev_CarThief.NpcCreated, nome)
    end
end

KnoxDev_CarThief.DeleteNPC = function(nome)
    local npc = KnoxDev_CarThief.NPCList[nome]
    if npc then
        DeletePed(npc)
        KnoxDev_CarThief.NPCList[nome] = nil
    end
end

KnoxDev_CarThief.ReturnNPC = function (nome)
    return KnoxDev_CarThief.NPCList[nome]
end

KnoxDev_CarThief.ReturnVehicle = function (nome)
    return KnoxDev_CarThief.VehicleList[nome]
end

KnoxDev_CarThief.DistanceCoords = function (posizione, posizione2)
    return Vdist2(posizione[1],posizione[2],posizione[3],posizione2[1], posizione2[2], posizione2[3])
end



KnoxDev_CarThief.DrawText3D = function (coords, text, size, font) --TY ESX for Function
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

    local camCoords = GetFinalRenderedCamCoord()
    local distance = #(vector - camCoords)

    if not size then
        size = 1
    end
    if not font then
        font = 0
    end

    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    BeginTextCommandDisplayText('STRING')
    SetTextCentre(true)
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(vector.xyz, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

KnoxDev_CarThief.AnimStart = function (pl,dict,anim)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(pl, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

KnoxDev_CarThief.ScenarioStart = function (pl,scenario)
    TaskStartScenarioInPlace(pl, scenario, 0, true)
end

KnoxDev_CarThief.CreateCamera = function (nome,coords)
    DoScreenFadeOut(1000)
    Wait(1000)
    DoScreenFadeIn(1000)
    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", vec3(coords[1], coords[2], coords[3]))
    SetCamCoord(camera, vec3(coords[1], coords[2], coords[3]))
    SetCamRot(camera, 0.0, 0.0, coords[4])
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 2000, true, true)
    KnoxDev_CarThief.CameraList[nome] = camera
end

KnoxDev_CarThief.DeleteCamera = function (nome)
    local camera = KnoxDev_CarThief.CameraList[nome]
    if camera then
        RenderScriptCams(false, false, 2000, true, true)
        DestroyCam(camera, false)
        KnoxDev_CarThief.CameraList[nome] = nil
    end
end

AddEventHandler('onClientResourceStop', function (resourceName)
    if resourceName == GetCurrentResourceName() then
        KnoxDev_CarThief.CleanTables()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    KnoxDev_CarThief.CleanTables()
end)


KnoxDev_CarThief.CleanTables = function ()
    
    for a, b in pairs(KnoxDev_CarThief_Config.NPC) do
        if a ~= 'NPC_Start' then
            KnoxDev_CarThief.DeleteNPC(a)
        end
    end
    for a, b in pairs(KnoxDev_CarThief_Config.Blip) do
        if a ~= 'NPC_Start' then
            KnoxDev_CarThief.DeleteBlip(a)
        end
    end

    for a, b in pairs(KnoxDev_CarThief.CameraList) do
        KnoxDev_CarThief.DeleteCamera(a)
    end

    for a, b in pairs(KnoxDev_CarThief.VehicleList) do
        DeleteVehicle(b)
    end

    KnoxDev_CarThief.Blip = {}
    KnoxDev_CarThief.NPCList = {}
    KnoxDev_CarThief.CameraList = {}
    KnoxDev_CarThief.VehicleList = {}
    KnoxDev_CarThief.Doing = false
    KnoxDev_CarThief.DoingJob = false
    KnoxDev_CarThief.EnteredInVehicle = false
    KnoxDev_CarThief.Position = false
    KnoxDev_CarThief.Minigame = false
end
