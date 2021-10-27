
credits.settings = {}

credits.settings.interest_rate = 0.05 -- Equates to 5% per in-game day (Only executed once)
credits.settings.bal_refresh_rate = 3 -- Every 3 seconds, updates the HUD and checks if interest can be performed
credits.settings.starting_balance = 100 -- New players who the mod did not see before will get 100 credits on join
credits.settings.allow_replication = false -- Do we allow credits in item_replicators? (could be duped)

if credits.settings.allow_replication then
    credits.settings.replication_time = 15
    credits.settings.replication_amount = 1
end
