local utilities = {}

function utilities:c(instance,props, children)
	local i = Instance.new(instance)
	local children = children or {}
	for prop, v in pairs(props) do
		i[prop] = v
	end
	for _, child in pairs(children) do
		child.Parent = i
	end
	return i
end

utilities:t = function(properties)
	--[[
	properties.Object -> any ui object
	properties.Animation -> {List of ui components}
	properties.Time -> <number>
	properties.Direction -> <string> In Out InOut
	properties.Style -> <string> Sine Linear Exponential etc
	properties.Repeat -> <number>
	]]--
	local TweenService = game:GetService("TweenService")
	local tweeninfo = TweenInfo.new(
		properties.Time, 
		Enum.EasingStyle[properties.Style], 
		Enum.EasingDirection[properties.Direction], 
		properties.Repeat
	)
	local Animate = TweenService:Create(
		properties.Object,
		tweeninfo,
		properties.Animation
	)
	return Animate
end

utilities:gt = function(properties)
	--[[
	properties.Objects -> {List of objects}
	properties.Animation -> {List of ui components}
	properties.Time -> <number>
	properties.Direction -> <string> In Out InOut
	properties.Style -> <string> Sine Linear Exponential etc
	properties.Repeat -> <number>
	]]--
	local TweenService = game:GetService("TweenService")
	local tweeninfo = TweenInfo.new(
		properties.Time, 
		Enum.EasingStyle[properties.Style], 
		Enum.EasingDirection[properties.Direction], 
		properties.Repeat
	)
	for i,v in next, properties.Objects do
		TweenService:Create(
			v,
			tweeninfo,
			properties.Animation
		):Play()
	end
end

utilities:b = function(object,properties)
	--[[
	object -> object affected
	properties.Down -> On mousebutton1down
	properties.Up -> On mousebutton1up
	properties.Click -> On mousebutton1click
	properties.Enter -> On mouseenter
	properties.Leave -> On mouseleave
	]]
	object.MouseButton1Down:Connect(function()
		properties.Down()
	end)
	object.MouseButton1Up:Connect(function()
		properties.Up()
	end)
	object.MouseButton1Click:Connect(function()
		properties.Click()
	end)
	object.MouseEnter:Connect(function()
		properties.Enter()
	end)
	object.MouseLeave:Connect(function()
		properties.Leave()
	end)
end

return utilities
