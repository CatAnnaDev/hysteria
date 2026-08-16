class LadderVolume extends ClimbableVolume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var const Ladder LadderList;
var() bool bNoPhysicalLadder;
var() bool bAutoPath;
var() bool bAllowLadderStrafing;
var Pawn PendingClimber;
var export editinline ArrowComponent WallDirArrow;

simulated event PhysicsChangedFor(Actor Other)
{
    if (Other.Physics == 2 || Other.Physics == 9 || Other.bDeleteMe || Pawn(Other) == none || Pawn(Other).Controller == none)
    {
        return;
    }
    Spawn(class'PotentialClimbWatcher', Other);
}

simulated event PawnLeavingVolume(Pawn P)
{
    local Controller C;
    
    if (P.OnLadder != self)
    {
        return;
    }
    PawnLeavingVolume(P);
    P.OnLadder = none;
    P.EndClimbLadder(self);
    if (P == PendingClimber)
    {
        PendingClimber = none;
    }
    if (!InUse(P))
    {
        foreach WorldInfo.AllControllers(class'Controller', C)
        {
            if (C.bPreparingMove && Ladder(C.MoveTarget) != none && Ladder(C.MoveTarget).MyLadder == self)
            {
                C.bPreparingMove = false;
                PendingClimber = C.Pawn;
                return;
            }
        }
    }
}

simulated event PawnEnteredVolume(Pawn P)
{
    local Rotator PawnRot;
    
    PawnEnteredVolume(P);
    if (!P.CanGrabLadder())
    {
        return;
    }
    PawnRot = P.Rotation;
    PawnRot.Pitch = 0;
    if (vector(PawnRot) Dot LookDir > 0.9 || AIController(P.Controller) != none && Ladder(P.Controller.MoveTarget) != none)
    {
        P.ClimbLadder(self);
    }
    else if (!P.bDeleteMe && P.Controller != none)
    {
        Spawn(class'PotentialClimbWatcher', P);
    }
}

function bool InUse(Pawn Ignored)
{
    local Pawn StillClimbing;
    
    foreach TouchingActors(class'Pawn', StillClimbing)
    {
        if (StillClimbing != Ignored && StillClimbing.bCollideActors && StillClimbing.bBlockActors)
        {
            return true;
        }
    }
    if (PendingClimber != none)
    {
        if (PendingClimber.Controller == none || !PendingClimber.bCollideActors || !PendingClimber.bBlockActors || Ladder(PendingClimber.Controller.MoveTarget) == none || Ladder(PendingClimber.Controller.MoveTarget).MyLadder != self)
        {
            PendingClimber = none;
        }
    }
    return PendingClimber != none && PendingClimber != Ignored;
}

simulated event PostBeginPlay()
{
    local Ladder L, M;
    local Vector Dir;
    
    PostBeginPlay();
    LookDir = vector(WallDir);
    if (!bAutoPath && LookDir.Z != float(0))
    {
        ClimbDir = vect(0.0, 0.0, 1.0);
        L = LadderList;
        while (L != none)
        {
            M = LadderList;
            while (M != none)
            {
                if (M != L)
                {
                    Dir = Normal(M.Location - L.Location);
                    if (Dir Dot ClimbDir < float(0))
                    {
                        Dir *= float(-1);
                    }
                    ClimbDir += Dir;
                }
                M = M.LadderList;
            }
            L = L.LadderList;
        }
        ClimbDir = Normal(ClimbDir);
        if (ClimbDir Dot vect(0.0, 0.0, 1.0) < float(0))
        {
            ClimbDir *= float(-1);
        }
    }
}

defaultproperties
{
    bAutoPath=True
    bAllowLadderStrafing=True
    WallDirArrow="Default__LadderVolume.Arrow"
    ClimbDir=(X=0.0,Y=0.0,Z=1.0)
    BrushComponent="Default__LadderVolume.BrushComponent0"
    Components(0)="Default__LadderVolume.BrushComponent0"
    Components(1)="Default__LadderVolume.Arrow"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionComponent="Default__LadderVolume.BrushComponent0"
}
