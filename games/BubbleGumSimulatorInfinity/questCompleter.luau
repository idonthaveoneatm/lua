--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--
repeat
    task.wait()
until game:IsLoaded()
print("griffin's quest utility")
local services = setmetatable({},{
    __index = function(tbl,key)
        return cloneref(game:GetService(key))
    end
})

local Workspace = services.Workspace
local Worlds = Workspace.Worlds
local Islands = Worlds['The Overworld'].Islands
local Rendered = Workspace.Rendered
local Rifts = Rendered.Rifts
local Chunker4
local tmp = 0
for i,v in Rendered:GetChildren() do
    if v.Name == "Chunker" then
        tmp += 1
        if tmp == 4 then
            Chunker4 = v
            break
        end
    end
end

local ReplicatedStorage = services.ReplicatedStorage
local Client = ReplicatedStorage.Client
local LocalData = require(Client.Framework.Services.LocalData)
local Shared = ReplicatedStorage.Shared
local Data = Shared.Data
local Eggs = require(Data.Eggs)
local Framework = Shared.Framework
local Network = Framework.Network
local Remote = Network.Remote
local Event = Remote.Event
local Remotes = ReplicatedStorage.Remotes
local Pickups = Remotes.Pickups
local CollectPickup = Pickups.CollectPickup

local Players = services.Players
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart

local TweenService = services.TweenService
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
local PathfindingService = services.PathfindingService

local worlds = {}
local worldNames = {}
for _,v in Worlds:GetChildren() do
    table.insert(worldNames, v.Name)
    worlds[v.Name] = {}
    for _,v2 in v.Islands:GetChildren() do
        table.insert(worlds[v.Name], v2.Name)
    end
end

local islandNames = {}
for _,v in Islands:GetChildren() do
    table.insert(islandNames, v.Name)
end

local flavors = {
    "Molten",
    "Swirl",
    "Donut",
    "Lemon",
    "Gold",
    "Contrast",
    "Chocolate",
    "Watermelon",
    "Pizza",
    "Cherry",
    "Blueberry"
}
local storages = {
    "Experiment #52",
    "Radioactive Gum",
    "Alien Gum",
    "Quantum Gum",
    "Mega Gum",
    "XL Gum",
    "Cosmic Gum",
    "Unreal Gum",
    "Omega Gum",
    "Ultra Gum",
    "Epic Gum",
    "Chewy Gum"
}

local function FireServer(...)
    Event:FireServer(...)
end
local function collectPickup(name)
    CollectPickup:FireServer(name)
end

local function goTo(coord, y)
    y = y or 0
    if typeof(coord) == "CFrame" then
        local anim = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = coord})
        local oldJP = Character.Humanoid.JumpPower
        Character.Humanoid.JumpPower = 9e9
        anim:Play()
        repeat
            LocalPlayer.Character.Humanoid:ChangeState(0)
            task.wait()
        until anim.Completed
        Character.Humanoid.JumpPower = oldJP
    else
        coord = CFrame.new(coord.X,coord.Y + y,coord.Z)
        goTo(coord)
    end
end

local function teleport(world, island)
    if not island then
        LocalPlayer:SetAttribute("OnIsland", true)
        FireServer("Teleport", `Workspace.{world}.PortalSpawn`)
        return
    end
    LocalPlayer:SetAttribute("OnIsland", false)
    FireServer("Teleport", `Workspace.Worlds.{world}.Islands.{island}.Island.Portal.Spawn`)
end

local function pathFindTo(part)
    local path = PathfindingService:CreatePath()
    local success, result = pcall(function()
        return path:ComputeAsync(HumanoidRootPart.Position, Vector3.new(part.CFrame.X, HumanoidRootPart.CFrame.Y, part.CFrame.Z))
    end)
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _,waypoint in waypoints do
            Character.Humanoid:MoveTo(waypoint.Position)
            Character.Humanoid.MoveToFinished:Wait();
        end
        return true, path.Status
    end
    return result, path.Status
end

