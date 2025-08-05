--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--
repeat
    task.wait()
until game:IsLoaded()
print("griffin's utility")
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
local index = 0
for i,v in Rendered:GetChildren() do
    if v.Name == "Chunker" then
        index += 1
        if index == 4 then
            Chunker4 = v
            break
        end
    end
end

local ReplicatedStorage = services.ReplicatedStorage
local Shared = ReplicatedStorage.Shared
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
local PlayerGui = LocalPlayer.PlayerGui
local Bubble = PlayerGui.ScreenGui.HUD.Left.Currency.Bubble
local BubbleLabel = Bubble.Frame.Label

local TweenService = services.TweenService
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
local PathfindingService = services.PathfindingService



--[[
Remotes
SellBubble
BlowBubble
Teleport, PathToIsland.Portal.Spawn
StartGenieQuest, 3 or 2 or 1
GumShopPurchase, Blueberry... both flavors and gums
UpdateStorage, Basic Gum
UpdateFlavor, Bubble Gum
]]

--[[
local args = {
    [1] = "GrabVisualItem",
    [2] = {
        [1] = "0548d00c-818c-4760-8217-796416b772b9"
    }
}

game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))
local args = {
    [1] = "HatchEgg",
    [2] = "Spotted Egg",
    [3] = 1
}

game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event"):FireServer(unpack(args))

]]
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
    LocalPlayer:SetAttribute("OnIsland", false)
    FireServer("Teleport", `Workspace.Worlds.{world}.Islands.{island}.Island.Portal.Spawn`)
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

local function sellBubbles()
    local text = BubbleLabel.Text
    local currentAmount = tonumber(string.split(text, ">")[2]:split("<")[1])
    local totalAmount = tonumber(text:split("/ ")[2]:split("<")[1])
    if currentAmount == totalAmount then
        FireServer("SellBubble")
    end
end

