class TargetingMode_BreakableActor extends TargetingModeBase
    notplaceable
    hidecategories(Navigation);

var transient BreakableActorLockOnInfo LockOnInfo;
var transient array<BreakableActorLockOnInfo> BAsToBeTargeted;
var transient array<BreakableActorLockOnInfo> BAsToBeTargetedSortedByAngle;

function MakeDebugColors(out array<Color> Colors)
{
    local Color _color;
    
    Colors.Length = 0;
    _color.R = 255;
    _color.G = 0;
    _color.B = 0;
    Colors.AddItem(_color);
    _color.R = 255;
    _color.G = 128;
    _color.B = 0;
    Colors.AddItem(_color);
    _color.R = 255;
    _color.G = 255;
    _color.B = 0;
    Colors.AddItem(_color);
    _color.R = 0;
    _color.G = 255;
    _color.B = 0;
    Colors.AddItem(_color);
    _color.R = 0;
    _color.G = 128;
    _color.B = 255;
    Colors.AddItem(_color);
    _color.R = 0;
    _color.G = 0;
    _color.B = 255;
    Colors.AddItem(_color);
    _color.R = 128;
    _color.G = 0;
    _color.B = 255;
    Colors.AddItem(_color);
}

function showDebugInfo(array<BreakableActorLockOnInfo> Infos)
{
    local int I;
    local Vector vStart, vEnd;
    local array<Color> Colors;
    
    MakeDebugColors(Colors);
    for (I = 0; I < Infos.Length; I++)
    {
        if (Infos[I].BActor == none)
        {
            continue;
        }
        vStart = Infos[I].vLocation;
        vEnd = vStart + vect(0.0, 0.0, 250.0);
        if (I < Colors.Length)
        {
            DrawDebugLine(vStart, vEnd, Colors[I].R, Colors[I].G, Colors[I].B);
            continue;
        }
        DrawDebugLine(vStart, vEnd, 0, 0, 0);
    }
}

simulated function PostLockOff()
{
    local GameBreakableActor BActor;
    
    BActor = GameBreakableActor(APC.TargetingActor);
    if (BActor != none)
    {
        BActor.OnNotLockedOn();
    }
    APC.TargetBActorInfo.BActor = none;
    TargetingActor = none;
    BAsToBeTargetedSortedByAngle.Length = 0;
}

simulated function PostLockOn()
{
    local GameBreakableActor BActor;
    
    BActor = GameBreakableActor(APC.TargetingActor);
    if (BActor != none)
    {
        BActor.OnLockedOn();
        if (APC.TargetBActorInfo.BActor == BActor)
        {
            if (!APC.IsInState('PlayerLockOnTarget'))
            {
                APC.GotoState('PlayerLockOnTarget');
            }
        }
    }
}

function BreakableActorLockOnInfo GetCurrentStepInfo(GameBreakableActor BActor)
{
    local BreakableActorLockOnInfo Info;
    local BreakableStep BAStep;
    
    if (BActor == none || BActor.BreakableSteps.Length < 1)
    {
        Info.BActor = none;
        return Info;
    }
    BAStep = BActor.BreakableSteps[BActor.CurrentBreakableStep];
    Info.BActor = BActor;
    Info.bIsLockable = BAStep.bIsLockable;
    Info.iPriority = BAStep.iPriority;
    Info.LockOffsetCamera = BAStep.LockOffsetCamera;
    Info.LockOffsetUI = BAStep.LockOffsetUI;
    Info.vLocation = BActor.StaticMeshComponent.Bounds.Origin;
    return Info;
}