local function teleportRift(rift)
    local closest
    local distance = 9e9
    for i,island in Islands:GetChildren() do
        local newDist = (island.Island.Input.Position - rift.Output.Position).magnitude
        if newDist < distance and island.Island.Input.Position.Y > rift.Output.Position.Y then
            distance = newDist
            closest = island
        end
    end
    teleport("The Overworld", closest.Name)
    task.wait(0.2)
    local part = Instance.new("Part", Workspace)
    part.Size = Vector3.new(1000,2,1000)
    part.CFrame = HumanoidRootPart.CFrame - Vector3.new(0,5,0)
    part.Anchored = true
    part.Transparency = 1
    local cachedParent = closest.Parent
    closest.Parent = game.Lighting
    local path = PathfindingService:CreatePath()
    local success, result = pcall(function()
        return path:ComputeAsync(HumanoidRootPart.Position, Vector3.new(rift.Output.CFrame.X, HumanoidRootPart.CFrame.Y, rift.Output.CFrame.Z))
    end)
    if success and path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _,waypoint in waypoints do
            Character.Humanoid:MoveTo(waypoint.Position)
            Character.Humanoid.MoveToFinished:Wait();
        end
    else
        print(result,path.Status)
    end
    part:Destroy()
    closest.Parent = cachedParent
    HumanoidRootPart.CFrame = rift.Output.CFrame + Vector3.new(0,5,0)
    return (success and path.Status == Enum.PathStatus.Success) and true or false, path.Status
end

local function getBubble()
    return LocalData:Get()['Bubble'].Total
end
local function getMaxBubble()
    return LocalData:Get()['Bubble'].Amount
end
local function isMaxBubble()
    return  getMaxBubble() == getBubble()
end
local function sellBubbles()
    if isMaxBubble() then
        FireServer("SellBubble")
    end
end

local function getAreas()
    return LocalData:Get()['AreasUnlocked']
end

local function inSellRadius()
    local position = HumanoidRootPart.Position
    local sellZone = getAreas().Twilight and Worlds['The Overworld'].Islands["Twilight"].Island.Sell.Border or Worlds['The Overworld'].Sell.Border
    return (position - sellZone.Position).magnitude < 10, sellZone
end

local function getCoins()
    return LocalData:Get()['Coins']
end

local function getEggCost(egg)
    return Eggs[egg].Cost
end

local function getQuests(clean, onlyPass)
    if clean then
        local badQuests = {
            "invite-1",
            "invite-2",
            "invite-3",
            "invite-4",
            "group",
            "bounty-mythic"
        }
        local pass = {
            "daily-challenge-1",
            "daily-challenge-2",
            "daily-challenge-3",
            "hourly-challenge-1",
            "hourly-challenge-2",
            "hourly-challenge-3"
        }
        local quests = LocalData:Get()['Quests']
        for index,quest in quests do
            if onlyPass and not table.find(pass, quest.Id) then
                quests[index] = nil
                continue
            end
            if table.find(badQuests, quest.Id) then
                quests[index] = nil
            end
        end
        return quests
    end
    return LocalData:Get()["Quests"] or nil
end
local function getProgresses(quest, string)
    local _tbl = {}
    for i,v in quest.Tasks do
        _tbl[i] = string and `{quest.Progress[i]}/{v.Amount}` or quest.Progress[i]/v.Amount
    end
    return _tbl
end

local bestChances = {
    ['Common'] = {"Common Egg"},
    ['Unique'] = {"Magma Egg", "Common Egg"},
    ['Rare'] = {"Iceshard Egg", "Spotted Egg"},
    ['Epic'] = {"Spikey Egg", "Spotted Egg"},
    ['Legendary'] = {"Spikey Egg", "Infinity Egg"}
}
local formats = {
    ['Hatch'] = {
        ['Rarity'] = "Hatch %* %s Pets",
        ['Egg'] = "Hatch %* %ss",
        ['Hatch'] = "Hatch %* Eggs"
    }
}

