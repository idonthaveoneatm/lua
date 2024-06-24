--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

local Workspace = cloneref(game:GetService("Workspace"))
local HttpService = cloneref(game:GetService("HttpService"))

getgenv().alreadySent = {}
getgenv().updating = false
getgenv().updating = true

local base64decode = crypt.base64decode or crypt.base64_decode or base64.decode or base64_decode

local function getMap()
    local rValue
    for _,map in ipairs(Workspace:GetChildren()) do
        if map.Name:find("Map") then
            rValue = map
            break
        end
    end
    if rValue then
        return rValue
    else
        task.wait()
        return getMap()
    end
end

local informationTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/table/"..getMap().Name..".lua"))()


local function checkIfAlreadySent(type, name, zone)
    if type == "World" then
        for _,info in ipairs(alreadySent) do
            if typeof(info) == "table" and info.Name == name then
                return true
            end
        end
    elseif type == "Machine" then
        for _,info in ipairs(alreadySent) do
            if typeof(info) == "table" and info.Name == name and info.Location == zone then
                return true
            end
        end
    elseif type == "Egg" then
        for _,info in ipairs(alreadySent) do
            if typeof(info) == "string" and info == name then
                return true
            end
        end
    end
    return false
end

local webhookLibrary = {}

function webhookLibrary.createMessage(properties)
    assert(properties.Url, "Url required")
    assert(properties.username, "username required")
    local requestTable = {
        Url = properties.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = {
            ["username"] = properties.username,
            ["content"] = properties.content or "",
            ["embeds"] = {}
        }
    }
    local webhookFunctions = {}
    local EmbedIndex = 0
    function webhookFunctions.addEmbed(title: string, color: number)
        assert(title, "title required")
        assert(color, "color required")

        EmbedIndex += 1
        local privateIndex = EmbedIndex

        table.insert(requestTable.Body.embeds, {
            ["title"] = title,
            ["color"] = tonumber(color),
            ["fields"] = {}
        })
        local embedFunctions = {}
        function embedFunctions.addField(name, value)
            assert(name, "name required")
            assert(value, "value required")
            table.insert(requestTable.Body.embeds[privateIndex].fields, {
                ["name"] = name,
                ["value"] = value
            })
        end
        return embedFunctions
    end
    function webhookFunctions.sendMessage()
        requestTable.Body = HttpService:JSONEncode(requestTable.Body)
        local response = request(requestTable)
        return response
    end
    return webhookFunctions
end

local function getNumber(str)
    return tonumber(string.match(str,'%d+'))
end

local function checkWorlds()
    local Map = getMap()
    local worldText = ""
    local worldTable = {}
    local newWorldFormat = [[
{
    Name = "%s",
    TeleportPart = CFrame.new(%s),
    FarmPart = CFrame.new(%s)
},
]]
    for _,world in ipairs(Map:GetChildren()) do
        if world.Name ~= "SHOP" and world:FindFirstChild("INTERACT") and world.INTERACT:FindFirstChild("BREAKABLE_SPAWNS") and world.INTERACT["BREAKABLE_SPAWNS"]:FindFirstChild("Main") then
            if not checkIfAlreadySent("World", world.Name) then
                table.insert(worldTable, world.Name)
                table.insert(alreadySent, {Name = world.Name})
            end
        end
    end
    table.sort(worldTable, function(a,b)
        return getNumber(a) < getNumber(b)
    end)
    for _,world in ipairs(worldTable) do
        local mapWorld = Map:FindFirstChild(world)
        local name = mapWorld.Name
        local FarmPart = tostring(mapWorld.INTERACT["BREAKABLE_SPAWNS"].Main.Position)
        local TeleportPart = tostring(mapWorld.PERSISTENT.Teleport.Position)
        
        worldText = worldText..newWorldFormat:format(name, TeleportPart, FarmPart)
    end

    local worldWebhook = webhookLibrary.createMessage({
        Url = base64decode("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTI1MzUwMjQ4MDI3NzU3MzY5My83VFpvdDFPZUpYcWFyMklhNUNvSHk0Z1JXcnZYQWFWYWNYeEkwMVFlb0hLNHRqcTBaOUoxcU1qVmFKbnNEZ0R2VHByag=="),
        username = "Update Required",
        content = tostring([[**Map:** ]]..getMap().Name..[[

**PlaceId:** ]]..tostring(game.PlaceId))
    })
    if #worldText >= 6000 then
        local numberOfEmbeds = 0
        local counter = #worldText
        local splitString = string.split(worldText, "")
        repeat
            task.wait()
            numberOfEmbeds += 1
            counter -= 3000
        until counter <= 0

        local stringIndex = 0
        for i=1, numberOfEmbeds do
            local privEmbed = worldWebhook.addEmbed("New Zones", 0x4FAD74)
            local partOfString = ""
            local stopAt = stringIndex + 3000
            repeat
                task.wait()
                stringIndex += 1
                if splitString[stringIndex] then
                    partOfString = partOfString..splitString[stringIndex]
                else
                    break
                end
            until stringIndex >= stopAt

            local splitPartString = string.split(partOfString, "")
            local counter2 = #partOfString
            local amountOfFields = 0
            local zoneStringIndex = 0
            repeat
                task.wait()
                counter2 -= 1018
                amountOfFields += 1
            until counter2 <= 0
            for i2=1, amountOfFields do
                local valueString = ""
                local startingIndex = zoneStringIndex + 1018
                repeat
                    task.wait()
                    zoneStringIndex += 1
                    if splitPartString[zoneStringIndex] then
                        valueString = valueString..splitPartString[zoneStringIndex]
                    else
                        break
                    end
                until zoneStringIndex >= startingIndex
                privEmbed.addField("Code", ([[```%s```]]):format(valueString))
            end

        end
    elseif #worldText >= 1018 then
        local privEmbed = worldWebhook.addEmbed("New Zones", 0x4FAD74)

        local splitPartString = string.split(worldText, "")
        local counter2 = #worldText
        local amountOfFields = 0
        local zoneStringIndex = 0
        repeat
            task.wait()
            counter2 -= 1018
            amountOfFields += 1
        until counter2 <= 0
        for i2=1, amountOfFields do
            local valueString = ""
            local startingIndex = zoneStringIndex + 1018
            repeat
                task.wait()
                zoneStringIndex += 1
                if splitPartString[zoneStringIndex] then
                    valueString = valueString..splitPartString[zoneStringIndex]
                else
                    break
                end
            until zoneStringIndex >= startingIndex
            privEmbed.addField("Code", ([[```%s```]]):format(valueString))
        end
    elseif #worldText < 1018 and worldText ~= "" then
        local privEmbed = worldWebhook.addEmbed("New Zones", 0x4FAD74)
        privEmbed.addField("Code", ([[```%s```]]):format(worldText))
    end
    if worldText ~= "" then
        worldWebhook.sendMessage()
    end
