if game.CoreGui:FindFirstChild("WizTyc|griffin#8008") then
    game.CoreGui["WizTyc|griffin#8008"]:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Top = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local Windows = Instance.new("Frame")
local UIPageLayout = Instance.new("UIPageLayout")
local Window = Instance.new("Frame")
local Players = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local Kill = Instance.new("TextButton")
local Give = Instance.new("TextButton")
local ClickD = Instance.new("TextButton")
local Tabs = Instance.new("Frame")
local UIListLayout_2 = Instance.new("UIListLayout")
local Tab = Instance.new("Frame")
local TextButton_2 = Instance.new("TextButton")
local UIPadding_2 = Instance.new("UIPadding")

local Selected = Instance.new("Folder")
Selected.Parent = Window
Selected.Name = "Selected"

ScreenGui.Name = "WizTyc|griffin#8008"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.new(0.184314, 0.192157, 0.211765)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.550233662, 0, 0.435681462, 0)
Frame.Size = UDim2.new(0, 360, 0, 310)

local FUIConer = Instance.new("UICorner")
FUIConer.Parent = Frame
FUIConer.CornerRadius = UDim.new(0,6)
local UserInputService = game:GetService("UserInputService")
local runService = (game:GetService("RunService"));
local gui = Frame
local dragging
local dragInput
local dragStart
local startPos
local function Lerp(a, b, m)
	return a + (b - a) * m
end
local lastMousePos
local lastGoalPos
local DRAG_SPEED = (10); -- // The speed of the UI darg.
local function Update(dt)
	if not (startPos) then return end;
	if not (dragging) and (lastGoalPos) then
		gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED))
		return 
	end;
	local delta = (lastMousePos - UserInputService:GetMouseLocation())
	local xGoal = (startPos.X.Offset - delta.X);
	local yGoal = (startPos.Y.Offset - delta.Y);
	lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
	gui.Position = UDim2.new(startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED), startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED))
end
gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position
		lastMousePos = UserInputService:GetMouseLocation()
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
runService.Heartbeat:Connect(Update)

Top.Name = "Top"
Top.Parent = Frame
Top.AnchorPoint = Vector2.new(0.5, 0.5)
Top.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
Top.BorderSizePixel = 0
Top.Position = UDim2.new(0.5, 0, 0.0580645166, 0)
Top.Size = UDim2.new(0, 360, 0, 36)
local TUIConer = Instance.new("UICorner")
TUIConer.Parent = Top
TUIConer.CornerRadius = UDim.new(0,6)

Frame_2.Parent = Top
Frame_2.AnchorPoint = Vector2.new(0.5, 1)
Frame_2.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.5, 0, 1, 0)
Frame_2.Size = UDim2.new(0, 360, 0, 16)
Frame_2.ZIndex = 0

TextLabel.Parent = Top
TextLabel.AnchorPoint = Vector2.new(0, 0.5)
TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 15, 0.5, 0)
TextLabel.Size = UDim2.new(0, 200, 1, 0)
TextLabel.ZIndex = 0
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.Text = "[Wizard Tycoon]                          griffin#8008"
TextLabel.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

Windows.Name = "Windows"
Windows.Parent = Frame
Windows.AnchorPoint = Vector2.new(0.5, 0.5)
Windows.BackgroundColor3 = Color3.new(1, 1, 1)
Windows.BackgroundTransparency = 1
Windows.ClipsDescendants = true
Windows.Position = UDim2.new(0.5, 0, 0.55806452, 0)
Windows.Size = UDim2.new(0, 360, 0, 274)

UIPageLayout.Parent = Windows
UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIPageLayout.EasingStyle = Enum.EasingStyle.Quint

Window.Name = "Window"
Window.Parent = Windows
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.BackgroundColor3 = Color3.new(1, 1, 1)
Window.BackgroundTransparency = 1
Window.Position = UDim2.new(0.5, 0, 0.5, 0)
Window.Size = UDim2.new(1, 0, 1, 0)

