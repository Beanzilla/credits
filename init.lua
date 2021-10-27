
-- Public API (Also used by some internals)
credits = {}

credits.S = minetest.get_translator("credits")
credits.modpath = minetest.get_modpath("credits")
credits.store = minetest.get_mod_storage()
credits.VERSION = "1.0-dev"

-- Assistants

-- Converts the first letter to uppercase
function credits.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- Splits the string into seperate strings for parsing
function credits.split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

-- Detect game mode
if minetest.registered_nodes["default:stone"] then
    credits.GAMEMODE = "MTG"
elseif minetest.registered_nodes["mcl_deepslate:deepslate"] then
    credits.GAMEMODE = "MCL5"
elseif minetest.registered_nodes["mcl_core:stone"] then
    credits.GAMEMODE = "MCL2"
else
    credits.GAMEMODE = "???"
end

dofile(credits.modpath.."/settings.lua")

-- Initalize the physical and digital
dofile(credits.modpath.."/physical.lua")
dofile(credits.modpath.."/digital.lua")
dofile(credits.modpath.."/interest.lua")

-- If this user is new to the server give them a starting balance
minetest.register_on_joinplayer(function(player, laston)
    local pname = player:get_player_name()
    if credits.has_account(pname) == false then
        credits.add_coin(pname, credits.settings.starting_balance) -- Move this to a settings.lua file (start_balance)
        minetest.chat_send_player(pname, credits.S("Welcome to the server you get @1 credits to start with!", credits.get_balance(pname, true)))
    end
end)

-- Initalize the chat commands
dofile(credits.modpath.."/cmds.lua")

-- Update all player's huds with "credit balance (physical credits on hand)"
local interval = 0
minetest.register_globalstep(function (dtime)
    interval = interval - dtime
    if interval <= 0 then
        for _, p in ipairs(minetest.get_connected_players()) do
            credits.show_bal(p:get_player_name())
        end
        credits.perform_interest()
        interval = credits.settings.bal_refresh_rate
    end
end)

-- Either blacklist it or add it's settings to item_replicator (but only if item_replicators is installed)
local ir = rawget(_G, "item_replicator") or nil
if ir and not credits.settings.allow_replication then
    minetest.log("action", "[credits] Blacklisting credits from replicators")
    ir.bl_add("credits:credits")
elseif ir and credits.settings.allow_replication then
    minetest.log("action", "[credits] Added Replication settings of "..tostring(credits.settings.replication_amount).." amount every "..tostring(credits.settings.replication_time).." seconds.")
    ir.add("credits:credits", credits.settings.replication_amount, credits.settings.replication_time)
end
