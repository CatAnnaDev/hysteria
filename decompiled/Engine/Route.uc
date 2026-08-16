class Route extends Info
    native
    placeable
    hidecategories(Navigation,Movement,Collision)
    implements(EditorLinkSelectionInterface);

enum ERouteType
{
    ERT_Linear,
    ERT_Loop,
    ERT_Circle,
};

enum ERouteDirection
{
    ERD_Forward,
    ERD_Reverse,
};

enum ERouteFillAction
{
    RFA_Overwrite,
    RFA_Add,
    RFA_Remove,
    RFA_Clear,
};

var const native noexport Pointer VfTable_IEditorLinkSelectionInterface;
var() ERouteType RouteType;
var() array<ActorReference> RouteList;
var() float FudgeFactor;

native final function int MoveOntoRoutePath(Pawn P, optional ERouteDirection RouteDirection = 0, optional float DistFudgeFactor = 1.0)
{
    P;
    RouteDirection;
    DistFudgeFactor;
}

native final function int ResolveRouteIndex(int Idx, ERouteDirection RouteDirection, out byte out_bComplete, out byte out_bReverse)
{
    Idx;
    RouteDirection;
    out_bComplete;
    out_bReverse;
}

defaultproperties
{
    FudgeFactor=1.0
    bStatic=True
    Components(0)="Default__Route.Sprite"
    Components(1)="Default__Route.Sprite"
    Components(2)="Default__Route.RouteRenderer"
}
