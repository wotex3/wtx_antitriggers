Config = {
    ['secondsToClearLimit'] = (5 * 1000), -- How many seconds to clear the limit
    ['limit'] = 25, -- How many times can the player trigger the event
    ['ignoredTriggers'] = {
        ['cfx_internal:okanburuk'] = true,
        ['cfx_internal:muslera'] = true,
    },
    ['ban'] = function(src, reason, message)
        -- Maybe you want to use your own ban/log function
        DropPlayer(src, ("[wtx-antitrigger] %s\n%s"):format(reason, message))
    end
}