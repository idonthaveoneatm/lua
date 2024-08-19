local webhookLibrary = {}
local HttpService = cloneref(game:GetService("HttpService"))

function webhookLibrary.createMessage(properties)
    assert(properties.Url, "Url required")
    assert(properties.username, "username required")
    local requestTable = {
        Url = properties.Url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = {
            ["username"] = properties.username,
            ["content"] = properties.content or "",
            ["embeds"] = {}
        }
    }
    local webhookFunctions = {}
    local EmbedIndex = 0
    function webhookFunctions.addEmbed(title: string, color: number)
        assert(title, "title required")
        assert(color, "color required")

        EmbedIndex += 1
        local privateIndex = EmbedIndex

        table.insert(requestTable.Body.embeds, {
            ["title"] = title,
            ["color"] = tonumber(color),
            ["fields"] = {}
        })
        local embedFunctions = {}
        function embedFunctions.addField(name, value)
            assert(name, "name required")
            assert(value, "value required")
            table.insert(requestTable.Body.embeds[privateIndex].fields, {
                ["name"] = name,
                ["value"] = value
            })
        end
        return embedFunctions
    end
    function webhookFunctions.sendMessage()
        requestTable.Body = HttpService:JSONEncode(requestTable.Body)
        local response = request(requestTable)
        return response
    end
    return webhookFunctions
end
return webhookLibrary
