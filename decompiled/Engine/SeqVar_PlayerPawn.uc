class SeqVar_PlayerPawn extends SeqVar_Object
    native
    notplaceable
    hidecategories(Object);

var transient array<Object> Players;
var bool bAllPlayers;
var int PlayerIdx;

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
    return C != none && C.Pawn != none ? C.Pawn : none;
}

native final function UpdatePlayersList()
{
}

defaultproperties
{
    ObjName="PlayerPawn"
    ObjCategory="Alice"
}
