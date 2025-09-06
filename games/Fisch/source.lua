--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

-- Globals

getgenv().usemetamethodhook = true
getgenv().shakedelay = 0
getgenv().catchdelay = 0.5
getgenv().castdelay = 0.2
getgenv().autocast = false
getgenv().autoshake = false
getgenv().autoreel = false
getgenv().morelegit = false
getgenv().perfectcatch = false
getgenv().disableeffects = false
getgenv().loopoffer = false
getgenv().loopAppraise = false
getgenv().loopPower = false

-- Services

local service = {}
setmetatable(service, {
    __index = function(_, key)
        return cloneref(game:GetService(key))
    end
})
local Players = service.Players
local ReplicatedStorage = service.ReplicatedStorage
local GuiService = service.GuiService
local RunService = service.RunService
local VirtualUser = service.VirtualUser
local HttpService = service.HttpService
local Workspace = service.Workspace

-- Conenctions

getgenv().connections = connections or {}
for _,v in connections do
    if typeof(v) == "thread" then
        coroutine.close(v)
    elseif typeof(v) == "RBXScriptConnection" then
        v:Disconnect()
    end
end
table.clear(connections)

-- Saved Positions

if not isfolder("fisherman") then
    makefolder("fisherman")
end
if not isfile("fisherman/positions.json") then
    writefile("fisherman/positions.json","{}")
end
local savedPositions = HttpService:JSONDecode(readfile("fisherman/positions.json"))
local savedPositionMT = {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for _,v in tbl do
                table.insert(names, v.name)
            end
            return names
        end
        return nil
    end
}
setmetatable(savedPositions, savedPositionMT)
local function getSavedPosition(name)
    for _,position in savedPositions do
        if position.name == name then
            return position
        end
    end
end
local function convertStringToCFrame(stringedCFrame)
    local numbers = stringedCFrame:split(", ")
    return CFrame.new(unpack(numbers))
end

-- Interface

local format = "minified"
local branch = "main"
local darius = loadstring(game:HttpGetAsync(`https://raw.githubusercontent.com/idonthaveoneatm/darius/refs/heads/{branch}/{format}.luau`))()    

-- Variables

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local animations = ReplicatedStorage.resources.animations
local allRods = require(ReplicatedStorage.modules.library.rods)
local catchCount = 0
local savedPosition

local function reelfinished(...)
    local reelEvent
    for i,v in ReplicatedStorage.events:GetChildre() do
        if v.Name:find("reelfinished") then
            reelEvent = v
            if v.Name:find(" ") then
                break
            end
        end
    end
    reelEvent:FireServer(...)
end

-- Functions

local function findRodInstance()
    local rod
    for _,child in Character:GetChildren() do
        if allRods[child.Name] ~= nil then
            rod =  child
            break
        end
    end
    for _,child in LocalPlayer.Backpack:GetChildren() do
        if allRods[child.Name] ~= nil then
            rod =  child
            break
        end
    end
    return rod
end
local function random(min, max, decimal)
    decimal = decimal or 0
    return math.random(min * math.pow(10, decimal)), max*math.pow(10, decimal)/math.pow(10, decimal)
end
local function sendKeystroke(key)
    service.VirtualInputManager:SendKeyEvent(true, key, false, nil)
    service.VirtualInputManager:SendKeyEvent(false, key, false, nil)
end
local function getAppraiser()
    return Workspace.world.npcs:FindFirstChild("Appraiser")
end
local function getMerlin()
    return Workspace.world.npcs:FindFirstChild("Merlin")
end

-- Inventory

local inventoryDropdown
local specificItem

local inventoryItems = setmetatable({}, {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for i,v in tbl do
                table.insert(names, `{tostring(i)}: {tostring(#v)}`)
            end
            return names
        end
        return nil
    end
})
local function addInventoryItem(...)
    local args = {...}
    local item = #args == 2 and args[2] or args[1]
    inventoryItems[item.Value] = inventoryItems[tostring(item.Value)] or {}
    local itemStats = {
        name = item.Value,
        uid = item.Name
    }
    for _,stat in item:GetChildren() do
        itemStats[stat.Name:lower()] = stat
    end
    setmetatable(itemStats, {
        __tostring = function(tbl)
            local returnString = ""
            for i,v in tbl do
                if typeof(v) ~= "string" then
                    returnString = returnString..`\n{i}: {tostring(v.Value)}`
                else
                    returnString = returnString..`\n{i}: {tostring(v)}`
                end
            end
            return returnString
        end
    })
    table.insert(inventoryItems[itemStats.name], itemStats)
    local itemIndex = table.find(inventoryItems[itemStats.name], itemStats)
    item.Destroying:Connect(function()
        --print(`removing {item.uid} at index {tostring(itemIndex)} from {itemStats.name}`)
        table.remove(inventoryItems[itemStats.name], itemIndex)
    end)
    if inventoryDropdown then
        inventoryDropdown:SetItems(inventoryItems.names)
    end
    if specificItem then
        specificItem:SetItems({})
    end
