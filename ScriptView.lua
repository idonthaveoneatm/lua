local u = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/utilities.lua"))()

if isfolder("ScriptView") then
	print("FoundFolder")
else
    makefolder("ScriptView")
    writefile("ScriptView/Test.lua", 'print("Hello World!")')
end


local folderreader = Instance.new("ScreenGui")

folderreader.Name = "folderreader"
folderreader.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
folderreader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
folderreader.DisplayOrder = 1

local Frame = Instance.new("Frame")

Frame.Parent = folderreader
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(56, 60, 74)
Frame.BorderColor3 = Color3.fromRGB(82, 148, 226)
Frame.Position = UDim2.new(0.351415068, 0, 0.423430324, 0)
Frame.Size = UDim2.new(0, 150, 0, 200)

local b = Instance.new("ScrollingFrame")

b.Name = "b"
b.Parent = Frame
b.Active = true
b.BackgroundColor3 = Color3.fromRGB(56, 60, 74)
b.BorderSizePixel = 0
b.Size = UDim2.new(1, 0, 0, 170)
b.ScrollBarThickness = 0

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Parent = b
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 3)

local UIPadding = Instance.new("UIPadding")

UIPadding.Parent = b
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)

local UIListLayout_2 = Instance.new("UIListLayout")

UIListLayout_2.Parent = Frame
UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center

local a = Instance.new("TextLabel")

a.Name = "a"
a.Parent = Frame
a.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
a.BackgroundTransparency = 1.000
a.BorderSizePixel = 0
a.Size = UDim2.new(1, 0, 0, 30)
a.Font = Enum.Font.GothamBold
a.Text = "Script View"
a.TextColor3 = Color3.fromRGB(206, 211, 220)
a.TextSize = 16.000

local replay = Instance.new("ImageButton")

replay.Name = "replay"
replay.Parent = a
replay.AnchorPoint = Vector2.new(1, 0)
replay.BackgroundColor3 = Color3.fromRGB(206, 211, 220)
replay.BackgroundTransparency = 1.000
replay.LayoutOrder = 3
replay.Position = UDim2.new(1, -5, 0, 5)
replay.Size = UDim2.new(0, 20, 0, 20)
replay.ZIndex = 2
replay.Image = "rbxassetid://3926307971"
replay.ImageColor3 = Color3.fromRGB(206, 211, 220)
replay.ImageRectOffset = Vector2.new(244, 524)
replay.ImageRectSize = Vector2.new(36, 36)

-- Scripts:
local function load()
    for i, v in ipairs(listfiles("ScriptView")) do
        local a = string.split(v, "ScriptView/")
        local n = a[2]
        local newScript = Instance.new("Frame")

        newScript.Name = "newScript"
        newScript.Parent = b
        newScript.BackgroundColor3 = Color3.fromRGB(64, 69, 82)
        newScript.BorderSizePixel = 0
        newScript.Size = UDim2.new(1, 0, 0, 30)
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = newScript
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundTransparency = 1.000
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.Font = Enum.Font.Gotham
        Button.Text = tostring(n)
        Button.TextColor3 = Color3.fromRGB(82, 148, 226)
        Button.TextSize = 12.000
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = newScript
        local dec = Instance.new("Frame")
        dec.Name = "dec"
        dec.Parent = newScript
        dec.AnchorPoint = Vector2.new(0.5, 0.5)
        dec.BackgroundColor3 = Color3.fromRGB(82, 148, 226)
        dec.BackgroundTransparency = 1.000
        dec.Position = UDim2.new(0.5, 0, 0.5, 0)
        dec.Size = UDim2.new(1, 0, 1, 0)
        dec.ZIndex = 0
        local UICorner_2 = Instance.new("UICorner")
        UICorner_2.CornerRadius = UDim.new(0, 5)
        UICorner_2.Parent = dec

        Button.MouseEnter:Connect(function()
        u:tween({o = dec,
            a = {BackgroundTransparency = 0.85},
            t = 0.15, s = "Sine",d = "In"
        }):Play()
        end)
        Button.MouseLeave:Connect(function()
            u:tween({o = dec,
                a = {BackgroundTransparency = 1},
                t = 0.15, s = "Sine",d = "In"
            }):Play()
        end)
        Button.MouseButton1Click:Connect(function()
            dofile(v)
        end)
    end
    print("Loaded")
end
local function unload()
    for i, v in ipairs(b:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    print("Unloaded")
end
local doing = false

replay.MouseButton1Down:Connect(function()
	u:tween({o = replay,
		a = {ImageColor3 = Color3.fromRGB(82, 148, 226)},
		t = 0.15,s = "Sine",d = "In"
	}):Play()
end)
replay.MouseLeave:Connect(function()
	if doing then
		wait()
	else
		u:tween({o = replay,
			a = {ImageColor3 = Color3.fromRGB(206, 211, 220)},
			t = 0.15,s = "Sine",d = "Out"
		}):Play()
	end
end)
replay.MouseButton1Click:Connect(function()
	doing = true
	unload()
	u:tween({o = replay,
		a = {Rotation = -360},
		t = 0.25,s = "Sine",d = "Out"
	}):Play() wait(0.25)
	doing = false
	u:tween({o = replay,
		a = {ImageColor3 = Color3.fromRGB(206, 211, 220)},
		t = 0.15,s = "Sine",d = "Out"
	}):Play()
	replay.Rotation = 0
    load()
end)

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

load()
