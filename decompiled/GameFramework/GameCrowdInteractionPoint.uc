class GameCrowdInteractionPoint extends Actor
    abstract
    native
    placeable
    hidecategories(Navigation,Advanced,Collision,Display,Actor,Movement,Physics);

var() repretry bool bIsEnabled;
var() export editinline CylinderComponent CylinderComponent;

replication
{
    if (bNoDelete)
        bIsEnabled;
}

function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bIsEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bIsEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bIsEnabled = !bIsEnabled;
    }
    ForceNetRelevant();
}

defaultproperties
{
    bIsEnabled=True
    CylinderComponent="Default__GameCrowdInteractionPoint.CollisionCylinder"
    bNoDelete=True
    Components(0)="Default__GameCrowdInteractionPoint.CollisionCylinder"
    Components(1)="Default__GameCrowdInteractionPoint.Sprite"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
    CollisionComponent="Default__GameCrowdInteractionPoint.CollisionCylinder"
}