end
table.foreach(ReplicatedStorage.playerstats[LocalPlayer.Name].Inventory:GetChildren(), addInventoryItem)
table.insert(connections, ReplicatedStorage.playerstats[LocalPlayer.Name].Inventory.ChildAdded:Connect(addInventoryItem))
local function findByUID(item:table, uid:string)
    for i,v in item do
        if v.uid == uid then
            return v
        end
    end
    return nil
end
local function findItemGear(uid)
    for _,gear in LocalPlayer.Backpack:GetChildren() do
        if gear:FindFirstChild("link") and gear.link.Value.Name == uid then
            return gear
        end
    end
end

-- Baits

local baits = setmetatable({}, {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for _,v in tbl do
                if v.quantity.Value == 0 then
                    continue
                end
                table.insert(names, v.name)
            end
            return names
        end
        return nil
    end
})
local function addBait(...)
    local args = {...}
    local bait = args[2] or args[1]
    local cleanName = string.gsub(bait.Name, "bait_", "")
    local baitStats = {
        name = cleanName,
        quantity = bait
    }
    setmetatable(baitStats, {
        __tostring = function(tbl)
            local returnString = ""
            for i,v in tbl do
                if typeof(v) ~= "string" then
                    returnString = returnString..`{i}: {tostring(v.Value)}\n`
                else
                    returnString = returnString..`{i}: {tostring(v)}\n`
                end
            end
            return returnString
        end
    })
    table.insert(baits, baitStats)
    table.find(baits, baitStats)
end
table.foreach(ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.bait:GetChildren(), addBait)
table.insert(connections, ReplicatedStorage.playerstats[LocalPlayer.Name].Stats.bait.ChildAdded:Connect(addBait))

-- Rods

local rods = setmetatable({}, {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for _,v in tbl do
                table.insert(names, v.name)
            end
            return names
        end
        return nil
    end
})
local function addRod(...)
    local args = {...}
    local rod = args[2] or args[1]
    local rodStats = {
        name = rod.Name,
        enchant = rod.Value ~= "none" and rod.Value or nil
    }
    for _,stat in rod:GetChildren() do
        if stat.Name == "Favourited" then
            continue
        end
        rodStats[stat.Name:lower()] = stat
    end
    setmetatable(rodStats, {
        __tostring = function(tbl)
            local returnString = ""
            for i,v in tbl do
                if typeof(v) ~= "string" then
                    returnString = returnString..`{i}: {tostring(v.Value)}\n`
                else
                    returnString = returnString..`{i}: {tostring(v)}\n`
                end
            end
            return returnString
        end
    })
    table.insert(rods, rodStats)
end
table.foreach(ReplicatedStorage.playerstats[LocalPlayer.Name].Rods:GetChildren(), addRod)
table.insert(connections, ReplicatedStorage.playerstats[LocalPlayer.Name].Rods.ChildAdded:Connect(addRod))
local function findRod(rod)
    rod = rod:gsub(": %*")
    for _,v in rods do
        if v.name == rod then
            return v
        end
    end
end

-- teleportSpots

local teleportSpots = setmetatable({}, {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for _,v in tbl do
                table.insert(names, v.name)
            end
            return names
        end
        return nil
    end
})
local function addteleportSpot(_, teleportSpot)
    local teleportSpotStats = {
        name = teleportSpot.Name,
        instance = teleportSpot
    }
    setmetatable(teleportSpotStats, {
        __tostring = function(tbl)
            local returnString = ""
            for i,v in tbl do
                returnString = returnString..`{i}: {tostring(v)}\n`
            end
            return returnString
        end
    })
    table.insert(teleportSpots, teleportSpotStats)
end
table.foreach(Workspace.world.spawns.TpSpots:GetChildren(), addteleportSpot)
local function getTeleportSpot(name)
    for _,teleportSpot in teleportSpots do
        if teleportSpot.name == name then
            return teleportSpot
        end
    end
end

-- Spawns

