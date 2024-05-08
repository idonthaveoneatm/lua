return function(multiplier, waitTime, successFunc)
    waitTime = waitTime or 10
    successFunc = successFunc or function() end
    repeat task.wait() until game:IsLoaded()
    local HttpService = cloneref(game:GetService("HttpService"))
    local TeleportService = cloneref(game:GetService("TeleportService"))
    local LocalPlayer = cloneref(game:GetService("Players")).LocalPlayer
    local function waitFor(path, object, bool)
        bool = bool or false
        repeat
            task.wait()
        until path:FindFirstChild(object, bool)
        return path:FindFirstChild(object, bool)
    end
    repeat task.wait() until LocalPlayer.Character
    
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

    checkActive("Backrooms")
    waitFor(instanceContainer.Active, "Backrooms")
    local path = waitFor(instanceContainer.Active.Backrooms, "GeneratedBackrooms")
    task.wait(waitTime)
    
    local checkedrooms = {}
    local eggRoom = nil
    local eggMultiplier = nil

    local function checkForEggRoom()
        for _,v in ipairs(path:GetChildren()) do
            if v.Name == "EggRoom" and not eggRoom then
                print("found egg room")
                eggRoom = v
                eggMultiplier = v:GetAttribute("EggMultiplier")
                print("multiplier:", eggMultiplier)
            end
        end
    end
    local function checkGenteratedBackrooms()
        if not eggRoom then
            for _,v in ipairs(path:GetChildren()) do
                if eggRoom then
                    break
                end
                if v.Name ~= "Walls" and v.Name ~= "SpawnRoom" and v:FindFirstChild("Baseplate", true) and not table.find(checkedrooms, v.Baseplate.Position) then
                    checkForEggRoom()
                    table.insert(checkedrooms, v.Baseplate.Position)
                    goTo(v.Baseplate.CFrame + Vector3.new(0,3,0))
                    task.wait(0.2)
                    checkGenteratedBackrooms()
                end
            end
        end
    end
    checkGenteratedBackrooms()
    if multiplier == tostring(eggMultiplier) then
        goTo(eggRoom.LockedDoors.Door.Lock.CFrame + Vector3.new(0,3,0))
        successFunc()
    else
        print("not the multiplier you want")
        local request = request or httprequest or http_request
        local robloxURL = ('https://games.roblox.com/v1/games/%s/servers/0?sortOrder=2&excludeFullGames=true&limit=100'):format(game.PlaceId)
        local repsonse = request({
            Url = robloxURL,
            Method = "GET"
        })
        local data = HttpService:JSONDecode(repsonse.Body).data
        local serverIds = {}
        for _,server in ipairs(data) do
            if server.id ~= game.JobId  then
                table.insert(serverIds, server.id)
            end
        end
        local randomServer = math.abs(math.random(1,#serverIds))

        local teleportString = 'repeat task.wait() until game:IsLoaded() loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/backroomsFinder.lua"))()('..multiplier..')'

        queue_on_teleport(teleportString)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverIds[randomServer], LocalPlayer)
    end
end
