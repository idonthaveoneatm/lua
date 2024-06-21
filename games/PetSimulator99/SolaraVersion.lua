--[[

Made by griffindoescooking

]]--

print("Pet Simulator 99 | griffindoescooking")
warn('The solara version removes require functions')
getgenv().griffinVersion = "2.9.8"

repeat
    task.wait()
until game:IsLoaded()
if game.PlaceId ~= 8737899170 and game.PlaceId ~= 16498369169 and game.PlaceId ~= 17503543197 then
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
    if not identifyexecutor then
        functionNames = functionNames.."identifyexecutor "
    end
    return functionNames
end
local function output(text: string, type: string)
    local outputTag = "[griffindoescooking] "
    type = type or "print"
    pcall(function()
        if type == "print" then
            print(outputTag..text)
        elseif type == "warn" then
            warn(outputTag..text)
        elseif type == "error" then
            error(outputTag..text)
        end
    end)
end

local missingFunctions = checkFunctions()
if missingFunctions ~= "" then
    return output("Missing: "..missingFunctions, "error")
end

-- Variables

local LocalPlayer = game.Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart", true)

local sqrt = math.sqrt
local pow = math.pow

local VirtualUser = cloneref(game:GetService("VirtualUser"))
local HttpService = cloneref(game:GetService("HttpService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local ClientNetwork = ReplicatedStorage.Network

local Workspace = cloneref(game:GetService("Workspace"))
local Debris = Workspace['__DEBRIS']
local Things = Workspace["__THINGS"]
local Instances = Things.Instances
local instanceContainer = Things["__INSTANCE_CONTAINER"]
local Lootbags = Things.Lootbags
local Orbs = Things.Orbs
local Breakables = Things.Breakables

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

local Map
if getMap() then
    Map = getMap()
else
    task.spawn(function()
        repeat
            task.wait()
        until getMap()
        Map = getMap()
    end)
end

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
        collectOrbsAndLootbags = false,
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
end
if not isfile("griffins configs/8737899170.config") then
    isFirstTime = true
    writefile("griffins configs/8737899170.config", "")
end

if isFirstTime then
    local encodedConfig = HttpService:JSONEncode(configTemplate)
    writefile("griffins configs/8737899170.config", encodedConfig)
end

local function loadConfig()
    local decodedConfig = HttpService:JSONDecode(readfile("griffins configs/8737899170.config"))
    getgenv().config = decodedConfig
end
local function updateConfig()
    local encodedConfig = HttpService:JSONEncode(getgenv().config)
    writefile("griffins configs/8737899170.config", encodedConfig)
end

loadConfig()

-- Tables

getgenv().coinQueue = {} -- needs to be global to clear it on reexecute
local PS99Info = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/informationTable.lua"))()
PS99Info = PS99Info[Map.Name]

local worlds = PS99Info.Worlds
local function getWorld(name: string)
    for index,wInfo in ipairs(worlds) do
        if wInfo.Name == name then
            return worlds[index]
        end
    end
end
local function getWorldNames()
    local returnTable = {}
    for _,wInfo in ipairs(worlds) do
        table.insert(returnTable, wInfo.Name)
    end
    return returnTable
end

local vendingMachines = PS99Info.VendingMachines
local function getVendingMachine(name: string)
    for index,vmInfo in ipairs(vendingMachines) do
        if vmInfo.Name == name then
            return vendingMachines[index]
        end
    end
end
local function getVendingMachineNames()
    local returnTable = {}
    for _,vmInfo in ipairs(vendingMachines) do
        table.insert(returnTable, vmInfo.Name)
    end
    return returnTable
end

local rewards = PS99Info.Rewards
local function getReward(name: string)
    for index,rInfo in ipairs(rewards) do
        if rInfo.Name == name then
            return rewards[index]
        end
    end
end
local function getRewardNames()
    local returnTable = {}
    for _,rInfo in ipairs(rewards) do
        table.insert(returnTable, rInfo.Name)
    end
    return returnTable
end

local otherMachines = PS99Info.OtherMachines
local function getOtherMachine(name: string)
    for index,omInfo in ipairs(otherMachines) do
        if omInfo.Name == name then
            return otherMachines[index]
        end
    end
end
local function getOtherMachineNames()
    local returnTable = {}
    for _,omInfo in ipairs(otherMachines) do
        table.insert(returnTable, omInfo.Name)
    end
    return returnTable
end

local minigames = PS99Info.Minigames
local eggs = PS99Info.Eggs
local miscInfo = PS99Info.MiscInfo

-- Functions

local function calcDistance(obj1, obj2)
    local PosX1, PosZ1 = obj1.CFrame.X, obj1.CFrame.Z
    local PosX2, PosZ2 = obj2.CFrame.X, obj2.CFrame.Z

    return sqrt(pow(PosX1 - PosX2, 2) + pow(PosZ1 - PosZ2, 2))
end
local function clickPosition(x,y)
    VirtualUser:Button1Down(Vector2.new(x,y))
    VirtualUser:Button1Up(Vector2.new(x,y))
end
local function goToPart(cframe)
    HumanoidRootPart.CFrame = cframe
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
        goToPart(Instances[name]:FindFirstChild("Enter", true).CFrame)
    end
end
local function completeObby(obbyInfo)
    if typeof(obbyInfo) ~= "table" then
        return output("Not a table", "error")
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

    goToPart(obbyInfo.StartLine + Vector3.new(0,3,0))
    task.wait(0.5)

    warn("Removed a require for Common.WinTimer. May break functionality")

    goToPart(obbyInfo.EndPad + Vector3.new(0,3,0))
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

local function collectLootbags()
    if config.farmSettings.collectOrbsAndLootbags then
        local lootbags = {}
        for _, lootbag in ipairs(Lootbags:GetChildren()) do
            if not config.farmSettings.collectOrbsAndLootbags then break end
            lootbags[lootbag.Name] = lootbag.Name
            lootbag:Destroy()
        end
        Fire("Lootbags_Claim", {lootbags})
    end
end
local function collectOrbs()
    if config.farmSettings.collectOrbsAndLootbags then
        local orbs = {}
        for _, orb in ipairs(Orbs:GetChildren()) do
            if not config.farmSettings.collectOrbsAndLootbags then break end
            table.insert(orbs, tonumber(orb.Name))
            orb:Destroy()
        end
        Fire("Orbs: Collect", {orbs})
    end
end

-- Library/Main script

local quake = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()
local main = quake:Window({
    Title = "Pet Simulator 99 | Solara",
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
        config.farmSettings.breakObjects = value
        updateConfig()

        local doingQueue = false

        while config.farmSettings.breakObjects and task.wait() do
            for _, v in ipairs(Breakables:GetChildren()) do

                if v:FindFirstChild("Hitbox", true) then
                    local coinPart = v:FindFirstChild("Hitbox", true)
                    local coinName = v.Name

                    if calcDistance(coinPart, HumanoidRootPart) <= config.farmSettings.breakRadius then
                        if config.farmSettings.singleTarget then

                            repeat
                                task.wait(config.farmSettings.waitTime)
                                Fire("Breakables_PlayerDealDamage", {coinName})
                            until not Breakables:FindFirstChild(coinName) or calcDistance(coinPart, HumanoidRootPart) > config.farmSettings.breakRadius or not config.farmSettings.breakObjects or not config.farmSettings.singleTarget

                        else

                            if not table.find(coinQueue, v.Name) then
                                table.insert(coinQueue, v.Name)
                                task.spawn(function()
                                    repeat
                                        task.wait()
                                    until not Breakables:FindFirstChild(coinName) or calcDistance(coinPart, HumanoidRootPart) > config.farmSettings.breakRadius or config.farmSettings.singleTarget or not config.farmSettings.breakObjects
                                    table.remove(coinQueue, table.find(coinQueue, coinName))
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
            end
        end
        table.clear(coinQueue)
    end
})
farmingTab:Toggle({
    Name = "Single Target",
    Default = config.farmSettings.singleTarget,
    Callback = function(value)
        config.farmSettings.singleTarget = value
        updateConfig()
    end
})
local radiusSetter
radiusSetter = farmingTab:TextBox({
    Name = "Radius (Recommended: 70)",
    Default = config.farmSettings.breakRadius,
    Callback = function(value)
        if tonumber(value) then
            config.farmSettings.breakRadius = tonumber(value)
        elseif value ~= "" and not tonumber(value) then
            config.farmSettings.breakRadius = 40
            radiusSetter:SetInput("40")
            main:Notify({
                Title = "Radius Error",
                Duration = 20,
                Body = "You need the RADIUS to be a number. It is now 40"
            })
        end
        updateConfig()
    end
})
local waitSetter
waitSetter = farmingTab:TextBox({
    Name = "Wait Time (Recommended: 0.2)",
    Default = config.farmSettings.waitTime,
    Callback = function(value)
        if tonumber(value) then
            config.farmSettings.waitTime = tonumber(value)
        elseif value ~= "" and not tonumber(value) then
            waitSetter:SetInput("0.2")
            main:Notify({
                Title = "Wait Time Error",
                Duration = 20,
                Body = "You need the WAIT TIME to be a number. It is now 0.2"
            })
        end
        updateConfig()
    end
})
farmingTab:Toggle({
    Name = "Buy Next Zone",
    Default = config.farmSettings.buyZone,
    Callback = function(value)
        config.farmSettings.buyZone = value
        updateConfig()

        for _,worldName in ipairs(getWorldNames()) do
            if not config.farmSettings.buyZone then break end
            task.spawn(function()
                while config.farmSettings.buyZone and task.wait() do
                    local name = string.split(worldName, " | ")[2]
                    Invoke("Zones_RequestPurchase", {name})
                end
            end)
        end
    end
})

farmingTab:Section("Collection")
local collectOrbsAndLootbags
collectOrbsAndLootbags = farmingTab:Toggle({
    Name = "Collect Orbs and Lootbags",
    Default = config.farmSettings.collectOrbsAndLootbags,
    Callback = function(value)
        config.farmSettings.collectOrbsAndLootbags = value
        task.spawn(function()
            while config.farmSettings.collectOrbsAndLootbags and task.wait() do
                collectLootbags()
                collectOrbs()
            end
        end)
        updateConfig()
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
        config.eggSettings.selectedEgg = eggPicked
        updateConfig()
    end
})
farmingTab:Slider({
    Name = "Amount of eggs",
    Max = 99,
    Min = 1,
    Default = config.eggSettings.openAmount,
    Callback = function(amountSelected)
        config.eggSettings.openAmount = amountSelected
        updateConfig()
    end
})
farmingTab:Toggle({
    Name = "Farm selected egg",
    Default = config.eggSettings.openEggs,
    Callback = function(value)
        config.eggSettings.openEggs = value
        updateConfig()

        while config.eggSettings.openEggs and task.wait() do
            local splitName = string.split(config.eggSettings.selectedEgg, " | ")
            Invoke("Eggs_RequestPurchase",{splitName[2], config.eggSettings.openAmount})
            task.wait(0.4)
            repeat
                task.wait()
                clickPosition(math.huge,math.huge)
            until not Workspace.Camera:FindFirstChild("Eggs") or not config.eggSettings.openEggs
            task.wait(0.75)
        end
    end
})

-- Teleports

local selectedWorld
local goToZone
teleportsTab:Dropdown({
    Name = "Zones",
    Items = getWorldNames(),
    Multiselect = false,
    Callback = function(chosenWorld)
        selectedWorld = getWorld(chosenWorld)
        goToZone:SetName("Go to "..chosenWorld)
    end
})
goToZone = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        goToPart(selectedWorld.TeleportPart + Vector3.new(0,3,0))
    end
})

teleportsTab:Section("Vending Machines")
local selectedVM
local goToVendingMachine
teleportsTab:Dropdown({
    Name = "Vending Machines",
    Items = getVendingMachineNames(),
    Multiselect = false,
    Callback = function(chosenVM)
        selectedVM = getVendingMachine(chosenVM)
        goToVendingMachine:SetName("Go to "..chosenVM)
    end
})
goToVendingMachine = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        local vmWorld = getWorld(selectedVM.Location)

        goToPart(vmWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[vmWorld.Name]["PARTS_LOD"], "GROUND")
        local world = Map[vmWorld.Name]
        local vendingPad = waitFor(world.INTERACT.Machines, selectedVM.Name).Pad.CFrame
        goToPart(vendingPad)
    end
})