local spawns = setmetatable({}, {
    __index = function(tbl,key)
        if key == "names" then
            local names = {}
            for _,v in tbl do
                table.insert(names, v.name)
            end
            return names
        end
        return nil
    end
})
local blacklistSpawns = {"TpSpots","loading","TeleportDelay"}
local function addSpawn(_, spawn)
    if table.find(blacklistSpawns, spawn.Name) then
        return
    end
    local spawnStats = {
        name = spawn.Name,
        instance = spawn:FindFirstChild("spawn")
    }
    setmetatable(spawnStats, {
        __tostring = function(tbl)
            local returnString = ""
            for i,v in tbl do
                returnString = returnString..`{i}: {tostring(v)}\n`
            end
            return returnString
        end
    })
    table.insert(spawns, spawnStats)
end
table.foreach(Workspace.world.spawns:GetChildren(), addSpawn)
local function getSpawn(name)
    for _,spawn in spawns do
        if spawn.name == name then
            return spawn
        end
    end
end

-- Rod

local rod = {}
rod.__index = rod
rod.name = findRodInstance().Name
rod.equipped = false
rod.values = findRodInstance().values
rod.instance = Character:FindFirstChild(rod.name) or LocalPlayer.Backpack:FindFirstChild(rod.name)
function rod.update(isHook)
    rod.name = findRodInstance().Name
    rod.values = findRodInstance().values
    rod.instance = Character:FindFirstChild(rod.name) or LocalPlayer.Backpack:FindFirstChild(rod.name)
    if isHook then
        if LocalPlayer.Backpack:FindFirstChild(rod.name) then
            rod.equipped = false
        else
            rod.equipped = true
        end
    end
end
function rod.equip()
    rod.equipped = true
    return LocalPlayer.Backpack:FindFirstChild(rod.name) and Character.Humanoid:EquipTool(rod.instance) and true or false
end
function rod.unequip()
    rod.equipped = false
    return Character:FindFirstChild(rod.name) and Character.Humanoid:UnequipTools(rod.name) and true or false
end
function rod.cast(...)
    rod.instance.events.cast:FireServer(...)
end
rod.events = {
    ['equippedEvent'] = Instance.new("BindableEvent")
}
rod.equippedChanged = rod.events.equippedEvent.Event
rod.monitoring = {
    ['lastEquipped'] = rod.equipped,
    ['equipped'] = RunService.RenderStepped:Connect(function()
        if rod.equipped ~= rod.monitoring.lastEquipped then
            rod.monitoring.lastEquipped = rod.equipped
            rod.events.equippedEvent:Fire(rod.equipped)
        end
    end)
}
table.insert(connections, rod.monitoring.equipped)
rod.equippedChanged:Connect(function(status)
    if not status then
        catchCount = 0
    else
        savedPosition = Character.HumanoidRootPart.CFrame
    end
end)

-- __namecall Hook

local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == rod.instance.events.cast and usemetamethodhook then
        return oldnamecall(self, random(97,100, 4), 1)
    elseif method == "FireServer" and self.Name == "reset" then
        task.spawn(rod.update, true)
    elseif method == "FireServer" and self.Name:find("reelfinished") then
        catchCount += 1
        if not checkcaller() and perfectcatch then
            return oldnamecall(self, ({...})[1], perfectcatch)
        end
    end
    return oldnamecall(self, ...)
end)

-- Fish Farm

local function pressShakeButtons(shakeui)
    if shakeui.Name ~= "shakeui" then
        return
    end
    local safeZone = shakeui:FindFirstChild("safezone")
    local connect = safeZone:FindFirstChild("connect")
    connect.Enabled = false
    safeZone.Size = UDim2.fromOffset(0, 0)
    safeZone.Position = UDim2.fromScale(0.5, 0.5)
    safeZone.AnchorPoint = Vector2.new(0.5, 0.5)
    safeZone.ChildAdded:Connect(function(button)
        if button.Name ~= "button" and not button:IsA("ImageButton") then
            return
        end
        if not autoshake then
            return
        end
        button.Selectable = true

        local isDestroyed = false
        local connection = button.Destroying:Connect(function()
            isDestroyed = true
        end)
        pcall(function()
            task.wait(shakedelay)
            repeat
                GuiService.AutoSelectGuiEnabled = false
                GuiService.GuiNavigationEnabled = true

                GuiService.SelectedObject = button
                sendKeystroke(Enum.KeyCode.Return)
                task.wait()
                GuiService.SelectedObject = nil

                GuiService.AutoSelectGuiEnabled = true
                GuiService.GuiNavigationEnabled = false
            until isDestroyed
            connection:Disconnect()
        end)
    end)
