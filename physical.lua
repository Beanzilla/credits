
-- This is just the physical interface
-- See digital.lua for the digital interface

-- I need to improve the mk2 and mk3 so dump can use them too, since 1000 credits could be represented as about 111 credits_mk2

-- The physical item
minetest.register_craftitem("credits:credits", {
    short_description = credits.S("Credit"),
    description = credits.S("Credit\nValue: 1"),
    inventory_image = "credits_credits_blue.png",
    stack_max = 50000,
    value = 1, -- How much it actually is worth (this allows me to do withdraw into a single item then handle loading it back in)
    on_secondary_use = function (stack, user, pointed)
        if user ~= nil then
            local _, rc = credits.load(user:get_player_name())
            if rc ~= nil then
                minetest.chat_send_player(user:get_player_name(), rc)
            end
        end
        -- Doesn't matter what I return the stack should be kept unless modifed by credits load
    end
})

-- An alias of the physical item
minetest.register_alias("credits", "credits:credits")

-- Add Crafts
minetest.register_craft({
    type = "fuel",
    recipe = "credits:credits",
    burntime = 1 -- For those who just litteraly want to burn money (This will actually only burn for 1 regardless the value, thus not quite good)
})

-- Checks the player's physical inventory for credits (Given by /credits dump ##)
credits.get_balance_physical_all = function(pname)
    local p = minetest.get_player_by_name(pname)
    local bal = 0
    if p ~= nil then
        local inv = minetest.get_inventory({type="player", name=pname})
        for i, stack in ipairs(inv:get_list("main")) do
            if stack:get_name() == "credits:credits" then
                local meta = stack:get_meta()
                local value = 1
                if meta:get_int("value") ~= nil then
                    value = meta:get_int("value")
                end
                bal = bal + (stack:get_count() * value)
            end
        end
    end
    return bal
end

-- Checks the player's physical hand for credits
credits.get_balance_physical = function(pname)
    local p = minetest.get_player_by_name(pname)
    local bal = 0
    if p ~= nil then
        local stack = p:get_wielded_item()
        if stack:get_name() == "credits:credits" then
            local meta = stack:get_meta()
            local value = 1
            if meta:get_int("value") ~= nil then
                value = meta:get_int("value")
            end
            bal = bal + (stack:get_count() * value)
        end
    end
    return bal
end

-- These are commands used in calls that perform various tasks. (once in cmds.lua)

-- Dump from digital into physical
credits.dump = function (name, amount)
    local amt = tonumber(amount) or 0
    local bal = credits.get_balance_digital(name)
    local inv = minetest.get_inventory({type="player", name=name})
    if amt ~= 0 and amt > 0 then
        if bal >= amt then
            local stack = ItemStack("credits:credits 1") -- We spawn one of these in
            local meta = stack:get_meta()
            -- Poof, no more limit! \o/ Yay!
            meta:set_int("value", amt) -- Set it's value, and update it's description
            meta:set_string("description", credits.S("Credit\nValue: "..tostring(amt)))
            if inv:room_for_item("main", stack) then
                inv:add_item("main", stack)
                credits.add_coin(name, -amt)
                return true, credits.S("Converted @1 credits", amt)
            else
                return false, credits.S("You don't have enough space to store @1 credits", amt)
            end
        else
            return false, credits.S("You don't have @1 credits to convert", amt)
        end
    else
        return true, "Aborted dump"
    end
end

-- Load physical into digital
credits.load = function (name)
    local bal = credits.get_balance_physical(name) -- The quick and dirty way to know how many there are (Only get's the hands)
    local player = minetest.get_player_by_name(name) -- Obtain player
    local stack = player:get_wielded_item() -- Obtain the hand's item
     -- Actually remove them if processed
    if stack:get_name() == "credits:credits" then
        player:set_wielded_item("")
    -- These are actually to invalidate them (they are worth 0 thanks to this update)
    elseif stack:get_name() == "credits:credits_mkii" then
        player:set_wielded_item("")
    elseif stack:get_name() == "credits:credits_mkiii" then
        player:set_wielded_item("")
    end
    -- Ha, now we add the digital based on the first dirty and quick check
    credits.add_coin(name, bal)
    return true, credits.S("Converted @1 credits", bal)
end