teleportsTab:Section("Other Machines")
local selectedOM
local goToOtherMachine
teleportsTab:Dropdown({
    Name = "Other Machines",
    Items = getOtherMachineNames(),
    Multiselect = false,
    Callback = function(chosenOM)
        selectedOM = getOtherMachine(chosenOM)
        goToOtherMachine:SetName("Go to "..chosenOM)
    end
})
goToOtherMachine = teleportsTab:Button({
    Name = "Go to none",
    Callback = function()
        local omWorld = getWorld(selectedOM.Location)

        goToPart(omWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[omWorld.Name]["PARTS_LOD"], "GROUND")
        local world = Map[omWorld.Name]
        local vendingPad = waitFor(world.INTERACT.Machines, selectedOM.Name).Pad.CFrame
        goToPart(vendingPad)
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
        goToMinigame:SetName("Go to "..chosenMG)
        completeMinigame:SetName("Complete "..chosenMG)
    end
})
goToMinigame = minigamesTab:Button({
    Name = "Go to none",
    Callback = function()
        goToPart(Things.Instances[selectedMG]:FindFirstChild("Enter", true).CFrame)
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
            local StartLine = waitFor(loadedMG, "StartLine", true)
            local Goal = waitFor(loadedMG, "Goal", true)
            completeObby({
                Name = selectedMG,
                StartLine = StartLine,
                EndPad = Goal.Pad
            })
        elseif selectedMG == "Minefield" then

            warn("Removed a require for Common.WinTimer and Common.RespawnTimer. May break functionality")

            local mines = waitFor(loadedMG, "Mines")
            local finish = waitFor(loadedMG, "Finish")
            local nextX,nextZ = 0, 0
            for _,mine in ipairs(mines:GetChildren()) do
                if nextX == 0 then
                    local oldPos = mine.Pad.CFrame
                    mine.Pad.CanCollide = false
                    nextX = mine.Pad.Position.X
                    nextZ = mine.Pad.Position.Z
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
                else
                    if mine.Pad.Position.X == nextX and mine.Pad.Position.Z == nextZ then
                        local oldPos = mine.Pad.CFrame
                        mine.Pad.CanCollide = false
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
                end
            end
            goToPart(finish.CFrame + Vector3.new(0,3,0))
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
        config.minigameSettings.farmFishing = value
        updateConfig()

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
        goToPart(fishing.Interactable:FindFirstChild("Pad", true).CFrame + Vector3.new(0,3,0))
    end
})
minigamesTab:Toggle({
    Name = "Farm Digsite",
    Default = false,
    Callback = function(value)
        config.minigameSettings.farmDigsite = value
        updateConfig()

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
                print(chest.Name)
                if chest.Name == "Animated" then
                    print("attempting ", chest.Name)
                    goToPart(chest.Bottom.CFrame)
                    task.wait(0.2)
                    digsiteRemote("Fire",{"DigChest",chest:GetAttribute("Coord")})
                    repeat task.wait() until not ActiveChests:FindFirstChild(chest)
                    task.wait(1)
                end
            end
            goToPart(oldPosition)
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
            goToPart(starterPos)
            task.wait(0.2)
            getChests(starterPos)
        end
        while config.minigameSettings.farmDigsite and task.wait() do
            for _,block in ipairs(ActiveBlocks:GetChildren()) do
                if checkForChests() then
                    getChests(HumanoidRootPart.CFrame)
                    break
                end
                if block.Name == "Part" then
                    local distance = getBlockDistance(block)

                    if distance < 8 then
                        print(distance)
                        repeat
                            digsiteRemote("Fire", {"DigBlock", block:GetAttribute("Coord")})
                            task.wait()
                        until not ActiveBlocks:FindFirstChild(block) or (getBlockDistance(block) > 8)
                    end
                end
            end
        end

        goToPart(endPos)
    end
})
-- Rewards

