local Workspace = cloneref(game:GetService("Workspace"))
local HttpService = cloneref(game:GetService("HttpService"))

local informationTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/informationTable.lua"))()
local alreadySent = {}

local base64decode = crypt.base64decode or crypt.base64_decode or base64.decode or base64_decode

local function getMap()
    local rValue
    for _,map in ipairs(Workspace:GetChildren()) do
        if map.Name:find("Map") then
            rValue = map
            break
        end
    end
    return rValue
end

local function sendWebhook(type, code)
    if code ~= "" and base64decode then
        print(type, code)
        local decoded = base64decode("aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTI1MzUwMjQ4MDI3NzU3MzY5My83VFpvdDFPZUpYcWFyMklhNUNvSHk0Z1JXcnZYQWFWYWNYeEkwMVFlb0hLNHRqcTBaOUoxcU1qVmFKbnNEZ0R2VHByag==")
        code = ([[```
%s
```]]):format(code)
        local data = {
            ["username"] = "Update Required",
            ["content"] = "",
            ["embeds"] = {
                {
                    ["title"] = "New Information",
                    ["color"] = tonumber(0x58b9ff),
                    ["fields"] = {
                        {
                            ["name"] = "PlaceId",
                            ["value"] = tostring(game.PlaceId)
                        },
                        {
                            ["name"] = "Map",
                            ["value"] = tostring(getMap().Name)
                        },
                        {
                            ["name"] = "Type",
                            ["value"] = type
                        },
                        {
                            ["name"] = "Code",
                            ["value"] = code
                        }
                    }
                }
            }
        }
        local request = request or httprequest or http_request
        request({
            Url = decoded,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end
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
},]]
    for _,world in ipairs(Map:GetChildren()) do
        if world.Name ~= "SHOP" and world["PARTS_LOD"]:FindFirstChild("GROUND") then
            if not table.find(alreadySent, world.Name) then
                table.insert(worldTable, world.Name)
                table.insert(alreadySent, world.Name)
            end
        end
    end
    table.sort(worldTable, function(a,b)
        return getNumber(a) < getNumber(b)
    end)
    for _,world in ipairs(worldTable) do
        local mapWorld = Map:FindFirstChild(world)
        local name = mapWorld.Name
        local FarmPart
        local TeleportPart = tostring(mapWorld.PERSISTENT.Teleport.Position)
        for _,v in ipairs(mapWorld["PARTS_LOD"]:FindFirstChild("GROUND"):GetChildren()) do
            if v:IsA("Part") and v.Name == "Ground" then
                FarmPart = tostring(v.Position)
                break
            end
        end
        worldText = worldText..newWorldFormat:format(name, TeleportPart, FarmPart)
    end
    sendWebhook("New Worlds", worldText)
end

local function checkEggs()
    local zoneEggs = game.ReplicatedStorage['__DIRECTORY'].Eggs['Zone Eggs']
    local textTable = {}
    for _,egg in ipairs(zoneEggs:GetDescendants()) do
        if egg:IsA("ModuleScript") and not table.find(alreadySent, egg.Name) then
            table.insert(textTable,egg.Name)
            table.insert(alreadySent,egg.Name)
        end
    end
    table.sort(textTable, function(a, b)
        return getNumber(a) < getNumber(b)
    end)
    tableText = ""
    for _,name in ipairs(textTable) do
        tableText = tableText..'"'..name..'",\n'
    end
    sendWebhook("New Eggs", tableText)
end

local function checkMachines()
    local Map = getMap()
    local machineText = ""
    local newMachineFormat = [[
{
    Name = "%s",
    Location = "%s"
},]]
    for _,world in ipairs(Map:GetChildren()) do
        if world:FindFirstChild("INTERACT") and world.INTERACT:FindFirstChild("Machines") then
            for _,machine in ipairs(world.INTERACT.Machines:GetChildren()) do
                if not table.find(alreadySent, machine.Name) then
                    table.insert(alreadySent, machine.Name)
                    local name = machine.Name
                    local location = world.Name

                    machineText = machineText..newMachineFormat:format(name, location)
                end
            end
        end
    end
    sendWebhook("New Machines", machineText)
end

local currentMapInfo = informationTable[getMap().Name]

for _,v in ipairs(currentMapInfo.Worlds) do
    table.insert(alreadySent, v.Name)
end
for _,v in ipairs(currentMapInfo.Eggs) do
    table.insert(alreadySent, v)
end
for _,v in ipairs(currentMapInfo.VendingMachines) do
    table.insert(alreadySent, v.Name)
end
for _,v in ipairs(currentMapInfo.Rewards) do
    table.insert(alreadySent, v.Name)
end
for _,v in ipairs(currentMapInfo.OtherMachines) do
    table.insert(alreadySent, v.Name)
end

task.spawn(function()
    while task.wait() do
        checkWorlds()
        task.wait(2)
        checkEggs()
        task.wait(2)
        checkMachines()
    end
end)
