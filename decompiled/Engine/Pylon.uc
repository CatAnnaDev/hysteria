class Pylon extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force,Lighting,LightColor,Force)
    implements(EditorLinkSelectionInterface);

enum ENavMeshEdgeType
{
    NAVEDGE_Normal,
    NAVEDGE_Mantle,
    NAVEDGE_Coverslip,
    NAVEDGE_SwatTurn,
    NAVEDGE_DropDown,
    NAVEDGE_PathObject,
    NAVEDGE_Jump,
};

struct native immutable PolyReference
{
    var ActorReference OwningPylon;
    var int PolyId;
};

var const native noexport Pointer VfTable_IEditorLinkSelectionInterface;
var const native Pointer NavMeshPtr;
var const native Pointer ObstacleMesh;
var const native Pointer DynamicObstacleMesh;
var const native transient Pointer WorkingSetPtr;
var const native transient Pointer PathObjectsThatAffectThisPylon;
var const transient array<Vector> NextPassSeedList;
var const native OctreeElementId OctreeId;
var const native Pointer OctreeIWasAddedTo;
var const Pylon NextPylon;
var(MeshGeneration) array<Volume> ExpansionVolumes;
var(MeshGeneration) float ExpansionRadius;
var const float MaxExpansionRadius;
var export editinline DrawPylonRadiusComponent PylonRadiusPreview;
var bool bImportedMesh;
var bool bUseExpansionSphereOverride;
var bool bNeedsCostCheck;
var(Debug) bool bDrawEdgePolys;
var(Debug) bool bDrawPolyBounds;
var(Display) bool bRenderInShowPaths;
var(Display) bool bDrawWalkableSurface;
var(Display) bool bDrawObstacleSurface;
var transient bool bBuildThisPylon;
var bool bDisabled;
var bool bForceObstacleMeshCollision;
var Vector ExpansionSphereCenter;
var export editinline NavMeshRenderingComponent RenderingComp;
var const transient export editinline SpriteComponent BrokenSprite;
var(Debug) int DebugEdgeCount;

native function bool CanReachPylon(Pylon DestPylon, Controller C)
{
    DestPylon;
    C;
}

function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SetEnabled(true);
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        SetEnabled(false);
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        SetEnabled(!IsEnabled());
    }
}

event bool IsEnabled()
{
    return !bDisabled;
}

event SetEnabled(bool bEnabled)
{
    bDisabled = !bEnabled;
    bForceObstacleMeshCollision = bDisabled;
}

defaultproperties
{
    ExpansionRadius=2048.0
    MaxExpansionRadius=7168.0
    PylonRadiusPreview="Default__Pylon.DrawPylonRadius0"
    bRenderInShowPaths=True
    bDrawWalkableSurface=True
    bDrawObstacleSurface=True
    RenderingComp="Default__Pylon.NavMeshRenderer"
    BrokenSprite="Default__Pylon.Sprite3"
    DebugEdgeCount=-1
    bDestinationOnly=True
    CylinderComponent="Default__Pylon.CollisionCylinder"
    GoodSprite="Default__Pylon.Sprite"
    BadSprite="Default__Pylon.Sprite2"
    Components(0)="Default__Pylon.Sprite"
    Components(1)="Default__Pylon.Sprite2"
    Components(2)="Default__Pylon.Arrow"
    Components(3)="Default__Pylon.CollisionCylinder"
    Components(4)="Default__Pylon.PathRenderer"
    Components(5)="Default__Pylon.NavMeshRenderer"
    Components(6)="Default__Pylon.DrawPylonRadius0"
    Components(7)="Default__Pylon.Sprite3"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Pylon.CollisionCylinder"
}
