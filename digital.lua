
-- This is the Digital interface
-- See physical.lua for the Physical interface

-- Gets the digital balance of the player
credits.get_balance_digital = function(pname)
    local player = credits.has_account(pname)
    local bal = 0
    if player then
        local mydata = minetest.deserialize(credits.store:get_string("digitals")) or {}
        if mydata[pname] ~= nil then
            bal = mydata[pname]
        end
    end
    return bal
end

-- Adds or removes the digital balance of the player (Use negative to remove coins)
credits.add_coin = function(pname, amount)
    --local player = minetest.get_player_by_name(pname)
    local bal = credits.get_balance_digital(pname)
    local mydata = minetest.deserialize(credits.store:get_string("digitals")) or {}
    bal = bal + amount
    if bal < 0 then -- No checks for asking to remove over the amount owned!
        bal = 0
    end
    mydata[pname] = bal
    credits.store:set_string("digitals", minetest.serialize(mydata))
end

-- Does this player have an account with us?
credits.has_account = function(pname)
    local mydata = minetest.deserialize(credits.store:get_string("digitals")) or {}
    if mydata[pname] ~= nil then
        return true
    else
        return false
    end
end

-- Forms the resulting chat messages to inform the player their balance (Includes seperating each individual account) Pass true or some value to not send to chat
credits.get_balance = function(pname, silent)
    local phy = credits.get_balance_physical(pname)
    local dig = credits.get_balance_digital(pname)
    local total = 0 + phy + dig
    local p = minetest.get_player_by_name(pname)
    if silent == nil and p ~= nil then
        -- Optionally send the player a chat mesage, but allow it not to be sent too!
        minetest.chat_send_player(pname, credits.S("Total:    @1", total))
        minetest.chat_send_player(pname, credits.S("Digital:  @1", dig))
        minetest.chat_send_player(pname, credits.S("Physical: @1", phy))
    end
    return total
end

-- Displays or updates a HUD element for the current player's balance
credits.show_bal = function (pname)
    local p = minetest.get_player_by_name(pname)
    local dis = credits.displays or {}
    local phy = credits.get_balance_physical(pname)
    local dig = credits.get_balance_digital(pname)
    local total = 0 + phy + dig
    if p ~= nil then
        if dis[pname] == nil then
            dis[pname] = p:hud_add({
                hud_elem_type = "text",
                position = {x = 0.8, y = 0.1},
                offset = {x = 0.0, y = 0.0},
                text = credits.S("Credits: @1 (@2)", total, phy),
                number = 0x00e100, -- 0, 225, 0 (RGB)
                alignment = {x = 0.0, y = 0.0},
                scale = {x = 100.0, y = 100.0}
            })
        else
            p:hud_change(dis[pname], "text", credits.S("Credits: @1 (@2)", total, phy))
        end
        credits.displays = dis
    end
end

-- Returns a table of player names who have a credits account
credits.user_list = function ()
    local result = {}
    local mydata = minetest.deserialize(credits.store:get_string("digitals")) or {}
    for k,v in pairs(mydata) do
        table.insert(result, k)
        --minetest.log("action", "Adde player "..k.." to userlist, now at "..tostring(#result).." size")
    end
    return result
end

-- These functions were once in cmds but has been moved to easily merge all forms into their coresponding digital.lua or physical.lua files.
-- Put everything coresponding with a form into that forms file (make everything in one place rather than jumping about in multiple files)

-- Pay another person amount coins
credits.pay = function (name, to, amount)
    amt = tonumber(amount) or 0
    local bal = credits.get_balance_digital(name)
    if amt ~= 0 and amt > 0 then
        if bal >= amt then
            if minetest.is_player(to) then
                credits.add_coin(to, amt)
                credits.add_coin(name, -amt)
                minetest.chat_send_player(to, credits.S("@1 payed you @2 credits", name, amt))
                return true, credits.S("You payed @1 @2 credits", to, amt)
            else
                return false, credits.S("@1 is not a player (They must be online)", to)
            end
        else
            return false, credits.S("You don't have @1 credits to send", amt)
        end
    else
        return true, "Aborted pay"
    end
end

-- Gives digital coins
credits.give = function (name, amount)
    if minetest.check_player_privs(name, {give=true}) then
        amt = tonumber(amount) or 0
        amt = math.abs(amt)
        credits.add_coin(name, amt)
        return true, credits.S("Gave @1 credits", amt)
    else
        return false, credits.S("You need the give priv to give yourself credits")
    end
end

-- Takes digital coins (But first loads physical)
credits.take = function (name, amount)
    if minetest.check_player_privs(name, {give=true}) then
        amt = tonumber(amount) or 0
        if amt ~= 0 then
            amt = math.abs(amt)
        else
            amt = credits.get_balance_digital(name)
        end
        credits.add_coin(name, -amt)
        return true, credits.S("Took @1 credits", amt)
    else
        return false, credits.S("You need the give priv to take credits from yourself")
    end
end
