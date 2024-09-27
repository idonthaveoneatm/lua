--[[

Made by griffin
Discord: @griffindoescooking
Github: https://github.com/idonthaveoneatm

]]--

print("Murder Mystery 2 | griffindoescooking")

local config = {
    chams = {
        roles = false
    }
}

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Remotes = ReplicatedStorage.Remotes
local GetLastRoundRewards = Remotes.Gameplay.GetLastRoundRewards

local ourPlayers = {}
local roleColors = {
    ['Sheriff'] = '#2690ed',
    ['Murderer'] = '#fc4c4c',
    ['Hero'] = '#fcd544',
    ['Innocent'] = '#ffffff',
    ['Spectator'] = '#ffffff'
}
local richText = {
    ['Sheriff'] = '<font color="'..roleColors.Sheriff..'"> %s </font>',
    ['Murderer'] = '<font color="'..roleColors.Murderer..'"> %s </font>',
    ['Hero'] = '<font color="'..roleColors.Hero..'"> %s </font>',
    ['Innocent'] = '%s',
}

local function addCham(object, tbl)
    if not object:FindFirstChild("griffin_cham") then
        local h = Instance.new("Highlight")
        h.Name = "griffin_cham"
        h.Parent = object
        h.Adornee = object
        h.Enabled = tbl.enabled or false
        h.FillColor = tbl.color or Color3.fromHex("#ffffff")
        h.FillTransparency = 0.5
        h.OutlineColor = tbl.color or Color3.fromHex("#ffffff")
        h.OutlineTransparency = 0.25
    end
end
local function updateCham(object, tbl)
    if object:FindFirstChild("griffin_cham") then
        local h = object:FindFirstChild("griffin_cham")
        h.Enabled = tbl.enabled or false
        h.FillColor = tbl.color or Color3.fromHex("#ffffff")
        h.OutlineColor = tbl.color or Color3.fromHex("#ffffff")
    end
end
local function getPlayerInfo(player)
    local allPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    local playerData = allPlayerData[player.Name]
    local playerRole

    local returnInfo = {}

    if playerData and playerData.Role then
        playerRole = playerData.Role or "Innocent"
        returnInfo.IsSheriff = true and playerRole == "Sheriff" or false
        returnInfo.IsMurderer = true and playerRole == "Murderer" or false
        returnInfo.IsHero = true and playerRole == "Hero" or false
        returnInfo.IsInnocent = true and playerRole == "Innocent" or false

        returnInfo.IsAlive = true and not playerData.Killed and not playerData.Dead or false
    else
        playerRole = "Spectator"
        returnInfo.IsAlive = false
        returnInfo.IsSpectator = true
    end

    returnInfo.RoleName = playerRole

    function returnInfo.playerTitle()
        return "("..player.DisplayName..") @"..player.Name
    end
    function returnInfo.playerBody()
        if returnInfo.IsSpectator then
            return "Spectator"
        else
            if returnInfo.IsAlive then
                return richText[playerRole]:format(playerRole)
            end
            return "Dead"
        end
        return "we got a problem"
    end
    return returnInfo
end
local theSheriffHero, theMurderer = nil, nil
getgenv().activeHero = false
local function updateKeyRoles(playerInfo)
    if playerInfo.IsHero then
        activeHero = true
        theSheriffHero:SetTitle(playerInfo.playerTitle())
        theSheriffHero:SetBody(playerInfo.playerBody())
    end
    if playerInfo.IsSheriff and not activeHero then
        theSheriffHero:SetTitle(playerInfo.playerTitle())
        theSheriffHero:SetBody(playerInfo.playerBody())
    end
    if playerInfo.IsMurderer then
        theMurderer:SetTitle(playerInfo.playerTitle())
        theMurderer:SetBody(playerInfo.playerBody())
    end
end

local project = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/quake/src"))()

local ui = project:Window({
    Title = "Murder Mystery 2",
    isMobile = false
})

local roles = ui:Tab({
    Name = "Roles",
    Image = "rbxassetid://10747373176"
})

roles:Toggle({
    Name = "Role Chams",
    Default = false,
    Callback = function(value)
        config.chams.roles = value
    end
})
roles:Section("Murderer")
theMurderer = roles:Paragraph({
    Title = "Waiting...",
    Body = "Waiting...",
})
roles:Section("Sheriff/Hero")
theSheriffHero = roles:Paragraph({
    Title = "Waiting...",
    Body = "Waiting...",
})
roles:Section("Players")
task.spawn(function()
    while true and task.wait() do
        for _,player in Players:GetPlayers() do
            local playerInfo = getPlayerInfo(player)
    
            if not ourPlayers[player.Name] then
    
                ourPlayers[player.Name] = roles:Paragraph({
                    Title = playerInfo.playerTitle(),
                    Body = "Waiting..."
                })
    
            end
            ourPlayers[player.Name]:SetBody(playerInfo.playerBody())
            updateKeyRoles(playerInfo)
    
            -- player chams
    
            if player.Character and player ~= LocalPlayer then
                addCham(player.Character, {
                    enabled = config.chams.roles and playerInfo.IsAlive or false,
                    color = Color3.fromHex(roleColors[playerInfo.RoleName])
                })
                updateCham(player.Character,{
                    enabled = config.chams.roles and playerInfo.IsAlive or false,
                    color = Color3.fromHex(roleColors[playerInfo.RoleName])
                })
            end
    
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        ourPlayers[player.Name]:Remove()
        ourPlayers[player.Name] = nil
    end)
end)
local oldnamecall
oldnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod():lower()

    if not checkcaller() and self == GetLastRoundRewards and method == "invokeserver" then
        theMurderer:SetTitle("Waiting...")
        theMurderer:SetBody("Waiting...")
        theSheriffHero:SetTitle("Waiting...")
        theSheriffHero:SetBody("Waiting...")
        activeHero = false
    end

    return oldnamecall(self, ...)
end)
