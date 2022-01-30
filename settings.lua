
credits.settings = {}
local set = credits.settings

--[[ See your `minetest.conf` file after first run to change these settings
credits.settings.interest_rate = 0.05 -- Equates to 5% per in-game day (Only executed once)
credits.settings.bal_refresh_rate = 3 -- Every 3 seconds, updates the HUD and checks if interest can be performed
credits.settings.starting_balance = 100 -- New players who the mod did not see before will get 100 credits on join
credits.settings.allow_replication = false -- Do we allow credits in item_replicators? (could be duped)

if credits.settings.allow_replication then
    credits.settings.replication_time = 15 -- Seconds it takes...
    credits.settings.replication_amount = 1 -- To produce this many
end

credits.settings.online_get_interest = true -- Do player's online get interest or does every account get interest
credits.settings.max_interest = 250 -- Limit the max credits a player can earn to this amount (this means regardless of their balance)
-- If online_get_interest then
--      For each player online do
--          credits_interest(player)
-- Else
--      For every player with an account do
--          credits_interest(player_account)
-- End
]]

set.interest_rate = minetest.settings:get("credits.interest_rate")
set.bal_refresh_rate = minetest.settings:get("credits.hud_refresh_rate")
set.starting_balance = minetest.settings:get("credits.starting_balance")
set.allow_replication = minetest.settings:get_bool("credits.allow_replication")
set.replication_time = minetest.settings:get("credits.replication_time")
set.replication_amount= minetest.settings:get("credits.replication_amount")
set.online_get_interest = minetest.settings:get_bool("credits.online_get_interest")
set.max_interest = minetest.settings:get("credits.max_interest")

-- Auto generate if they didn't exist
if set.interest_rate == nil then
    set.interest_rate = 0.05
    minetest.settings:set("credits.interest_rate", set.interest_rate)
else
    set.interest_rate = tonumber(set.interest_rate)
end
if set.bal_refresh_rate == nil then
    set.bal_refresh_rate = 3.0
    minetest.settings:set("credits.hud_refresh_rate", set.bal_refresh_rate)
else
    set.bal_refresh_rate = tonumber(set.bal_refresh_rate)
end
if set.starting_balance == nil then
    set.starting_balance = 100
    minetest.settings:set("credits.starting_balance", set.starting_balance)
else
    set.starting_balance = tonumber(set.starting_balance)
end
if set.allow_replication == nil then
    set.allow_replication = false
    minetest.settings:set_bool("credits.allow_replication", set.allow_replication)
end
if set.replication_time == nil then
    set.replication_time = 60
    minetest.settings:set("credits.replication_time", set.replication_time)
else
    set.replication_time = tonumber(set.replication_time)
end
if set.replication_amount == nil then
    set.replication_amount = 1
    minetest.settings:set("credits.replication_amount", set.replication_amount)
else
    set.replication_amount = tonumber(set.replication_amount)
end
if set.online_get_interest == nil then
   set.online_get_interest = true
   minetest.settings:set_bool("credits.online_get_interest", set.online_get_interest)
end
if set.max_interest == nil then
    set.max_interest = 250
    minetest.settings:set("credits.max_interest", set.max_interest)
else
    set.max_interest = tonumber(set.max_interest)
end