Players.Name = "Players"
Players.Parent = Window
Players.Active = true
Players.AnchorPoint = Vector2.new(0.5, 0.5)
Players.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
Players.BackgroundTransparency = 0.5
Players.BorderSizePixel = 0
Players.Position = UDim2.new(0.5, 0, 0.377248168, 0)
Players.Size = UDim2.new(0, 330, 0, 175)
Players.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Players.ScrollBarThickness = 0
Players.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Players.CanvasSize = UDim2.new(0,1, 0, 390)

UIListLayout.Parent = Players
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

UIPadding.Parent = Players
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)
UIPadding.PaddingTop = UDim.new(0, 5)

Kill.Name = "Kill"
Kill.Parent = Window
Kill.AnchorPoint = Vector2.new(0.5, 0.5)
Kill.BackgroundColor3 = Color3.new(1, 1, 1)
Kill.Position = UDim2.new(0.25, 0, 0.846715331, 0)
Kill.Size = UDim2.new(0, 110, 0, 50)
Kill.Font = Enum.Font.SourceSans
Kill.Text = "kill"
Kill.TextColor3 = Color3.new(0, 0, 0)
Kill.TextSize = 14

Give.Name = "Give"
Give.Parent = Window
Give.AnchorPoint = Vector2.new(0.5, 0.5)
Give.BackgroundColor3 = Color3.new(1, 1, 1)
Give.Position = UDim2.new(0.75, 0, 0.846715331, 0)
Give.Size = UDim2.new(0, 110, 0, 50)
Give.Font = Enum.Font.SourceSans
Give.Text = "give"
Give.TextColor3 = Color3.new(0, 0, 0)
Give.TextSize = 14

ClickD.Name = "ClickD"
ClickD.Parent = Window
ClickD.AnchorPoint = Vector2.new(0.5, 0.5)
ClickD.BackgroundColor3 = Color3.new(1, 1, 1)
ClickD.Position = UDim2.new(0.5, 0, 0.846715331, 0)
ClickD.Size = UDim2.new(0, 40, 0, 40)
ClickD.Font = Enum.Font.SourceSans
ClickD.Text = "click"
ClickD.TextColor3 = Color3.new(0, 0, 0)
ClickD.TextSize = 14

Tabs.Name = "Tabs"
Tabs.Parent = Frame
Tabs.AnchorPoint = Vector2.new(0.5, 0.5)
Tabs.BackgroundColor3 = Color3.new(0.184314, 0.192157, 0.211765)
Tabs.Position = UDim2.new(0.5, 0, 0.55806452, 0)
Tabs.Size = UDim2.new(0, 360, 0, 274)
Tabs.Visible = false

UIListLayout_2.Parent = Tabs
UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_2.Padding = UDim.new(0, 5)

Tab.Name = "Tab"
Tab.Parent = Tabs
Tab.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
Tab.BackgroundTransparency = 0.5
Tab.Size = UDim2.new(1, 0, 0, 25)

TextButton_2.Parent = Tab
TextButton_2.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton_2.BackgroundColor3 = Color3.new(1, 1, 1)
TextButton_2.BackgroundTransparency = 1
TextButton_2.Position = UDim2.new(0.5, 0, 0.5, 0)
TextButton_2.Size = UDim2.new(1, 0, 1, 0)
TextButton_2.Font = Enum.Font.GothamMedium
TextButton_2.Text = "Tab Name"
TextButton_2.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
TextButton_2.TextSize = 14

UIPadding_2.Parent = Tabs
UIPadding_2.PaddingLeft = UDim.new(0, 15)
UIPadding_2.PaddingRight = UDim.new(0, 15)
UIPadding_2.PaddingTop = UDim.new(0, 5)

local RS = game:GetService("RunService")


