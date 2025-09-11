-- Disable animations for faster response
hs.window.animationDuration = 0

-- Define hyper key
local hyper = { "cmd", "alt", "ctrl", "shift" }

-- Reload config with hyper+r
hs.hotkey.bind(hyper, "r", function()
    hs.reload()
end)

-- Ghosty cmd + return new window
hs.hotkey.bind({"cmd"}, "return", function()
    local app = hs.application.get("Ghostty")
    if app then
        -- App is running, create new window
        app:selectMenuItem({"File", "New Window"}) -- or whatever the menu item is
    else
        -- App not running, launch it
        hs.application.open("Ghostty")
    end
end)

-- Show loaded alert
hs.alert.show("Hammerspoon loaded")

-- Show reload alert (this will show after reload)
hs.loadSpoon = hs.loadSpoon or function() end
hs.spoons = hs.spoons or {}

