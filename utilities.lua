local u = {} 

function u:c(instance,props, children)
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

function u:tween(properties)
	--[[
	properties.o -> ui object
	properties.a -> {Table of ui modications}
	properties.t -> <number>
	properties.d -> <string> In Out InOut
	properties.s -> <string> Sine Linear Exponential etc
	properties.r -> <number>
	]]--
	if not properties.r then properties.r = 0 end
	if not properties.d then properties.d = "InOut" end
	if not properties.s then properties.s = "Linear" end
	if not properties.t then properties.t = 1 end
	
	if not properties.a or not properties.o then
		return warn('\nUI-UTILITIES ERROR: \nMissing one of the required propertoes: a, o')
	elseif properties.a and properties.o then
		local TweenService = game:GetService("TweenService")
		local tweeninfo = TweenInfo.new(
			properties.t, 
			Enum.EasingStyle[properties.s], 
			Enum.EasingDirection[properties.d], 
			properties.r
		)
		local Animate = TweenService:Create(
			properties.o,
			tweeninfo,
			properties.a
		)
		return Animate
	end
end

function u:gtween(properties)
	--[[
	properties.O -> {List of objects}
	properties.A -> {List of ui components}
	properties.T -> <number>
	properties.D -> <string> In Out InOut
	properties.S -> <string> Sine Linear Exponential etc
	properties.R -> <number>
	]]--
	local TweenService = game:GetService("TweenService")
	local tweeninfo = TweenInfo.new(
		properties.T, 
		Enum.EasingStyle[properties.S], 
		Enum.EasingDirection[properties.D], 
		properties.R
	)
	for i,v in next, properties.O do
		TweenService:Create(
			v,
			tweeninfo,
			properties.A
		):Play()
	end
end
function u:button(o,properties)
	--[[
	o -> object affected
	properties.d -> On mousebutton1down
	properties.u -> On mousebutton1up
	properties.c -> On mousebutton1click
	properties.e -> On mouseenter
	properties.l -> On mouseleave
	]]
	for i,v in next, properties do
		if not v then
			v = function() wait() end
		else
			wait()
		end
	end
	o.MouseButton1Down:Connect(function()
		properties.d()
	end)
	o.MouseButton1Up:Connect(function()
		properties.u()
	end)
	o.MouseButton1Click:Connect(function()
		properties.c()
	end)
	o.MouseEnter:Connect(function()
		properties.e()
	end)
	o.MouseLeave:Connect(function()
		properties.l()
	end)
end

return u
