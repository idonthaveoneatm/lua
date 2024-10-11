--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

local timeToLoad = tick()

getgenv().isLooping = false
task.wait(0.2)
getgenv().isLooping = true
getgenv().allowedToBuyZone = true
getgenv().activeLoopedMinigame = ""
getgenv().killswitch = false
getgenv().playerStatus = ""
getgenv().selectedQuest = ""
getgenv().quests = {}
local lastZone = ""

local oldprint = print
local print = function(...)
    oldprint("[auto rank]", ...)
end
local oldwarn = warn
local warn = function(...)
    oldwarn("[auto rank]", ...)
end

local Workspace = cloneref(game:GetService("Workspace"))
local Things = Workspace["__THINGS"]
local Instances = Things.Instances
local instanceContainer = Things["__INSTANCE_CONTAINER"]
local workspaceEggs = Things.Eggs
local Breakables = Things.Breakables
local Lootbags = Things.Lootbags
local Orbs = Things.Orbs

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts = LocalPlayer.PlayerScripts.Scripts
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
local Unlocks = LocalPlayer.PlayerGui.Rank.Frame.Rewards.Items.Unlocks
local RankUpNotif = LocalPlayer.PlayerGui.GoalsSide.Frame.Quests.QuestsGradient.QuestsHolder.RankUpNotif.Title
local RankNotification = LocalPlayer.PlayerGui.GoalsSide.Frame.Bottom.OpenRewards.Notification
local RankUp = LocalPlayer.PlayerGui.RankUp
local Rebirth = LocalPlayer.PlayerGui.Rebirth
local Currency2 = getsenv(LocalPlayerScripts.GUIs["Currency 2"])
local coinsTable = debug.getupvalue(Currency2.init, 1)
local EggFrontend = getsenv(LocalPlayerScripts.Game["Egg Opening Frontend"])
EggFrontend.PlayEggAnimation = function(...)
    return
end

local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local RunService = cloneref(game:GetService("RunService"))

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Library = ReplicatedStorage.Library
local Client = require(Library.Client)
local Quests = require(Library.Types.Quests)
local CurrencyCmds = Client.CurrencyCmds
local QuestCmds = Client.QuestCmds
local EggCmds = Client.EggCmds
local ZoneCmds = Client.ZoneCmds
local RebirthCmds = Client.RebirthCmds
local PlayerPet = Client.PlayerPet
local MasteryCmds = Client.MasteryCmds
local BreakableCmds = Client.BreakableCmds
local MapCmds = Client.MapCmds
local FlexibleFlagCmds = Client.FlexibleFlagCmds
Client.PlayerPet.CalculateSpeedMultiplier = function(...)
    return 9e9
end
local Gamepasses = Client.Gamepasses
local Network = Client.Network
local TabController = Client.TabController
local zoneDirectory = require(Library.Directory.Zones)
local shovelsDirectory = require(Library.Directory.Shovels)
local CalcEggPricePlayer = require(Library.Balancing.CalcEggPricePlayer)
local eggPriceFunction = debug.getupvalue(CalcEggPricePlayer, 1)
local getGatePrice = require(Library.Balancing.CalcGatePrice)
local zoneEggs = ReplicatedStorage['__DIRECTORY'].Eggs['Zone Eggs']
local zones = ReplicatedStorage.__DIRECTORY.Zones
local vipProductId = 257811346

local function goTo(coord)
    if typeof(coord) == "CFrame" then
        LocalPlayer.Character:PivotTo(coord)
    else
        coord = CFrame.new(coord.X,coord.Y,coord.Z)
        goTo(coord)
    end
end
local function leaveActiveInstance()
    if #instanceContainer.Active:GetChildren() == 1 then
        local activeInstance = instanceContainer.Active:GetChildren()[1].Name
        goTo(Instances[activeInstance]:FindFirstChild("Leave", true).CFrame)
        task.wait(0.2)
    end
end
leaveActiveInstance()
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

local information = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/table/"..getMap().Name..".lua"))()

local currencyAmounts = {}
for i,_ in coinsTable do
    currencyAmounts[i] = function()
        return CurrencyCmds.Get(i)
    end
end

local currencyIDAlternative = {
    ["Diamonds"] = "Diamond"
}
local validEnchantNames = {
    "Diamonds",
    "Treasure Hunter",
    "Lucky Eggs",
    "Walkspeed",
    "Criticals",
    "Tap Power",
    "Strong Pets"
}
local BooksRequiredPerTier = {
    5,
    5,
    5,
    7,
    7,
    7,
    7,
    7,
    10,
    10
}
local PotionsRequiredPerTier = {
    3,
    3,
    4,
    5,
    5,
    5,
    5,
    7,
    7
}
local questTypes

-- Misc Functions

local function findInTable(tbl, name)
    for index,info in tbl do
        if typeof(info) == "table" and info.Name == name then
            return tbl[index]
        elseif typeof(info) == "string" and info == name then
            return tbl[index]
        end
    end
    return nil
end
local function getNames(tbl)
    local returnTable = {}
    for _,info in tbl do
        if typeof(info) == "table" then
            table.insert(returnTable, info.Name)
        elseif typeof(info) == "string" then
            table.insert(returnTable, info)
        end
    end
    return returnTable
end
local function Fire(name, ...)
    return Network.Fire(name, ...)
end
local function Invoke(name, ...)
    return Network.Invoke(name, ...)
end
local function getNumber(str)
    return tonumber(string.match(str,'%d+'))
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

    local common = require(instanceContainer.Active:FindFirstChild(obbyInfo.Name):FindFirstChild("Common", true))
    common.WinTimer = 0

    goTo(obbyInfo.EndPad + Vector3.new(0,3,0))
end
local function waitFor(path, object, bool)
    bool = bool or false
    repeat
        task.wait()
    until path:FindFirstChild(object, bool)
    return path:FindFirstChild(object, bool)
end
local function clickPosition(x,y)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, nil, 1)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, nil, 1)
end

-- Player Related Functions

local function getPlayerSave()
    return Client.Save.GetSaves()[LocalPlayer]
end
local function getGoals()
    return getPlayerSave().Goals
end
local function getMaxPetsEquipped()
    return getPlayerSave().MaxPetsEquipped
end
local function getMaxHatch()
    return EggCmds.GetMaxHatch()
end
local function hasVIP()
    return Gamepasses.Owns(vipProductId)
end
local function getPets()
    return getPlayerSave().Inventory.Pet
end
local function getEquippedPets()
    local petTable = {}
    for _,pet in PlayerPet:GetAll() do
        if pet.owner and pet.owner == LocalPlayer then
            table.insert(petTable, pet)
        end
    end
    return petTable
end
local function findMiscInventoryItem(item)
    for i,v in getPlayerSave().Inventory.Misc do
        if typeof(v) == "table" and v.id and v.id == item then
            return {
                uid = i,
                quantity = v._am
            }
        end
    end
    return nil
end

-- Currency Functions

local function getCurrency(currency)
    return currencyAmounts[currency]()
end

-- Quest Functions

local function findQuestType(qType)
    for v,i in Quests.Goals do
        if qType == i then
            return tostring(v)
        end
    end
end
local function getQuests()
    local rTable = {}
    for _,v in getGoals() do
        table.insert(rTable, {
            Goal = v,
            TypeAsString = findQuestType(v.Type),
            Title = QuestCmds.MakeTitle(v)
        })
    end
    return rTable
end
local function getQuestByUID(uid)
    for _,v in getQuests() do
        if v.Goal.UID == uid then
            return v.Goal
        end
    end
    return nil
