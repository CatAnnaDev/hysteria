class PlayerStart extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force,Collision);

var() bool bEnabled;
var() bool bPrimaryStart;
var() int TeamIndex;

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
}

defaultproperties
{
    bEnabled=True
    bPrimaryStart=True
    CylinderComponent="Default__PlayerStart.CollisionCylinder"
    GoodSprite="Default__PlayerStart.Sprite"
    BadSprite="Default__PlayerStart.Sprite2"
    bEdShouldSnap=True
    Components(0)="Default__PlayerStart.Sprite"
    Components(1)="Default__PlayerStart.Sprite2"
    Components(2)="Default__PlayerStart.Arrow"
    Components(3)="Default__PlayerStart.CollisionCylinder"
    Components(4)="Default__PlayerStart.PathRenderer"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__PlayerStart.CollisionCylinder"
}
