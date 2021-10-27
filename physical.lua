
-- This is just the physical interface
-- See digital.lua for the digital interface

-- The physical item
minetest.register_craftitem("credits:credits", {
    description = credits.S("Credit"),
    inventory_image = "credits_credits.png",
    stack_max = 1000 -- I add a max of 1000 just because 1k is a fairly large amount (Though it could mean nothing since it's also digital)
})

-- An alias of the physical item
minetest.register_alias("credits", "credits:credits")

-- Checks the player's physical inventory for credits (Given by /credits dump ##)
credits.get_balance_physical = function(pname)
    local p = minetest.get_player_by_name(pname)
    local bal = 0
    if p ~= nil then
        local inv = minetest.get_inventory({type="player", name=pname})
        for i, stack in ipairs(inv:get_list("main")) do
            if stack:get_name() == "credits:credits" then
                bal = bal + stack:get_count()
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
            local stack = ItemStack("credits:credits "..tostring(amt)) -- This doesn't respect max stack size
            if inv:room_for_item("main", stack) then
                inv:add_item("main", stack)
                credits.add_coin(name, -amt)
                return true, credits.S("Converted @1 creditss", amt)
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
        end
    end -- Ha, now we add the digital based on the first dirty and quick check
    credits.add_coin(name, bal)
    return true, credits.S("Converted @1 creditss", bal)
end