function shootWand(x,y,z,damage)
	local lp = game.Players.LocalPlayer
	local character = lp.Character
	local wand = character:FindFirstChild("Wand")
	if not wand then
		wand = lp.Backpack:FindFirstChild("Wand")
		if wand then
			character.Humanoid:EquipTool(wand)
			wait(0.05)
			wand = character:FindFirstChild("Wand")
			spawn(function() 
				wait(0.1)
				lp.Character.Humanoid:UnequipTools(wand)
			end)
		else
			return
		end
	end
	local tbl_main = 
		{
			CFrame.new(x, y, z), 
			0, 
			0.1,
			wand, 
			damage, 
			character
		}
	wand.Fire:FireServer(unpack(tbl_main))
end
function teamCheck(plyr)
	local team = plyr.Team
	local v
	if team == game:GetService("Teams")["Red"] then
		v = "Red"
	elseif team == game:GetService("Teams")["Blue"] then
		v = "Blue"
	elseif team == game:GetService("Teams")["Green"] then
		v = "Green"
	elseif team == game:GetService("Teams")["Yellow"] then
		v = "Yellow"
	elseif team == game:GetService("Teams")["For Hire"] then
		v = "For Hire"
	end
	return v
end

Kill.MouseButton1Click:Connect(function()
	for i,v in pairs(Selected:GetChildren()) do
		for i2, plyr in pairs(game.Players:GetPlayers()) do
			if v.Value == plyr.Name then
				local rp = plyr.Character.HumanoidRootPart
				local p, v = rp.CFrame, rp.Velocity
				shootWand(p.x+v.x/3,p.y+v.y/3,p.z+v.z/3,10000)
				print("Trying to kill: "..plyr.Name)
			end
		end
	end
end)


local ond = false
ClickD.MouseButton1Click:Connect(function()
	local team = teamCheck(game.Players.LocalPlayer)
	local path
	local kit = game.workspace["berezaa's Tycoon Kit"]
	if team == "Red" then
		path = kit['Medium red'].RedSecond.PurchasedObjects.Mine.Button.ClickDetector
	elseif team == "Blue" then
		path = kit['Pastel Blue'].BlueSecond.PurchasedObjects.Mine.Button.ClickDetector
	elseif team == "Green" then
		path = kit['Medium green'].GreenSecond.PurchasedObjects.Mine.Button.ClickDetector
	elseif team == "Yellow" then
		path = kit['Cool yellow'].YellowSecond.PurchasedObjects.Mine.Button.ClickDetector
	elseif team == "For Hire" then
		return print("Join a team!")
	end
	ond = not ond
	if ond and team ~= "For Hire" then
		RS:BindToRenderStep(tostring("a"), 0, function()
			fireclickdetector(path)
		end) 
	else
		RS:UnbindFromRenderStep(tostring("a"))
	end
end)

Give.MouseButton1Click:Connect(function()
	for i,v in pairs(Selected:GetChildren()) do
		for i2, plyr in pairs(game.Players:GetPlayers()) do
			if v.Value == plyr.Name then
				local rp = plyr.Character.HumanoidRootPart
				local p, v = rp.CFrame, rp.Velocity
				shootWand(p.x+v.x/3,p.y+v.y/3,p.z+v.z/3,-10000)
				print("Trying to heal: "..plyr.Name)
			end
		end
	end
end)

