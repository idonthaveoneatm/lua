--[[

Made by griffindoescooking

]]--

return function(multiplier, roomMax)
    assert(multiplier, "You need the first variable:\n ...)()(multipler[MISSING], roomMax)")
    roomMax = roomMax or 100

    repeat task.wait() until game:IsLoaded()

    local HttpService = cloneref(game:GetService("HttpService"))
    local TeleportService = cloneref(game:GetService("TeleportService"))

    local LocalPlayer = cloneref(game:GetService("Players")).LocalPlayer
    repeat task.wait() until LocalPlayer.Character

    local function waitFor(path, object, bool)
        bool = bool or false
        repeat
            task.wait()
        until path:FindFirstChild(object, bool)
        return path:FindFirstChild(object, bool)
    end

    local HumanoidRootPart = waitFor(LocalPlayer.Character, "HumanoidRootPart", true)
    local Workspace = cloneref(game:GetService("Workspace"))
    local Things = waitFor(Workspace, "__THINGS")
    local Instances = waitFor(Things, "Instances")
    local instanceContainer = waitFor(Things, "__INSTANCE_CONTAINER")

    local function goTo(cframe)
        if typeof(cframe) == "CFrame" then
            LocalPlayer.Character:PivotTo(cframe)
        else
            HumanoidRootPart.CFrame:PivotTo(CFrame.new(cframe))
        end
    end
    local function checkActive(name)
        if not instanceContainer.Active:FindFirstChild(name) then
            goTo(Instances[name]:FindFirstChild("Enter", true).CFrame)
        end
    end
    local function generateRandomServer(page)
        page = page or 1
        local cursor = ""
        local response
        for i=1,page do
            local request = request or httprequest or http_request
            local robloxURL = ('https://games.roblox.com/v1/games/%s/servers/0?sortOrder=1&excludeFullGames=true&limit=100&cursor=%s'):format(game.PlaceId, cursor)
            response = request({
                Url = robloxURL,
                Method = "GET"
            })
            cursor = HttpService:JSONDecode(response.Body).nextPageCursor
        end
        local data = HttpService:JSONDecode(response.Body).data
        local serverIds = {}
        for _,server in ipairs(data) do
            if server.id ~= game.JobId then
                table.insert(serverIds, server.id)
            end
        end
        return serverIds[math.abs(math.random(1,#serverIds))]
    end

    checkActive("Backrooms")
    waitFor(instanceContainer.Active, "Backrooms")
    local path = waitFor(instanceContainer.Active.Backrooms, "GeneratedBackrooms")
    repeat task.wait() until #path:GetChildren() >= 6

    local checkedrooms = {}
    local hasEggs = {}
    local currentChecked = 0

    local function checkGenteratedBackrooms()
        if currentChecked < roomMax then
            for _,v in ipairs(path:GetChildren()) do
                if currentChecked < roomMax and v.Name ~= "Walls" and v.Name ~= "SpawnRoom" and v:FindFirstChild("Baseplate", true) and not table.find(checkedrooms, v.Baseplate.Position) then
                    currentChecked += 1
                    
                    if v.Name:lower() ~= "eggroom" and string.match(v.Name:lower(), "egg") then
                        if not table.find(hasEggs, v) then
                            if v:FindFirstChild("Sign") then
                                print(v.Name, v.Sign.SurfaceGui.TextLabel.Text)
                            end
                            table.insert(hasEggs, v)
                        end
                    end
                    
                    table.insert(checkedrooms, v.Baseplate.Position)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Baseplate.CFrame + Vector3.new(0,3,0)
                    task.wait(0.2)
                    checkGenteratedBackrooms()
                end
            end
        end
    end
    checkGenteratedBackrooms()

    local function findMultiplier()
        for _,room in ipairs(hasEggs) do
            if string.find(room.Sign.SurfaceGui.TextLabel.Text,tostring(multiplier)) then
                print(room.Name, "has:", room.Sign.SurfaceGui.TextLabel.Text)
                return room
            end
        end
        print("no room for", multiplier, "was found")
        return nil
    end
    if findMultiplier() then
        local eggWithMultiplier = findMultiplier()
        goTo(eggWithMultiplier.Baseplate.CFrame)
    else
        local teleportString = 'repeat task.wait() until game:IsLoaded() loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/randomEggFinder.lua"))()'..('(%s,%s)'):format(multiplier, roomMax)
        clear_teleport_queue()
        queue_on_teleport(teleportString)
        local _, e = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, generateRandomServer(6), LocalPlayer)
        end)
        if e then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, generateRandomServer(5), LocalPlayer)
        end
    end
end
