Namedinstances = {}
math.randomseed(os.time())

-- credits to MrDankKetchup
RegisterServerEvent("vRedM:instanceplayers")
AddEventHandler("vRedM:instanceplayers", function(setRoom)
    local src = source
    local instanceSource = nil

    -- if setRoom is 0, then we are leaving the instance
    if setRoom == 0 then
        for k, v in pairs(Namedinstances) do
            for k2, v2 in pairs(v.people) do
                if v2 == src then
                    table.remove(v.people, k2)
                end
            end
            if #v.people == 0 then
                Namedinstances[k] = nil
            end
        end
        instanceSource = setRoom
    else
        for k, v in pairs(Namedinstances) do
            if v.name == setRoom then
                instanceSource = k
            end
        end

        if instanceSource == nil then
            instanceSource = math.random(1, 63)

            while Namedinstances[instanceSource] and #Namedinstances[instanceSource] >= 1 do
                instanceSource = math.random(1, 63)
                Wait(1)
            end
        end
    end

    if instanceSource ~= 0 then
        if not Namedinstances[instanceSource] then
            Namedinstances[instanceSource] = {
                name = setRoom,
                people = {}
            }
        end

        table.insert(Namedinstances[instanceSource].people, src)
    end

    SetPlayerRoutingBucket(
        src,
        instanceSource
    )

    TriggerClientEvent('vRedM:instanceChanged', src, instanceSource)
end)

RegisterServerEvent('vRedM:server:SetPlayerRoutingBucket', function(bucket)
    local _source = source
    SetPlayerRoutingBucket(_source, bucket)
end)
