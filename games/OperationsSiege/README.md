# Operations:Siege

https://www.roblox.com/games/13997018456/SEASON-2-Operations-Siege

```lua
getgenv().config = {
    chams = true,
    fixTeam = true, -- fixes the issue of the premade highlights overwriting ours
    transSoftWall = true,
    transBarricade = true,
    bringEnemies = false, -- super buggy cant be undone once toggled?
    bombColor = Color3.fromHex("#ffac00"), -- orange
    teamColor = {
        attacker = Color3.fromHex("#ff0000"), -- red
        defender = Color3.fromHex("#0000ff") -- blue
    }
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/OperationsSiege/src"))()
```

if you are on mobile and cannot copy this to replace the loadstring:

https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/OperationsSiege/src

## Features

player chams

bomb chams

transparency on soft walls/reinforced walls (buggy on reinforced ones

transparency on barricades

bring enemies (client sided but shooting them is server sided)

color selection for teams and bomb cham
