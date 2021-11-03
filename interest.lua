
-- Interest is a percent of digital currency earned per in-game day
credits.perform_interest = function()
    local last_day = tonumber(credits.store:get_string("day_count")) or 0
    local current_day = minetest.get_day_count()
    if last_day == current_day then return end -- Abort if the current day is the last day
    if last_day < current_day then
        local days_off = current_day - last_day
        minetest.log("action", "Interest last performed "..tostring(days_off).." days ago")
        local my_list = true
        local ulist = credits.user_list()
        if credits.settings.online_get_interest then -- Instead of every account let's get the current connected players
            ulist = minetest.get_connected_players()
            my_list = false
        end
        -- Convert user datas into user names
        if not my_list then
            local new_list = {}
            for _, user in ipairs(ulist) do
                table.insert(new_list, user:get_player_name())
            end
            ulist = new_list
        end
        minetest.log("action", "There are "..tostring(#ulist).." players to perform interst on")
        for _, user in ipairs(ulist) do
            minetest.log("action", minetest.serialize(user))
            -- Only perform 1 days worth of interest. (While this means more online more money it doesn't ruin servers which have been running a long time)
            local cur = credits.get_balance_digital(user)
            local earn = math.floor(cur * credits.settings.interest_rate) -- Ensure it's a whole number
            --minetest.log("action", "Player '"..ulist[i].."' has "..tostring(cur).." credits")
            credits.add_coin(user, tonumber(earn) ) -- Move the percent interest to settings.lua (interest percent)
            minetest.log("action", "Player '"..user.."' earned "..tostring( tonumber(earn) ).." credits in interest")
            local p = minetest.get_player_by_name(user)
            if p ~= nil then -- Check if they are online, if so let them know now.
                minetest.chat_send_player(user, "You earned "..tostring(tonumber(earn)).." credits in interest")
            end
        end
        credits.store:set_string("day_count", tostring(current_day))
    end
end
