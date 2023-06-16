repeat task.wait() until game.PlaceId ~= nil
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local failed = false
print("started")
local PATH = game.Players.LocalPlayer.PlayerGui:WaitForChild("Loading").Black.BackgroundTransparency
task.wait(10)
while true do
    if PATH ==0 then
        print("failed check 1")
        failed = true
    end
    task.wait(WaitTime)
    if PATH == 0 then
        print("failed check 2")
        print("Worked")
        local function Hop()
        local Servers = {}
        local function Scrape()
            local URL = 'https://games.roblox.com/v1/games/'..game.PlaceId..'/servers/Public?sortOrder=asc&limit=100'
            return game.HttpService:JSONDecode(game:HttpGet(URL))
        end
        local function TeleportServer()
            while task.wait(3) do
                local sid = math.random(1, #Servers)
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, Servers[sid], game:GetService("Players").localPlayer)
            end
        end
        local function PlaceServers()
            local scraped = Scrape()
            for key, index in pairs(scraped.data) do
                if index.playing and tonumber(index.playing) <= math.abs(math.random(3,10)) then
                    table.insert(Servers, index.id)
                end
            end
            TeleportServer()
        end
        PlaceServers()
    end
    Hop()
    else
        failed = false
    end
end
