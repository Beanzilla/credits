
-- Interest is a percent of digital currency earned per in-game day
credits.perform_interest = function()
    local last_day = tonumber(credits.store:get_string("day_count")) or 0
    local current_day = minetest.get_day_count()
    if last_day == current_day then return end -- Abort if the current day is the last day
    if last_day < current_day then
        local days_off = current_day - last_day
        minetest.log("action", "Interest last performed "..tostring(days_off).." days ago")
        local ulist = credits.user_list()
        --minetest.log("action", "There are "..tostring(#ulist).." players to perform interst on")
        for i in ipairs(ulist) do
            -- Only perform 1 days worth of interest. (While this means more online more money it doesn't ruin servers which have been running a long time)
            local cur = credits.get_balance_digital(ulist[i])
            local earn = math.floor(cur * credits.settings.interest_rate) -- Ensure it's a whole number
            --minetest.log("action", "Player '"..ulist[i].."' has "..tostring(cur).." credits")
            credits.add_coin(ulist[i], tonumber(earn) ) -- Move the percent interest to settings.lua (interest percent)
            minetest.log("action", "Player '"..ulist[i].."' earned "..tostring( tonumber(earn) ).." credits in interest")
            local p = minetest.get_player_by_name(ulist[i])
            if p ~= nil then
                minetest.chat_send_player(ulist[i], "You earned "..tostring(tonumber(earn)).." credits in interest")
            end
        end
        credits.store:set_string("day_count", tostring(current_day))
    end
end