rewardsTab:Toggle({
    Name = 'Collect Time Rewards',
    Default = config.rewardSettings.collectTimeRewards,
    Callback = function(value)
        config.rewardSettings.collectTimeRewards = value
        updateConfig()
        if not config.farmSettings.collectOrbsAndLootbags then
            collectOrbsAndLootbags:SetValue(config.rewardSettings.collectTimeRewards)
        end

        while config.rewardSettings.collectTimeRewards and task.wait() do
            for i=1,12 do
                Invoke("Redeem Free Gift", {i})
            end
        end
    end
})
rewardsTab:Toggle({
    Name = "Collect Spinner Ticket",
    Default = config.rewardSettings.collectSpinnerTicket,
    Callback = function(value)
        config.rewardSettings.collectSpinnerTicket = value
        updateConfig()

        while config.rewardSettings.collectSpinnerTicket and task.wait() do
            Fire("Spinny Wheel: Request Ticket", {"StarterWheel"})
        end
    end
})
rewardsTab:Section("Daily Rewards")
local selectedReward
local getDailyReward
rewardsTab:Dropdown({
    Name = "Reward Type",
    Items = getRewardNames(),
    Callback = function(chosenReward)
        selectedReward = getReward(chosenReward)
        getDailyReward:SetName("Get: "..chosenReward)
    end
})
rewardsTab:Toggle({
    Name = "Teleport and Stay",
    Default = config.rewardSettings.teleportAndStay,
    Callback = function(value)
        config.rewardSettings.teleportAndStay = value
        updateConfig()
    end
})
getDailyReward = rewardsTab:Button({
    Name = "Get: none",
    Callback = function()
        local oldPos = HumanoidRootPart.CFrame
        local rewardWorld = getWorld(selectedReward.Location)

        goToPart(rewardWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[rewardWorld.Name]["PARTS_LOD"], "GROUND")
        local world = Map[rewardWorld.Name]
        local rewardPad = waitFor(world.INTERACT.Machines, selectedReward.Name).Pad.CFrame
        goToPart(rewardPad + Vector3.new(0,3,0))
        if not config.rewardSettings.teleportAndStay then
            task.wait(0.2)
            goToPart(oldPos)
        end
    end
})
rewardsTab:Button({
    Name = "Go to Crystal Chest",
    Callback = function()
        local ccWorld = getWorld("3 | Castle")

        goToPart(ccWorld.TeleportPart + Vector3.new(0,50,0))
        waitFor(Map[ccWorld.Name]["PARTS_LOD"], "GROUND")
        local world = Map[ccWorld.Name]
        local rewardPad = waitFor(world.INTERACT, "CrystalChest").Pad.CFrame
        goToPart(rewardPad + Vector3.new(0,3,0))
    end
})