end
local function questFailure(questUID, time, questType)
    print("[FAILED]", questUID, "retrying again in", time, "s")
    task.spawn(function()
        questType.CantComplete = true
        task.wait(time)
        questType.CantComplete = false
    end)
end
local function checkPassiveFunctions()
    for _,quest in getQuests() do
        if questTypes[quest.TypeAsString]["PassiveFunction"] and selectedQuest.Goal.UID ~= quest.Goal.UID then
            questTypes[quest.TypeAsString].PassiveFunction(quest.Goal)
        end
    end
end

-- Egg Functions

local function ownsEgg(egg)
    for _,eggNumber in getPlayerSave().UnlockedEggs do
        if eggNumber == egg then
            return true
        end
    end
    return false
end
local hasFullyChecked = true
task.spawn(function()
    while not killswitch and task.wait() do
        hasFullyChecked = false
        for _,egg in ipairs(zoneEggs["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
            if not egg:IsA("ModuleScript") then
                continue
            end
            local module = require(egg)
            Invoke("Eggs_RequestUnlock", module.name)
        end
        hasFullyChecked = true
    end
end)
local function getBestEgg()
    print("waiting...")
    local timeToComplete = tick()
    repeat
        task.wait()
    until hasFullyChecked
    print("[FINISHED] getBestEgg:", tick()-timeToComplete)
    local tableToSort = {}
    for _,egg in ipairs(zoneEggs["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
        if not egg:IsA("ModuleScript") then
            continue
        end
        local module = require(egg)
        if not ownsEgg(module.eggNumber) then
            continue
        end
        local splitName = string.split(egg.Name, " | ")
        table.insert(tableToSort, {
            instance = egg,
            number = tonumber(splitName[1])
        })
    end
    table.sort(tableToSort, function(a,b)
        return a.number > b.number
    end)
    return require(tableToSort[1].instance)
end
local function calcEggPrice(egg, amount)
    return eggPriceFunction(egg, LocalPlayer) * amount
end
local function getWorstEgg()
    local tableToSort = {}
    for _,egg in ipairs(zoneEggs["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
        if not egg:IsA("ModuleScript") then
            continue
        end
        local splitName = string.split(egg.Name, " | ")
        table.insert(tableToSort, {
            instance = egg,
            number = tonumber(splitName[1])
        })
    end
    table.sort(tableToSort, function(a,b)
        return a.number > b.number
    end)
    return require(tableToSort[1].instance)
end
local function findEggInWorkspace(egg)
    for _,wEgg in workspaceEggs:GetDescendants() do
        if getNumber(wEgg.Name) and getNumber(wEgg.Name) == egg.eggNumber then
            return wEgg
        end
    end
end
local function getInventoryPetsFromEgg(egg, filters)
    assert(filters, "filters required")
    filters.pt = filters.pt or false
    filters.sh = filters.sh or false

    local petsFromEgg = {}
    for _,v in egg.pets do
        table.insert(petsFromEgg, v[1])
    end
    local petsInInventory = {}
    for _,v in petsFromEgg do
        for i2,v2 in getPets() do
            if v2.id == v then
                if not filters.sh and v2.sh then
                    continue
                end
                if not filters.pt and v2.pt then
                    continue
                end
                if filters.pt and v2.pt ~= filters.pt then
                    continue
                end

                table.insert(petsInInventory, {
                    uid = i2,
                    name = v2.id,
                    quantity = v2._am or 1,
                    sh = v2.sh or nil,
                    pt = v2.pt or nil
                })
            end
        end
    end
    return petsInInventory
end
local function getWorstEggWithRare()
    local tableToSort = {}
    for _,egg in ipairs(zoneEggs["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
        if not egg:IsA("ModuleScript") then
            continue
        end
        local module = require(egg)
        for _,v in module.pets do
            if v[3] and (v[3] == "Great" or v[3] == "Insane") then
                table.insert(tableToSort, {
                    name = module.name,
                    egg = egg,
                    number = module.eggNumber
                })
            end
        end
    end
    table.sort(tableToSort, function(a,b)
        return a.number < b.number
    end)
    if ownsEgg(tableToSort[1]) then
        return require(tableToSort[1].egg)
    end
    return nil
end

-- Zone Functions

local function getMaxZone()
    return ZoneCmds.GetMaxOwnedZone()
end
local function getZoneByName(zone)
    return zoneDirectory[zone] or nil
end
local function getNextZone()
    return ZoneCmds.GetNextZone()
end
local function getOwnedZones()
    local rTable = {}
    for i,_ in Client.Save.Get().UnlockedZones do
        if not getZoneByName(i).ZoneFolder then
            continue
        end
        rTable[i] = getZoneByName(i)
    end
    table.sort(rTable, function(a,b)
        return a.ZoneNumber < b.ZoneNumber
    end)
    return rTable
end
local function ownsZone(zone)
    if zone:find("|") then
        zone = string.split(zone, " | ")[2]
    end
    for i,_ in getOwnedZones() do
        if i == zone then
            return true
        end
    end
    return false
end
local function getBreakablesInZone(zone, class)
    class = class or "Normal"
    local returnTable = {}
    for _,v in BreakableCmds.AllByZoneAndClass(zone, class) do
        table.insert(returnTable, v)
    end
    return returnTable
end
local function goToZone(zone, doFarm)
    if typeof(zone) == "table" then
        zone = zone._id
    end
    if zone:find("|") then
        zone = string.split(zone, " | ")[2]
    end
    if lastZone == zone and doFarm and MapCmds.IsInDottedBox() then
        return
    end
    lastZone = zone

    if not getZoneByName(zone).ZoneFolder:FindFirstChild("PERSISTENT") then
        warn("Missing PERSISTENT:", zone)
        return
    end
    local teleportPart = getZoneByName(zone).ZoneFolder.PERSISTENT.Teleport
    goTo(teleportPart.CFrame + Vector3.new(0,5,0))
    waitFor(getZoneByName(zone).ZoneFolder, "INTERACT")
    if #getBreakablesInZone(zone) <= 15 then
        task.wait(2)
    end
    if doFarm then
        zone = getZoneByName(zone)
        if not zone.ZoneFolder.INTERACT["BREAKABLE_SPAWNS"]:FindFirstChild("Main") then
            local main
            for _,v in zone.ZoneFolder.INTERACT["BREAKABLE_SPAWNS"]:GetChildren() do
                if v.Name:find("Main") then
                    main = v
                end
            end
            goTo(main.Position + Vector3.new(0,5,0))
            task.wait(0.2)
        else
            goTo(zone.ZoneFolder.INTERACT["BREAKABLE_SPAWNS"].Main.Position + Vector3.new(0,5,0))
            task.wait(0.2)
        end
    end
end
local function getWorstZone()
    local tableToSort = {}
    for _,zone in ipairs(zones["World "..tostring(getNumber(getMap().Name) or 1)]:GetDescendants()) do
        local splitName = string.split(zone.Name, " | ")
        if zone:IsA("ModuleScript") then
            table.insert(tableToSort, {
                name = splitName[2],
                instance = zone,
                number = tonumber(splitName[1])
            })
        end
    end
    table.sort(tableToSort, function(a,b)
        return a.number < b.number
    end)
    return require(tableToSort[1].instance)
end
local worstZone = getWorstZone()

-- Potion Functions

local function getPotionsWithTier(tier)
    local rTable = {}
    for i,v in getPlayerSave().Inventory.Potion do
        if tier and v.tn ~= tier then
            continue
        end
        table.insert(rTable, {
            uid = i,
            name = v.id,
            quantity = v._am or 1,
            tier = v.tn
        })
    end
    return rTable
end
local function getRequiredPotionsPerTier(tier)
    return PotionsRequiredPerTier[tier] - MasteryCmds.GetPerkPower("Potions", "BetterCrafting")
end

-- Enchant Functions

local function getEnchants()
    return getPlayerSave().Inventory.Enchant
end
local function getEnchantsWithTier(tier)
    local validEnchants = {}
    for i,v in getEnchants() do
        if table.find(validEnchantNames, v.id) then
            if tier and v.tn ~= tier then
                continue
            end
            table.insert(validEnchants, {
                name = v.id,
                uid = i,
                quantity = v._am or 1,
                tier = v.tn
            })
        end
    end
    return validEnchants
end
local function getRequiredEnchantsPerTier(tier)
    return BooksRequiredPerTier[tier] - MasteryCmds.GetPerkPower("Enchants", "BetterCrafting")
end

-- Flag Functions

local function getFlags()
    local rTable = {}
    for i,v in getPlayerSave().Inventory.Misc do
        if typeof(v) == "table" and v.id:find("Flag") and v.id ~= "Flag Bundle" then
            table.insert(rTable, {
                id = v.id,
                uid = i,
                quantity = v._am or 1
            })
        end
    end
    return rTable
end
local function getFlag(flag)
    for _,iFlag in getFlags() do
        if iFlag.id == flag then
            return iFlag
        end
    end
    return nil
end
local function getWorstZoneWithNoFlag()
    local validZones = {}
    for zone,data in getOwnedZones() do
        if FlexibleFlagCmds.GetActiveFlag(1, zone) then
            continue
        end
        table.insert(validZones, data)
    end
    table.sort(validZones, function(a,b)
        return a.ZoneNumber < b.ZoneNumber
    end)
    return validZones[1]
end
local function getWorstZoneWithFlag(flag)

end

-- Breakable Functions

local function getBreakables()
    local rTable = {}
    for _, breakable in ipairs(Breakables:GetChildren()) do
        if breakable:FindFirstChildWhichIsA("MeshPart") then
            local meshPart = breakable:FindFirstChildWhichIsA("MeshPart")
            local distance = (HumanoidRootPart.Position - meshPart.Position).magnitude
            table.insert(rTable, {
                Breakable = breakable,
                Distance = distance
            })
        end
    end
    table.sort(rTable, function(a,b)
        return a.Distance < b.Distance
    end)
    return rTable
end
local function getNearestBreakables(amount)
    local breakables = getBreakables()
    local rTable = {}
    for i=1, amount do
        table.insert(rTable, breakables[i].Breakable)
    end
    return rTable
end
local function getBreakablesWithId(id, zone)
    zone = zone or false
    local vip = hasVIP()
    local rTable = {}
    for _, breakable in ipairs(Breakables:GetChildren()) do
        if not tonumber(breakable.Name) then
            continue
        end
        if breakable:GetAttribute("ParentID") == "Spawn" then
            continue
        end
        if not ownsZone(breakable:GetAttribute("ParentID")) then
            continue
        end
        if not breakable:GetAttribute("BreakableID"):find(id) then
            continue
        end
        if not vip and breakable:GetAttribute("BreakableID"):find("VIP") then
            continue
        end
        if zone and not breakable:GetAttribute("ParentID"):find(zone) then
            continue
        end

        local meshPart = breakable:FindFirstChildWhichIsA("MeshPart")
        local distance = (HumanoidRootPart.Position - meshPart.Position).magnitude
        table.insert(rTable, {
            Breakable = breakable,
            Name = breakable.Name,
            Id = breakable:GetAttribute("BreakableID"),
            Distance = distance
        })
    end
    table.sort(rTable, function(a,b)
        return a.Distance < b.Distance
    end)
    return rTable
end
local function sendPetsToBreakables(amountSending, amountPerBreakable)
    local pets = getEquippedPets()
    if amountSending > #pets then
        amountSending = #pets
    end
    if amountPerBreakable > #pets then
        amountPerBreakable = #pets
    end
    local amountOfBreakables = 0
    local tempValue = amountSending
    repeat
        task.wait()
        tempValue -= amountPerBreakable
        amountOfBreakables += 1
    until tempValue <= 0

    local targets = getNearestBreakables(amountOfBreakables)

    local currentPet = 0
    for i=1,#targets do
        if currentPet == amountSending then
            break
        end
        local target = targets[i]
        for _=1, amountPerBreakable do
            currentPet += 1
            if not target or currentPet > amountSending then
                continue
            end
            --Fire("Breakables_JoinPetBulk", {[pets[i].euid] = target})
            PlayerPet.SetTargetFromServer(pets[i], "Breakable", target)
        end
    end
end
local function sendPetsToBreakable(breakable)
    local pets = getEquippedPets()
    for i,_ in pets do
        PlayerPet.SetTargetFromServer(pets[i], "Breakable", breakable)
    end
    repeat
        task.wait()
    until 
    task.wait(0.2)
end
local function getBreakablesInZoneWithId(zone, id)
    local returnTable = {}
    for _,breakable in getBreakablesInZone(zone) do
        if not tonumber(breakable.Name) then
            continue
        end
        if breakable:GetAttribute("ParentID") == "Spawn" or breakable:GetAttribute("ParentID") == " Tech Spawn" then
            continue
        end
        if not ownsZone(breakable:GetAttribute("ParentID")) then
            continue
        end
        if not breakable:GetAttribute("BreakableID"):find(id) then
            continue
        end
        if zone and not breakable:GetAttribute("ParentID"):find(zone) then
            continue
        end

        local meshPart = breakable:FindFirstChildWhichIsA("MeshPart")
        local distance = (HumanoidRootPart.Position - meshPart.Position).magnitude
        if distance > 200 then
            continue
        end
        table.insert(returnTable, {
            Breakable = breakable,
            Name = breakable.Name,
            Id = breakable:GetAttribute("BreakableID"),
            Distance = distance
        })
    end
    return returnTable
end

-- Machine Functions

local function goToMachine(machineTable, machine)
    machine = findInTable(machineTable, machine)
    goToZone(machine.Location)
    local zone = getMap()[machine.Location]
    waitFor(zone, "INTERACT")
    goTo(zone.INTERACT.Machines[machine.Name].Arrow.CFrame + Vector3.new(0,5,0))
    task.wait(0.2)
end
local function getMachinesWithName(name)
    local rTable = {}
    local vendingMachines = getNames(information.VendingMachines)
    for _,v in vendingMachines do
        if v:find(name) then
            table.insert(rTable, findInTable(information.VendingMachines, v))
        end
    end
    return rTable
end
local function getStock(machine)
    for i,v in getPlayerSave().VendingStocks do
        if i == machine then
            return v
        end
    end
end
local function createPotionsWithTier(amount, tier)
    local machine = findInTable(information.OtherMachines, "UpgradePotionsMachine")
    local tierNeeded = tier - 1
    local potionsWithTier = getPotionsWithTier(tierNeeded)

    if machine then
        if not ownsZone(machine.Location) then
            warn("didnt own zone", machine.Location)
            return
        end

        print("going to", "UpgradePotionsMachine")
        goToMachine(information.OtherMachines, "UpgradePotionsMachine")

        for _,tItem in potionsWithTier do
            if amount <= 0 then
                break
            end
            if tierNeeded ~= tItem.tier then
                continue
            end
            if getRequiredPotionsPerTier(tItem.tier) >= tItem.quantity then
                continue
            end
            print("name:", tItem.name)
            print("tier:", tItem.tier)
            print("quantity:", tItem.quantity)
            print("itemRequiredPerTier:", getRequiredPotionsPerTier(tItem.tier))
            local itemsToUpgrade = math.clamp(math.floor(tItem.quantity/getRequiredPotionsPerTier(tItem.tier)),0, amount)
            print("itemsToUpgrade:", itemsToUpgrade)
            local response = false
            repeat
                response = Invoke("UpgradePotionsMachine_Activate", tItem.uid, itemsToUpgrade)
                task.wait()
            until response or amount <=0
            if typeof(response) == "boolean" and response then
                print("UpgradePotionsMachine_Activate returned true")
                amount -= itemsToUpgrade
                print("amount:", amount)
                task.wait(0.5)
            end
        end
    end
end

-- Gold and Rainbow Functions

local function combinePets(convertType, egg, questUID, questRemaining)
    local filters
    if convertType == "Gold" then
        filters = {sh = true, pt = false}
    elseif convertType == "Rainbow" then
        filters = {sh = true, pt = 1}
    end
    for _,pet in getInventoryPetsFromEgg(egg, filters) do
        if not getQuestByUID(questUID) then
            break
        end
        if math.floor(pet.quantity/10) <= 0 then
            continue
        end
        local petsToCombine = math.clamp(math.floor(pet.quantity/10),0, questRemaining)
        print("name:", pet.name)
        print("quantity:", pet.quantity)
        print("petsToCombine:", petsToCombine)
        local result = false
        repeat
            _, result = pcall(Invoke, convertType.."Machine_Activate", pet.uid, petsToCombine)
            task.wait()
        until result
        print("result:", result)
        if typeof(result) == "boolean" and result then
            questRemaining -= petsToCombine
            print("questRemaining:", questRemaining)
        end
    end
    return math.clamp(questRemaining, 0,9e9)
end
local function makePetsGold(quest)
    local questUID = quest.UID
    local questRemaining = quest.Amount - quest.Progress

    for _,pet in getPets() do
        if not getQuestByUID(questUID) then
            break
        end
        if math.floor(pet.quantity/10) <= 0 then
            continue
        end
        local petsToCombine = math.clamp(math.floor(pet.quantity/10),0, questRemaining)
        print("name:", pet.name)
        print("quantity:", pet.quantity)
        print("petsToCombine:", petsToCombine)
        local result = false
        repeat
            _, result = pcall(Invoke, "GoldMachine_Activate", pet.uid, petsToCombine)
            task.wait()
        until result
        print("result:", result)
        if typeof(result) == "boolean" and result then
            questRemaining -= petsToCombine
            print("questRemaining:", questRemaining)
        end
    end
end

-- Farming Functions

local function farmTableOfBreakables(breakables, questUID)
    for _,breakable in breakables do
        if not getQuestByUID(questUID) then
            break
        end
        if not BreakableCmds.Get(breakable.Name) then
            continue
        end

        --print(breakable.Name, "passed checks")
        if not breakable.Breakable:FindFirstChildWhichIsA("MeshPart") then
            warn(breakable.Name, "MeshPart not found")
            continue
        end
        goTo(breakable.Breakable:FindFirstChildWhichIsA("MeshPart").CFrame + Vector3.new(0,3,0))
        --print("waiting for", breakable.Name, "to break")
        sendPetsToBreakable(breakable.Breakable)
        if BreakableCmds.Get(breakable.Name) then
            repeat
                task.wait()
            until not BreakableCmds.Get(breakable.Name) or not getQuestByUID(questUID)
        end
    end
end
local function farmThroughOwnedZones(id, questUID)
    for i,v in getOwnedZones() do
        if not getQuestByUID(questUID) then
            break
        end
        goToZone(i)
        if #getBreakablesInZoneWithId(i, id) > 0 then
            farmTableOfBreakables(getBreakablesInZoneWithId(i, id), questUID)
        else
            if not v.ZoneFolder.INTERACT["BREAKABLE_SPAWNS"]:FindFirstChild("Main") then
                warn("couldnt find Main")
                continue
            end
            goTo(v.ZoneFolder.INTERACT["BREAKABLE_SPAWNS"].Main.Position + Vector3.new(0,3,0))
            task.wait(2)
        end
    end
end
local function farmEggForAmount(egg, amount)
    local workspaceEgg = findEggInWorkspace(egg)
    goTo(workspaceEgg.Center.CFrame)
    task.wait(0.2)
    local amountPurchased = 0
    repeat
        task.wait()
        local response = Invoke("Eggs_RequestPurchase", egg._id, getMaxHatch())
        if response then
            amountPurchased += getMaxHatch()
        end
    until amount <= amountPurchased
end
local function farmCurrencyRequired(currency, price)
    repeat
        task.wait()
        goToZone(getMaxZone(), true)
        sendPetsToBreakables(getMaxPetsEquipped(), 3)
        checkPassiveFunctions()
    until getCurrency(currency) > price
end

-- Rank Functions

local function claimRewards()
    while RankNotification.Visible and task.wait() do
        for _,v in Unlocks:GetChildren() do
            if not v:IsA("TextButton") then
                continue
            end
            task.spawn(Fire, "Ranks_ClaimReward", tonumber(v.Title.Text))
            if not v:FindFirstChild("Button") then
                continue
            end
            for _,connection in getconnections(v.Button.Activated) do
                connection:Fire()
            end
        end
    end
end

-- Rebirth Function

local function checkForRebirth()
    local nextRebirth = RebirthCmds.GetNextRebirth(LocalPlayer)
    local zoneToReturn = getZoneByName(getMaxZone()).ZoneNumber + 1
    if nextRebirth.ZoneNumberRequired <= getZoneByName(getMaxZone()).ZoneNumber then

        Invoke("Rebirth_Request", tostring(nextRebirth.RebirthNumber))
        task.wait(6)
        repeat
            if Rebirth.Enabled then
                repeat
                    clickPosition(0,0)
                    task.wait()
                until not Rebirth.Enabled
            end
            goToZone(getMaxZone(), true)
            task.wait(0.2)
            Invoke("Zones_RequestPurchase", getNextZone())
        until getZoneByName(getNextZone()).ZoneNumber >= zoneToReturn
    end
end

-- Complete Quest Functions

local function completeEggQuest(egg, quest, questType, isBest, isRare)
    if isBest then
        allowedToBuyZone = false
    end
    local eggToFarm = egg
    local currency = getCurrency(eggToFarm.currency)
    local questRemaining = quest.Amount - quest.Progress
    local totalPrice = calcEggPrice(eggToFarm, questRemaining)
    local difference = currency - totalPrice

    print("egg:", eggToFarm.name)
    print("total price:", totalPrice)
    print("coins owned:", currency)
    print("difference:", difference)
    if difference < 0 then
        print("farming", (difference * -1), "coins")
        farmCurrencyRequired(eggToFarm.currency, totalPrice)
        print("farming complete")
        questType.Function(quest)
        return
    else
        if isRare then
            print("hatching for", questRemaining, "rare pets")
            repeat
                farmEggForAmount(eggToFarm, questRemaining)
                task.wait()
            until not getQuestByUID(quest.UID)
        else
            print("hatching", questRemaining, "eggs")
            farmEggForAmount(eggToFarm, questRemaining)
        end
        print("[FINISHED]", quest.UID)
        allowedToBuyZone = true
    end
end
local function completeCombineQuest(convertType, egg, quest, questType, isBest)
    if isBest then
        allowedToBuyZone = false
    end

    local eggToFarm = egg
    local questRemaining = quest.Amount - quest.Progress
    local petsRequired

    if convertType == "Rainbow" then
        questRemaining = 9e9
    end

    if findInTable(information.OtherMachines, "GoldMachine") then
        print("going to gold machine")
        goToMachine(information.OtherMachines, "GoldMachine")
        task.wait(2)
        print("making gold pets from", eggToFarm.name.."'s pets")
        petsRequired = combinePets("Gold", eggToFarm, quest.UID, questRemaining)*10
    else
        print("super computer code here")
    end

    if convertType == "Rainbow" then
        if findInTable(information.OtherMachines, "RainbowMachine") then
            print("going to rainbow machine")
            goToMachine(information.OtherMachines, "RainbowMachine")
            task.wait(2)
            local updatedQuest = getQuestByUID(quest.UID)
            questRemaining = updatedQuest.Amount - updatedQuest.Progress
            print("making rainbow pets from", eggToFarm.name.."'s pets")
            petsRequired = combinePets("Rainbow", eggToFarm, quest.UID, questRemaining)*100
        else
            print("super computer code here")
        end
    end

    task.wait(1)
    if not getQuestByUID(quest.UID) then
        print("[FINISHED]", quest.UID)
        allowedToBuyZone = true
        return
    end

    local currency = getCurrency(eggToFarm.currency)
    local totalPrice = calcEggPrice(eggToFarm, petsRequired)
    local difference = currency - totalPrice

    print("egg:", eggToFarm.name)
    print("total price:", totalPrice, "\ncoins owned:",  currency, "\ndifference:",  difference)
    if difference < 0 then
        print("farming", difference, "coins")
        farmCurrencyRequired(eggToFarm.currency, totalPrice)
        questType.Function(quest)
    else
        print("hatching", petsRequired, "eggs")
        farmEggForAmount(eggToFarm, petsRequired)
        questType.Function(quest)
    end
end
local function completeBasicObbyQuest(obby, quest, questType)
    if not findInTable(information.Minigames, obby) then
        print("wrong world")
        questType.CantComplete = true
        return
    end

    print("traveling to", obby)
    checkActive(obby)
    task.wait(1)
    local loadedMG = waitFor(instanceContainer.Active, obby)
    task.wait(1)
    print("completing", obby)
    completeObby({
        Name = obby,
        StartLine = waitFor(loadedMG, "StartLine", true),
        EndPad = waitFor(loadedMG, "Goal", true).Pad
    })

    if not getQuestByUID(quest.UID) then
        print("[FINISHED]", quest.UID)
    else
        questType.Function(quest)
    end
end
local function completeCoinJarQuest(zone, quest, questType, isBest)
    if isBest then
        allowedToBuyZone = false
    end
    local coinJar = findMiscInventoryItem("Basic Coin Jar")

    if not coinJar then
        questFailure(quest.UID, 300, questType)
    end

    goToZone(zone, true)
    local response = Invoke("CoinJar_Spawn", coinJar.uid)
    if response then
        print("CoinJar_Spawn returned true")
        print("waiting for completion")
    end

    if not getQuestByUID(quest.UID) then
        print("[FINISHED]", quest.UID)
        allowedToBuyZone = true
    else
        questType.Function(quest)
    end
end
local function completeCometQuest(zone, quest, questType, isBest)
    if isBest then
        allowedToBuyZone = false
    end
    local comet = findMiscInventoryItem("Comet")

    if not isBest then
        print("checking zones for comets")
        farmThroughOwnedZones("Comet", quest.UID)
        if not getQuestByUID(quest.UID) then
            print("[FINISHED]", quest.UID)
            return
        end
    end

    if not comet then
        questFailure(quest.UID, 300, questType)
    end

    goToZone(zone, true)
    local response = Invoke("Comet_Spawn", comet.uid)
    if response then
        print("Comet_Spawn returned true")
    end
    task.wait(0.2)
    local cometBreakable = getBreakablesWithId("Comet", zone)
    if #cometBreakable > 0 then
        print("found comet in", zone)
        farmTableOfBreakables(cometBreakable, quest.UID)
        task.wait(1)
    end

    if not getQuestByUID(quest.UID) then
        print("[FINISHED]", quest.UID)
        allowedToBuyZone = true
    else
        questType.Function(quest)
    end
end
local function completeCollectOrUpgradeQuest(item, quest, questType, isCollect)
    isCollect = isCollect or false
    local tierNeeded = (quest[item.."Tier"] or 0) - 1
    local questRemaining = quest.Amount - quest.Progress
    local machineName = tostring("Upgrade"..item.."sMachine")

    local machine = findInTable(information.OtherMachines, machineName)
    local machines = getMachinesWithName(item)
    local itemRequiredPerTier,getItemWithTier
    if item == "Potion" then
        getItemWithTier = getPotionsWithTier
        itemRequiredPerTier = getRequiredPotionsPerTier
    elseif item == "Enchant" then
        getItemWithTier = getEnchantsWithTier
        itemRequiredPerTier = getRequiredEnchantsPerTier
    end

    print("item:", item)
    print("isCollect:", isCollect)
    print("tierNeeded?:", tierNeeded)

    if isCollect then
        print("going through vending machines")
        for _,v in machines do
            if not getQuestByUID(quest.UID) then
                break
            end
            if getStock(v) == 0 then
                continue
            end
            if not ownsZone(v.Location) then
                continue
            end

            print("going to", v.Name)
            goToMachine(information.VendingMachines, v.Name)

            print("buying items")
            local response = true
            repeat
                if not getQuestByUID(quest.UID) then
                    break
                end
                response =  Invoke("VendingMachines_Purchase", v.Name, 1)
                if typeof(response) == "boolean" and response then
                    questRemaining -= 1
                    print("questRemaining:", questRemaining)
                end
                task.wait()
            until response ~= true
        end

        if not getQuestByUID(quest.UID) then
            print("[FINISHED]", quest.UID)
            return
        end
    end
    if machine then
        if not ownsZone(machine.Location) then
            print("didnt own zone", machine.Location)
            questFailure(quest.UID, 300, questType)
            return
        end

        print("going to", machineName)
        goToMachine(information.OtherMachines, machineName)

        if isCollect then
            for i=1,10 do
                for _,tItem in getItemWithTier(i) do
                    if not getQuestByUID(quest.UID) then
                        break
                    end
                    if itemRequiredPerTier(tItem.tier) >= tItem.quantity then
                        continue
                    end
                    print("name:", tItem.name)
                    print("tier:", tItem.tier)
                    print("quantity:", tItem.quantity)
                    print("itemRequiredPerTier:",itemRequiredPerTier(tItem.tier))
                    local itemsToUpgrade = math.clamp(math.floor(tItem.quantity/itemRequiredPerTier(tItem.tier)),0, questRemaining)
                    print("itemsToUpgrade:", itemsToUpgrade)
                    local response = false
                    repeat
                        response = Invoke(machineName.."_Activate", tItem.uid, itemsToUpgrade)
                        task.wait()
                    until response or not getQuestByUID(quest.UID)
                    if typeof(response) == "boolean" and response then
                        print(machineName.."_Activate returned true")
                        questRemaining -= itemsToUpgrade
                        print("questRemaining:", questRemaining)
                        task.wait(0.5)
                    end
                end
            end
        else
            for _,tItem in getItemWithTier(tierNeeded) do
                if not getQuestByUID(quest.UID) then
                    break
                end
                if tierNeeded ~= tItem.tier then
                    continue
                end
                if itemRequiredPerTier(tItem.tier) >= tItem.quantity then
                    continue
                end
                print("name:", tItem.name)
                print("tier:", tItem.tier)
                print("quantity:", tItem.quantity)
                print("itemRequiredPerTier:",itemRequiredPerTier(tItem.tier))
                local itemsToUpgrade = math.clamp(math.floor(tItem.quantity/itemRequiredPerTier(tItem.tier)),0, questRemaining)
                print("itemsToUpgrade:", itemsToUpgrade)
                local response = false
                repeat
                    response = Invoke(machineName.."_Activate", tItem.uid, itemsToUpgrade)
                    task.wait()
                until response or not getQuestByUID(quest.UID)
                if typeof(response) == "boolean" and response then
                    print(machineName.."_Activate returned true")
                    questRemaining -= itemsToUpgrade
                    print("questRemaining:", questRemaining)
                    task.wait(0.5)
                end
            end
        end
    else
        print("super computer code here")
    end

    task.wait(1)
    if getQuestByUID(quest.UID) then
        questFailure(quest.UID, 300, questType)
    else
        print("[FINISHED]", quest.UID)
    end
end

questTypes = {
    ["BREAKABLE"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            quest.logTime = quest.logTime or tick()
            local breakableType = quest.BreakableType or nil

            if breakableType then
                farmThroughOwnedZones(breakableType, quest.UID)
            else
                goToZone(worstZone)
                sendPetsToBreakables(getMaxPetsEquipped(), 1)
            end

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
                print("time to complete", tostring(tick() - quest.logTime).."s")
            else
                questTypes.BREAKABLE.Function(quest)
            end
        end
    },
    ["PET"] = {}, -- MISSING
    ["EGG"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeEggQuest(getWorstEgg(), quest, questTypes["EGG"])
        end
    },
    ["GOLD_PET"] = {
        ["Function"] = function(quest)
            makePetsGold(quest)

            task.wait(1)
            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            end
        end
    },
    ["RAINBOW_PET"] = {}, -- MISSING
    ["ZONE"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            local zoneToBuy = getZoneByName(getNextZone())
            local currency = getCurrency(zoneToBuy.Currency)
            local price = getGatePrice(zoneToBuy)
            local difference = currency - price

            print("price:", price, "\ncoins owned:",  currency, "\ndifference:",  difference)
            if difference < 0 then
                farmCurrencyRequired(zoneToBuy.Currency, price)
                questTypes.ZONE.Function(quest)
            else
                Invoke("Zones_RequestPurchase", getNextZone())
                task.wait(3)
                if not getQuestByUID(quest.UID) then
                    print("[FINISHED]", quest.UID)
                else
                    questTypes.ZONE.Function(quest)
                end
            end
        end
    },
    ["CURRENCY"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            quest.logTime = quest.logTime or tick()
            local currencyID = currencyIDAlternative[quest.CurrencyID] or quest.CurrencyID
            if currencyID == "Diamond" then
                for i=1,12 do
                    local response = Invoke("Redeem Free Gift", i)
                    if response then
                        print("Redeem Free Gift", i, "returned true")
                        task.wait(1)
                    end
                    if not getQuestByUID(quest.UID) then
                        break
                    end
                end
            end
            farmThroughOwnedZones(currencyID, quest.UID)
            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
                print("time to complete", tostring(tick() - quest.logTime).."s")
            else
                questTypes.CURRENCY.Function(quest)
            end
        end
    },
    ["MINI_CHEST"] = {
        ["Avoid"] = true,
        ["Function"] = function(quest)
            quest.logTime = quest.logTime or tick()
            farmThroughOwnedZones("Chest", quest.UID)
            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
                print("time to complete", tostring(tick() - quest.logTime).."s")
            else
                questTypes.MINI_CHEST.Function(quest)
            end
        end
    },
    ["DIAMOND_BREAKABLE"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            quest.logTime = quest.logTime or tick()
            local worstZoneWithNoFlags = getWorstZoneWithNoFlag()
            repeat
                goToZone(worstZoneWithNoFlags, true)
                if not FlexibleFlagCmds.GetActiveFlag(1, worstZoneWithNoFlags._id) then
                    local diamondFlag = getFlag("Diamonds Flag")
                    if diamondFlag then
                        Invoke("Flags: Consume", diamondFlag.id, diamondFlag.uid)
                    end
                end
                farmTableOfBreakables(getBreakablesInZoneWithId(worstZoneWithNoFlags._id, "diamond"), quest.UID)
                task.wait(1)
            until not getQuestByUID(quest.UID)

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
                print("time to complete", tostring(tick() - quest.logTime).."s")
            else
                questTypes.DIAMOND_BREAKABLE.Function(quest)
            end
        end
    },
    ["BUY_POTION"] = {}, -- MISSING
    ["BUY_ENCHANT"] = {}, -- MISSING
    ["UPGRADE_POTION"] = {
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeCollectOrUpgradeQuest("Potion", quest, questTypes["UPGRADE_POTION"])
        end
    },
    ["UPGRADE_ENCHANT"] = {
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeCollectOrUpgradeQuest("Enchant", quest, questTypes["UPGRADE_ENCHANT"])
        end
    },
    ["COLLECT_POTION"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCollectOrUpgradeQuest("Potion", quest, questTypes["COLLECT_POTION"], true)
        end
    },
    ["COLLECT_ENCHANT"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCollectOrUpgradeQuest("Enchant", quest, questTypes["COLLECT_ENCHANT"], true)
        end
    },
    ["FREE_GIFT"] = {},
    ["FUSE_PETS"] = {},
    ["BEST_EGG"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeEggQuest(getBestEgg(), quest, questTypes["BEST_EGG"], true)
        end
    },
    ["CURRENT_BREAKABLE"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            quest.logTime = quest.logTime or tick()
            allowedToBuyZone = false
            goToZone(getMaxZone(), true)
            sendPetsToBreakables(getMaxPetsEquipped(), math.floor(getMaxPetsEquipped()/3))
            task.wait(2)
            checkPassiveFunctions()

            if not getQuestByUID(quest.UID) then
                allowedToBuyZone = true
                print("[FINISHED]", quest.UID)
                print("time to complete", tostring(tick() - quest.logTime).."s")
            else
                questTypes.CURRENT_BREAKABLE.Function(quest)
            end
        end
    },
    ["SPAWN_OBBY"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeBasicObbyQuest("SpawnObby", quest, questTypes["SPAWN_OBBY"])
        end
    },
    ["MINEFIELD"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            if not findInTable(information.Minigames, "Minefield") then
                print("wrong world")
                questTypes.MINEFIELD.CantComplete = true
                return
            end

            checkActive("Minefield")
            task.wait(2)
            local minefield = findInTable(information.Minigames, "Minefield")
            loadstring(minefield.CustomFunction)()

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            else
                questTypes.MINEFIELD.Function(quest)
            end
        end
    },
    ["ATLANTIS"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            if not findInTable(information.Minigames, "Atlantis") then
                print("wrong world")
                questTypes.ATLANTIS.CantComplete = true
                return
            end

            checkActive("Atlantis")
            task.wait(2)
            local atlantis = findInTable(information.Minigames, "Atlantis")
            loadstring(atlantis.CustomFunction)()

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            else
                questTypes.ATLANTIS.Function(quest)
            end
        end
    },
    ["DIGSITE"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            if not findInTable(information.Minigames, "Digsite") then
                print("wrong world")
                questTypes.DIGSITE.CantComplete = true
                return
            end

            checkActive("Digsite")
            task.wait(2)
            local digsite = findInTable(information.Minigames, "Digsite")
            getgenv().activeLoopedMinigame = "Digsite"
            task.spawn(loadstring(digsite.CustomFunction))
            local counter = 0
            repeat
                task.wait(1)
                for shovel,_ in shovelsDirectory do
                    Invoke("DigsiteMerchant_PurchaseShovel", shovel)
                end
                counter += 1
            until not getQuestByUID(quest.UID) or counter >= 300
            getgenv().activeLoopedMinigame = ""
            TabController.CloseTab(true)
            leaveActiveInstance()
            task.wait(1)

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            else
                questFailure(quest.UID, 300, questTypes.DIGSITE)
            end
        end
    },
    ["FISHING"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            if not findInTable(information.Minigames, "Fishing") then
                print("wrong world")
                questTypes.FISHING.CantComplete = true
                return
            end

            checkActive("Fishing")
            task.wait(2)
            local fishing = findInTable(information.Minigames, "Fishing")
            getgenv().activeLoopedMinigame = "Fishing"
            task.spawn(loadstring(fishing.CustomFunction))
            repeat
                task.wait()
            until not getQuestByUID(quest.UID)
            getgenv().activeLoopedMinigame = ""
            TabController.CloseTab(true)
            leaveActiveInstance()
            print("[FINISHED]", quest.UID)
        end
    },
    ["ICE_OBBY"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeBasicObbyQuest("IceObby", quest, questTypes["ICE_OBBY"])
        end
    },
    ["PYRAMID_OBBY"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeBasicObbyQuest("PyramidObby", quest, questTypes["PYRAMID_OBBY"])
        end
    },
    ["JUNGLE_OBBY"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            completeBasicObbyQuest("JungleObby", quest, questTypes["JUNGLE_OBBY"])
        end
    },
    ["CHEST_RUSH"] = {}, -- MISSING
    ["SLED_RACE"] = {}, -- MISSING
    ["CART_RIDE"] = {
        ["Avoid"] = false,
        ["CantComplete"] = false,
        ["Function"] = function(quest)
            if not findInTable(information.Minigames, "Minecart") then
                print("wrong world")
                questTypes.CAR_RIDE.CantComplete = true
                return
            end

            checkActive("Minecart")
            task.wait(2)
            local minecart = findInTable(information.Minigames, "Minecart")
            loadstring(minecart.CustomFunction)

            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            else
                questTypes.CART_RIDE.Function(quest)
            end
        end
    },
    ["HOVERBOARD_OBBY"] = {}, -- MISSING
    ["DIAMOND_WHEEL"] = {}, -- MISSING
    ["USE_FLAG"] = {
        ["Avoid"] = false,
        ["GenuinelyAvoid"] = false,
        ["Function"] = function(quest)
            local questRemaining = quest.Amount - quest.Progress

            local availableFlags = getFlags()

            local selectedFlag
            for _,flag in availableFlags do
                if flag.quantity > questRemaining then
                    selectedFlag = flag
                end
            end
            if selectedFlag then
                repeat
                    goToZone(getMaxZone(), true)
                    task.wait(0.2)
                    Invoke("FlexibleFlags_Consume", selectedFlag.id, selectedFlag.uid)
                until not getQuestByUID(quest.UID)
                print("[FINISHED]", quest.UID)
            else
                print("how you dont got enough flags")
            end
        end
    },
    ["USE_POTION"] = {
        ["Avoid"] = false,
        ["GenuinelyAvoid"] = false,
        ["Function"] = function(quest)
            local desiredTier = quest.PotionTier

            for _,potion in getPotionsWithTier(desiredTier) do
                if not getQuestByUID(quest.UID) then
                    break
                end
                for _=1,potion.quantity do
                    if not getQuestByUID(quest.UID) then
                        break
                    end
                    Fire("Potions: Consume", potion.uid)
                    task.wait(0.2)
                end
            end
            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            else
                local newQuest = getQuestByUID(quest.UID)
                createPotionsWithTier(newQuest.Amount - newQuest.Progress, desiredTier)
            end
        end,
        ["PassiveFunction"] = function(quest)
            local desiredTier = quest.PotionTier

            for _,potion in getPotionsWithTier(desiredTier) do
                if not getQuestByUID(quest.UID) then
                    break
                end
                for _=1,potion.quantity do
                    if not getQuestByUID(quest.UID) then
                        break
                    end
                    Fire("Potions: Consume", potion.uid)
                    task.wait(0.2)
                end
            end
            if not getQuestByUID(quest.UID) then
                print("[FINISHED]", quest.UID)
            end
        end
    },
    ["USE_FRUIT"] = {}, -- MISSING
    ["BEST_COIN_JAR"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCoinJarQuest(getMaxZone(), quest, questTypes["BEST_COIN_JAR"], true)
        end
    },
    ["BEST_COMET"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCometQuest(getMaxZone(), quest, questTypes["BEST_COMET"], true)
        end
    },
    ["BEST_MINI_CHEST"] = {
        ["Avoid"] = true,
        ["Function"] = function(quest)
            allowedToBuyZone = false
            goToZone(getMaxZone(), true)
            if #getBreakablesWithId("Chest", getMaxZone()) > 0 then
                local chest = getBreakablesWithId("Chest", getMaxZone())[1]
                if BreakableCmds.Get(chest.Name) then
                    sendPetsToBreakable(chest.Breakable)
                    repeat
                        task.wait()
                    until not BreakableCmds.Get(chest.Name)
                end
            else

                sendPetsToBreakables(getMaxPetsEquipped(), math.floor(getMaxPetsEquipped()/3))
            end
            if not getQuestByUID(quest.UID) then
                allowedToBuyZone = true
                print("[FINISHED]", quest.UID)
            else
                questTypes.BEST_MINI_CHEST.Function(quest)
            end
        end,
        ["PassiveFunction"] = function(quest)
            if lastZone == getMaxZone() and MapCmds.IsInDottedBox() then
                local miniChests = getBreakablesWithId("chest", getMaxZone())
                farmTableOfBreakables(miniChests, quest)
            end
        end
    },
    ["BEST_GOLD_PET"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCombineQuest("Gold", getBestEgg(), quest, questTypes["BEST_GOLD_PET"], true)
        end
    },
    ["BEST_RAINBOW_PET"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCombineQuest("Rainbow", getBestEgg(), quest, questTypes["BEST_RAINBOW_PET"], true)
        end
    },
    ["HATCH_RARE_PET"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            if getWorstEggWithRare() then
                completeEggQuest(getWorstEggWithRare(), quest, questTypes["HATCH_RARE_PET"], false, true)
            else
                questFailure(quest.UID, 600, questTypes["HATCH_RARE_PET"])
            end
        end
    },
    ["BEST_PINATA"] = {}, -- MISSING
    ["BEST_LUCKYBLOCK"] = {}, -- MISSING
    ["ADVANCED_DIGSITE"] = {}, -- MISSING
    ["ADVANCED_FISHING"] = {}, -- MISSING
    ["INDEX_PET"] = {}, -- MISSING
    ["BLACK_LUCKY_BLOCK"] = {}, -- MISSING
    ["FISH_SHARD"] = {}, -- MISSING
    ["MAGIC_POOL"] = {}, -- MISSING
    ["SELL_AT_BOOTH"] = {}, -- Can't complete
    ["TRADE_PLAYER"] = {}, -- MISSING
    ["FREE_GIFT_IN_TRADE"] = {}, -- MISSING
    ["FREE_GIFT_IN_MAIL"] = {}, -- MISSING
    ["USE_SECRET_KEY"] = {}, -- MISSING
    ["USE_CRYSTAL_KEY"] = {}, -- MISSING
    ["UPGRADE_FRUIT"] = {}, -- MISSING
    ["PLANT_GARDEN"] = {}, -- MISSING
    ["ITEM_CREATOR"] = {}, -- MISSING
    ["GET_CRITICAL"] = {}, -- MISSING
    ["COLLECT_LOOTBAG"] = {}, -- MISSING
    ["COLLECT_FRUIT"] = {}, -- MISSING
    ["COIN_JAR"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCoinJarQuest(worstZone, quest, questTypes["COIN_JAR"])
        end
    },
    ["COMET"] = {
        ["Avoid"] = false,
        ["Function"] = function(quest)
            completeCometQuest(worstZone, quest, questTypes["COMET"])
        end
    },
    ["PINATA"] = {}, -- MISSING
    ["LUCKYBLOCK"] = {}, -- MISSING
    ["RANDOM_COIN_JAR"] = {}, -- MISSING
    ["RANDOM_COMET"] = {}, -- MISSING
    ["RANDOM_PINATA"] = {}, -- MISSING
    ["RANDOM_LUCKYBLOCK"] = {}, -- MISSING
    ["RANDOM_MINI_CHEST"] = {}, -- MISSING
    ["HIDEOUT_BREAKABLE"] = {}, -- MISSING
    ["XP_POTION"] = {}, -- MISSING
    ["SUPERIOR_MINI_CHEST"] = {}, -- MISSING
    ["BEST_SUPERIOR_MINI_CHEST"] = {
        ["Avoid"] = true,
        ["GenuinelyAvoid"] = true,
        ["Function"] = function(quest)
            allowedToBuyZone = false
            repeat
                goToZone(getMaxZone(), true)
                task.wait(0.2)
                sendPetsToBreakables(getMaxPetsEquipped(), 1)
            until not getQuestByUID(quest.UID)
            allowedToBuyZone = true
            print("[FINISHED]", quest.UID)
        end,
        ["PassiveFunction"] = function(quest)
            if lastZone == getMaxZone() and MapCmds.IsInDottedBox() then
                local miniChests = getBreakablesWithId("chest", getMaxZone())
                farmTableOfBreakables(miniChests, quest)
            end
        end
    },
    ["RANDOM_SUPERIOR_MINI_CHEST"] = {}, -- MISSING
    ["COLLECT_PRISON_KEY"] = {}, -- MISSING
    ["COLLECT_SUMMER_SHELL"] = {}, -- MISSING
    ["COLLECT_HACKER_KEY"] = {}, -- MISSING
    ["MAP_UPGRADE"] = {}, -- MISSING
    ["EQUIP_PET"] = {}, -- MISSING
    ["SPECIFIC_ZONE"] = {}, -- MISSING
    ["HATCH_CUSTOM_EGG"] = {} -- MISSING
}

-- checks if we cant rank up

task.spawn(function()
    while isLooping and task.wait() do
        local claimedCount = 0
        for _,v in ipairs(Unlocks:GetChildren()) do
            if v.Name == "ClaimedSlot" then
                claimedCount += 1
            end
        end
        if claimedCount >= (#Unlocks:GetChildren() - 2) then
            if RankUpNotif.Text:find("Area") then
                local areaNumber = getNumber(RankUpNotif.Text)
                repeat
                    print("zone unlock from rank up")
                    goToZone(getMaxZone(), true)
                    Invoke("Zones_RequestPurchase", getNextZone())
                    task.wait(2)
                until areaNumber == getZoneByName(getMaxZone()).ZoneNumber
            end
        end
    end
end)

-- Auto grab orbs n stuff

task.spawn(function()
    local collectLootbagsDebounce = false
    local collectOrbsDebounce = false
    while isLooping and task.wait() do
        task.spawn(function()
            if not collectLootbagsDebounce then
                collectLootbagsDebounce = true
                local lootbags = {}
                for _, lootbag in ipairs(Lootbags:GetChildren()) do
                    if not isLooping then break end
                    lootbags[lootbag.Name] = lootbag.Name
                    lootbag:Destroy()
                end
                Fire("Lootbags_Claim", lootbags)
                collectLootbagsDebounce = false
            end
        end)
        task.spawn(function()
            if not collectOrbsDebounce then
                collectOrbsDebounce = true
                local orbs = {}
                for _, orb in ipairs(Orbs:GetChildren()) do
                    if not isLooping then break end
                    table.insert(orbs, tonumber(orb.Name))
                    orb:Destroy()
                end
                Fire("Orbs: Collect", orbs)
                collectOrbsDebounce = false
            end
        end)
    end
end)

-- Anti Afk measures might not work dunno

local oldnamecall = nil
oldnamecall = hookmetamethod(game, "__namecall", function(self,...)
    local method = getnamecallmethod()
    if (self.Name == "Is Real Player" or self.Name:find("Idle")) and method:lower() == "invokeserver" then
        print(self.Name, "attempted to run")
        return
    end
    return oldnamecall(self,...)
end)
LocalPlayer.PlayerScripts.Scripts.Core["Idle Tracking"].Enabled = false

if getconnections then
    for _,connection in getconnections(LocalPlayer.Idled) do
        if connection["Disable"] then
            connection["Disable"](connection)
        elseif connection["Disconnect"] then
            connection["Disconnect"](connection)
        end
    end
end

local questConnections = {}

local completionCounter = 0
local function chooseQuest()
    for _,connection in questConnections do
        connection:Disconnect()
    end
    table.clear(questConnections)

    local highestQuest
    local highestStars = 0
    for _,quest in getQuests() do
        local uid = quest.Goal.UID
        table.insert(questConnections, RunService.Stepped:Connect(function()
            if not getQuestByUID(uid) and selectedQuest.Goal.UID ~= uid then
                completionCounter += 1
                print("[FINISHED]", uid)
                print("completionCounter:", completionCounter)
                return
            end
        end))
        print("added connection for", uid)
        local questType = questTypes[quest.TypeAsString]
        if highestStars < quest.Goal.Stars and questType and questType.Function and not questType.Avoid and not questType.GenuinelyAvoid and not questType.CantComplete then
            highestQuest = quest
            highestStars = quest.Goal.Stars
        end
    end
    if not highestQuest then
        for _,quest in getQuests() do
            local questType = questTypes[quest.TypeAsString]
            if highestStars < quest.Goal.Stars and questType and questType.Function and not questType.GenuinelyAvoid and not questType.CantComplete then
                highestQuest = quest
                highestStars = quest.Goal.Stars
            end
        end
    end
    if not highestQuest then
        task.wait(20)
        return warn("no quest available")
    end
    selectedQuest = highestQuest or ""
    return highestQuest
end
local function doQuest()
    local quest = chooseQuest()
    if not quest then
        return
    end
    setreadonly(quest.Goal, false)
    print("quest:", quest.Title)
    print("type:", quest.TypeAsString)
    print("uid:", quest.Goal.UID)
    questTypes[quest.TypeAsString].Function(quest.Goal)
end

---RunService:Set3dRenderingEnabled(false)

print("loaded:", tick()-timeToLoad)

while not killswitch and task.wait() do
    leaveActiveInstance()
    if completionCounter >= 3 then
        if allowedToBuyZone then
            Invoke("Zones_RequestPurchase", getNextZone())
        end
        completionCounter = 0
    end
    task.spawn(claimRewards)
    if RankUp.Enabled then
        repeat
            clickPosition(0,0)
            task.wait()
        until not RankUp.Enabled
    end
    checkForRebirth()
    doQuest()
    completionCounter += 1
end
