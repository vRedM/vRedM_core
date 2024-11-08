RegisterNetEvent('vRedM:playerSpawn', function()
    local _source = source
    local identifier = GetSteamID(_source)

    if not identifier then
        return print("user cant load no identifier steam found")
    end
    _usersLoading[identifier] = false

    local user = _users[identifier]
    if not user then
        return
    end

    user.Source(_source)

    local numCharacters = user.Numofcharacters()

    if numCharacters <= 0 then
        return TriggerClientEvent("vRedM:startCharacterCreator", _source)
    else
        if tonumber(user._charperm) > 1 then
            return TriggerEvent("vorp_character:server:GoToSelectionMenu", _source)
        else
            return TriggerEvent("vorp_character:server:SpawnUniqueCharacter", _source)
        end
    end
end)