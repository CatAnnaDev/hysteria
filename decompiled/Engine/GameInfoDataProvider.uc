class GameInfoDataProvider extends UIDynamicDataProvider
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var GameReplicationInfo GameDataSource;

event ProviderInstanceBound(Object DataSourceInstance)
{
    local GameReplicationInfo GRI;
    
    GRI = GameReplicationInfo(DataSourceInstance);
    if (GRI != none)
    {
        GameDataSource = GRI;
    }
}

defaultproperties
{
    DataClass="GameReplicationInfo"
}