end
local function progressCatch(reelui)
    if reelui.Name ~= "reel" then
        return
    end
    local isDestroyed = false
    local connection = reelui.Destroying:Connect(function()
        isDestroyed = true
    end)
    if autoreel then
        local playerbar = reelui.bar.playerbar
        local fish = reelui.bar.fish
        task.spawn(function()
            repeat
                task.wait()
                playerbar.Position = fish.Position
            until isDestroyed
        end)
        task.wait(catchdelay)
        if not morelegit then
            repeat
                task.wait(1.5)
                if isDestroyed then break end
                reelfinished(100, perfectcatch)
            until isDestroyed or morelegit
        end
    end
    connection:Disconnect()
end

table.insert(connections, LocalPlayer.PlayerGui.ChildAdded:Connect(pressShakeButtons))
table.insert(connections, LocalPlayer.PlayerGui.ChildAdded:Connect(progressCatch))

local castingCoroutine = coroutine.create(function()
    while task.wait(0.4) do
        if catchCount >= 5 then
            task.wait(0.2)
            Character.HumanoidRootPart.CFrame = savedPosition
            catchCount = 0
        end
        if not autocast or not rod.equipped or rod.values.casted.Value then
            continue
        end
        local castAnimation = Character.Humanoid:LoadAnimation(animations.fishing.throw)
        castAnimation.Priority = Enum.AnimationPriority.Action3
        castAnimation:Play()
        rod.cast()
        castAnimation.Stopped:Wait()
        castAnimation:Destroy()

        local waitAnimation = Character.Humanoid:LoadAnimation(animations.fishing.waiting)
        waitAnimation.Priority = Enum.AnimationPriority.Action3
        waitAnimation:Play()

        local castConnection, equippedChanged
        castConnection = rod.values.casted.Changed:Connect(function()
            castAnimation:Stop()
            waitAnimation:Stop()
            waitAnimation:Destroy()
            castConnection:Disconnect()
        end)

        equippedChanged = rod.equippedChanged:Connect(function(value)
            if not value then
                castAnimation:Stop()
                waitAnimation:Stop()
                waitAnimation:Destroy()
                equippedChanged:Disconnect()
                castConnection:Disconnect()
            end
        end)
    end
end)

-- Disable Effects

local _zone = Instance.new("Part")
local priority = Instance.new("IntValue", _zone)
priority.Name = "priority"
priority.Value = 100
local _name = Instance.new("StringValue", _zone)
_name.Name = "zonename"
_name.Value = "Disabled Zone Effects"

local cachedOldZone
table.insert(connections, RunService.RenderStepped:Connect(function()
    cachedOldZone = Character.zone.Value ~= _zone and Character.zone.Value or cachedOldZone
    if disableeffects then
        Character.zone.Value = _zone
    end
end))

local window = darius:Window({
    Title = "Fisherman",
    Description = "Contact @griffindoescooking on Discord for questions",

    -- Optional
    HideBind = Enum.KeyCode.T,
    Parent = gethui(), -- Defaults to game.CoreGui
    --UseConfig = true,
    Config = "fisherman",
    IsMobile = true,
})

local fishing = window:Tab({
    Name = "Fishing"
})
local teleporting = window:Tab({
    Name = "Teleportation"
})
local inventory = window:Tab({
    Name = "Inventory"
})
local merlin = window:Tab({
    Name = "Merlin"
})

local dupe = window:Tab({
    Name = "Dupe"
})

fishing:Toggle({
    Name = "Auto Cast",
    Callback = function(value)
        autocast = value
    end,
    FLAG = "autocast",
    Default = false,
    LinkKeybind = true
})

fishing:Slider({
    Name = "Auto Cast Delay",
    Min = 0,
    Max = 1,
    Callback = function(value)
        castdelay = value
    end,
    FLAG = "autocastdelay",
    Default = 0.5,
    DecimalPlace = 2
})

fishing:Toggle({
    Name = "Auto Shake",
    Callback = function(value)
        autoshake = value
    end,
    FLAG = "autoshake",
    Default = false,
    LinkKeybind = true
})

