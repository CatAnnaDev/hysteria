class LocalMessage extends Object
    abstract
    notplaceable;

var bool bIsSpecial;
var bool bIsUnique;
var bool bIsPartiallyUnique;
var bool bIsConsoleMessage;
var bool bBeep;
var bool bCountInstances;
var float Lifetime;
var Color DrawColor;
var float PosY;
var int FontSize;

static function bool PartiallyDuplicates(int Switch1, int Switch2, Object OptionalObject1, Object OptionalObject2)
{
    return Switch1 == Switch2;
}

static function bool IsKeyObjectiveMessage(int Switch)
{
    return false;
}

static function bool IsConsoleMessage(int Switch)
{
    return default.bIsConsoleMessage;
}

static function float GetLifeTime(int Switch)
{
    return default.Lifetime;
}

static function int GetFontSize(int Switch, PlayerReplicationInfo RelatedPRI1, PlayerReplicationInfo RelatedPRI2, PlayerReplicationInfo LocalPlayer)
{
    return default.FontSize;
}

static function float GetPos(int Switch, HUD myHUD)
{
    return default.PosY;
}

static function Color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    return default.DrawColor;
}

static function Color GetConsoleColor(PlayerReplicationInfo RelatedPRI_1)
{
    return default.DrawColor;
}

static function string GetString(optional int Switch, optional bool bPRI1HUD, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    if (class<Actor>(OptionalObject) != none)
    {
        return class<Actor>(OptionalObject).static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
    }
    return "";
}

static function ClientReceive(PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string MessageString;
    
    MessageString = GetString(Switch, RelatedPRI_1 == P.PlayerReplicationInfo, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    if (MessageString != "")
    {
        if (P.myHUD != none)
        {
            P.myHUD.LocalizedMessage(default.Class, RelatedPRI_1, MessageString, Switch, GetPos(Switch, P.myHUD), GetLifeTime(Switch), GetFontSize(Switch, RelatedPRI_1, RelatedPRI_2, P.PlayerReplicationInfo), GetColor(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject), OptionalObject);
        }
        if (IsConsoleMessage(Switch) && LocalPlayer(P.Player) != none && LocalPlayer(P.Player).ViewportClient != none)
        {
            LocalPlayer(P.Player).ViewportClient.ViewportConsole.OutputText(MessageString);
        }
    }
}

defaultproperties
{
    bIsSpecial=True
    bIsConsoleMessage=True
    Lifetime=3.0
    DrawColor=(B=255,G=255,R=255,A=255)
    PosY=0.83
}
