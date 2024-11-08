local function toggleNuiFrame(shouldShow, windowId)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', { visible = shouldShow, windowId = windowId })
end

RegisterCommand('show-nui1', function()
  toggleNuiFrame(true, "window1")
  debugPrint('Show NUI frame 1')
end)

RegisterCommand('show-nui2', function()
  toggleNuiFrame(true, "window2")
  debugPrint('Show NUI frame 2')
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false, nil) -- Cache toutes les fenêtres
  debugPrint('Hide NUI frame')
  cb({})
end)


RegisterNUICallback('TriggerUI1', function(data)
  print("This event was triggered in the 1st UI")
end)

RegisterNUICallback('TriggerUI2', function(data)
  print("This event was triggered in the 2nd UI")
end)

RegisterNetEvent("vRedM:startCharacterCreator")
AddEventHandler("vRedM:startCharacterCreator", function()
	-- exports.weathersync:setSyncEnabled(false)
	ShutdownLoadingScreen()
	-- ShowBusyspinnerWithText(T.Other.spinnertext2)
	Wait(500)
	InCharacterCreator = true
  toggleNuiFrame(true, "CharacterCreation")
	Wait(2000)
	-- BusyspinnerOff()
	Setup()
end)


-- request char creator imaps
local function Setup()
	Citizen.InvokeNative(0x513F8AA5BF2F17CF, -561.4, -3782.6, 237.6, 50.0, 20)                                 -- loadshpere
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area", true, true)                   -- load sound
	Citizen.InvokeNative(0x9748FA4DE50CCE3E, "AZL_RDRO_Character_Creation_Area_Other_Zones_Disable", false, true) -- load sound
	RequestImapCreator()
	NetworkClockTimeOverride(10, 0, 0, 0, true)
	SetTimecycleModifier('Online_Character_Editor')
	StartPlayerTeleport(PlayerId(), -561.22, -3776.26, 239.16, 93.2, true, true, true, true)

	repeat Wait(0) until not IsPlayerTeleportActive()

	if not HasCollisionLoadedAroundEntity(PlayerPedId()) then
		RequestCollisionAtCoord(-561.22, -3776.26, 239.16)
	end

	repeat Wait(0) until HasCollisionLoadedAroundEntity(PlayerPedId())

	local cam = SetupCameraCharacterCreationSelect()
	local animscene, peds = SetupAnimscene()

	LoadAnimScene(animscene)
	repeat Wait(0) until Citizen.InvokeNative(0x477122B8D05E7968, animscene)

	StartAnimScene(animscene)

	DoScreenFadeIn(3000)
	repeat Wait(0) until IsScreenFadedIn()

	repeat Wait(0) until Citizen.InvokeNative(0xCBFC7725DE6CE2E0, animscene)

	SetCamParams(cam, vec3(-562.15, -3776.22, 239.11), vec3(-4.71, 0.0, -93.14), 45.0, 0, 1, 1, 2, 1, 1)

	Wait(1000)
	exports[GetCurrentResourceName()]:_UI_FEED_POST_OBJECTIVE(-1,
		'~INPUT_CREATOR_MENU_TOGGLE~' .. T.Other.GenderChoice .. '~INPUT_CREATOR_ACCEPT~')
	SetCamFocusDistance(cam, 4.0)

	local char = 1
	while true do
		if IsControlJustPressed(0, `INPUT_CREATOR_MENU_TOGGLE`) then
			char = (char + 1) % 2
			local view = Config.Intro.views[char + 1]
			if view then
				SetCamParams(cam, view.pos.x, view.pos.y, view.pos.z, view.rot.x, view.rot.y, view.rot.z, view.fov, 1200,
					1, 1, 2, 1, 1)
				SetCamFocusDistance(cam, 4.0)

				local transEnd = false
				Citizen.SetTimeout(1200, function()
					transEnd = true
				end)

				while not transEnd do
					Citizen.Wait(0)
				end
			end
		end

		if IsControlJustPressed(0, `INPUT_CREATOR_ACCEPT`) then
			break
		end

		Wait(0)
	end

	UiFeedClearChannel()
	local ped = peds[char + 1]
	local gender = IsPedMale(ped) and "Male" or "Female"
	Citizen.InvokeNative(0xAB5E7CAB074D6B84, animscene, ("Pl_Start_to_Edit_%s"):format(gender))
	while not (Citizen.InvokeNative(0x3FBC3F51BF12DFBF, animscene, Citizen.ResultAsFloat()) > 0.2) do
		Citizen.Wait(0)
	end

	SetCamParams(cam, vec3(-561.82, -3780.97, 239.08), vec3(-4.21, 0.0, -87.88), 30.0, 0, 1, 1, 2, 1, 1)
	N_0x11f32bb61b756732(cam, 1.0)

	while not (N_0xd8254cb2c586412b(animscene) == 1) do
		Citizen.Wait(0)
	end
	Citizen.InvokeNative(0x84EEDB2C6E650000, animscene) -- delete animscene
	RegisterGenderPrompt()

	if gender ~= "Male" then
		CreatePlayerModel("mp_female", peds)
	else
		CreatePlayerModel("mp_male", peds)
	end
end