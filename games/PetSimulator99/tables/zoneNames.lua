--[[
local function loadTable(tableName)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/PetSimulator99/tables/"..tableName..".lua"))()
end
local zoneNames = loadTable("zoneNames")
local Map = game.workspace.Map
local zonesText = ""
for _,zone in ipairs(Map:GetChildren()) do
    if not table.find(zoneNames, zone.Name) and zone.Name ~= "SHOP" then
        zonesText = zonesText..'"'..zone.Name..'", \n'
    end
end
setclipboard(zonesText)
]]
return {
    "1 | Spawn",
    "2 | Colorful Forest",
    "3 | Castle",
    "4 | Green Forest" ,
    "5 | Autumn",
    "6 | Cherry Blossom",
    "7 | Farm",
    "8 | Backyard",
    "9 | Misty Falls",
    "10 | Mine",
    "11 | Crystal Caverns" ,
    "12 | Dead Forest",
    "13 | Dark Forest",
    "14 | Mushroom Field",
    "15 | Enchanted Forest",
    "16 | Crimson Forest",
    "17 | Jungle",
    "19 | Oasis",
    "18 | Jungle Temple",
    "20 | Beach",
    "21 | Coral Reef",
    "22 | Shipwreck",
    "23 | Atlantis",
    "24 | Palm Beach",
    "25 | Tiki",
    "26 | Pirate Cove",
    "27 | Pirate Tavern",
    "28 | Shanty Town",
    "29 | Desert Village",
    "30 | Fossil Digsite",
    "31 | Desert Pyramids",
    "32 | Red Desert",
    "33 | Wild West",
    "34 | Grand Canyons",
    "35 | Safari",
    "36 | Mountains",
    "37 | Snow Village",
    "38 | Icy Peaks",
    "39 | Ice Rink",
    "40 | Ski Town",
    "41 | Hot Springs",
    "42 | Fire and Ice",
    "43 | Volcano",
    "44 | Obsidian Cave",
    "45 | Lava Forest",
    "46 | Underworld",
    "47 | Underworld Bridge",
    "48 | Underworld Castle",
    "49 | Metal Dojo",
    "50 | Fire Dojo",
    "51 | Samurai Village",
    "52 | Bamboo Forest",
    "53 | Zen Garden",
    "54 | Flower Field",
    "55 | Fairytale Meadows",
    "56 | Fairytale Castle",
    "57 | Royal Kingdom",
    "58 | Fairy Castle",
    "59 | Cozy Village", 
    "60 | Rainbow River", 
    "61 | Colorful Mines", 
    "62 | Colorful Mountains", 
    "63 | Frost Mountains"
}
