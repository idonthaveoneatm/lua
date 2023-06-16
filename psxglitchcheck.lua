repeat task.wait() until game.PlaceId ~= nil
if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("__INTRO")

local failed = false
print("started")
local PATH = game.workspace['__MAP']:WaitForChild('Interactive'):WaitForChild('Diamond Mine Collapsed Sign')
task.wait(10)
while true do
    if PATH then
        print("failed check 1")
        failed = true
    end
    task.wait(WaitTime)
    if PATH then
        print("failed check 2")
        print("Worked")
    else
        failed = false
    end
    ]]
end
