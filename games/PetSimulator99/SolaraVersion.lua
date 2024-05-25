--game:GetService("ReplicatedStorage").Network
--[[

Made by griffindoescooking

]]--

print("Pet Simulator 99 | griffindoescooking")
warn('This removes require functions and the "Collect Orbs" toggle')

repeat
    task.wait()
until game:IsLoaded()
if game.PlaceId ~= 8737899170 and game.PlaceId ~= 16498369169 then
    game.Players.LocalPlayer:Kick("wrong game")
end

-- Compatibility Check

local function checkFunctions()
    local functionNames = ""
    if not isfile then
        functionNames = functionNames.."isfile "
    end
    if not writefile then
        functionNames = functionNames.."writefile "
    end
    if not readfile then
        functionNames = functionNames.."readfile "
    end
    if not isfolder then
        functionNames = functionNames.."isfolder "
    end
    if not makefolder then
        functionNames = functionNames.."makefolder "
    end
    if not cloneref then
        functionNames = functionNames.."cloneref "
    end
    if not setclipboard then
        functionNames = functionNames.."setclipboard "
    end
    return functionNames
end


local missingFunctions = checkFunctions()
if missingFunctions ~= "" then
    return error("Missing: "..missingFunctions)
end

-- Variables

local VirtualUser = cloneref(game:GetService("VirtualUser"))
local HttpService = cloneref(game:GetService("HttpService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local ClientNetwork = ReplicatedStorage.Network

local LocalPlayer = Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart", true)
local Debris = Workspace['__DEBRIS']
local Things = Workspace["__THINGS"]
local Instances = Things.Instances
local instanceContainer = Things["__INSTANCE_CONTAINER"]
local Lootbags = Things.Lootbags
local Breakables = Things.Brea
local Map
repeat
    task.wait()
until Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Map2")
Map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Map2")

-- Configuration File

getgenv().config = getgenv().config
local isFirstTime = false
local configTemplate = {
    farmSettings = {
        breakObjects = false,
        singleTarget = false,
        breakRadius = 70,
        waitTime = 0.2,
        buyZones = false,
        collectLootbags = false,
        collectOrbs = false
    },
    eggSettings = {
        openEggs = false,
        selectedEgg = "",
        openAmount = 1
    },
    minigameSettings = {
        farmFishing = false
    },
    rewardSettings = {
        collectTimeRewards = false,
        collectSpinnerTicket = false,
        teleportAndStay = false
    },
    miscSettings = {
        antiAFK = false,
        stairwayToHeaven = false
    }
}
if not isfolder("griffins configs") then
    isFirstTime = true
    makefolder("griffins configs")
else
    isFirstTime = false
end
if not isfile("griffins configs/8737899170.config") then
    isFirstTime = true
    writefile("griffins configs/8737899170.config", "")
else
    isFirstTime = false
end
if isFirstTime then
    writefile("griffins configs/8737899170.config", HttpService:JSONEncode(configTemplate))
end
local function updateConfig(arg1,arg2)
    arg1 = arg2
    writefile("griffins configs/8737899170.config", HttpService:JSONEncode(getgenv().config))
end

-- Tables

for _,connection in ipairs(getgenv().connections) do
    if typeof(connection) == "table" then
        for _,c2 in ipairs(connection) do
            c2:Disconnect()
        end
    else
        connection:Disconnect()
    end
end
getgenv().connections = getgenv().connections or {}
connections.zones = connections.zones or {}
getgenv().coinQueue = {} -- needs to be global to clear it on reexecute
local PS99Info = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/informationTable.lua"))()[Map().Name]

local worlds = PS99Info.Worlds
local vendingMachines = PS99Info.VendingMachines
local rewards = PS99Info.Rewards
local otherMachines = PS99Info.OtherMachines
local minigames = PS99Info.Minigames
local eggs = PS99Info.Eggs
local miscInfo = PS99Info.MiscInfo
local function getNames(tbl)
    local returnTable = {}
    for _,info in ipairs(tbl) do
        table.insert(returnTable, info.Name)
    end
    return returnTable
end
local function findInTable(tbl, name)
    for index,info in ipairs(tbl) do
        if info.Name == name then
            return worlds[index]
        end
    end
end

-- Functions

local function XZDist(obj1, obj2)
    local PosX1, PosZ1 = obj1.CFrame.X, obj1.CFrame.Z
    local PosX2, PosZ2 = obj2.CFrame.X, obj2.CFrame.Z
    return math.sqrt(math.pow(PosX1 - PosX2, 2) + math.pow(PosZ1 - PosZ2, 2))
end
local function findNearestBreakable()
    local distance = config.farmSettings.breakRadius
    local closest
    for _, breakable in ipairs(Breakables:GetChildren()) do
        if breakable:FindFirstChild("Hitbox", true) then
            local hitbox = breakable:FindFirstChild("Hitbox", true)
            if XZDist(hitbox, HumanoidRootPart) <= distance then
                closest = breakable
                distance = XZDist(hitbox, HumanoidRootPart)
            end
        end
    end
    return closest
end
local function isBreakableInRadius(breakable)
    if breakable:FindFirstChild("Hitbox", true) and XZDist(breakable:FindFirstChild("Hitbox", true), HumanoidRootPart) <= config.farmSettings.breakRadius then
        return true
    end
    return false
end
local function clickPosition(x,y)
    VirtualUser:Button1Down(Vector2.new(x,y))
    VirtualUser:Button1Up(Vector2.new(x,y))
end
local function goTo(cframe)
    if typeof(cframe) == "CFrame" then
        LocalPlayer.Character:PivotTo(cframe)
    else
        HumanoidRootPart.CFrame:PivotTo(CFrame.new(cframe))
    end
end
local function waitFor(path, object, bool)
    bool = bool or false
    repeat
        task.wait()
    until path:FindFirstChild(object, bool)
    return path:FindFirstChild(object, bool)
end
local function checkActive(name)
    if not instanceContainer.Active:FindFirstChild(name) then
        goTo(Instances[name]:FindFirstChild("Enter", true).CFrame)
    end
end
local function completeObby(obbyInfo)
    if typeof(obbyInfo) ~= "table" then
        return error("Not a table")
    end
    if typeof(obbyInfo.StartLine) ~= "CFrame" then
        if obbyInfo.StartLine:IsA("Model") then
            obbyInfo.StartLine = obbyInfo.StartLine:FindFirstChild("Part").CFrame
        else
            obbyInfo.StartLine = obbyInfo.StartLine.CFrame
        end
    end
    if typeof(obbyInfo.EndPad) ~= "CFrame" then
        obbyInfo.EndPad = obbyInfo.EndPad.CFrame
    end

    goTo(obbyInfo.StartLine + Vector3.new(0,3,0))
    task.wait(0.5)

    warn("Required module after this may not require correctly")
    local common = require(instanceContainer.Active:FindFirstChild(obbyInfo.Name):FindFirstChild("Common", true))
    common.WinTimer = 0

    goTo(obbyInfo.EndPad + Vector3.new(0,3,0))
end
local function Fire(name, args)
    if ClientNetwork:FindFirstChild(name) then
        ClientNetwork[name]:FireServer(unpack(args))
    else
        warn("theres no ClientNetwork."..name)
    end
end
local function Invoke(name, args)
    if ClientNetwork:FindFirstChild(name) then
        ClientNetwork[name]:InvokeServer(unpack(args))
    else
        warn("theres no ClientNetwork."..name)
    end
end
local function addConnections(tbl)
    for _,func in ipairs(tbl) do
        table.insert(connections, RunService.Heartbeat(func))
    end
end
local doingQueue = false
local function farmBreakables()
    if config.farmSettings.breakObjects then
        local breakable = findNearestBreakable()
        if config.farmSettings.singleTarget then
            repeat
                task.wait(config.farmSettings.waitTime)
                Fire("Breakables_PlayerDealDamage", {breakable.Name})
            until not Breakables:FindFirstChild(breakable.Name) or not isBreakableInRadius(breakable) or not config.farmSettings.breakObjects or not config.farmSettings.singleTarget
        else
            if not table.find(coinQueue, breakable.Name) then
                table.insert(coinQueue, breakable.Name)
                task.spawn(function()
                    repeat
                        task.wait()
                    until not Breakables:FindFirstChild(breakable) or not isBreakableInRadius(breakable) or config.farmSettings.singleTarget or not config.farmSettings.breakObjects
                    table.remove(coinQueue, table.find(coinQueue, breakable))
                end)
            end
            task.spawn(function()
                if not doingQueue then
                    doingQueue = true
                    for _,currentCoin in ipairs(coinQueue) do
                        Fire("Breakables_PlayerDealDamage", {currentCoin})
                        task.wait(config.farmSettings.waitTime)
                    end
                    doingQueue = false
                end
            end)
        end
    end
end
local function buyZones(value)
    if value then
        for _,worldName in ipairs(getNames(worlds)) do
            if not config.farmSettings.buyZone then break end
            local connection = RunService.Heartbeat:Connect(function()
                local name = string.split(worldName, " | ")[2]
                Invoke("Zones_RequestPurchase", {name})
            end)
            table.insert(connections.zones, connection)
        end
    else
        for _,connection in ipairs(connections.zones) do
            connection:Disconnect()
        end
    end
end
local function collectLootbags()
    for _, lootbag in ipairs(Lootbags:GetDescendants()) do
        if not config.farmSettings.collectLootbags then break end
        if lootbag:IsA("MeshPart") then
            lootbag.CFrame = HumanoidRootPart.CFrame
        end
    end
end
local hasFinished = true
local function farmEggs()
    if config.eggSettings.openEggs then
        if hasFinished then
            hasFinished = false
            local splitName = string.split(config.eggSettings.selectedEgg, " | ")
            Invoke("Eggs_RequestPurchase",{splitName[2], config.eggSettings.openAmount})
            task.wait(0.4)
            repeat
                task.wait()
                clickPosition(math.huge,math.huge)
            until not Workspace.Camera:FindFirstChild("Eggs") or not config.eggSettings.openEggs
            task.wait(0.75)
            hasFinished = true
        end
    end
end
local function collectTimeRewards()
    if config.rewardSettings.collectTimeRewards then
        for i=1,12 do
            Invoke("Redeem Free Gift", {i})
        end
    end
end
local function collectStarterWheelTicket()
    if config.rewardSettings.collectSpinnerTicket then
        Fire("Spinny Wheel: Request Ticket", {"StarterWheel"})
    end
end
local timesUp = false
local function antiAFK()
    if config.miscSettings.antiAFK and not timesUp then
        timesUp = true
        LocalPlayer.Character.Humanoid:ChangeState(3)
        task.wait(math.random(120,180))
        timesUp = false
    end
end

-- Library/Main script

local quake = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()
local main = quake:Window({
    Title = "Pet Simulator 99",
    isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
})

local farmingTab = main:Tab({
    Name = "Farming",
    tabColor = Color3.fromHex("#71d1f5"),
    Image = "rbxassetid://10709769841"
})
local teleportsTab = main:Tab({
    Name = "Teleports",
    tabColor = Color3.fromHex("#9bf038"),
    Image = "rbxassetid://15555209580"
})
local minigamesTab = main:Tab({
    Name = "Minigames",
    tabColor = Color3.fromHex("#d19b4a"),
    Image = "rbxassetid://10723376114"
})
local rewardsTab = main:Tab({
    Name = "Rewards",
    tabColor = Color3.fromHex("#da0a48"),
    Image = "rbxassetid://10723396402"
})
local miscTab = main:Tab({
    Name = "Miscellaneous",
    tabColor = Color3.fromHex("#34d793"),
    Image = "rbxassetid://10709819149"
})
local creditsTab = main:Tab({
    Name = "Credits",
    Image = "rbxassetid://10747373176"
})

-- Farming

farmingTab:Toggle({
    Name = "Farm Coins",
    Default = config.farmSettings.breakObjects,
    Callback = function(value)
        updateConfig(config.farmSettings.breakObjects, value)
        if not config.farmSettings.breakObjects then
            table.clear(coinQueue)
        end
    end
})
farmingTab:Toggle({
    Name = "Single Target",
    Default = config.farmSettings.singleTarget,
    Callback = function(value)
        updateConfig(config.farmSettings.singleTarget, value)
    end
})
local radiusSetter
radiusSetter = farmingTab:TextBox({
    Name = "Radius (Recommended: 70)",
    Default = config.farmSettings.breakRadius,
    Callback = function(value)
        if value ~= "" or not tonumber(value) then
            radiusSetter:SetInput("40")
            main:Notify({
                Title = "Radius Error",
                Duration = 20,
                Body = "You need the RADIUS to be a number. It is now 40"
            })
            return
        end
        updateConfig(config.farmSettings.breakRadius, tonumber(value))
    end
})
local waitSetter
waitSetter = farmingTab:TextBox({
    Name = "Wait Time (Recommended: 0.2)",
    Default = config.farmSettings.waitTime,
    Callback = function(value)
        if value ~= "" or not tonumber(value) then
            waitSetter:SetInput("0.2")
            main:Notify({
                Title = "Wait Time Error",
                Duration = 20,
                Body = "You need the WAIT TIME to be a number. It is now 0.2"
            })
            return
        end
        updateConfig(config.farmSettings.waitTime, tonumber(value))
    end
})
farmingTab:Toggle({
    Name = "Buy Next Zone",
    Default = config.farmSettings.buyZone,
    Callback = function(value)
        updateConfig(config.farmSettings.buyZone, value)
        buyZones(config.farmSettings.buyZone)
    end
})

farmingTab:Section("Collection")
local orbToggle = farmingTab:Toggle({
    Name = "Collect Orbs",
    Default = config.farmSettings.collectOrbs,
    Callback = function(value)
    end
})
orbToggle:Lock("Won't work on Solara")
local lootbags
lootbags = farmingTab:Toggle({
    Name = "Collect Lootbags",
    Default = config.farmSettings.collectLootbags,
    Callback = function(value)
        updateConfig(config.farmSettings.collectLootbags, value)
    end
})

farmingTab:Section("Egg Farming")
farmingTab:Label("You must be near eggs to hatch them")
farmingTab:Dropdown({
    Name = "Egg to farm",
    Items = eggs,
    Multiselect = false,
    Default = config.eggSettings.selectedEgg,
    Callback = function(eggPicked)
        updateConfig(config.eggSettings.selectedEgg, eggPicked)
    end
})
farmingTab:Slider({
    Name = "Amount of eggs",
    Max = 99,
    Min = 1,
    Default = config.eggSettings.openAmount,
    Callback = function(amountSelected)
        updateConfig(config.eggSettings.openAmount, amountSelected)
    end
})
farmingTab:Toggle({
    Name = "Farm selected egg",
    Default = config.eggSettings.openEggs,
    Callback = function(value)
        updateConfig(config.eggSettings.openEggs, value)
    end
})

-- Teleports

local selectedWorld
local goToZone
teleportsTab:Dropdown({
    Name = "Zones",
    Items = getNames(worlds),
    Multiselect = false,
    Callback = function(chosenWorld)
        selectedWorld = findInTable(worlds,chosenWorld)
        goToZone:SetText("Go to "..chosenWorld)
    end
})
goToZone = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        goTo(selectedWorld.TeleportPart + Vector3.new(0,3,0))
    end
})

