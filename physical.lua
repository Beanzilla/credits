
-- This is just the physical interface
-- See digital.lua for the digital interface

-- I need to improve the mk2 and mk3 so dump can use them too, since 1000 credits could be represented as about 111 credits_mk2

-- The physical item
minetest.register_craftitem("credits:credits", {
    description = credits.S("Credit"),
    inventory_image = "credits_credits_blue.png",
    stack_max = 1000 -- I add a max of 1000 just because 1k is a fairly large amount (Though it could mean nothing since it's also digital)
})

minetest.register_craftitem("credits:credits_mkii", {
    description = credits.S("Credit Mk2"),
    inventory_image = "credits_credits_green.png",
    stack_max = 1000 -- I add a max of 1000 just because 1k is a fairly large amount (Though it could mean nothing since it's also digital)
})

minetest.register_craftitem("credits:credits_mkiii", {
    description = credits.S("Credit Mk3"),
    inventory_image = "credits_credits_red.png",
    stack_max = 1000 -- I add a max of 1000 just because 1k is a fairly large amount (Though it could mean nothing since it's also digital)
})

-- An alias of the physical item
minetest.register_alias("credits", "credits:credits")
minetest.register_alias("credits_mk2", "credits:credits_mkii")
minetest.register_alias("credits_mk3", "credits:credits_mkiii")

-- Add Crafts
minetest.register_craft({
    type = "fuel",
    recipe = "credits:credits",
    burntime = 1 -- For those who just litteraly want to burn money
})

minetest.register_craft({
    type = "fuel",
    recipe = "credits:credits_mkii",
    burntime = 10 -- For those who just litteraly want to burn money
})

minetest.register_craft({
    type = "fuel",
    recipe = "credits:credits_mkiii",
    burntime = 100 -- For those who just litteraly want to burn money
})

minetest.register_craft({
    output = "credits:credits_mkii",
    recipe = { -- 9 credits = 1 mk2 credit
        {"credits:credits", "credits:credits", "credits:credits"},
        {"credits:credits", "credits:credits", "credits:credits"},
        {"credits:credits", "credits:credits", "credits:credits"}
    },
})

minetest.register_craft({
    type = "shapeless",
    output = "credits:credits 9",
    recipe = { -- 1 mk2 credit = 9 credits
        "credits:credits_mkii"
    }
})

minetest.register_craft({
    output = "credits:credits_mkiii",
    recipe = { -- 9 mk2 credits = 1 mk3 credit
        {"credits:credits_mkii", "credits:credits_mkii", "credits:credits_mkii"},
        {"credits:credits_mkii", "credits:credits_mkii", "credits:credits_mkii"},
        {"credits:credits_mkii", "credits:credits_mkii", "credits:credits_mkii"}
    },
})

minetest.register_craft({
    type = "shapeless",
    output = "credits:credits_mkii 9",
    recipe = { -- 1 mk3 credit = 9 mk2 credits
        "credits:credits_mkiii"
    }
})

-- Checks the player's physical inventory for credits (Given by /credits dump ##)
credits.get_balance_physical = function(pname)
    local p = minetest.get_player_by_name(pname)
    local bal = 0
    if p ~= nil then
        local inv = minetest.get_inventory({type="player", name=pname})
        for i, stack in ipairs(inv:get_list("main")) do
            if stack:get_name() == "credits:credits" then
                bal = bal + stack:get_count()
            elseif stack:get_name() == "credits:credits_mkii" then
                bal = bal + (stack:get_count() * 9) -- Each one counts for 9
            elseif stack:get_name() == "credits:credits_mkiii" then
                bal = bal + ((stack:get_count() * 9) * 9) -- Each one counts for 81
            end
        end
    end
    return bal
end

-- These are commands used in calls that perform various tasks. (once in cmds.lua)

-- Dump from digital into physical
credits.dump = function (name, amount)
    amt = tonumber(amount) or 0
    local bal = credits.get_balance_digital(name)
    local inv = minetest.get_inventory({type="player", name=name})
    if amt ~= 0 and amt > 0 then
        if bal >= amt then
            -- Possibly convert this from a bulk or instantanious dump all into one item mabe make it so it can split it into multiple stacks
            -- Seperate by 1000 (max stack size)
            -- I need to include usage of mk2 and mk3 into this
            local stack = ItemStack("credits:credits "..tostring(amt)) -- This doesn't respect max stack size
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

-- Load all from physical into digital
credits.load = function (name)
    local bal = credits.get_balance_physical(name) -- The quick and dirty way to know how many there are
    local inv = minetest.get_inventory({type="player", name=name})
    for i, s in ipairs(inv:get_list("main")) do -- Actually remove them now
        if s:get_name() == "credits:credits" then
            inv:set_stack("main", i, nil)
        elseif s:get_name() == "credits:credits_mkii" then
            inv:set_stack("main", i, nil)
        elseif s:get_name() == "credits:credits_mkiii" then
            inv:set_stack("main", i, nil)
        end
    end -- Ha, now we add the digital based on the first dirty and quick check
    credits.add_coin(name, bal)
    return true, credits.S("Converted @1 credits", bal)
end