fishing:Slider({
    Name = "Auto Shake Delay",
    Min = 0,
    Max = 1,
    Callback = function(value)
        shakedelay = value
    end,
    FLAG = "autoshakedelay",
    Default = 0,
    DecimalPlace = 2
})
fishing:Toggle({
    Name = "Auto Catch",
    Callback = function(value)
        autoreel = value
    end,
    FLAG = "autocatch",
    Default = false,
    LinkKeybind = true
})
fishing:Toggle({
    Name = "Always perfect",
    Callback = function(value)
        perfectcatch = value
    end,
    FLAG = "perfectcatch",
    Default = false,
    LinkKeybind = true
})
fishing:Toggle({
    Name = "Make it more legit",
    Callback = function(value)
        morelegit = value
    end,
    FLAG = "autocatchmorelegit",
    Default = false,
    LinkKeybind = true
})

fishing:Slider({
    Name = "Auto Catch Delay",
    Min = 0,
    Max = 10,
    Callback = function(value)
        catchdelay = value
    end,
    FLAG = "autocatchdelay",
    Default = 0.5,
    DecimalPlace = 2
})

fishing:Toggle({
    Name = "Disable Effects",
    Callback = function(value)
        disableeffects = value
    end
})

fishing:Toggle({
    Name = "Disable 3d Rendering",
    Callback = function(value)
        RunService:Set3dRenderingEnabled(value)
    end
})

local selectedItem
local teleportButton
teleporting:Dropdown({
    Name = "Select Teleport Spot",
    Items = teleportSpots.names,
    Callback = function(value)
        selectedItem = getTeleportSpot(value)
        teleportButton:Enable()
        teleportButton:SetName(`Teleport to: {value}`)
    end,
    Regex = function(s)
        return s
    end
})
teleporting:Dropdown({
    Name = "Select Spawn",
    Items = spawns.names,
    Callback = function(value)
        selectedItem = getSpawn(value)
        teleportButton:Enable()
        teleportButton:SetName(`Teleport to: {value}`)
    end,
    Regex = function(s)
        return s
    end
})

local listedPositions
listedPositions = teleporting:Dropdown({
    Name = "Select Saved Position",
    Items = savedPositions.names,
    Callback = function(value)
        selectedItem = getSavedPosition(value)
        teleportButton:Enable()
        teleportButton:SetName(`Teleport to: {value}`)
    end
})

teleportButton = teleporting:Button({
    Name = "Teleport to: none",
    IsEnabled = false,
    DisabledText = "Select something first!",
    Callback = function()
        local _cframe = selectedItem.instance and selectedItem.instance.CFrame or convertStringToCFrame(selectedItem.position)
        Character:PivotTo(_cframe + Vector3.new(0,5,0))
    end
})

teleporting:Divider()

local positionLabel = teleporting:Label("Position: none")
local _savedPosition
local currentName
teleporting:Button({
    Name = "Get current position",
    Callback = function()
        _savedPosition = Character.HumanoidRootPart.Position
        positionLabel:SetText(`Position: {tostring(_savedPosition) or "none"}`)
    end
})
teleporting:TextBox({
    Name = "Name for position",
    Callback = function(value)
        currentName = value
    end,
    Default = "",
    OnLeave = true,
    ClearTextOnFocus = true
})
teleporting:Button({
    Name = "Save custom position",
    Callback = function()
        if not table.find(savedPositions.names, currentName) then
            table.insert(savedPositions, {
                name = currentName,
                position = tostring(_savedPosition)
            })
            writefile("fisherman/positions.json", HttpService:JSONEncode(savedPositions))
            savedPositions = setmetatable(HttpService:JSONDecode(readfile('fisherman/positions.json')), savedPositionMT)
            listedPositions:SetItems(savedPositions.names)
            darius:Notify({
                Title = "Fisherman",
                Duration = 5,
                Body = `Successfully saved position named '{currentName}'`
            })
        else
            darius:Notify({
                Title = "Fisherman",
                Duration = 5,
                Body = "The name you selected already exists please select a different name."
            })
        end
    end
})

-- Inventory