for i,v in pairs(game.Players:GetPlayers()) do
	if v.Name ~= game.Players.LocalPlayer.Name then
		local Player = Instance.new("Frame")
		local ImageLabel = Instance.new("ImageLabel")
		local PlayerN = Instance.new("TextLabel")
		local TextButton = Instance.new("TextButton")
		local PUIConer = Instance.new("UICorner")
		PUIConer.Parent = Player
		PUIConer.CornerRadius = UDim.new(0,4)
		local IUIConer = Instance.new("UICorner")
		IUIConer.Parent = ImageLabel
		IUIConer.CornerRadius = UDim.new(1,0)
		Player.Name = v.Name
		Player.Parent = Players
		Player.AnchorPoint = Vector2.new(0.5, 0.5)
		Player.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
		Player.Position = UDim2.new(0.5, 0, 0.5, 0)
		Player.Size = UDim2.new(1, 0, 0, 50)
		Player.Visible = true
		ImageLabel.Parent = Player
		ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
		ImageLabel.BackgroundColor3 = Color3.new(0.168627, 0.694118, 1)
		ImageLabel.BackgroundTransparency = 0
		ImageLabel.Position = UDim2.new(0, 5, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 40, 1, -10)
		ImageLabel.ZIndex = 0
		ImageLabel.Image = game.Players:GetUserThumbnailAsync(v.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		local lim = Instance.new("UITextSizeConstraint")
		lim.Parent = PlayerN
		lim.MaxTextSize = 14
		lim.MinTextSize = 1
		PlayerN.Parent = Player
		PlayerN.AnchorPoint = Vector2.new(0.5, 0.5)
		PlayerN.BackgroundColor3 = Color3.new(1, 1, 1)
		PlayerN.BackgroundTransparency = 1
		PlayerN.Position = UDim2.new(0.43, 0, 0.5, 0)
		PlayerN.Size = UDim2.new(0, 175, 0, 50)
		PlayerN.ZIndex = 0
		PlayerN.Font = Enum.Font.Gotham
		PlayerN.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
		PlayerN.TextSize = 14
		PlayerN.TextXAlignment = Enum.TextXAlignment.Left
		PlayerN.Text = "("..v.DisplayName..")\n "..v.Name
        PlayerN.TextScaled = true
		TextButton.Parent = Player
		TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
		TextButton.BackgroundTransparency = 1
		TextButton.Position = UDim2.new(0.609375, 0, 0, 0)
		TextButton.Size = UDim2.new(0, 125, 0, 50)
		TextButton.Font = Enum.Font.GothamMedium
		TextButton.Text = "Select"
		TextButton.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
		TextButton.TextSize = 14
		local a = false 
		local folder = Selected
        TextButton.MouseButton1Click:Connect(function()
            a = not a
            local n = string.split(PlayerN.Text, ")\n ")
            if a then
                local plyr = Instance.new("StringValue")
                plyr.Parent = folder
                plyr.Name = "Player: "..n[2]
                plyr.Value = tostring(n[2])
                TextButton.Text = "Selected"
            else
                for i,v in pairs(folder:GetChildren()) do
                    if v.Value == tostring(n[2]) then
                        v:Destroy()
                    end
                end
                TextButton.Text = "Select"
            end
        end)
        print("Added Player: "..v.Name)
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local Player = Instance.new("Frame")
	local ImageLabel = Instance.new("ImageLabel")
	local PlayerN = Instance.new("TextLabel")
	local TextButton = Instance.new("TextButton")
	local PUIConer = Instance.new("UICorner")
	PUIConer.Parent = Player
	PUIConer.CornerRadius = UDim.new(0,4)
	local IUIConer = Instance.new("UICorner")
	IUIConer.Parent = ImageLabel
	IUIConer.CornerRadius = UDim.new(1,0)
	Player.Name = player.Name
	Player.Parent = Players
	Player.AnchorPoint = Vector2.new(0.5, 0.5)
	Player.BackgroundColor3 = Color3.new(0.129412, 0.137255, 0.141176)
	Player.Position = UDim2.new(0.5, 0, 0.5, 0)
	Player.Size = UDim2.new(1, 0, 0, 50)
	Player.Visible = true
	ImageLabel.Parent = Player
	ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
	ImageLabel.BackgroundColor3 = Color3.new(0.168627, 0.694118, 1)
	ImageLabel.BackgroundTransparency = 0
	ImageLabel.Position = UDim2.new(0, 5, 0.5, 0)
	ImageLabel.Size = UDim2.new(0, 40, 1, -10)
	ImageLabel.ZIndex = 0
	ImageLabel.Image = game.Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	local lim = Instance.new("UITextSizeConstraint")
	lim.Parent = PlayerN
	lim.MaxTextSize = 14
	lim.MinTextSize = 1
	PlayerN.Parent = Player
	PlayerN.AnchorPoint = Vector2.new(0.5, 0.5)
	PlayerN.BackgroundColor3 = Color3.new(1, 1, 1)
	PlayerN.BackgroundTransparency = 1
	PlayerN.Position = UDim2.new(0.43, 0, 0.5, 0)
	PlayerN.Size = UDim2.new(0, 175, 0, 50)
	PlayerN.ZIndex = 0
	PlayerN.Font = Enum.Font.Gotham
	PlayerN.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
	PlayerN.TextSize = 14
	PlayerN.TextXAlignment = Enum.TextXAlignment.Left
	PlayerN.Text = "("..player.DisplayName..")\n "..player.Name
    PlayerN.TextScaled = true
	TextButton.Parent = Player
	TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
	TextButton.BackgroundTransparency = 1
	TextButton.Position = UDim2.new(0.609375, 0, 0, 0)
	TextButton.Size = UDim2.new(0, 125, 0, 50)
	TextButton.Font = Enum.Font.GothamMedium
	TextButton.Text = "Select"
	TextButton.TextColor3 = Color3.new(0.847059, 0.870588, 0.913725)
	TextButton.TextSize = 14
	local a = false 
	local folder = Selected
	TextButton.MouseButton1Click:Connect(function()
            a = not a
            local n = string.split(PlayerN.Text, ")\n ")
            if a then
                local plyr = Instance.new("StringValue")
                plyr.Parent = folder
                plyr.Name = "Player: "..n[2]
                plyr.Value = tostring(n[2])
                TextButton.Text = "Selected"
            else
                for i,v in pairs(folder:GetChildren()) do
                    if v.Value == tostring(n[2]) then
                        v:Destroy()
                    end
                end
                TextButton.Text = "Select"
            end
	end)
	print("Added Player: "..player.Name)
end)

