class PlayerOwnerDataProvider extends PlayerDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var transient PlayerDataProvider PlayerData;

function bool CleanupDataProvider()
{
    if (CleanupDataProvider())
    {
        PlayerData = none;
        return true;
    }
    return false;
}

function SetPlayerDataProvider(PlayerDataProvider NewPlayerData)
{
    local Object PRI;
    
    if (NewPlayerData != none)
    {
        PRI = NewPlayerData.GetDataSource();
        if (PRI != none)
        {
            BindProviderInstance(PRI);
        }
    }
    PlayerData = NewPlayerData;
}

defaultproperties
{
}
