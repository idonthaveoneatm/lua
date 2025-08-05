--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--
-- Requires webhooks and role ids for Discord.
local webhooks = {
    luck = "",
    royal = "",
    man = "",
    bubble = "",
    eventLuck = "",
    stats = "",
    silly = ""
}
local roles = {
    luck = 123,
    royal = 123,
    man = 123,
    silly = 123,
    eventLuck = 123,
    bubble = 123
}

local services = setmetatable({},{
    __index = function(tbl,key)
        return cloneref(game:GetService(key))
    end
})
local Workspace = services.Workspace
local TeleportService = services.TeleportService
local HttpService = services.HttpService
local RunService = services.RunService
local Players = services.Players

local start = tick()

getgenv().cachedServer = cachedServer or ""

local request = request or httprequest or http_request

local LocalPlayer = Players.LocalPlayer

RunService:Set3dRenderingEnabled(false)

local webhookUtil = {}

function webhookUtil.createMessage(properties)
    assert(properties.Url, "Url required")
    assert(properties.username, "username required")
    assert(properties.content, "content required")

    local requestTable = {
        Url = properties.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = {
            ["username"] = properties.username,
            ["content"] = properties.content or "",
            ["embeds"] = {}
        }
    }
    local webhookFunctions = {}
    local EmbedIndex = 0
    function webhookFunctions.addEmbed(title: string, color: number, description: string, footer)
        assert(title, "title required")
        assert(description, "description required")
        assert(color, "color required")
        footer = footer or ""

        EmbedIndex += 1
        local privateIndex = EmbedIndex

        table.insert(requestTable.Body.embeds, {
            ["title"] = title,
            ["color"] = tonumber(color),
            ["description"] = description,
            ["fields"] = {},
            ["footer"] = {["text"] = footer}
        })
        local embedFunctions = {}
        function embedFunctions.addField(name, value, inline)
            assert(name, "name required")
            assert(value, "value required")
            inline = inline or false
            table.insert(requestTable.Body.embeds[privateIndex].fields, {
                ["name"] = name,
                ["value"] = value,
                ["inline"] = inline
            })
        end
        return embedFunctions
    end
    function webhookFunctions.sendMessage()
        requestTable.Body = HttpService:JSONEncode(requestTable.Body)
        local response = request(requestTable)
        return response
    end
    return webhookFunctions
end

if not isfile("BGSIServers.json") then
    writefile("BGSIServers.json", "{}")
end
if not isfile("BGSIStats.json") then
    writefile("BGSIStats.json", [[{"total_servers": 0,"nightmare-egg":0,"void-egg":0,"rainbow-egg":0,"man-egg":0,"event-1":0,"event-2":0,"royal-chest":0,"last_server":"", "message_id":null}]])
end

local serverList = HttpService:JSONDecode(readfile("BGSIServers.json"))
local statsList = HttpService:JSONDecode(readfile("BGSIStats.json"))

