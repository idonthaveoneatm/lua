--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

if identifyexecutor() == "Solara" then
    return error("THIS DOESN'T SUPPORT SOLARA")
end

print("Good vs Evil Event | griffindoescooking")

repeat
    task.wait()
until game:IsLoaded()
if game.PlaceId ~= 8737899170 and game.PlaceId ~= 16498369169 and game.PlaceId ~= 17503543197 then
    game.Players.LocalPlayer:Kick("wrong game")
end

getgenv().eventConfig = {
    farmZone = "",
    side = "",
    selectedEgg = "",
    openAmount = 1,
    openEggs = false,
    skipAnimation = false,
    collectThings = false,
    antiAFK = false
}

getgenv().griffindoescooking = false
task.wait()
getgenv().griffindoescooking = true

local UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))

local LocalPlayer = Players.LocalPlayer
local EggFrontend = getsenv(LocalPlayer.PlayerScripts.Scripts.Game["Egg Opening Frontend"])

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local ClientNetwork = require(ReplicatedStorage.Library.Client.Network)
local CustomEggCmds = require(ReplicatedStorage.Library.Client.CustomEggsCmds)
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds)

local Things = Workspace["__THINGS"]
local Instances = Things.Instances
local instanceContainer = Things["__INSTANCE_CONTAINER"]
local Lootbags = Things.Lootbags
local Orbs = Things.Orbs

local customEggs = {}
for _,v in CustomEggCmds.All() do
    if typeof(v) == "table" and not v._id:find("2x") and not v._id:find("3x") and not v._id:find("5x") and not v._id:find("10x") and not v._id:find("Police") then
        table.insert(customEggs, {
            Name = v._id,
            remoteName = v._uid,
            Position = v._position
        })
    end
end

local function getNames(tbl)
    local returnTable = {}
    for _,info in tbl do
        if typeof(info) == "table" then
            table.insert(returnTable, info.Name)
        end
    end
    return returnTable
end
local antiAFKDebounce = false
local function antiAFK()
    if eventConfig.antiAFK and not antiAFKDebounce then
        antiAFKDebounce = true
        LocalPlayer.Character.Humanoid:ChangeState(3)
        task.wait(math.random(120,180))
        antiAFKDebounce = false
    end
end
local function goTo(coord)
    if typeof(coord) == "CFrame" then
        LocalPlayer.Character:PivotTo(coord)
    else
        coord = CFrame.new(coord.X,coord.Y,coord.Z)
        goTo(coord)
    end
end
local function findInTable(tbl, name)
    for index,info in tbl do
        if typeof(info) == "table" and info.Name == name then
            return tbl[index]
        end
    end
    return nil
end
local function Invoke(name, args)
    ClientNetwork.Invoke(name, unpack(args))
end
local function Fire(name, args)
    ClientNetwork.Fire(name, unpack(args))
end
local function checkActive(name)
    if not instanceContainer.Active:FindFirstChild(name) then
        goTo(Instances[name]:FindFirstChild("Enter", true).CFrame)
    end
end
local farmEventEggsDebounce = false
local function farmEventEggs()
    if eventConfig.openEggs and not farmEventEggsDebounce then
        farmEventEggsDebounce = true
        local egg = findInTable(eggs, eventConfig.selectedEgg)
        Invoke("CustomEggs_Hatch",{egg.remoteName, eventConfig.openAmount})
        farmEventEggsDebounce = false
    end
end
local collectLootbagsDebounce = false
local function collectLootbags()
    if eventConfig.collectThings and not collectLootbagsDebounce then
        collectLootbagsDebounce = true
        local lootbags = {}
        for _, lootbag in ipairs(Lootbags:GetChildren()) do
            if not eventConfig.collectThings then break end
            lootbags[lootbag.Name] = lootbag.Name
            lootbag:Destroy()
        end
        Fire("Lootbags_Claim", {lootbags})
        collectLootbagsDebounce = false
    end
end
local collectOrbsDebounce = false
local function collectOrbs()
    if eventConfig.collectThings and not collectOrbsDebounce then
        collectOrbsDebounce = true
        local orbs = {}
        for _, orb in ipairs(Orbs:GetChildren()) do
            if not eventConfig.collectThings then break end
            table.insert(orbs, tonumber(orb.Name))
            orb:Destroy()
        end
        Fire("Orbs: Collect", {orbs})
        collectOrbsDebounce = false
    end
end
local function getMaxHatchable()
    return tonumber(EggCmds.GetMaxHatch())
end

local quake = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()
local main = quake:Window({
    Title = "Pet Simulator 99 | Good vs Evil Event",
    isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled,
    Size = {
        X = 550,
        Y = 500
    }
})
local eggTab = main:Tab({
    Name = "Eggs",
    tabColor = Color3.fromRGB(84, 177, 147),
    Image = "rbxassetid://10723345518"
})

checkActive("GoodEvilInstance")

local hasChosenSide = false
local hasChosenEgg = false
eggTab:Toggle({
    Name = "Collect Lootbags and Orbs",
    Default = eventConfig.collectThings,
    Callback = function(value)
        eventConfig.collectThings = value
    end
})
eggTab:Dropdown({
    Name = "Choose a side",
    Items = {"Good", "Evil"},
    Multiselect = false,
    Default = eventConfig.side,
    Callback = function(value)
        eventConfig.side = value
        hasChosenSide = true
    end
})
eggTab:Dropdown({
    Name = "Egg to farm",
    Items = getNames(customEggs),
    Multiselect = false,
    Default = eventConfig.selectedEgg,
    Callback = function(value)
        eventConfig.selectedEgg = value
        hasChosenEgg = true
    end
})
local slider = eggTab:Slider({
    Name = "Amount of eggs",
    Min = 1,
    Max = 99,
    InitialValue = 1,
    Step = 1,
    Callback = function(value)
        eventConfig.openAmount = value
    end
})

eggTab:Label("You must be near eggs to hatch them")
local farmEggs = eggTab:Toggle({
    Name = "Farm selected egg",
    Default = eventConfig.openEggs,
    Callback = function(value)
        local egg = findInTable(customEggs, eventConfig.selectedEgg)
        if eventConfig.side == "Good" then
            goTo(egg.Position + Vector3.new(0,0,25))
        else
            goTo(egg.Position + Vector3.new(0,0,-25))
        end
        task.wait(0.2)
        eventConfig.openEggs = value
    end
})
local oldPlayEggAnimation
oldPlayEggAnimation = hookfunction(EggFrontend.PlayEggAnimation, function(...)
    if eventConfig.skipAnimation then
        return
    end
    return oldPlayEggAnimation(...)
end)

eggTab:Toggle({
    Name = "Remove Animation",
    Default = eventConfig.skipAnimation,
    Callback = function(value)
        eventConfig.skipAnimation = value
    end
})

slider:SetValue(getMaxHatchable())
task.spawn(function()
    farmEggs:Lock("Complete Side and Egg selection")
    repeat
        task.wait()
    until hasChosenSide and hasChosenEgg
    farmEggs:Unlock()
end)

-- Anti Afk measures might not work dunno

local oldnamecall = nil
oldnamecall = hookmetamethod(game, "__namecall", function(self,...)
    local method = getnamecallmethod()
    if self.Name == "Is Real Player" or self.Name:find("Idle")and method:lower() == "invokeserver" then
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
else
    eventConfig.antiAFK = true
end

while getgenv().griffindoescooking and task.wait() do
    task.spawn(farmEventEggs)
    task.spawn(antiAFK)
    task.spawn(collectOrbs)
    task.spawn(collectLootbags)
end
