# Credits V1.3

A physical and digital currency.

## News

* Version 1.2 introduces 2 other branches of the physical currency (Mk2 and Mk3 are 9:1 to 81:1 credit ratio), currently they can only be crafted by players. (But can be loaded the same)
* Version 1.3 reverts the 2 branches of physical currency, changed loading to only load credits in the player's hand, and changed dumping to store total amount into 1 single credit item. (you can now ask to dump 100,000 or more without fear of getting 100 stacks (since old limit was 1000), now you'll get only 1 stack with count of 1, with a value of 100000), you can now also load credits by using it while not looking at anything. (again this would only load your hand, nothing else)

> Warning as of version 1.3, Mk2 and Mk3 are worth 0 credits, so load them all into digital then upgrade to 1.3!

## Issues

* As of version 1.3, there is a major issue with most shop trading mods (smartshop, currency's shop), they don't implement how much the credit is actually worth, thus all credits are valued the same to them (despite their values actually differing), a shop will be added to this mod in 1.3.1 to fix this issue (assuming that shop is used instead of others).

## What's in the box

* Physical representation of a digital currency. (Use `/credits dump ##` Where # is number of coins to convert to a physical item, each coin tracks how much it's worth, so a coin could be worth 1000 or 10000000 or anything)
* Digital currency. (And a player can `/credits load` to convert only credits in their hands to convert the physical item back to digital)
* An API for performing general calculations (Such as getting the total balance of the player (both physical and digital), adding or taking credits, etc)
* Interest rate (Gives players a percent of their digital credits per in-game day)

> Please note, Interest rate will only provide a percent of digital credits. (Physical is not included in interest)

## Why Digital and Physical?

### Why Digital

Digital allows a player to have a very large amount of currency without needing to carry all that around. (instead the mod holds the number in memory, saving it as mod storage is saved to disk (about every 10 minutes))

In a Digital form it is slightly easier to know how much a player has. (Where as the physical would require this mod to check their inventory each time I want a balance)

> I made it so a player can convert from Digital to Physical so that a player can give another player a Physical item as payment. (Though `/credits pay playername ##` works too)

### Why Physical

> Warning: Don't use `/giveme credits:credits somenumber` the load process donesn't recognize them, so to get it working you will need to use `/credits give yourname amount` then `/credits dump thatamount` if you need it physical.

Physical was added to provide a way for a player to in some sense "save" credits so if they tend to spend all their credits they could convert some to physical then hide that in a chest.

It was also added to allow completely physical item trades. (For those who don't trust the `/credits pay playername ##` command, or are using it at a shop)

> I made it so a player can convert Physical back to Digital for when they don't want the Physical items sitting around. (As digital can't be stolen)


## Command Reference

Or just /help and select credits to see all commands for credits. (`/credits` is the base command)

### Dump

`/credits dump ##`

Converts ## of credits into the physical (provided there is space in the player's inventory and they have ## of credits)

> The stack size is now 50,000, but the value can be just about unlimited. (this means you could make 1 credit "notes" like bank notes from Minecraft)

### load

`/credits load`

Converts physical credits in the player's hand into the digital. (thus the physical coins are removed from the player's hand)

> This command was changed to support finer control of credit loading. (Also in version 1.3 there will be a use option to use the credit to load it)

### pay

`/credits pay playername ##`

Sends ## of credits in digital form to the playername (provided that player has a credits account which is created on first login that the mod recognizes, and the player issuing this command has ## of credits)

> This keeps everything digital (Use dump and load to physically trade credits)

### bal

`/credits bal`

Calculates total number of credits the player has. (Also gives a breakdown of digital and physical credit counts)

> I.E. Assuming I had 10 credits in digital and 100 in physical:
>
>        Total:    110
>
>        Digital:  10
>
>        Physical: 100
