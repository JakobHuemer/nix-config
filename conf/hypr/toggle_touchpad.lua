local STATE = (os.getenv("HOME") .. "/.local/state/hypr-touchpad")
local TOUCHPAD = "apple-mtp-multi-touch"

local function is_enabled()
    local f = io.open(STATE, "r")
    if not f then
        return true
    end
    local v = f:read("*a")
    f:close()
    return not v:match("off")
end

local function set(enabled)
    os.execute("mkdir -p " .. os.getenv("HOME") .. "/.local/state")
    local f = io.open(STATE, "w")
    if f then
        f:write(enabled and "on" or "off")
        f:close()
    end
    hl.exec_cmd("notify-send -u normal '" .. (enabled and "Enabling" or "Disabling") .. " Touchpad'")
    hl.device({ name = TOUCHPAD, enabled = enabled })
end

set(is_enabled()) -- apply saved state at startup
hl.bind("SUPER + G", function()
    set(not is_enabled())
end)