-- Miscellaneous

miscTab:Label("These are things that dont fit in a category")
miscTab:Toggle({
    Name = "Anti AFK",
    Default = config.miscSettings.antiAFK,
    Callback = function(value)
        config.miscSettings.antiAFK = value
        updateConfig()

        while config.miscSettings.antiAFK and task.wait() do
            LocalPlayer.Character.Humanoid:ChangeState(3)
            task.wait(math.random(120,180))
        end
    end
})
local completeStairs
completeStairs = miscTab:Toggle({
    Name = "Try and complete stairway to heaven",
    Default = config.miscSettings.stairwayToHeaven,
    Callback = function(value)
        config.miscSettings.stairwayToHeaven = value
        updateConfig()

        if config.miscSettings.stairwayToHeaven and not instanceContainer.Active:FindFirstChild("StairwayToHeaven") then
            goToPart(CFrame.new(0,-100,0))
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
                goToPart(goal.Shrine.Pad.CFrame + Vector3.new(0,3,0))
            end
            task.spawn(function()
                for _,part in ipairs(stairway:GetDescendants()) do
                    if part.Name == "Goal" then
                        config.miscSettings.stairwayToHeaven = false
                        completeStairs:SetValue(false)
                        local goal = stairway:FindFirstChild("Goal", true)
                        task.wait(0.3)
                        goToPart(goal.Shrine.Pad.CFrame + Vector3.new(0,3,0))
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
                    goToPart(highestCFrame + Vector3.new(0,3,0))
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/updateInfo.lua"))()

local gitVersion = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/version"))()
if getgenv().griffinVersion and getgenv().griffinVersion == gitVersion then
    print("versions match")
else
    warn("versions don't match. either you are on the wrong version or the github raw hasnt updated")
end
