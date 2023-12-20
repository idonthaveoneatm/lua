local localHost = require(script.Parent)

return function(target)
    local host = localHost({
        parent = target
    })
    return function()
        host:Destroy()
    end
end