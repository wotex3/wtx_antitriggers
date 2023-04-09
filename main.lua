local registeredEvents = {}
local ratelimitOnEvent = {}

exports('RegisterServerEvent', function(data)
    CreateThread(function()
        local src = data.src  
        local name = data.name
        local resource = data.resource     
        if Config['ignoredTriggers'][name] then return end
        Citizen.Wait(800) -- WAIT FOR THE REAL EVENT LOAD
        if not registeredEvents[name] then 
            registeredEvents[name] = true
            RegisterNetEvent(name)
            AddEventHandler(name, function()
                local _src = source
                if not ratelimitOnEvent[name] then 
                    ratelimitOnEvent[name] = {}
                end
                if not ratelimitOnEvent[name][_src] then 
                    ratelimitOnEvent[name][_src] = {
                        limit = 0,
                        lastTriggered = os.time()
                    }
                end
                if ratelimitOnEvent[name][_src].limit > 5 then 
                    Config['ban'](_src, "Trigger Protector", ("Triggered '%s' too many times"):format(name))
                    return CancelEvent()
                end
                ratelimitOnEvent[name][_src].limit = ratelimitOnEvent[name][_src].limit + 1
                Citizen.Wait(Config['secondsToClearLimit'] + math.random(500, 800))
                if os.time() + Config['secondsToClearLimit'] - ratelimitOnEvent[name][_src].lastTriggered then -- LİMİT RESET AFTER 5 SECONDS
                    ratelimitOnEvent[name][_src].limit = 0
                    ratelimitOnEvent[name][_src].lastTriggered = os.time()
                end
            end) 
        end              
    end)
end)

dump = function(data)
    i = 0 
    for k,v in pairs(data) do 
        i = i + 1 
    end 
    return i 
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    print(('^2We are protecting ^1%s^2 triggers right now^0'):format(dump(registeredEvents)))
end)

RegisterCommand('wtx_install', function(_src)
    if _src == 0 then
        local pC = LoadResourceFile(GetCurrentResourceName(), "triggerProtector.lua")
        for rn = 0, GetNumResources() - 1 do
            local res = GetResourceByFindIndex(rn)
            local fxmanifest = LoadResourceFile(res, "fxmanifest.lua")
            if fxmanifest then 
                edittedManifest = "server_script 'triggerProtector.lua'\n\n"..fxmanifest 
                SaveResourceFile(res, 'triggerProtector.lua', pC, -1)
                SaveResourceFile(res, "fxmanifest.lua", edittedManifest, -1)
            end 
            print('Trigger Protector installed to ' .. res .. '')
            Citizen.Wait(100)
        end
        print('Trigger Protector installed to all resources. Dont forget to restart your server. If you have any problem, please contact me on discord: wotex#7415')
    end
end)