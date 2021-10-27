# Credits

A physical and digital currency.

## What's in the box

* Physical representation of a digital currency. (Use `/credits dump ##` Where # is number of coins to convert to a physical item, limited to 1000 credits per dump command)
* Digital currency. (And a player can `/credits load` to convert all credits in their inventory to convert the physical item back to digital)
* An API for performing general calculations (Such as getting the total balance of the player (both physical and digital), adding or taking credits, etc)
* Interest rate (Gives players a percent of their digital credits per in-game day)

> Please note, Interest rate will only provide a percent of digital credits. (Physical is not included in interest)

## Why Digital and Physical?

### Why Digital

Digital allows a player to have a very large amount of currency without needing to carry all that around. (instead the mod holds the number in memory)

In a Digital form it is slightly easier to know how much a player has. (Where as the physical would require this mod to check their inventory each time I want a balance)

> I made it so a player can convert from Digital to Physical so that a player can give another player a Physical item as payment. (Though `/credits pay playername ##` works too)

### Why Physical

Physical was added to provide a way for a player to in some sense "save" credits so if they tend to spend all their creditss they could convert some to physical then hide that in a chest.

It was also added to allow completely physical item trades. (For those who don't trust the `/credits pay playername ##` command, or are using it at a shop)

> I made it so a player can convert Physical back to Digital for when they don't want the Physical items sitting around. (As digital can't be stolen)


## Command Reference

Or just /help and select credits to see all commands for credits. (`/credits` is the base command)

### Dump

`/credits dump ##`

Converts ## of credits into the physical (provided there is space in the player's inventory and they have ## of credits)

> A limit of 1000 credits can be converted in a single command (Since that's the stack size too)

### load

`/credits load`

Converts ALL physical credits into the digital. (thus all the physical coins are removed from the player's inventory)

> No limit is applied, if you want to keep some still physical put it into a chest then issue the command.

### pay

`/credits pay playername ##`

Sends ## of credits in digital form to the playername (provided that player has a credits account which is created on first login that the mod recognizes, and the player issuing this command has ## of credits)

> This keeps everything digital (Use dump and load to physically trade credits)

### bal

`/credits bal`

Calculates total number of credits the player has. (Also gives a breakdown of digital and physical credit counts)

> I.E. Assuming I had 10 creditss in digital and 100 in physical:
>
>        Total:    110
>
>        Digital:  10
>
>        Physical: 100