local function taskTips(task)
    if task.Type == 'Hatch' and task.Rarity then
        return bestChances[task.Rarity] or false
    end
    if task.Type == 'Currency' then
        return getAreas().Zen == true and "Has Zen" or false
    end
    if task.Type == 'Bubbles' then
        return getAreas().Twilight == true and "Has Twilight" or false
    end
    return false
end
--[[
for _,quest in getQuests(true) do
    print(`{quest.Id}'s Stats`)
    local taskProgresses = getProgresses(quest, true)
    print('Tasks')
    for index,task in quest.Tasks do
        if formats[task.Type] then
            if task.Egg then
                print(string.format(formats[task.Type]['Egg'], taskProgresses[index], task.Egg))
            elseif task.Rarity then
                print(string.format(formats[task.Type]['Rarity'], taskProgresses[index], task.Rarity))
            else
                print(string.format(formats[task.Type]['Hatch'], taskProgresses[index]))
            end
        else
            print(task.Type, taskProgresses[index])
        end
        if taskTips(task) then
            print("Has tip")
            if typeof(taskTips(task)) == "table" then
                print(table.concat(taskTips(task), ", "))
            else
                print(taskTips(task))
            end
        end
    end
end
]]

local function getQuestsWithTask(task)
    local _tbl = {}
    for i,v in getQuests(true) do
        for i2,v2 in v.Tasks do
            if v2.Type == task then
                table.insert(_tbl, {
                    quest = v,
                    index = i
                })
            end
        end
    end
    return _tbl
end
local function getTaskFromQuest(quest, _task)
    for i,task in quest.Tasks do
        if task.Type == _task then
            return task, i
        end
    end
    return nil
end

local currentTask
local taskFunctions = {
    ['Bubbles'] = function(tip)
        local inRadius, sellZone = inSellRadius()
        if not inRadius then
            if tip then
                teleport("The Overworld", "Twilight")
                task.wait(0.2)
            end
            local result, reason = pathFindTo(sellZone)
            if not result then
                print(reason)
            end
        end
        FireServer("BlowBubble")
        task.wait(0.45)
        sellBubbles()
    end,
    ['Hatch'] = function(tip, case)
        local bestEgg
        for _,egg in tip do
            local cost = getEggCost(egg)
            if cost.Currency == "Coins" and getCoins() > cost.Amount then
                bestEgg = egg
            end
        end
        if bestEgg then
            teleport("The Overworld")
            task.wait(0.2)
        else
            print("Can't Afford any tips")
            currentTask = nil
        end
    end
}

local cachedProgress
local loopthread = coroutine.create(function()
    while task.wait() do
        if not currentTask then
            task.wait()
            continue
        end
        local quest = getQuests(true)[currentTask[1]]
        if not quest then
            print("No quest found aborting")
            currentTask = nil
            continue
        end
        local _task = quest.Tasks[currentTask[2]]
        if not _task then
            print("No task found aborting")
            currentTask = nil
            continue
        end
        local progress = getProgresses(quest, true)[currentTask[2]]
        if progress ~= cachedProgress then
            cachedProgress = progress
            print(`Task's progress: {progress}`)
        end

        if not taskFunctions[_task.Type] then
            print("No task type found aborting")
            currentTask = nil
            continue
        end

        taskFunctions[_task.Type](taskTips(_task), _task.Egg or _task.Rarity)

        if progress == 1 then
            currentTask = nil
            print("Task Complete!")
        end
    end
end)
if getgenv().loopThread then
    print("loopThread existed cleaning up")
    coroutine.close(getgenv().loopThread)
    getgenv().loopThread = nil
end
getgenv().loopThread = loopthread
coroutine.resume(loopthread)

local found = getQuestsWithTask("Hatch")[1]
if found then
    local _task, tI = getTaskFromQuest(found.quest, "Hatch")
    if _task and tI then
        print(`Starting {found.quest.Id}'s task with the type {_task.Type} {_task.Egg or _task.Rarity or "No Special"}`)
        currentTask = {found.index, tI}
        currentNames = {found.quest.Id, _task.Type}
    else
        print(`Error: "{_task}" and "{tI}"`)
    end
else
    print("None Found")
end
