# discord webhook for roblox executor
ripped from my pet simulator script
## Credit:
- griffin
### Requirements
executor with request or httprequest or http_request
### Usage
```lua
local webhookUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/lua/normal/discordwebhook/src.lua"))()

--  create a message
local myMessage = webhookUtil.createMessage({
  Url = "", -- your webhook,
  username = "" -- the webhook username,
  content = "" -- the content
})

-- adding an embed
local embed1 = myMessage.addEmbed(title: string, color: number, description: string) -- color format is "0x" followed by your hex color code

-- adding field to embed
embed1.addField(name: string, value: string)

-- sending message
local response = myMessage.sendMessage()
print(response) -- to see the response fr
```
