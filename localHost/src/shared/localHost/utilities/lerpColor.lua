local black = Color3.new(0, 0, 0)
local white = Color3.new(1, 1, 1)

return function(color: Color3, BorW: string, lerpAmount: number) 
	local check = string.lower(BorW)
	if BorW == "black" then
		return color:Lerp(black, lerpAmount)
	elseif BorW == "white" then
		return color:Lerp(white, lerpAmount)
	else
		return error("hey its not white or black")
	end
end