teleportsTab:Section("Vending Machines")
local selectedVM
local goToVendingMachine
teleportsTab:Dropdown({
    Name = "Vending Machines",
    Items = getNames(vendingMachines),
    Multiselect = false,
    Callback = function(chosenVM)
        selectedVM = findInTable(vendingMachines,chosenVM)
        goToVendingMachine:SetText("Go to "..chosenVM)
    end
})
goToVendingMachine = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        local vmWorld = findInTable(worlds,selectedVM.Location)

        goTo(vmWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[vmWorld.Name]["PARTS_LOD"], "GROUND")
        local vendingPad = waitFor(Map[vmWorld.Name].INTERACT.Machines, selectedVM.Name).Pad.CFrame
        goTo(vendingPad)
    end
})

teleportsTab:Section("Other Machines")
local selectedOM
local goToOtherMachine
teleportsTab:Dropdown({
    Name = "Other Machines",
    Items = getNames(otherMachines),
    Multiselect = false,
    Callback = function(chosenOM)
        selectedOM = findInTable(otherMachines,chosenOM)
        goToOtherMachine:SetText("Go to "..chosenOM)
    end
})
goToOtherMachine = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        local omWorld = findInTable(worlds, selectedOM.Location)

        goTo(omWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[omWorld.Name]["PARTS_LOD"], "GROUND")
        local vendingPad = waitFor(Map[omWorld.Name].INTERACT.Machines, selectedOM.Name).Pad.CFrame
        goTo(vendingPad)
    end
})