local selectedInventoryItem
local selectedSpecificItem
local itemDetails
inventoryDropdown = inventory:Dropdown({
    Name = "Inventory",
    Items = inventoryItems.names,
    Callback = function(value)
        selectedInventoryItem = inventoryItems[string.split(value, ":")[1]]
        local specificTable = {}
        table.foreach(selectedInventoryItem, function(_,v)
            table.insert(specificTable, `{v.uid}: {v.mutation and tostring(v.mutation.Value) or ""} {v.weight and tostring(v.weight.Value).."kg" or ""} {v.stack and tostring(v.stack.Value).."x" or ""} {v.favourited and v.favourited.Value and "Favourited" or ""}`)
        end)
        specificItem:Enable()
        specificItem:SetItems(specificTable)
    end
})
specificItem = inventory:Dropdown({
    Name = "Specific Item",
    IsEnabled = false,
    Items = {},
    Callback = function(value)
        selectedSpecificItem = findByUID(selectedInventoryItem, value:split(":")[1])
        if selectedSpecificItem then
            itemDetails:SetTitle(selectedSpecificItem.uid)
            itemDetails:SetBody(tostring(selectedSpecificItem))
        end
    end
})
itemDetails = inventory:Paragraph({
    Title = "none",
    Body = "none"
})
inventory:Toggle({
    Name = "Loop Appraise",
    LinkKeybind = true,
    Callback = function(value)
        loopAppraise = value
        local gearToAppraise = findItemGear(selectedSpecificItem.uid)
        local appraiser = getAppraiser()
        if appraiser then
            Character.Humanoid:EquipTool(gearToAppraise)
            while loopAppraise and task.wait() do
                appraiser.appraiser.appraise:InvokeServer()
            end
            Character.Humanoid:UnequipTools()
        else
            darius:Notify({
                Title = "fisherman",
                Duration = 5,
                Body = "No NPC rendered."   
            })
        end
    end
})

inventory:Divider()

local playerName = ""
local offerinventory
inventory:TextBox({
    Name = "Player Name",
    Callback = function(value)
        if Players[value] then
            playerName = value
            offerinventory:Enable()
            offerinventory:SetName(`Offer inventory to: {playerName}`)
        else
            offerinventory:Disable()
        end
    end,
    FLAG = "playername",
    Default = "",
    OnLeave = true,
    ClearTextOnFocus = true
})

offerinventory = inventory:Button({
    Name = "Offer inventory to: none",
    IsEnabled = false,
    DisabledText = "Type player name first!",
    Callback = function()
        if Players[playerName] then
            for _,gear in LocalPlayer.Backpack:GetChildren() do
                if typeof(gear) == "Instance" and gear:IsA("Tool") and gear:FindFirstChild("offer") then
                    Character.Humanoid:EquipTool(gear)
                    gear.offer:FireServer(Players[playerName])
                    Character.Humanoid:UnequipTools()
                end
            end
        end
    end
})
inventory:Button({
    Name = "Teleport To",
    Callback = function()
        if Players[playerName] then
            Character:PivotTo(Players[playerName].Character.HumanoidRootPart.CFrame)
        end
    end
})

local cooldowned = {}
inventory:Toggle({
    Name = "Loop Offer",
    Callback = function(value)
        loopoffer = value
        while loopoffer and Players[playerName] and task.wait(2) do
            for _,gear in LocalPlayer.Backpack:GetChildren() do
                if not loopoffer then break end
                if typeof(gear) == "Instance" and gear:IsA("Tool") and gear:FindFirstChild("offer") and not table.find(cooldowned, gear) then
                    Character.Humanoid:EquipTool(gear)
                    gear.offer:FireServer(Players[playerName])
                    table.insert(cooldowned, gear)
                    task.delay(3, function()
                        table.remove(cooldowned, table.find(cooldowned, gear))
                    end)
                end
            end
        end
        Character.Humanoid:UnequipTools()
    end
})

-- Merlin

merlin:Button({
    Name = "Go To Merlin",
    Callback = function()
        Character:PivotTo(getTeleportSpot("merlin").instance.CFrame + Vector3.new(0,5,0))
    end
})
local veryFast = false
merlin:Toggle({
    Name = "Very Fast",
    Callback = function(value)
        veryFast = value
    end
})

merlin:Toggle({
    Name = "Get Power",
    Callback = function(value)
        loopPower = value
        if not veryFast then
            while loopPower and task.wait() do
                getMerlin().Merlin.power:InvokeServer()
            end
        else
            for i=1,10 do
                local b = coroutine.create(function()
                    while loopPower and task.wait() do
                        getMerlin().Merlin.power:InvokeServer()
                    end
                end)
                coroutine.resume(b)
            end
        end
    end
})

table.insert(connections, LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
	pcall(function()VirtualUser:ClickButton2(Vector2.new())end)
end))

coroutine.resume(castingCoroutine)
table.insert(connections, castingCoroutine)

darius.OnDestruction:Connect(function()
    for _,v in connections do
        if typeof(v) == "thread" then
            coroutine.close(v)
        else
            v:Disconnect()
        end
    end
    table.clear(connections)
end)