simulated function SwitchTargetingActor(bool bLeft)
{
    local int I, Index;
    
    if (!bInitialized || !bActive)
    {
        return;
    }
    if (BAsToBeTargetedSortedByAngle.Length <= 1)
    {
        return;
    }
    Index = -1;
    for (I = 0; I < BAsToBeTargetedSortedByAngle.Length; I++)
    {
        if (BAsToBeTargetedSortedByAngle[I].BActor == LockOnInfo.BActor)
        {
            Index = I;
            break;
        }
    }
    if (Index == -1)
    {
        return;
    }
    if (bLeft)
    {
        Index--;
    }
    else
    {
        Index++;
    }
    if (Index < 0 || Index >= BAsToBeTargetedSortedByAngle.Length)
    {
        return;
    }
    LockOnInfo = BAsToBeTargetedSortedByAngle[Index];
    TargetingActor = LockOnInfo.BActor;
}

simulated function SetAPCTargetingInfo()
{
    if (TargetingActor != APC.TargetingActor)
    {
        if (APC.bTargetingModeActive)
        {
            if (APC.TargetingActor != none)
            {
                GameBreakableActor(APC.TargetingActor).OnNotLockedOn();
            }
            GameBreakableActor(TargetingActor).OnLockedOn();
        }
        APC.TargetingActor = TargetingActor;
    }
    APC.TargetBActorInfo = LockOnInfo;
}

simulated function FindAvailableTargets(Vector vCenterOfSearch, float fRadius, float fZDiff, bool bUpdateTargetingActor)
{
    local BreakableActorLockOnInfo BActorInfo, AWithMinDist, A, B;
    local GameBreakableActor BreakActor;
    local float MinDist, curDist, nextDist;
    local bool bSeenByGD;
    local int I, J, T;
    local Vector vPlayerFacing, vTarget, CamLoc;
    local Rotator CamRot;
    local array<float> Angles;
    local float fAngle;
    local bool bDestroyed;
    
    MinDist = fRadius;
    BAsToBeTargeted.Length = 0;
    BAsToBeTargetedSortedByAngle.Length = 0;
    foreach DynamicActors(class'GameBreakableActor', BreakActor)
    {
        BreakActor.APC = APC;
        BActorInfo = GetCurrentStepInfo(BreakActor);
        bSeenByGD = (APC.MyAlicePawn.bLockOnFromCamera ? IsInValidRange(BActorInfo.vLocation) : true);
        bDestroyed = (PlayerPawn.bEnableTargetOnDestroyedActor ? false : BActorInfo.BActor.bHidden);
        if (BActorInfo.BActor != none && !bDestroyed && BActorInfo.bIsLockable && bSeenByGD)
        {
            if (!PlayerPawn.bEnableTargetOnDestroyedActor && BActorInfo.BActor.bPendingDestroySelf)
            {
                break;
            }
            if (BActorInfo.BActor.bHidden)
            {
                break;
            }
            if (PlayerPawn.bEnableTargetOnDestroyedActor)
            {
                if (!APC.bTargetingModeActive && BActorInfo.BActor.bPendingDestroySelf)
                {
                    break;
                }
                if (APC.bTargetingModeActive && BActorInfo.BActor != TargetingActor && BActorInfo.BActor.bPendingDestroySelf)
                {
                    break;
                }
            }
            curDist = VSize2D(vCenterOfSearch - BActorInfo.vLocation);
            if (curDist < fRadius && Abs(vCenterOfSearch.Z - BActorInfo.vLocation.Z) < fZDiff)
            {
                BAsToBeTargeted.AddItem(BActorInfo);
                if (MinDist > curDist)
                {
                    AWithMinDist = BActorInfo;
                    MinDist = curDist;
                }
                if (!APC.bTargetingModeActive || APC.TargetingActor == none || !APC.TargetingActor.IsA('GameBreakableActor') || BreakActor == APC.TargetingActor)
                {
                    UpdateAPCTargetLocation(BActorInfo.vLocation, BActorInfo.LockOffsetCamera, BActorInfo.LockOffsetUI);
                }
            }
        }
    }
    if (BAsToBeTargeted.Length == 0)
    {
        TargetingActor = none;
        return;
    }
    for (I = 0; I < BAsToBeTargeted.Length; I++)
    {
        T = BAsToBeTargeted.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            A = BAsToBeTargeted[J];
            curDist = VSize2D(PlayerPawn.Location - A.vLocation);
            B = BAsToBeTargeted[J + 1];
            nextDist = VSize2D(PlayerPawn.Location - B.vLocation);
            if (curDist > nextDist)
            {
                BAsToBeTargeted[J] = BAsToBeTargeted[J + 1];
                BAsToBeTargeted[J + 1] = A;
            }
        }
    }
    APC.GetPlayerViewPoint(CamLoc, CamRot);
    vPlayerFacing = vector(CamRot);
    vPlayerFacing = Normal(vPlayerFacing);
    Angles.Length = 0;
    for (I = 0; I < BAsToBeTargeted.Length; I++)
    {
        vTarget = BAsToBeTargeted[I].vLocation - CamLoc;
        vTarget = Normal(vTarget);
        fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
        if (Abs(fAngle) < PlayerPawn.LockConeAngle / 180.0 * 3.1415927 && !APC.MyAlicePawn.IsLockOnBlocked(BAsToBeTargeted[I].vLocation))
        {
            BAsToBeTargetedSortedByAngle.AddItem(BAsToBeTargeted[I]);
            Angles.AddItem(fAngle);
        }
    }
    for (I = 0; I < BAsToBeTargetedSortedByAngle.Length; I++)
    {
        T = BAsToBeTargetedSortedByAngle.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            if (Angles[J] > Angles[J + 1])
            {
                A = BAsToBeTargetedSortedByAngle[J];
                BAsToBeTargetedSortedByAngle[J] = BAsToBeTargetedSortedByAngle[J + 1];
                BAsToBeTargetedSortedByAngle[J + 1] = A;
                fAngle = Angles[J];
                Angles[J] = Angles[J + 1];
                Angles[J + 1] = fAngle;
            }
        }
    }
    TargetingActor = AWithMinDist.BActor;
    LockOnInfo = AWithMinDist;
}

