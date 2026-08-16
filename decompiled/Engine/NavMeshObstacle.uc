class NavMeshObstacle extends Actor
    native
    placeable
    hidecategories(Navigation)
    implements(Interface_NavMeshPathObstacle);

var const native noexport Pointer VfTable_IInterface_NavMeshPathObstacle;
var() bool bEnabled;
var() bool bPreserveInternalGeo;

function SetEnabled(bool bInEnabled)
{
    if (bInEnabled)
    {
        RegisterObstacle();
    }
    else
    {
        UnRegisterObstacle();
    }
}

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
    SetEnabled(bEnabled);
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    if (bEnabled)
    {
        RegisterObstacle();
    }
}

native function UnRegisterObstacle()
{
}

native function RegisterObstacle()
{
}

defaultproperties
{
    Components(0)="Default__NavMeshObstacle.Sprite"
    Components(1)="Default__NavMeshObstacle.DrawBox0"
    CollisionType="COLLIDE_CustomDefault"
}
