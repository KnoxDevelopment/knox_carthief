KnoxDev_CarThief_Config = {}

KnoxDev_CarThief_Config.Distance = 5.0 --Interact

KnoxDev_CarThief_Config.UseESX = true 

KnoxDev_CarThief_Config.UseItem = 'lockpick' -- if you set '' , is false

KnoxDev_CarThief_Config.LockPick_Time = math.random(11000,15000)

KnoxDev_CarThief_Config.Time_Remaining = 150 --Seconds
KnoxDev_CarThief_Config.Time_Update_GPS = 10 --Seconds
KnoxDev_CarThief_Config.Time_Remove_GPS = 1 -- Minutes
KnoxDev_CarThief_Config.Time_Remaining_Vehicle = 30 -- Seconds | You have * seconds to go back to the vehicle, if you don't go back everything is cancelled
KnoxDev_CarThief_Config.Time_Hacking = 50 --Seconds

KnoxDev_CarThief_Config.Reward = 'money' --Item
KnoxDev_CarThief_Config.Quantity = math.random(20000,40000)

KnoxDev_CarThief_Config.FDO = {
    'lspd'
}

KnoxDev_CarThief_Config.NPC = {
    ['NPC_Start'] = {
        coords = vec4(-428.63293457031, -1728.2821044922, 18.783826828003, 75.38117980957),
        cam = vec4(-429.44207763672, -1725.7347412109, 20.33834457397, 185.03504943848),
        model = 'ig_claypain',
        anim_dict = 'misscarsteal4@actor',
        anim = 'actor_berating_loop',
        image = 'https://cdn.discordapp.com/attachments/1134973139915382805/1142862503626424361/image-removebg-preview_1.png',
        npc_dialog = {
            [1] = 'Hey bro, are you looking for a job?',
            [2] = 'Do you really want to risk it?',
            [3] = 'Now my friend will tell you what to do',
        },
        player_dialog = {
            [1] = 'Yes, I really need it!',
            [2] = 'Always!',
            [3] = 'OK boss',
        }
    }
}

KnoxDev_CarThief_Config.Key = {
    ['Accept_Call'] = 'G',
    ['Reject_Call'] = 'H',
}

KnoxDev_CarThief_Config.Blip = {
    ['NPC_Start'] = {
        coords = vec3(-428.63293457031, -1728.2821044922, 18.783826828003),
        name = 'CarThief',
        sprite = 380,
        color = 1,
        size = 0.7
    },
    ['Destination'] = {
        name = 'Destination: Vehicle',
        sprite = 620,
        color = 1,
        size = 0.7
    },
    ['CarThief'] = {
        name = 'Car Thief: Position',
        sprite = 620,
        color = 1,
        size = 0.7
    },
    ['Delivery'] = {
        name = 'Delivery',
        sprite = 207,
        color = 1,
        size = 0.7
    }
}


KnoxDev_CarThief_Config.Interaction = function (name)
    if name == 'NPC_Start' then
        local options  = {
            {
                name = 'knoxdev_carthief:startjob',
                event = 'knoxdev_carthief:startjob',
                icon = 'fa-solid fa-car-burst',
                label = KnoxDev_CarThief_Config.Lang['Start_Thief']
            }
        }


        exports.ox_target:addLocalEntity(KnoxDev_CarThief.ReturnNPC(name),options)
    elseif name == 'Delivery' then
        local options  = {
            {
                name = 'knoxdev_carthief:delivery',
                event = 'knoxdev_carthief:delivery',
                icon = 'fa-solid fa-car-burst',
                label = KnoxDev_CarThief_Config.Lang['Delivery_NPC']
            }
        }


        exports.ox_target:addLocalEntity(KnoxDev_CarThief.ReturnNPC(name),options)
    end
end

KnoxDev_CarThief_Config.CallDialog = {
    ['NPC_IMAGE'] = 'https://cdn.discordapp.com/attachments/1134973139915382805/1142930943921881138/image.png',
    ['NPC_MODEL'] = 'u_m_m_streetart_01',
    ['NPC'] = {
        [1] = 'Hey buddy, you\'re Redley\'s friend right?',
        [2] = 'A few questions, How is he dressed?',
        [4] = 'Come on mate, I\'m sending you camera access for you to see the vehicle'
    },
    ['PLAYER'] = {
        [1] = 'Yes, mh he didn\'t tell me the name but I think so',
        [2] = 'I don\'t have to get engaged, let me think',
        [3] = 'RED!',
    },
}

KnoxDev_CarThief_Config.VehicleSpawn = {
    [1] = {
        vehiclespawn = 'adder',
        spawnvehicle = vec4(464.26840209961, -1683.9028320313, 29.291473388672, 52.5595703125),
        cam = vec4(463.61587524414, -1675.4525146484, 31.291469573975, 172.5708770752),
        npcspawn = vec4(461.23483276367, -1685.1018066406, 28.287048339844, 290.69848632813)
    }
}

KnoxDev_CarThief_Config.Delivery = {
    vec4(2055.9428710938, 3454.2834472656, 43.779773712158, 149.98034667969),
    vec4(-1577.9450683594, 5165.259765625, 19.509815216064, 349.33615112305),
    vec4(659.9814453125, -2668.5458984375, 6.0809850692749, 276.29348754883),
    vec4(-1913.9937744141, 2047.318359375, 140.7367401123, 355.4680480957)
}

KnoxDev_CarThief_Config.Ban = function ()
    --Insert Server Event anticheat
end

KnoxDev_CarThief_Config.Lang = {
    ['Start_Thief'] = 'Start Car Thief',
    ['Delivery_NPC'] = 'Vehicle Delivery',
    ['Wait_After_Start'] = 'Waiting a call...',
    ['Request_Call'] = '['..KnoxDev_CarThief_Config.Key['Accept_Call']..'] Accept | ['..KnoxDev_CarThief_Config.Key['Reject_Call']..'] Reject',
    ['Rejected_Call'] = 'You rejected the call',
    ['Do_not_look_at_me'] = 'Don\'t look at me while I take pictures!',
    ['Destination'] = 'I gave you the location, next time don\'t look at me!',
    ['Key_LockPicking'] = 'Press [E] to lockpick',
    ['Failed_NoItem'] = 'You made me look bad! You could have at least one lock pick',
    ['Lockpicking'] = 'Lockpicking...',
    ['Do_Not_Abandon_Vehicle'] = 'Do not abandon the vehicle or you will receive nothing!',
    ['Time'] = 'Seconds Left:',
    ['Time_Vehicle'] = 'Seconds left to return to vehicle:',
    ['Press_E_For_Remove_GPS'] = 'Press [E] to remove the tracker',
    ['AlredyCarThief'] = 'There is already an active carthief!',
    ['Delivery'] = 'Take the vehicle to its destination and deliver it!',
    ['Failed'] = 'You failed, congratulations!',
    ['Reward'] = 'You have received x%s %s',
}

KnoxDev_CarThief_Config.Notify = function (msg)
    ESX.ShowNotification(msg)
end