teleportsTab:Label("Miscellaneous")
teleportsTab:Button({
    Name = "Remove Water",
    Callback = function()
        for _, water in ipairs(Map:GetDescendants()) do
            if water:IsA("Folder") and water.Name == "Water Bounds" then
                water:Destroy()
            end
        end
    end
})

-- Minigames

local selectedMG
local goToMinigame
local completeMinigame
minigamesTab:Dropdown({
    Name = "Select Minigame",
    Items = minigames,
    Multiselect = false,
    Callback = function(chosenMG)
        selectedMG = chosenMG
        goToMinigame:SetText("Go to "..chosenMG)
        completeMinigame:SetText("Complete "..chosenMG)
    end
})
goToMinigame = minigamesTab:Button({
    Name = "Go to none",
    Callback = function()
        goTo(Things.Instances[selectedMG]:FindFirstChild("Enter", true).CFrame)
    end
})
minigamesTab:Section("Auto Complete")
completeMinigame = minigamesTab:Button({
    Name = 'Complete none',
    Callback = function()
        checkActive(selectedMG)
        task.wait(1)
        local loadedMG = waitFor(instanceContainer.Active, selectedMG)
        task.wait(1)
        if selectedMG ~= "Minefield" and selectedMG ~= "Atlantis" and selectedMG ~= "Minecart" then
            completeObby({
                Name = selectedMG,
                StartLine = waitFor(loadedMG, "StartLine", true),
                EndPad = waitFor(loadedMG, "Goal", true).Pad
            })
        elseif selectedMG == "Minefield" then
            --local common = require(loadedMG.Common)
            --common.Config.RespawnTimer = 0
            --common.Config.WinTimer = 0
            warn("This may not work as intended due to Solara limitations")

            local mines = waitFor(loadedMG, "Mines")
            local finish = waitFor(loadedMG, "Finish")
            local nextX,nextZ = 0, 0
            for _,mine in ipairs(mines:GetChildren()) do
                local oldPos = mine.Pad.CFrame
                mine.Pad.CanCollide = false

                if nextX == 0 then
                    nextX = mine.Pad.Position.X
                    nextZ = mine.Pad.Position.Z
                end
                mine.Pad.CFrame = HumanoidRootPart.CFrame
                task.wait(0.2)
                mine.Pad.CFrame = oldPos
                mine.Pad.CanCollide = true
                if tostring(mine.Pad.BrickColor) == "Really red" then
                    nextZ = nextZ + 10
                    task.wait(2)
                else
                    nextX = nextX + 10
                end
            end
            goTo(finish.CFrame + Vector3.new(0,3,0))
        elseif selectedMG == "Atlantis" then
            checkActive("Atlantis")
            task.wait(1)
            local atlantis = waitFor(instanceContainer.Active, "Atlantis")
            local rings = waitFor(atlantis, "Rings")
            for i=1,31 do
                local ring = waitFor(rings, tostring(i))
                task.wait(0.4)
                HumanoidRootPart.CFrame = ring.Collision.CFrame
            end
        elseif selectedMG == "Minecart" then
            waitFor(loadedMG.Interactable, "StartLine")
            waitFor(loadedMG.Interactable, "Goal")
            completeObby({
                Name = selectedMG,
                StartLine = CFrame.new(0,0,0) + Vector3.new(-1380.3746337890625, -102.0365982055664, -4659.6044921875),
                EndPad = loadedMG.Interactable.Goal.Pad
            })
        end
    end
})
minigamesTab:Toggle({
    Name = "Farm Fishing",
    Default = config.minigameSettings.farmFishing,
    Callback = function(value)
        updateConfig(config.minigameSettings.farmFishing, value)
        checkActive("Fishing")
        task.wait(0.2)
        local fishing = waitFor(instanceContainer.Active, "Fishing")
        local Layer1 =  waitFor(fishing.Water, "Layer1")
        local L1Position = Layer1.Position
        local function fishingRemote(type, args)
            if type == "Invoke" then
                return Invoke("Instancing_InvokeCustomFromClient", {"Fishing", unpack(args)})
            elseif type == "Fire" then
                return Fire("Instancing_FireCustomFromClient", {"Fishing", unpack(args)})
            end
        end
        local function isBubbling()
            local bubbling = false
            for _,host in ipairs(Debris:GetChildren()) do
                if host.Name == "host" and host:FindFirstChild("Attachment") and (host.Attachment:FindFirstChild("Bubbles") or host.Attachment:FindFirstChild("Rare Bubbles")) then
                    local distance = (L1Position.X - host.Position.X)
                    if distance <= 2 then
                        bubbling = true
                    end
                end
            end
            return bubbling
        end
        while config.minigameSettings.farmFishing and task.wait() do
            fishingRemote("Fire",{"RequestCast", Vector3.new(L1Position.X,L1Position.Y,L1Position.Z)})
            repeat task.wait() until isBubbling() or not config.minigameSettings.farmFishing
            fishingRemote("Fire", {"RequestReel"})
            repeat
                task.wait()
                fishingRemote("Invoke", {"Clicked"})
            until (not isBubbling()) or not config.minigameSettings.farmFishing
        end
        goTo(fishing.Interactable:FindFirstChild("Pad", true).CFrame + Vector3.new(0,3,0))
    end
})
minigamesTab:Toggle({
    Name = "Farm Digsite",
    Default = false,
    Callback = function(value)
        updateConfig(config.minigameSettings.farmDigsite, value)
        checkActive("Digsite")
        task.wait(0.2)
        local digsite = waitFor(instanceContainer.Active, "Digsite")
        local function digsiteRemote(type, args)
            if type == "Invoke" then
                return Invoke("Instancing_InvokeCustomFromClient", {"Digsite", unpack(args)})
            elseif type == "Fire" then
                return Fire("Instancing_FireCustomFromClient", {"Digsite", unpack(args)})
            end
        end
        local ActiveChests = digsite.Important.ActiveChests
        local ActiveBlocks = digsite.Important.ActiveBlocks
        local starterPos = CFrame.new(-75.44137573242188, 60.91250991821289, -2530.437744140625)
        local endPos = CFrame.new(-65.44137573242188, 60.91250991821289, -2520.437744140625)

        local function getChests(oldPosition)
            for _,chest in ipairs(ActiveChests:GetChildren()) do
                if chest.Name == "Animated" then
                    goTo(chest.Bottom.CFrame)
                    task.wait(0.2)
                    digsiteRemote("Fire",{"DigChest",chest:GetAttribute("Coord")})
                    repeat task.wait() until not ActiveChests:FindFirstChild(chest)
                    task.wait(1)
                end
            end
            goTo(oldPosition)
        end
        local function checkForChests()
            local isChest = false
            for _, chest in ipairs(ActiveChests:GetChildren()) do
                if chest.Name == "Animated" then
                    isChest = true
                end
            end
            return isChest
        end
        local function getBlockDistance(obj)
            return (HumanoidRootPart.Position - obj.Position).magnitude
        end
        if config.minigameSettings.farmDigsite then
            goTo(starterPos)
            task.wait(0.2)
        end
        while config.minigameSettings.farmDigsite and task.wait() do
            for _,block in ipairs(ActiveBlocks:GetChildren()) do
                if checkForChests() then
                    getChests(HumanoidRootPart.CFrame)
                    break
                end
                if block.Name == "Part" then
                    local distance = getBlockDistance(block)

                    if distance < 7 then
                        repeat
                            digsiteRemote("Fire", {"DigBlock", block:GetAttribute("Coord")})
                            task.wait()
                        until not ActiveBlocks:FindFirstChild(block) or (getBlockDistance(block) > 8)
                    end
                end
            end
        end
        goTo(endPos)
    end
})
-- Rewards