local randomA
local function generateRandomServer()
    local cursor = ""
    if (serverList.data and #serverList.data > 0) and (serverList.tick and (start - serverList.tick) < 60) then
        if #serverList.data == 1 then
            table.remove(serverList.data, 1)
            writefile("BGSIServers.json", HttpService:JSONEncode(serverList))
            return serverList.data[1].id
        else
            local randomServer = serverList.data[math.abs(math.random(1,#serverList.data))]
            table.remove(serverList.data, table.find(serverList.data, randomServer))
            writefile("BGSIServers.json", HttpService:JSONEncode(serverList))
            return randomServer.id
        end
    else
        if serverList.nextPageCursor then
            cursor = serverList.nextPageCursor
        end
        local response = request({
            Url = `https://games.roblox.com/v1/games/{game.PlaceId}/servers/0?sortOrder=1&excludeFullGames=true&limit=25&cursor={cursor}`,
            Method = "GET"
        })
        local body = HttpService:JSONDecode(response.Body)
        if body.errors then
            print(`errored at fetch`)
            print(response.Body)
            task.wait(20)
            return generateRandomServer()
        end
        body.tick = start
        writefile("BGSIServers.json", HttpService:JSONEncode(body))
        local _list = readfile("BGSIServers.json")
        serverList = HttpService:JSONDecode(_list)
        return generateRandomServer()
    end
end
local function round(val,am)
    if val == 0 then
        return math.floor(val)
    end
    return tonumber(string.format('%.'..tostring(am)..'f', val))
end
task.spawn(function()
    randomA = generateRandomServer()
end)

local noLucks = {
    "royal-chest",
    "bubble-rift"
}
local whitelist = {
    "void-egg",
    "nightmare-egg",
    "rainbow-egg",
    "event-1",
    "event-2",
    "event-3",
    "silly-egg"
}
local royalcontent = ""
local x25content = ""
local mancontent = ""
local bubblecontent = ""
local eventx25content = ""
local sillycontent = ""

for i,v in whitelist do
    if not statsList[v] then
        statsList[v] = 0
    end
end

local ping = {
    luck = false,
    royal = false,
    bubble = false,
    silly = false,
    man = false,
    event = false
}
local joinercontent = `https://www.roblox.com/games/start?placeId=92771272533848&launchData={game.PlaceId}|{game.JobId}\n\n**ALTERNATIVE Copy this:**\n{game.PlaceId}|{game.JobId}\nJoin this game and paste it in the text box then press join!\nhttps://www.roblox.com/games/92771272533848/Joiner`
for _,v in Workspace.Rendered.Rifts:GetChildren() do
    if not v:FindFirstChild("Display") or not v:FindFirstChild("Output") or (v:GetAttribute("DespawnAt") and (v:GetAttribute("DespawnAt") - DateTime.now().UnixTimestamp) < 45) then
        continue
    end
    local name = string.lower(v.Name)
    local endTime = math.round(v:GetAttribute("DespawnAt"))
    local yCoordinate = math.ceil(v.Output.CFrame.Y)
    if table.find(noLucks, name) then
        if name:find("royal") then
            ping.royal = true
            statsList[name] = statsList[name] + 1
            royalcontent = `{royalcontent}### {name}\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        end
        if name:find("bubble") then
            local mult = v.Display:FindFirstChild("Label", true).Text
            ping.bubble = true
            statsList[name] = statsList[name] + 1
            bubblecontent = `{bubblecontent}### {name}\n**Multiplier:** {mult}\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        end
    end
    if table.find(whitelist, name) then
        local luck = v.Display.SurfaceGui.Icon.Luck.Text
        if string.find(name, "event") and luck == "x25" then
            ping.event = true
            statsList[name] = statsList[name] + 1
            eventx25content = `{eventx25content}### {name}\n**Luck: {luck}**\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        elseif string.find(name, "man") then
            ping.man = true
            statsList[name] = statsList[name] + 1
            mancontent = `{mancontent}### {name}\n**Luck: {luck}**\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        elseif string.find(name, "silly") then
            ping.silly = true
            statsList[name] = statsList[name] + 1
            sillycontent = `{sillycontent}### {name}\n**Luck: {luck}**\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        elseif not string.find(name, "event") and not string.find(name, "man") and not string.find(name, "silly") and luck == "x25" then
            ping.luck = true
            x25content = `{x25content}### {name}\n**Luck: {luck}**\nHeight: {yCoordinate}\nGone <t:{endTime}:R>\n`
        end
    end
end
if cachedServer == game.JobId then
    return
end

local endTime = tick()-start
if ping.luck then
    local message = webhookUtil.createMessage({
        Url = webhooks.luck,
        username = "griffin's utility",
        content = `<@&{roles.luck}>`
    })
    message.addEmbed("x25 Found", 0xa49ae6, x25content)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end
if ping.royal then
    local message = webhookUtil.createMessage({
        Url = webhooks.royal,
        username = "griffin's utility",
        content = `<@&{roles.royal}>`
    })
    message.addEmbed("Royal Chest Found", 0xa49ae6, royalcontent)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end
if ping.man then
    local message = webhookUtil.createMessage({
        Url = webhooks.man,
        username = "griffin's utility",
        content = `<@&{roles.man}>`
    })
    message.addEmbed("Man Egg Found", 0xa49ae6, mancontent)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end
if ping.silly then
    local message = webhookUtil.createMessage({
        Url = webhooks.silly,
        username = "griffin's utility",
        content = `<@&{roles.silly}>`
    })
    message.addEmbed("Silly Egg Found", 0xa49ae6, sillycontent)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end
if ping.event then
    local message = webhookUtil.createMessage({
        Url = webhooks.eventLuck,
        username = "griffin's utility",
        content = `<@&{roles.eventLuck}>`
    })
    message.addEmbed("x25 Event Found", 0xa49ae6, eventx25content)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end
if ping.bubble then
    local message = webhookUtil.createMessage({
        Url = webhooks.bubble,
        username = "griffin's utility",
        content = `<@&{roles.bubble}>`
    })
    message.addEmbed("Bubble Rift Found", 0xa49ae6, bubblecontent)
    message.addEmbed("Join Game", 0xa49ae6, joinercontent)
    message.sendMessage()
end

cachedServer = game.JobId

if statsList.last_server ~= game.JobId then
    statsList.total_servers += 1
    statsList.last_server = game.JobId
    writefile("BGSIStats.json", HttpService:JSONEncode(statsList))
    if not statsList.message_id then -- Create new msg and store id
        local response = request({
            Url = `{webhooks.stats}?wait=true`,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                ['username'] = "griffin's utility",
                ['content'] = "",
                ['embeds'] = {
                    {
                        ['title'] = "Statistics",
                        ['color'] = tonumber(0xa49ae6),
                        ['description'] = `**Servers Scraped:** {statsList.total_servers}\n**Royal Chests:** {statsList['royal-chest']}\n### x25 Eggs:\n**Rainbow Eggs:** {statsList['rainbow-egg']}\n**Nightmare Eggs:** {statsList['nightmare-egg']}\n**Void Eggs:** {statsList['void-egg']}\n**Easter 1 Eggs:** {statsList['event-1']}\n**Easter 2 Eggs:** {statsList['event-2']}`
                    }
                }
            })
        })
        statsList.message_id = HttpService:JSONDecode(response.Body).id
        writefile("BGSIStats.json", HttpService:JSONEncode(statsList))
    end
    request({
        Url = `{webhooks.stats}/messages/{statsList.message_id}`,
        Method = "PUT", -- should be PATCH but delta bad
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            ['content'] = "",
            ['embeds'] = {
                {
                    ['title'] = "Statistics",
                    ['color'] = tonumber(0xa49ae6),
                    ['description'] = `**Servers Scraped:** {statsList.total_servers}\n**Royal Chests:** {statsList['royal-chest']}\n**Bubble Rifts:** {statsList['bubble-rift']}\n**Man Eggs:** {statsList['man-egg']}\n**Silly Eggs:** {statsList['silly-egg']}\n### x25 Eggs:\n**Rainbow Eggs:** {statsList['rainbow-egg']}\n**Nightmare Eggs:** {statsList['nightmare-egg']}\n**Void Eggs:** {statsList['void-egg']}\n**Throwback Eggs:** {statsList['event-3']}`,
                    ['footer'] = {['text'] = `{round(endTime, 4)}, {#serverList.data}/25`}
                }
            }
        })
    })
end
repeat
    task.wait()
until randomA ~= nil

TeleportService:TeleportToPlaceInstance(game.PlaceId, randomA, LocalPlayer)
print("should of teleported")
