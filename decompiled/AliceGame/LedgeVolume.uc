class LedgeVolume extends ClimbableVolume
    native
    placeable
    hidecategories(Navigation,Object,Display);

enum ELedgeVolumeType
{
    ELVT_Ledge,
    ELVT_BalanceBeam,
    ELVT_Ladder,
    ELVT_WallEdge,
};

var() ELedgeVolumeType VolumeType;
var() LedgeVolume NextLedge;
var() LedgeVolume PrevLedge;
var() LedgeVolume LeftLedgeToJump;
var() LedgeVolume RightLedgeToJump;
var() bool bCanBeClimbedUp;
var() bool bDynamicVolume;
var(Info) Vector UpDir;
var(Info) float Length;
var(Info) float Width;
var(Info) float Height;
var(Info) Vector RefLoc;
var(Info) Vector LeftEnd;
var(Info) Vector RightEnd;
var(Info) Vector TopEnd;
var(Info) Vector BottomEnd;
var(Info) Vector OffsetBetweenRefLocAndLocation;
var Vector DynamicVolumeSpeed;

simulated event PawnLeavingVolume(Pawn P)
{
    if (AliceGamePawn(P) == none || AliceGamePawn(P).OnLedge != self)
    {
        return;
    }
    PawnLeavingVolume(P);
    AliceGamePawn(P).OnLedge = none;
    AliceGamePawn(P).EndClimbEdge(self);
}

simulated event PawnEnteredVolume(Pawn P)
{
    PawnEnteredVolume(P);
    if (AliceGamePawn(P) == none || AlicePawn(P).bShrinkingModeActive)
    {
        return;
    }
    AliceGamePawn(P).ClimbEdge(self);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

native function GetClosestEnd(Vector Position, out Vector EndPos, out Rotator EndRot, float Radius)
{
    Position;
    EndPos;
    EndRot;
    Radius;
}

defaultproperties
{
    bPhysicsOnContact=True
    BrushComponent="Default__LedgeVolume.BrushComponent0"
    bHardAttach=True
    bGameRelevant=True
    Components(0)="Default__LedgeVolume.BrushComponent0"
    Components(1)="Default__LedgeVolume.Arrow"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionComponent="Default__LedgeVolume.BrushComponent0"
}
