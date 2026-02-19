local ESX = exports["es_extended"]:getSharedObject()
local npc = nil

-- Spawn NPC
CreateThread(function()
    local model = GetHashKey(Config.NPCLokacija.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end

    npc = CreatePed(4, model, Config.NPCLokacija.coords.x, Config.NPCLokacija.coords.y, Config.NPCLokacija.coords.z - 1, Config.NPCLokacija.coords.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(model)

    exports.ox_target:addLocalEntity(npc, {
        {
            name = 'lokacije_menu',
            icon = 'fa-solid fa-map',
            label = Config.NPCLokacija.text,
            onSelect = function()
                OpenLokacijeMenu()
            end
        }
    })
end)

-- Odpri NUI meni
function OpenLokacijeMenu()
    local lokacije = {}
    for _, lok in ipairs(Config.Lokacije) do
        table.insert(lokacije, {
            ime = lok.ime,
            x = lok.coords.x,
            y = lok.coords.y,
            z = lok.coords.z,
            slika = lok.slika
        })
    end

    SendNUIMessage({
        action = "openMenu",
        lokacije = lokacije
    })

    SetNuiFocus(true, true)
end

-- Klik na lokacijo
RegisterNUICallback('teleport', function(data, cb)
    local ped = PlayerPedId()
    SetEntityCoords(ped, data.x, data.y, data.z)
    ESX.ShowNotification("Teleportiran si na " .. data.ime)
    
    -- Zapri meni
    SetNuiFocus(false, false)
    SendNUIMessage({action = "closeMenu"})
    cb('ok')
end)

-- Zapri meni
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({action = "closeMenu"})
    cb('ok')
end)
