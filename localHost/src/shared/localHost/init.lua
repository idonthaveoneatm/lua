local Fusion = require(script.Bundles.Fusion)
local get = require(script.utilities.get)
local lerpColor = require(script.utilities.lerpColor)
local u = require(script.Bundles["ui-utilities"])

local hex = Color3.fromHex
local new,onevent,children = Fusion.New,Fusion.OnEvent,Fusion.Children
local value,computed,ref,spring,observer = Fusion.Value,Fusion.Computed,Fusion.Ref,Fusion.Spring,Fusion.Observer
local function animate(callback, speed, damping)
	return spring(computed(callback), speed, damping)
end

return function(config)
	if not config.root then
		return error('You need a "root" variable with the url to your host')
	end
	local textHover = value(false)
	local executeHover = value(false)
	local down = value(false)
	local textFocused = value(false)
	local pathRef = value()
	if config.parent:FindFirstChild("localHost") then
		config.parent:FindFirstChild("localHost"):Destroy()
	end

	local newHost = new "ScreenGui" {
		Name = "localHost",
		Parent = config.parent,

		[children] = {
			new "Frame" {
				AnchorPoint = Vector2.new(1,1),
				Position = UDim2.new(1,-10,1,-10),
				Size = UDim2.fromOffset(300,100),
				BackgroundColor3 = hex("#2E3440"),

				[children] = {
					new "UICorner" {CornerRadius = UDim.new(0,6)},
					new "UIStroke" {Color = hex("#5E81AC")},
					new "TextLabel" {
						Name = "title",
						AnchorPoint = Vector2.new(0.5,0),
						Position = UDim2.fromScale(0.5,0),
						Size = UDim2.new(1,0,0,30),
						Text = config.root,
						BackgroundTransparency = 1,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Enum.Font.GothamMedium,
						TextColor3 = hex("#ECEFF4"),
						TextSize = 18,

						[children] = {
							new "UIPadding" {PaddingLeft = UDim.new(0,10)}
						}
					},
					new "Frame" {
						Name = "body",
						AnchorPoint = Vector2.new(0.5,0),
						Position = UDim2.new(0.5,0,0,30),
						Size = UDim2.new(1,0,1,-30),
						BackgroundTransparency = 1,

						[children] = {
							new "UIListLayout" {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
							},
							new "Frame" {
								Size = UDim2.new(1,0,0.5,0),
								BackgroundTransparency = 1,
								[children] = {
									new "TextLabel" {
										Text = "root/",
										TextColor3 = hex("#5E81AC"),
										Size = UDim2.new(0,30,1,-10),
										AnchorPoint = Vector2.new(0,0.5),
										Position = UDim2.new(0,10,0.5,0),
										Font = Enum.Font.Gotham,
										BackgroundTransparency = 1,
									},
									new "TextBox" {
										Name = "path",
										Text = "",
										PlaceholderText = "path/to/script.lua",
										AnchorPoint = Vector2.new(1,0.5),
										Position = UDim2.new(1,-10,0.5,0),
										Size = UDim2.new(1,-52,1,-10),
										BackgroundColor3 = animate(function()
											if get(textHover) or get(textFocused) then
												return hex("#3B4252")
											end
											return hex("#2E3440")
										end,15,1),
										TextXAlignment = Enum.TextXAlignment.Left,
										TextColor3 = hex("#D8DEE9"),
										Font = Enum.Font.Gotham,

										[ref] = pathRef,

										[onevent "MouseEnter"] = function()
											textHover:set(true)
										end,
										[onevent "MouseLeave"] = function()
											textHover:set(false)
										end,
										[onevent "Focused"] = function()
											textFocused:set(true)
										end,
										[onevent "FocusLost"] = function()
											textFocused:set(false)
											print(get(pathRef).Text)
										end,

										[children] = {
											new "UIPadding" {PaddingLeft = UDim.new(0,4)},
											new "UICorner" {CornerRadius = UDim.new(0,6)},
										}
									}
								}
							},
							new "Frame" {
								Size = UDim2.new(1,0,0.5,0),
								BackgroundTransparency = 1,
								[children] = {
									new "TextButton" {
										Size = UDim2.fromOffset(150,30),
										BackgroundColor3 = animate(function()
											if get(executeHover) and not get(down) then
												return hex("#3B4252")
											end
											if get(down) then
												return hex("#81A1C1")
											end
											return hex("#2E3440")
										end,15,1),
										BackgroundTransparency = animate(function()
											if get(down) then
												return 0.75
											end
											return 0
										end,50,1),
										Text = "Execute",
										TextColor3 = hex("#A3BE8C"),
										Font = Enum.Font.GothamMedium,
										TextXAlignment = Enum.TextXAlignment.Left,
										AnchorPoint = Vector2.new(0,0),
										Position = UDim2.new(0,10,0,0),

										[onevent "MouseEnter"] = function()
											executeHover:set(true)
										end,
										[onevent "MouseLeave"] = function()
											executeHover:set(false)
											down:set(false)
										end,
										[onevent "MouseButton1Down"] = function()
											down:set(true)
										end,
										[onevent "MouseButton1Up"] = function()
											down:set(false)
										end,
										[onevent "MouseButton1Click"] = function()
											local path = config.root..get(pathRef).Text
											loadstring(game:HttpGet(path))()
										end,

										[children] = {
											new "UICorner" {CornerRadius = UDim.new(0,4)},
											new "UIPadding" {PaddingLeft = UDim.new(0,10)}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	u.drag(newHost.Frame, 15)
	return newHost
end