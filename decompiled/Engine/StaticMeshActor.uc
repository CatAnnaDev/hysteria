class StaticMeshActor extends StaticMeshActorBase
    native
    placeable
    hidecategories(Navigation);

var() const export editconst editinline StaticMeshComponent StaticMeshComponent;
var() editoronly bool bDisableAutoBaseOnProcBuilding;

event PreBeginPlay()
{
    if (!(bLoadIfPhysXLevel0 && bLoadIfPhysXLevel1 && bLoadIfPhysXLevel2))
    {
        if (!WorldInfo.Game.CheckRelevance(self))
        {
            SetHidden(true);
            SetCollisionType(1);
        }
    }
}

defaultproperties
{
    StaticMeshComponent="Default__StaticMeshActor.StaticMeshComponent0"
    Components(0)="Default__StaticMeshActor.StaticMeshComponent0"
    CollisionComponent="Default__StaticMeshActor.StaticMeshComponent0"
}
