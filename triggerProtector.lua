local haveSended = {}
local res = GetCurrentResourceName()

fatihterim = RegisterServerEvent 

RegisterServerEvent = function(name, cb)
    if haveSended[name] then return end
    Citizen.CreateThread(function()
        local src = source 
        Citizen.Wait(math.random(300, 800))
        exports['wtx_antitriggers']:RegisterServerEvent({
            name = name,
            resource = res,
            src = src
        })
        return fatihterim(name, cb)
    end)
end