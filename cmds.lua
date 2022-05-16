
-- Adds the chat command(s)
minetest.register_chatcommand("credits", {
    privs = {
        shout = true
    },
    description = "The base command for credits, see /credits help",
    func = function (name, param)
        local words = credits.split(param, ' ')
        if words[1] == "bal" then
            return credits.get_balance(name)
        elseif words[1] == "pay" then
            local to, amt = string.match(param, "^pay ([%a%d_-]+) ([%d]+)$")
            return credits.pay(name, to, amt)
        elseif words[1] == "dump" then
            local amt = string.match(param, "^dump ([%d]+)$")
            -- No more limit! Because it gets stored essentially into meta of the item
            amt = tonumber(amt) or 0
            return credits.dump(name, amt)
        elseif words[1] == "load" then
            -- Changed to load only the currently held credits (so you don't load a bunch of them)
            return credits.load(name)
        elseif words[1] == "help" then
            local C = minetest.chat_send_player
            local base_cmd = "credits"
            C(name, credits.S(" "))
            C(name, credits.S("Command List:"))
            C(name, credits.S("      /@1 help", base_cmd))
            C(name, credits.S("      /@1 pay <player_name> <amount>", base_cmd))
            C(name, credits.S("      /@1 bal", base_cmd))
            C(name, credits.S("      /@1 dump <amount>", base_cmd))
            C(name, credits.S("      /@1 load", base_cmd))
            if minetest.check_player_privs(name, {give=true}) then
                C(name, credits.S("      /@1 give <amount>", base_cmd))
                C(name, credits.S("      /@1 take <amount>", base_cmd))
            end
            C(name, credits.S(" "))
        elseif words[1] == "give" then
            local amt = string.match(param, "^give ([%d]+)$")
            return credits.give(name, amt)
        elseif words[1] == "take" then
            local amt = string.match(param, "^take ([%d]+)$")
            return credits.take(name, amt)
        else
            minetest.chat_send_player(name, credits.S("Try /credits help"))
        end
    end

})

-- Allow them to show up with help info

minetest.register_chatcommand("credits help", {
    privs = {
        shout = true
    },
    description = "Displays a command list of commands avalible via credits"
})

minetest.register_chatcommand("credits dump ##", {
    privs = {
        shout = true,
    },
    description = "Converts ## of credits from digital into a physical form"
})

minetest.register_chatcommand("credits load", {
    privs = {
        shout = true
    },
    description = "Converts physical credits held in your hand into digital form"
})

minetest.register_chatcommand("credits pay <player_name> ##", {
    privs = {
        shout = true
    },
    description = "Sends ## of digital credits to given player_name"
})

minetest.register_chatcommand("credits bal", {
    privs = {
        shout = true
    },
    description = "Displays current balance and a break down of digital and physical credits into chat"
})

minetest.register_chatcommand("credits give ##", {
    privs = {
        shout = true,
        give = true
    },
    description = "Gives ## of digital credits to you"
})

minetest.register_chatcommand("credits take ##", {
    privs = {
        shout = true,
        give = true
    },
    description = "Converts ALL physical credits into digital form, then takes ## of digital credits from you"
})