local characters = string.split("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890","")
local function randomString(length)
    if length > 0 then
        return randomString(length - 1) .. characters[math.random(1, #characters)]
    else
        return ""
    end
end

getgenv().global = {
    blow = false
}
getgenv().coroutines = {}
getgenv().connections = getgenv().connections or {}
getgenv().ui = getgenv().ui or nil
if ui then
    ui:Destroy()
end

local format = "minified"
local branch = "main"
local darius = loadstring(game:HttpGetAsync(`https://raw.githubusercontent.com/idonthaveoneatm/darius/refs/heads/{branch}/{format}.luau`))()

local window = darius:Window({
    Title = "Darius",
    Description = "What the sigma this isn't Quantum UI",
    HideBind = Enum.KeyCode.Q,
    Icon = "",
    Parent = gethui(),
    UseConfig = false,
    Workspace = "mainWorkspace",
    IsMobile = true
})
darius.OnDestruction:Connect(function()
    for i,v in coroutines do
        coroutine.close(v)
        coroutines[i] = nil
    end
    for i,v in connections do
        v:Disconnect()
    end
end)
getgenv().ui = darius

local tabs = {
    main = window:Tab({
        Name = "Main"
    }),
    teleports = window:Tab({
        Name = "Teleports"
    })
}

tabs.main:Toggle({
    LinkKeybind = true,
    Name = "blow",
    Callback = function(boolean)
        global.blow = boolean
    end
})
tabs.main:Toggle({
    LinkKeybind = true,
    Name = "sell",
    Callback = function(boolean)
        global.sell = boolean
        if global.sell then
            sellBubbles()
        end
    end
})
tabs.main:Toggle({
    LinkKeybind = true,
    Name = "pickups",
    Callback = function(boolean)
        global.pickup = boolean
        if global.pickup then
            for _,child in Chunker4:GetChildren() do
                collectPickup(child.Name)
                child:Destroy()
            end
        end
    end
})
tabs.main:Button({
    Name = "s",
    Callback = function()
        
    end
})

local selectedWorld = ""
local selectedIsland
local selectedRift
local _islands
local _rifts
local _teleportToRift
local rifts = {}
local realRifts = {}
local _teleportToIsland
tabs.teleports:Dropdown({
    Name = "Worlds",
    Items = worldNames,
    Default = "The Overworld",
    Callback = function(item)
        selectedWorld = item
        _islands:SetItems(worlds[item])
        _islands:Enable()
    end
})
_islands = tabs.teleports:Dropdown({
    Name = "Islands",
    Items = {},
    IsEnabled = false,
    DisabledText = "Select World",
    Callback = function(item)
        selectedIsland = item
        _teleportToIsland:Enable()
        _teleportToIsland:SetName(`Teleport to {selectedIsland}`)
    end
})
_teleportToIsland = tabs.teleports:Button({
    Name = `Teleport to `,
    IsEnabled = false,
    DisabledText = "Select Island",
    Callback = function()
        teleport(selectedWorld, selectedIsland)
    end
})
tabs.teleports:Divider()
_rifts = tabs.teleports:Dropdown({
    Name = "Rifts",
    Items = {},
    Callback = function(item)
        if realRifts[item] then
            _teleportToRift:Enable()
            _teleportToRift:SetName(`Select Rift {realRifts[item].Name}`)
            selectedRift = realRifts[item]
        else
            _teleportToRift:Disable()
            _teleportToRift:SetName(`Select Rift `)
        end
    end
})
_teleportToRift = tabs.teleports:Button({
    Name = "Teleport to ",
    IsEnabled = false,
    DisabledText = "Select Rift",
    Callback = function()
        teleportRift(selectedRift)
    end
})



table.insert(connections, Chunker4.ChildAdded:Connect(function(child)
    if not global.pickup then
        return
    end
    collectPickup(child.Name)
    child:Destroy()
end))

local noLucks = {
    "gift-rift",
    "golden-chest",
    "royal-chest"
}
table.insert(connections, Rifts.ChildAdded:Connect(function(child)
    local uid = randomString(6)
    realRifts[uid] = child
    local tbl
    if table.find(noLucks, child.Name) then
        tbl = {
            DisplayValue = child.Name,
            Value = uid
        }
        table.insert(rifts, tbl)
    else
        local display = child:WaitForChild("Display")
        tbl = {
            DisplayValue = `{display.SurfaceGui.Icon.Luck.Text} {child.Name}`,
            Value = uid
        }
        table.insert(rifts, tbl)
    end
    _rifts:SetItems(rifts)
    child.Destroying:Once(function()
        table.remove(rifts, table.find(rifts, tbl))
        realRifts[uid] = nil
        _rifts:SetItems(rifts)
    end)
end))
for _,child in Rifts:GetChildren() do
    local uid = randomString(6)
    realRifts[uid] = child
    local tbl
    if table.find(noLucks, child.Name) then
        tbl = {
            DisplayValue = child.Name,
            Value = uid
        }
        table.insert(rifts, tbl)
        realRifts[uid] = child
    else
        tbl = {
            DisplayValue = `{child.Display.SurfaceGui.Icon.Luck.Text} {child.Name}`,
            Value = uid
        }
        table.insert(rifts, tbl)
    end
    _rifts:SetItems(rifts)
    child.Destroying:Once(function()
        table.remove(rifts, table.find(rifts, tbl))
        realRifts[uid] = nil
        _rifts:SetItems(rifts)
    end)
end
table.insert(connections, BubbleLabel:GetPropertyChangedSignal("Text"):Connect(function()
    if global.sell then
        sellBubbles()
    end
end))


local coroutineBlow = coroutine.create(function()
    while task.wait() do
        if global.blow then
            FireServer("BlowBubble")
            task.wait(0.45)
        end
    end
end)
coroutine.resume(coroutineBlow)
table.insert(coroutines, coroutineBlow)
