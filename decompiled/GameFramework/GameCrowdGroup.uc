class GameCrowdGroup extends Object
    native
    notplaceable;

var array<GameCrowdAgent> Members;

function UpdateDestinations(GameCrowdDestination NewDestination)
{
    local int I;
    
    for (I = 0; I < Members.Length; I++)
    {
        if (Members[I] != none && Members[I].CurrentDestination != NewDestination)
        {
            Members[I].SetCurrentDestination(NewDestination);
            Members[I].UpdateIntermediatePoint();
        }
    }
}

function RemoveMember(GameCrowdAgent Agent)
{
    Members.RemoveItem(Agent);
    Agent.MyGroup = none;
}

function AddMember(GameCrowdAgent Agent)
{
    Members[Members.Length] = Agent;
    Agent.MyGroup = self;
}

defaultproperties
{
}
