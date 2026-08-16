class DataStoreClient extends UIRoot
    native
    notplaceable
    config(Engine)
    hidecategories(Object,UIRoot);

struct native transient PlayerDataStoreGroup
{
    var const transient LocalPlayer PlayerOwner;
    var const transient array<UIDataStore> DataStores;
};

var config array<string> GlobalDataStoreClasses;
var const array<UIDataStore> GlobalDataStores;
var config array<string> PlayerDataStoreClassNames;
var const array<class<UIDataStore>> PlayerDataStoreClasses;
var const array<PlayerDataStoreGroup> PlayerDataStores;

final function DebugDumpDataStoreInfo(bool bVerbose)
{
    local int DataStoreIndex, PlayerDataStoreIndex;
    local string PlayerName;
    local LocalPlayer PlayerOwner;
    local array<UIDataStore> PlayerGroupDataStores;
    
    LogInternal("GlobalDataStores: " $ string(GlobalDataStores.Length), 'DevDataStore');
    for (DataStoreIndex = 0; DataStoreIndex < GlobalDataStores.Length; DataStoreIndex++)
    {
        LogInternal("\tGlobalDataStore[" $ string(DataStoreIndex) $ "]:" @ string(GlobalDataStores[DataStoreIndex].Tag) @ "(" $ string(GlobalDataStores[DataStoreIndex]) $ ")", 'DevDataStore');
    }
    LogInternal("");
    LogInternal("Player data store groups:" $ string(PlayerDataStores.Length), 'DevDataStore');
    for (DataStoreIndex = 0; DataStoreIndex < PlayerDataStores.Length; DataStoreIndex++)
    {
        PlayerOwner = PlayerDataStores[DataStoreIndex].PlayerOwner;
        PlayerGroupDataStores = PlayerDataStores[DataStoreIndex].DataStores;
        PlayerName = (PlayerOwner != none && PlayerOwner.Actor != none && PlayerOwner.Actor.PlayerReplicationInfo != none ? PlayerOwner.Actor.PlayerReplicationInfo.PlayerName : "None");
        LogInternal("\tPlayerDataStores for player " $ string(DataStoreIndex) $ ":" @ string(PlayerGroupDataStores.Length) @ "(" $ PlayerName @ "-" @ string(PlayerOwner) $ ")", 'DevDataStore');
        for (PlayerDataStoreIndex = 0; PlayerDataStoreIndex < PlayerGroupDataStores.Length; PlayerDataStoreIndex++)
        {
            LogInternal("\t\tPlayerDataStore[" $ string(PlayerDataStoreIndex) $ "]:" @ string(PlayerGroupDataStores[PlayerDataStoreIndex].Tag) @ "(" $ string(PlayerGroupDataStores[PlayerDataStoreIndex]) $ ")", 'DevDataStore');
        }
    }
}

final event NotifyGameSessionEnded()
{
    local int I, DataStoreIndex;
    local array<UIDataStore> DataStoreArray;
    
    DataStoreArray = GlobalDataStores;
    for (DataStoreIndex = 0; DataStoreIndex < DataStoreArray.Length; DataStoreIndex++)
    {
        if (DataStoreArray[DataStoreIndex].NotifyGameSessionEnded())
        {
            UnregisterDataStore(DataStoreArray[DataStoreIndex]);
        }
    }
    for (I = PlayerDataStores.Length - 1; I >= 0; I--)
    {
        DataStoreArray = PlayerDataStores[I].DataStores;
        for (DataStoreIndex = 0; DataStoreIndex < DataStoreArray.Length; DataStoreIndex++)
        {
            DataStoreArray[DataStoreIndex].NotifyGameSessionEnded();
            UnregisterDataStore(DataStoreArray[DataStoreIndex]);
        }
    }
}

final function class<UIDataStore> FindDataStoreClass(class<UIDataStore> RequiredMetaClass)
{
    local int I;
    local class<UIDataStore> Result;
    
    for (I = 0; I < GlobalDataStores.Length; I++)
    {
        if (GlobalDataStores[I].IsA(RequiredMetaClass.Name))
        {
            Result = GlobalDataStores[I].Class;
            break;
        }
    }
    if (Result == none)
    {
        for (I = 0; I < PlayerDataStoreClasses.Length; I++)
        {
            if (ClassIsChildOf(PlayerDataStoreClasses[I], RequiredMetaClass))
            {
                Result = PlayerDataStoreClasses[I];
                break;
            }
        }
    }
    return Result;
}

final function GetPlayerDataStoreClasses(out array<class<UIDataStore>> out_DataStoreClasses)
{
    out_DataStoreClasses = PlayerDataStoreClasses;
}

native final function int FindPlayerDataStoreIndex(LocalPlayer PlayerOwner)
{
    PlayerOwner;
}

native final function GetAvailableDataStores(UIScene CurrentScene, out array<UIDataStore> out_DataStores)
{
    CurrentScene;
    out_DataStores;
}

native final function bool UnregisterDataStore(UIDataStore DataStore)
{
    DataStore;
}

native final function bool RegisterDataStore(UIDataStore DataStore, optional LocalPlayer PlayerOwner)
{
    DataStore;
    PlayerOwner;
}

native final function UIDataStore CreateDataStore(class<UIDataStore> DataStoreClass)
{
    DataStoreClass;
}

native final function UIDataStore FindDataStore(name DataStoreTag, optional LocalPlayer PlayerOwner)
{
    DataStoreTag;
    PlayerOwner;
}

defaultproperties
{
    GlobalDataStoreClasses(0)="Engine.UIDataStore_Strings"
    GlobalDataStoreClasses(1)="Engine.UIDataStore_Images"
    GlobalDataStoreClasses(2)="Engine.UIDataStore_GameResource"
    GlobalDataStoreClasses(3)="Engine.CurrentGameDataStore"
    GlobalDataStoreClasses(4)="Engine.UIDataStore_Fonts"
    GlobalDataStoreClasses(5)="Engine.UIDataStore_Color"
    GlobalDataStoreClasses(6)="Engine.UIDataStore_Gamma"
    GlobalDataStoreClasses(7)="Engine.UIDataStore_Registry"
    GlobalDataStoreClasses(8)="Engine.UIDataStore_InputAlias"
    PlayerDataStoreClassNames(0)="Engine.PlayerOwnerDataStore"
}
