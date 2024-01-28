local UgCore = exports['ug-core']:GetCore()
local ResetStress = false

RegisterNetEvent('ug-hud:Server:GainStress', function(amount)
    local src = source
    local player = UgCore.Functions.GetPlayer(src)
    local newStress
    if not player or (Config.DisablePoliceStress and player.job.name == 'police') then return end
    if not ResetStress then
        if not player.Functions.GetData('stress') then
            player.Functions.SetData('stress', 0)
        end
        newStress = player.Functions.GetData('stress') + amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    player.Functions.SetData('stress', newStress)
    TriggerClientEvent('ug-hud:Client:UpdateStress', src, newStress)
end)

RegisterNetEvent('ug-hud:Server:RelieveStress', function(amount)
    local src = source
    local player = UgCore.Functions.GetPlayer(src)
    local newStress
    if not player then return end
    if not ResetStress then
        if not player.Functions.GetData('stress') then
            player.Functions.SetData('stress', 0)
        end
        newStress = player.Functions.GetData('stress') - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    player.Functions.SetData('stress', newStress)
    TriggerClientEvent('ug-hud:Client:UpdateStress', src, newStress)
    --TriggerClientEvent('QBCore:Notify', src, Lang:t("notify.stress_removed"))
end)

RegisterNetEvent('ug-hud:Server:saveUIData', function(data)
    local src = source
    local player = UgCore.Functions.GetPlayer(src)
	-- Check Permissions
    if not player then return end

    if not player.Functions.GetGroup(src, 'admin') and not IsplayerAceAllowed(src, 'command') then
		return
	end

    local uiConfigData = { }
    uiConfigData.icons = { }

    local path = GetResourcePath(GetCurrentResourceName())
    path = path:gsub('//', '/')..'/uiconfig.lua'
    local file = io.open(path, 'w+')

    local heading = "UIConfig = { }\n"
    file:write(heading)

    -- write out icons
    file:write("\nUIConfig.icons = { }\n")
    
    -- Sort the icons so its easier to find in the config file
    local iconKeys = { }
    for k, _ in pairs(data.icons) do
        iconKeys[#iconKeys + 1] = k
    end
    table.sort(iconKeys)

    for _, iconName in ipairs(iconKeys) do
        uiConfigData.icons[iconName] = {}

        local iconLabel = "\nUIConfig.icons['"..iconName.."'] = {"
        file:write(iconLabel)

        -- sort the values as well inside icons
        local iconValues = {}
        for k, _ in pairs(data.icons[iconName]) do
            table.insert(iconValues, k)
        end
        table.sort(iconValues)

        for _, iconValueName in ipairs(iconValues) do
            local str
            local v = data.icons[iconName][iconValueName]
            uiConfigData.icons[iconName][iconValueName] = v
            if type(v) == "string" then
                str = ("\n    %s = '%s',"):format(iconValueName, v)
            else
                str = ("\n    %s = %s,"):format(iconValueName, v)
            end
            file:write(str)
        end
        file:write("\n}\n")
    end


    --local layoutLabel = "\nUIConfig.layout = '"..data.layout.."'\n"
    local layoutLabel = "\nUIConfig.layout = {"
    file:write(layoutLabel)
    for layoutName, layoutVal in pairs(data.layout) do
        local str
        if type(layoutVal) == "string" then
            str = ("\n    %s = '%s',"):format(layoutName, layoutVal)
        else
            str = ("\n    %s = %s,"):format(layoutName, layoutVal)
        end
        file:write(str)
    end
    file:write("\n}\n")
    uiConfigData.layout = data.layout


    -- write out color icons info
    file:write("\nUIConfig.colors = {}\n")
    uiConfigData.colors = {}

    -- Sort the color keys
    local colorKeys = {}
    for k, _ in pairs(data.colors) do
        table.insert(colorKeys, k)
    end
    table.sort(colorKeys)

    for _, colorName in ipairs(colorKeys) do
        uiConfigData.colors[colorName] = {}
        uiConfigData.colors[colorName].colorEffects = {}

        local colorLabel = "\nUIConfig.colors['"..colorName.."'] = {"
        file:write(colorLabel)

        local colorEffectsLabel = "\n    colorEffects = {"
        file:write(colorEffectsLabel)

        for k, v in ipairs(data.colors[colorName].colorEffects) do
            local colorEffectIndexLabel = "\n        ["..k.."] = {"
            file:write(colorEffectIndexLabel)

            -- sort the values as well inside color effects
            local colorEffect = data.colors[colorName].colorEffects[k]
            local colorEffectkeys = {}
            for scekey, _ in pairs(colorEffect) do
                table.insert(colorEffectkeys, scekey)
            end
            table.sort(colorEffectkeys)

            table.insert(uiConfigData.colors[colorName].colorEffects, colorEffect)

            for _, CEKey in ipairs(colorEffectkeys) do
                local str
                if type(colorEffect[CEKey]) == "string" then
                    str = ("\n            %s = '%s',"):format(CEKey, colorEffect[CEKey])
                else
                    str = ("\n            %s = %s,"):format(CEKey, colorEffect[CEKey])
                end
                file:write(str)
            end
            file:write("\n        },")
        end
        file:write("\n    },")
        file:write("\n}\n")
    end

    file:close()

    UIConfig = uiConfigData

    -- -1 to send to all players
    TriggerClientEvent('ug-hud:Client:UpdateUISettings', 1, uiConfigData)
end)

UgCore.Callbacks.CreateCallback('ug-hud:Server:getMenu', function(source, cb)
    cb(Config.Menu)
end) 


UgCore.Callbacks.CreateCallback('ug-hud:Server:getRank', function(source, cb)
    local player = UgCore.Functions.GetPlayer(source)

    if player then
        local playerGroup = player.Functions.GetGroup()

        if playerGroup then 
            cb(true)
        else
            cb(true)
        end
    else
        cb(true)
    end
end)