# Operations:Siege

https://www.roblox.com/games/13997018456/SEASON-2-Operations-Siege

```lua
getgenv().config = {
    chams = {
        players = true,
        bombs = true,
        gadgets = true -- very laggy due to barbed wire might change
    },
    transSoftWall = true,
    transBarricade = true,
    bringEnemies = false, -- super buggy cant be undone once toggled?
    colors = {
        attackers = Color3.fromHex("#ff0000"), -- red
        defenders = Color3.fromHex("#0000ff"), -- blue
        bombs = Color3.fromHex("#ffac00"), -- orange
        gadgets = Color3.fromHex("#ffff00") -- yellow
    },
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/OperationsSiege/src"))()
```

if you are on mobile and cannot copy this to replace the loadstring:

https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/games/OperationsSiege/src

## Features

player chams

bomb chams

gadget chams

transparency on soft walls/reinforced walls (buggy on reinforced ones

transparency on barricades

bring enemies (client sided but shooting them is server sided)

color selection for teams, bomb, and gadget chams
