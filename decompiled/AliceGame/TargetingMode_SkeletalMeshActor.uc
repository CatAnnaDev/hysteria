class TargetingMode_SkeletalMeshActor extends TargetingModeBase
    notplaceable
    hidecategories(Navigation);

var transient SkeletalMeshActorLockOnInfo LockOnInfo;
var transient array<SkeletalMeshActorLockOnInfo> SMAsToBeTargeted;
var transient array<SkeletalMeshActorLockOnInfo> SMAsToBeTargetedSortedByAngle;

simulated function SetAPCTargetingInfo()
{
    if (TargetingActor != APC.TargetingActor)
    {
        APC.TargetingActor = TargetingActor;
    }
    APC.TargetSMAInfo = LockOnInfo;
}

simulated function FindAvailableTargets(Vector vCenterOfSearch, float fRadius, float fZDiff, bool bUpdateTargetingActor)
{
    local DoomBarrierActor A;
    local SkeletalMeshActorLockOnInfo Info;
    local Vector vPlayerFacing, vTarget, CamLoc;
    local Rotator CamRot;
    local bool bSeenByGD;
    local array<float> Angles;
    local float dis, dis1, fAngle;
    local int I, J;
    
    SMAsToBeTargeted.Length = 0;
    SMAsToBeTargetedSortedByAngle.Length = 0;
    foreach DynamicActors(class'DoomBarrierActor', A)
    {
        if (!PlayerPawn.bEnableTargetOnDestroyedActor && !A.IsAliveAndWell())
        {
            break;
        }
        bSeenByGD = (APC.MyAlicePawn.bLockOnFromCamera ? AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(A.Location, APC.MyAlicePawn.FOVScale) : true);
        if (!bSeenByGD)
        {
            break;
        }
        dis = VSize2D(vCenterOfSearch - A.CollisionSocketLoc);
        if (dis > fRadius || Abs(vCenterOfSearch.Z - A.CollisionSocketLoc.Z) > fZDiff)
        {
            break;
        }
        Info.Actor = A;
        if (A.bHaveUISocket)
        {
            Info.UILockOnLoc = A.UISockectLoc;
            Info.UILockOnRot = A.UISockectRot;
        }
        if (A.bHaveCollisionSocket)
        {
            Info.CollisionLockOnLoc = A.CollisionSocketLoc;
            Info.CollisionLockOnRot = A.CollisionSocketRot;
        }
        if (A.bHaveCameraSocket)
        {
            Info.CameraLockOnLoc = A.CameraSocketLoc;
            Info.CameraLockOnRot = A.CameraSocketRot;
        }
        SMAsToBeTargeted.AddItem(Info);
    }
    if (SMAsToBeTargeted.Length == 0)
    {
        LockOnInfo.Actor = none;
        TargetingActor = none;
        return;
    }
    for (I = 0; I < SMAsToBeTargeted.Length - 1; I++)
    {
        for (J = I + 1; J < SMAsToBeTargeted.Length; J++)
        {
            dis = VSize2D(SMAsToBeTargeted[I].CollisionLockOnLoc - PlayerPawn.Location);
            dis1 = VSize2D(SMAsToBeTargeted[J].CollisionLockOnLoc - PlayerPawn.Location);
            if (dis > dis1)
            {
                Info = SMAsToBeTargeted[I];
                SMAsToBeTargeted[I] = SMAsToBeTargeted[J];
                SMAsToBeTargeted[J] = Info;
            }
        }
    }
    Angles.Length = 0;
    APC.GetPlayerViewPoint(CamLoc, CamRot);
    for (I = 0; I < SMAsToBeTargeted.Length; I++)
    {
        vTarget = SMAsToBeTargeted[I].CollisionLockOnLoc - CamLoc;
        vPlayerFacing = vector(CamRot);
        fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
        if (Abs(fAngle) < PlayerPawn.LockConeAngle / 180.0 * 3.1415927 && !APC.MyAlicePawn.IsLockOnBlocked(SMAsToBeTargeted[I].CollisionLockOnLoc))
        {
            SMAsToBeTargetedSortedByAngle.AddItem(SMAsToBeTargeted[I]);
            Angles.AddItem(fAngle);
        }
    }
    for (I = 0; I < SMAsToBeTargetedSortedByAngle.Length - 1; I++)
    {
        for (J = I + 1; J < SMAsToBeTargetedSortedByAngle.Length; J++)
        {
            if (Angles[I] > Angles[J])
            {
                Info = SMAsToBeTargetedSortedByAngle[I];
                SMAsToBeTargetedSortedByAngle[I] = SMAsToBeTargetedSortedByAngle[J];
                SMAsToBeTargetedSortedByAngle[J] = Info;
                fAngle = Angles[I];
                Angles[I] = Angles[J];
                Angles[J] = fAngle;
            }
        }
    }
    if (bUpdateTargetingActor && LockOnInfo.Actor == none || LockOnInfo.Actor != APC.TargetSMAInfo.Actor)
    {
        LockOnInfo = SMAsToBeTargeted[0];
        TargetingActor = LockOnInfo.Actor;
    }
}

simulated function PostLockOff()
{
    APC.TargetSMAInfo.Actor = none;
    ResetDefaultTransientVariables();
}

simulated function PostLockOn()
{
    if (!APC.IsInState('PlayerLockOnTarget'))
    {
        APC.GotoState('PlayerLockOnTarget');
    }
}

simulated function ResetDefaultTransientVariables()
{
    SMAsToBeTargeted.Length = 0;
    SMAsToBeTargetedSortedByAngle.Length = 0;
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
}
