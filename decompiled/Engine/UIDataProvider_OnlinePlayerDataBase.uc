class UIDataProvider_OnlinePlayerDataBase extends UIDataProvider
    abstract
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var LocalPlayer Player;

event OnUnregister()
{
    Player = none;
}

event OnRegister(LocalPlayer InPlayer)
{
    Player = InPlayer;
}

defaultproperties
{
}
