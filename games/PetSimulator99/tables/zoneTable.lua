--[[
local function loadTable(tableName)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/tables/"..tableName..".lua"))()
end
local zoneNames = loadTable("zoneNames")
local Map = game.workspace.Map
local zonesText = ""
for _,zone in ipairs(Map:GetChildren()) do
    if not table.find(zoneNames, zone.Name) and zone.Name ~= "SHOP" then
        zonesText = zonesText..'["'..zone.Name..'"] = '..'CFrame.new('..tostring(zone.INTERACT.Teleport.Position)..'), \n'
    end
end
setclipboard(zonesText)
]]
return {
    ["1 | Spawn"] = CFrame.new(212.035538, 20.1876869, -388.115417), 
    ["2 | Colorful Forest"] = CFrame.new(372.539154, 16.6393204, -211.668884), 
    ["3 | Castle"] = CFrame.new(530.453491, 16.6393204, -196.13797), 
    ["4 | Green Forest"] = CFrame.new(689.05304, 16.6393204, -205.87149), 
    ["5 | Autumn"] = CFrame.new(867.194641, 16.6393204, -189.63826), 
    ["6 | Cherry Blossom"] = CFrame.new(862.67627, 16.6393204, 11.237937), 
    ["7 | Farm"] = CFrame.new(692.400391, 16.6393204, 17.9911346), 
    ["8 | Backyard"] = CFrame.new(532.868164, 16.639328, 43.6470337), 
    ["9 | Misty Falls"] = CFrame.new(376.211975, 16.6393242, 18.0910645), 
    ["10 | Mine"] = CFrame.new(192.829605, 16.6393204, 45.5758171), 
    ["11 | Crystal Caverns"] = CFrame.new(209.164581, 16.6393204, 246.451965), 
    ["12 | Dead Forest"] = CFrame.new(373.901062, 16.6393204, 272.476379), 
    ["13 | Dark Forest"] = CFrame.new(532.400635, 16.639328, 265.901733), 
    ["14 | Mushroom Field"] = CFrame.new(691.71637, 16.6393204, 274.932434), 
    ["15 | Enchanted Forest"] = CFrame.new(875.281921, 16.639328, 267.881653), 
    ["16 | Crimson Forest"] = CFrame.new(862.621338, 16.639328, 486.007843),
    ["17 | Jungle"] = CFrame.new(693.105652, 16.6393204, 498.760559), 
    ["19 | Oasis"] = CFrame.new(372.10672, 16.639328, 499.208069),
    ["18 | Jungle Temple"] = CFrame.new(532.636536, 16.639328, 497.795471), 
    ["20 | Beach"] = CFrame.new(190.732224, 16.6393204, 487.357147), 
    ["21 | Coral Reef"] = CFrame.new(207.498001, -33.3606873, 768.545471), 
    ["22 | Shipwreck"] = CFrame.new(372.649658, -33.3606873, 786.346558), 
    ["23 | Atlantis"] = CFrame.new(533.234131, -93.8606186, 767.947815), 
    ["24 | Palm Beach"] = CFrame.new(808.733521, -69.4857025, 785.823608), 
    ["25 | Tiki"] = CFrame.new(1014.25232, 16.6393356, 773.097778),
    ["26 | Pirate Cove"] = CFrame.new(970.85302734375, 16.94143295288086, 923.5709838867188),
    ["27 | Pirate Tavern"] = CFrame.new(878.7459716796875, 16.957433700561523, 1018.3610229492188),
    ["28 | Shanty Town"] = CFrame.new(721.1669921875, 16.957433700561523, 1017.6840209960938),
    ["29 | Desert Village"] = CFrame.new(567.2160034179688, 16.957433700561523, 1017.6840209960938),
    ["30 | Fossil Digsite"] = CFrame.new(406.0140075683594, 16.957433700561523, 1017.6840209960938),
    ["31 | Desert Pyramids"] = CFrame.new(360.9360046386719, 16.94143295288086, 1161.2469482421875),
    ["32 | Red Desert"] = CFrame.new(458.25799560546875, 16.957433700561523, 1256.342041015625),
    ["33 | Wild West"] = CFrame.new(607.89697265625, 16.957433700561523, 1256.342041015625),
    ["34 | Grand Canyons"] = CFrame.new(757.2940063476562, 16.957433700561523, 1256.342041015625),
    ["35 | Safari"] = CFrame.new(909.9240112304688, 16.957433700561523, 1256.342041015625),
    ["36 | Mountains"] = CFrame.new(1076.3909912109375, 16.957433700561523, 1256.342041015625),
    ["37 | Snow Village"] = CFrame.new(1121.7769775390625, 16.94143295288086, 1400.458984375),
    ["38 | Icy Peaks"] = CFrame.new(1023.5139770507812, 16.957433700561523, 1494.6949462890625),
    ["39 | Ice Rink"] = CFrame.new(874.1409912109375, 16.957433700561523, 1494.6949462890625),
    ["40 | Ski Town"] = CFrame.new(707.9400024414062, 16.957433700561523, 1494.6949462890625),
    ["41 | Hot Springs"] = CFrame.new(662.7490234375, 16.94143295288086, 1637.83203125),
    ["42 | Fire and Ice"] = CFrame.new(760.2379760742188, 16.957433700561523, 1732.842041015625),
    ["43 | Volcano"] = CFrame.new(909.4849243164062, 16.957433700561523, 1732.842041015625),
    ["44 | Obsidian Cave"] = CFrame.new(1057.867919921875, 16.957433700561523, 1732.842041015625),
    ["45 | Lava Forest"] = CFrame.new(1206.64892578125, 16.957433700561523, 1732.842041015625),
    ["46 | Underworld"] = CFrame.new(1371.876953125, 16.957433700561523, 1732.842041015625),
    ["47 | Underworld Bridge"] = CFrame.new(1416.886962890625, 16.957433700561523, 1873.783935546875),
    ["48 | Underworld Castle"] = CFrame.new(1416.886962890625, 16.957433700561523, 2025.4990234375),
    ["49 | Metal Dojo"] = CFrame.new(1324.8709716796875, 16.957433700561523, 2120.532958984375),
    ["50 | Fire Dojo"] = CFrame.new(1158.8800048828125, 16.957433700561523, 2120.532958984375),
    ["51 | Samurai Village"] = CFrame.new(789.0751953125, 16.957012176513672, 2119.5673828125),
    ["52 | Bamboo Forest"] = CFrame.new(641.6153564453125, 16.957035064697266, 2119.66650390625),
    ["53 | Zen Garden"] = CFrame.new(482.8709716796875, 16.957433700561523, 2119.866943359375),
    ["54 | Flower Field"] = CFrame.new(318.35394287109375, 16.941783905029297, 2119.868896484375),
    ["55 | Fairytale Meadows"] = CFrame.new(257.15765380859375, 16.957441329956055, 2245.4831542968752),
    ["56 | Fairytale Castle"] = CFrame.new(257.15765380859375, 16.957441329956055, 2403.983154296875),
    ["57 | Royal Kingdom"] = CFrame.new(318.35394287109375, 16.94178581237793, 2664.445068359375),
    ["58 | Fairy Castle"] = CFrame.new(349.2230224609375, 16.957448959350586, 2664.471435546875),
    ["59 | Cozy Village"] = CFrame.new(508.8411865234375, 16.625007629394531, 2664.028076171875),
    ["60 | Rainbow River"] = CFrame.new(665.814697265625, 16.625007629394531, 2664.028076171875), 
    ["61 | Colorful Mines"] = CFrame.new(825.8172607421875, 16.625007629394531, 2664.028076171875), 
    ["62 | Colorful Mountains"] = CFrame.new(982.9673461914062, 16.625007629394531, 2664.028076171875), 
    ["63 | Frost Mountains"] = CFrame.new(1153.78955078125, 16.625, 2663.842041015625)
}