rewardsTab:Toggle({
    Name = 'Collect Time Rewards',
    Default = config.rewardSettings.collectTimeRewards,
    Callback = function(value)
        updateConfig(config.rewardSettings.collectTimeRewards, value)
        if not config.farmSettings.collectLootbags then
            lootbags:SetValue(config.rewardSettings.collectTimeRewards)
        end
    end
})
rewardsTab:Toggle({
    Name = "Collect Spinner Ticket",
    Default = config.rewardSettings.collectSpinnerTicket,
    Callback = function(value)
        updateConfig(config.rewardSettings.collectSpinnerTicket, value)
    end
})
rewardsTab:Section("Daily Rewards")
local selectedReward
local getDailyReward
rewardsTab:Dropdown({
    Name = "Reward Type",
    Items = getNames(rewards),
    Callback = function(chosenReward)
        selectedReward = findInTable(rewards, chosenReward)
        getDailyReward:SetText("Get: "..chosenReward)
    end
})
rewardsTab:Toggle({
    Name = "Teleport and Stay",
    Default = config.rewardSettings.teleportAndStay,
    Callback = function(value)
        updateConfig(config.rewardSettings.teleportAndStay, value)
    end
})
getDailyReward = rewardsTab:Button({
    Name = "Get: none",
    Callback = function()
        local oldPos = HumanoidRootPart.CFrame
        local rewardWorld = findInTable(worlds, selectedReward.Location)
        goTo(rewardWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[rewardWorld.Name]["PARTS_LOD"], "GROUND")
        local rewardPad = waitFor(Map[rewardWorld.Name].INTERACT.Machines, selectedReward.Name).Pad.CFrame
        goTo(rewardPad + Vector3.new(0,3,0))
        if not config.rewardSettings.teleportAndStay then
            task.wait(0.2)
            goTo(oldPos)
        end
    end
})
rewardsTab:Button({
    Name = "Go to Crystal Chest",
    Callback = function()
        local ccWorld = findInTable(worlds, "3 | Castle")
        goTo(ccWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[ccWorld.Name]["PARTS_LOD"], "GROUND")
        local rewardPad = waitFor(Map[ccWorld.Name].INTERACT, "CrystalChest").Pad.CFrame
        goTo(rewardPad + Vector3.new(0,3,0))
    end
})