simulated function UpdateAPCTargetLocation(Vector newLockOnLoc, Vector newLockOffsetCamera, Vector newLockOffsetUI)
{
    APC.TargetBActorInfo.vLocation = newLockOnLoc;
    APC.TargetBActorInfo.LockOffsetCamera = newLockOffsetCamera;
    APC.TargetBActorInfo.LockOffsetUI = newLockOffsetUI;
}

function bool IsInValidRange(Vector BActorLocation)
{
    local AlicePawn aPawn;
    local Vector vTarget, vPlayerFacing;
    local float fAngle, angleThreshold;
    local bool bInSight, bInValidAngle;
    
    aPawn = AlicePawn(APC.Pawn);
    vPlayerFacing = vector(aPawn.Rotation);
    vTarget = BActorLocation - aPawn.Location;
    fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
    angleThreshold = aPawn.NonLockOnAutoTargetAngleRange * 0.017453292 * 0.5;
    bInSight = AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(BActorLocation, APC.MyAlicePawn.FOVScale);
    bInValidAngle = Abs(fAngle) < angleThreshold;
    return bInSight || bInValidAngle;
}

simulated function ResetDefaultTransientVariables()
{
    BAsToBeTargeted.Length = 0;
    BAsToBeTargetedSortedByAngle.Length = 0;
    TargetingActor = none;
}

simulated function LeavingMode()
{
    if (!bInitialized || !bActive)
    {
        return;
    }
    ResetDefaultTransientVariables();
    Deactivated();
}

simulated function EnteringMode()
{
    if (!bInitialized || bActive)
    {
        return;
    }
    if (APC == none)
    {
        bInitialized = false;
        bActive = false;
        return;
    }
    PlayerPawn = APC.MyAlicePawn;
    if (PlayerPawn == none)
    {
        return;
    }
    ResetDefaultTransientVariables();
    GetSearchConditionParameters();
    FindAvailableTargets(SearchCenter, SearchRadius, SearchZDiff, true);
    Activated();
}

defaultproperties
{
    SearchTargetType="GameBreakableActor"
}