game.Players.PlayerRemoving:Connect(function(player)
	for i,v in pairs(Players:GetChildren()) do
		if v.Name == player.Name then
			v:Destroy()
		end
	end
	for i,v in pairs(Selected:GetChildren()) do
		if v.Value == player.Name then
			v:Destroy()
		end
	end
end)

RS:BindToRenderStep(tostring("b"), 0, function()
	for i,v in pairs(game.Players:GetPlayers()) do
		local pf = Players
		for i2,plyr in pairs(pf:GetChildren()) do
			if plyr.Name == v.Name then
				if v.Name ~= game.Players.LocalPlayer.Name then
					pf[v.Name].TextLabel.TextColor = v.TeamColor
					pf[v.Name].ImageLabel.BackgroundColor = v.TeamColor
				end
			end
		end
	end
end)

--[[
GAMEPASS STUFF


>>>Server Lagger:

getgenv().serverraper = false
local lp = game.Players.LocalPlayer

game:GetService("RunService").RenderStepped:Connect(function()
    if serverraper then
        local hr = lp.Character.HumanoidRootPart
        local p, vel = hr.CFrame, hr.Velocity
        local x,y,z = p.x+vel.x/3, p.y+vel.y/3, p.z+vel.z/3
       game:GetService("Players").LocalPlayer.Character.Inferno.ActivateSpecial:FireServer(CFrame.new(x,y,z)) 
    end
end)


>>>Click to Special Ability:

local lp = game.Players.LocalPlayer
local m = lp:GetMouse()
local char = lp.Character


local InfernoB = lp.Backpack.Inferno
local ProgressUI = InfernoB.ProgressUI

ProgressUI.Frame.Title.Name = "griffin#8008"
ProgressUI.Frame.Tween.Name = "griffin2"
if ProgressUI.Frame:FindFirstChild("TextLabel") then
    ProgressUI.Frame["TextLabel"].Name = "griffin1"
end
ProgressUI.Frame["griffin1"].Text = "infinite"

if char:FindFirstChild("Inferno") then
    local Inferno = char.Inferno
    Inferno.Fire:Destroy()
else
    char.Humanoid:EquipTool(InfernoB)
    local Inferno = char.Inferno
    Inferno.Fire:Destroy()
end
local Inferno = char.Inferno
local function click()
    if char:FindFirstChild("Inferno") then
        Inferno.ActivateSpecial:FireServer(m.Hit)
        Inferno.ProgressUI.Frame["griffin2"].Size = UDim2.fromScale(1, 1)
    end
end

m.Button1Up:Connect(click)


>>>Kill All: 

local lp = game.Players.LocalPlayer
local char = lp.Character
local op = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

local InfernoB = lp.Backpack.Inferno
if char:FindFirstChild("Inferno") then
    local Inferno = char.Inferno
    Inferno.Fire:Destroy()
else
    char.Humanoid:EquipTool(InfernoB)
    local Inferno = char.Inferno
    Inferno.Fire:Destroy()
end

local Inferno = char.Inferno
local AP = Inferno.ActivateSpecial

for i,v in pairs(game.Players:GetPlayers()) do
    if v.Name ~= lp.Name then
        local hr = lp.Character.HumanoidRootPart
        local p, vel = hr.CFrame, hr.Velocity
        local x,y,z = p.x+vel.x/3, p.y+vel.y/3, p.z+vel.z/3
        hr.CFrame = v.Character.HumanoidRootPart.CFrame
        AP:FireServer(CFrame.new(x,y,z)) AP:FireServer(CFrame.new(x,y,z)) AP:FireServer(CFrame.new(x,y,z))
        wait(0.25)
        p, vel = hr.CFrame, hr.Velocity
        x,y,z = p.x+vel.x/3, p.y+vel.y/3, p.z+vel.z/3
        hr.CFrame = v.Character.HumanoidRootPart.CFrame
        AP:FireServer(CFrame.new(x,y,z)) AP:FireServer(CFrame.new(x,y,z)) AP:FireServer(CFrame.new(x,y,z))
    end
end
lp.Character.HumanoidRootPart.CFrame = op


>>>Get Tools:

local names = {
    "Broom","Ice Staff",
    "Korblox Staff","Lightning Staff",
    "Meteor Staff","Snow Staff",
    "Vine Staff","Wind Broom",
    "Wind Staff",
}
print("Starting attempts...")
local hr = game.Players.LocalPlayer.Character.HumanoidRootPart
local op = hr.CFrame

for i,v in pairs(game.workspace["berezaa's Tycoon Kit"]:GetDescendants()) do
   for i2,gn in pairs(names) do
       if v.Name == gn then
            warn("\n Attempting to grab: "..v.Name)
            hr.CFrame = v.CFrame
            print("\n Attempt complete.")
            wait(0.25)
       end
   end
end
hr.CFrame = op


local names = {
    "Broom","Ice Staff",
    "Korblox Staff","Lightning Staff",
    "Meteor Staff","Snow Staff",
    "Vine Staff","Wind Broom",
    "Wind Staff",
}
print("Starting attempts...")
local hr = game.Players.LocalPlayer.Character.HumanoidRootPart
local op = hr.CFrame

for i,v in pairs(game.workspace["berezaa's Tycoon Kit"]:GetDescendants()) do
   for i2,gn in pairs(names) do
       if v.Name == gn then
            warn("\n Attempting to grab: "..v.Name)
            hr.CFrame = v.CFrame
            wait(0.25)
       end
   end
end
hr.CFrame = op
]]