end

local function checkEggs()
    local zoneEggs = game.ReplicatedStorage['__DIRECTORY'].Eggs['Zone Eggs']
    local textTable = {}
    for _,egg in ipairs(zoneEggs["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
        if egg:IsA("ModuleScript") then
            if not checkIfAlreadySent("Egg", egg.Name) then
                table.insert(textTable,egg.Name)
                table.insert(alreadySent,egg.Name)
            end
        end
    end
    table.sort(textTable, function(a, b)
        return getNumber(a) < getNumber(b)
    end)
    local eggText = ""
    for _,name in ipairs(textTable) do
        eggText = eggText..'"'..name..'",\n'
    end
    local eggWebhook = webhookLibrary.createMessage({
        Url = base64decode("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTI1MzUwMjQ4MDI3NzU3MzY5My83VFpvdDFPZUpYcWFyMklhNUNvSHk0Z1JXcnZYQWFWYWNYeEkwMVFlb0hLNHRqcTBaOUoxcU1qVmFKbnNEZ0R2VHByag=="),
        username = "Update Required",
        content = tostring([[**Map:** ]]..getMap().Name..[[

**PlaceId:** ]]..tostring(game.PlaceId))
    })
    if #eggText >= 6000 then
        local numberOfEmbeds = 0
        local counter = #eggText
        local splitString = string.split(eggText, "")
        repeat
            task.wait()
            numberOfEmbeds += 1
            counter -= 3000
        until counter <= 0
    
        local stringIndex = 0
        for i=1, numberOfEmbeds do
            local privEmbed = eggWebhook.addEmbed("New Eggs", 0xEEF598)
            local partOfString = ""
            local stopAt = stringIndex + 3000
            repeat
                task.wait()
                stringIndex += 1
                if splitString[stringIndex] then
                    partOfString = partOfString..splitString[stringIndex]
                else
                    break
                end
            until stringIndex >= stopAt
    
            local splitPartString = string.split(partOfString, "")
            local counter2 = #partOfString
            local amountOfFields = 0
            local eggStringIndex = 0
            repeat
                task.wait()
                counter2 -= 1018
                amountOfFields += 1
            until counter2 <= 0
            for i2=1, amountOfFields do
                local valueString = ""
                local startingIndex = eggStringIndex + 1018
                repeat
                    task.wait()
                    eggStringIndex += 1
                    if splitPartString[eggStringIndex] then
                        valueString = valueString..splitPartString[eggStringIndex]
                    else
                        break
                    end
                until eggStringIndex >= startingIndex
                privEmbed.addField("Code", ([[```%s```]]):format(valueString))
            end
    
        end
    elseif #eggText >= 1018 then
        local privEmbed = eggWebhook.addEmbed("New Eggs", 0xEEF598)
    
        local splitPartString = string.split(eggText, "")
        local counter2 = #eggText
        local amountOfFields = 0
        local eggStringIndex = 0
        repeat
            task.wait()
            counter2 -= 1018
            amountOfFields += 1
        until counter2 <= 0
        for i2=1, amountOfFields do
            local valueString = ""
            local startingIndex = eggStringIndex + 1018
            repeat
                task.wait()
                eggStringIndex += 1
                if splitPartString[eggStringIndex] then
                    valueString = valueString..splitPartString[eggStringIndex]
                else
                    break
                end
            until eggStringIndex >= startingIndex
            privEmbed.addField("Code", ([[```%s```]]):format(valueString))
        end
    elseif #eggText < 1018 and eggText ~= "" then
        local privEmbed = eggWebhook.addEmbed("New Eggs", 0xEEF598)
        privEmbed.addField("Code", ([[```%s```]]):format(eggText))
    end
    if eggText ~= "" then
        eggWebhook.sendMessage()
    end
end

local function checkMachines()
    local Map = getMap()
    local machineText = ""
    local newMachineFormat = [[
{
    Name = "%s",
    Location = "%s"
},
]]
    for _,world in ipairs(Map:GetChildren()) do
        if world:FindFirstChild("INTERACT") and world.INTERACT:FindFirstChild("Machines") then
            for _,machine in ipairs(world.INTERACT.Machines:GetChildren()) do
                if not checkIfAlreadySent("Machine", machine.Name, world.Name) then
                    table.insert(alreadySent, {Name = machine.Name, Location = world.Name})
                    local name = machine.Name
                    local location = world.Name

                    machineText = machineText..newMachineFormat:format(name, location)
                end
            end
        end
    end
    local machineWebhook = webhookLibrary.createMessage({
        Url = base64decode("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTI1MzUwMjQ4MDI3NzU3MzY5My83VFpvdDFPZUpYcWFyMklhNUNvSHk0Z1JXcnZYQWFWYWNYeEkwMVFlb0hLNHRqcTBaOUoxcU1qVmFKbnNEZ0R2VHByag=="),
        username = "Update Required",
        content = tostring([[**Map:** ]]..getMap().Name..[[

**PlaceId:** ]]..tostring(game.PlaceId))
    })
    if #machineText >= 6000 then
        local numberOfEmbeds = 0
        local counter = #machineText
        local splitString = string.split(machineText, "")
        repeat
            task.wait()
            numberOfEmbeds += 1
            counter -= 3000
        until counter <= 0
    
        local stringIndex = 0
        for i=1, numberOfEmbeds do
            local privEmbed = machineWebhook.addEmbed("New Machines", 0x77659F)
            local partOfString = ""
            local stopAt = stringIndex + 3000
            repeat
                task.wait()
                stringIndex += 1
                if splitString[stringIndex] then
                    partOfString = partOfString..splitString[stringIndex]
                else
                    break
                end
            until stringIndex >= stopAt
    
            local splitPartString = string.split(partOfString, "")
            local counter2 = #partOfString
            local amountOfFields = 0
            local machineStringIndex = 0
            repeat
                task.wait()
                counter2 -= 1018
                amountOfFields += 1
            until counter2 <= 0
            for i2=1, amountOfFields do
                local valueString = ""
                local startingIndex = machineStringIndex + 1018
                repeat
                    task.wait()
                    machineStringIndex += 1
                    if splitPartString[machineStringIndex] then
                        valueString = valueString..splitPartString[machineStringIndex]
                    else
                        break
                    end
                until machineStringIndex >= startingIndex
                privEmbed.addField("Code", ([[```%s```]]):format(valueString))
            end
    
        end
    elseif #machineText >= 1018 then
        local privEmbed = machineWebhook.addEmbed("New Machines", 0x77659F)
    
        local splitPartString = string.split(machineText, "")
        local counter2 = #machineText
        local amountOfFields = 0
        local machineStringIndex = 0
        repeat
            task.wait()
            counter2 -= 1018
            amountOfFields += 1
        until counter2 <= 0
        for i2=1, amountOfFields do
            local valueString = ""
            local startingIndex = machineStringIndex + 1018
            repeat
                task.wait()
                machineStringIndex += 1
                if splitPartString[machineStringIndex] then
                    valueString = valueString..splitPartString[machineStringIndex]
                else
                    break
                end
            until machineStringIndex >= startingIndex
            privEmbed.addField("Code", ([[```%s```]]):format(valueString))
        end
    elseif #machineText < 1018 and machineText ~= "" then
        local privEmbed = machineWebhook.addEmbed("New Machines", 0x77659F)
        privEmbed.addField("Code", ([[```%s```]]):format(machineText))
    end
    if machineText ~= "" then
        machineWebhook.sendMessage()
    end
end

for i,v in informationTable do
    for _,v2 in v do
        table.insert(alreadySent, v2)
    end
end
task.wait(2)

task.spawn(function()
    while task.wait() and updating do
        checkWorlds()
        checkEggs()
        checkMachines()
    end
end)
