class SeqVar_Player extends SeqVar_Object
    native
    notplaceable
    hidecategories(Object);

var transient array<Object> Players;
var() bool bAllPlayers;
var() int PlayerIdx;

function Object GetObjectValue()
{
    local Controller C;
    
    UpdatePlayersList();
    if (Players.Length > 0)
    {
        if (bAllPlayers || PlayerIdx < 0 || PlayerIdx >= Players.Length)
        {
            C = Controller(Players[0]);
        }
        else
        {
            C = Controller(Players[PlayerIdx]);
        }
    }
    return C != none && C.Pawn != none ? C.Pawn : C;
}

native final function UpdatePlayersList()
{
}

defaultproperties
{
    bAllPlayers=True
    SupportedClasses(0)="Controller"
    SupportedClasses(1)="Pawn"
    ObjName="Player"
    ObjCategory="Player"
}