-- Miscellaneous

miscTab:Label("These are things that dont fit in a category")
miscTab:Toggle({
    Name = "Anti AFK",
    Default = config.miscSettings.antiAFK,
    Callback = function(value)
        updateConfig(config.miscSettings.antiAFK, value)
    end
})
local shrineButton
shrineButton = miscTab:Button({
    Name = "Collect Shrines (maybe)",
    Callback = function()
        for i=1, miscInfo.relicCount do
            shrineButton:SetText("Progress: "..tostring(i).."/"..tostring(miscInfo.relicCount))
            Invoke("Relic_Found", {i})
        end
        shrineButton:SetText("Collect Shrines (Maybe)")
    end
})
local completeStairs
completeStairs = miscTab:Toggle({
    Name = "Try and complete stairway to heaven",
    Default = config.miscSettings.stairwayToHeaven,
    Callback = function(value)
        updateConfig(config.miscSettings.stairwayToHeaven, value)

        if config.miscSettings.stairwayToHeaven and not instanceContainer.Active:FindFirstChild("StairwayToHeaven") then
            goTo(CFrame.new(0,-100,0))
        end
        repeat task.wait() until instanceContainer.Active:FindFirstChild("StairwayToHeaven")
        local stairway = instanceContainer.Active.StairwayToHeaven
        local highestY = 0
        local oldHighest = highestY
        local highestCFrame

        while config.miscSettings.stairwayToHeaven and task.wait() do
            if stairway:FindFirstChild("Goal", true) then
                config.miscSettings.stairwayToHeaven = false
                completeStairs:SetValue(false)
                local goal = stairway:FindFirstChild("Goal", true)
                task.wait(0.3)
                goTo(goal.Shrine.Pad.CFrame + Vector3.new(0,3,0))
            end
            task.spawn(function()
                for _,part in ipairs(stairway:GetDescendants()) do
                    if part.Name == "Goal" then
                        config.miscSettings.stairwayToHeaven = false
                        completeStairs:SetValue(false)
                        local goal = stairway:FindFirstChild("Goal", true)
                        task.wait(0.3)
                        goTo(goal.Shrine.Pad.CFrame + Vector3.new(0,3,0))
                    end
                end
            end)
            for _,section in ipairs(stairway.Stairs:GetChildren()) do
                if not config.miscSettings.stairwayToHeaven then break end

                if section.Name == "Section" then
                    for _,part in ipairs(section:GetChildren()) do
                        if not config.miscSettings.stairwayToHeaven then break end

                        if part.Name == "Part" and part:IsA("Part") then
                            if part.Position.Y > highestY then
                                highestY = part.Position.Y
                                highestCFrame = part.CFrame
                            end
                        end
                    end
                end
            end
            if oldHighest ~= highestY then
                oldHighest = highestY
                pcall(function()
                    goTo(highestCFrame + Vector3.new(0,3,0))
                end)
                task.wait(0.2)
            end
        end
    end
})
miscTab:Label("^ This probably doesn't even work ^")

creditsTab:Label("UI: griffindoescooking")
creditsTab:Label("Script: griffindoescooking, project L")
creditsTab:Button({
    Name = "project L",
    Callback = function()
        setclipboard("https://discord.gg/Mw7rYHDNw4")
    end
})
creditsTab:Section("Support: ")
creditsTab:Button({
    Name = "Discord",
    Callback = function()
        setclipboard("https://discord.gg/DBPHwFyCVT")
    end
})
addConnections({farmBreakables,collectLootbags,farmEggs,collectTimeRewards,collectStarterWheelTicket,antiAFK})

getgenv().config = HttpService:JSONDecode(readfile("griffins configs/8737899170.config"))
