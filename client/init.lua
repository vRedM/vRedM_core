-- Initializing the Spawn 
AddEventHandler('playerSpawned', function()
    DoScreenFadeOut(0)
    TriggerServerEvent('vRedM:server:SetPlayerRoutingBucket', GetRandomIntInRange(0, 0xFFFFFFFF))
    Citizen.InvokeNative(0x1E5B70E53DB661E5, 0, 0, 0, T.Hold, T.Load, T.Almost) --_DISPLAY_LOADING_SCREENS
    DisplayRadar(false)
    SetMinimapHideFow(false)
    Wait(2000)
    TriggerServerEvent("vRedM:playerSpawn")
    SetTimeout(7000, function()
        ShutdownLoadingScreen()
    end)
    SetEntityCanBeDamaged(PlayerPedId(), false)
    CreateThread(function()
        while not LocalPlayer.state.IsInSession do
            Wait(0)
            DisableControlAction(0, `INPUT_MP_TEXT_CHAT_ALL`, true)
            DisableControlAction(0, `INPUT_QUICK_USE_ITEM`, true)
        end
    end)
end)