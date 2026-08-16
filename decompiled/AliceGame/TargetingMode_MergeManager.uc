class TargetingMode_MergeManager extends Object
    notplaceable;

enum SwitchCommond
{
    ETSC_Up,
    ETSC_DOWN,
    ETSC_LEFT,
    ETSC_RIGHT,
};

var transient AlicePlayerController APC;

function ChooseByPotentialField(out const array<TargetingNPCInfo> NPCs, out const array<BreakableActorLockOnInfo> BActors, out const array<SkeletalMeshActorLockOnInfo> SMALockOnInfos)
{
    local int I, ChoosedSocketID;
    local Actor TargetActor;
    local float fPV, MinPV;
    local Vector NewCoorLoc;
    
    MinPV = 999999.0;
    for (I = 0; I < NPCs.Length; I++)
    {
        fPV = APC.MyAlicePawn.CalcPotentialValue(NPCs[I].CollisionSocketLocation, NewCoorLoc);
        if (IsValidePV(fPV) && fPV < MinPV)
        {
            TargetActor = NPCs[I].Pawn;
            ChoosedSocketID = NPCs[I].SocketIndex;
            MinPV = fPV;
        }
    }
    for (I = 0; I < BActors.Length; I++)
    {
        fPV = APC.MyAlicePawn.CalcPotentialValue(BActors[I].vLocation, NewCoorLoc);
        if (IsValidePV(fPV) && fPV < MinPV)
        {
            TargetActor = BActors[I].BActor;
            MinPV = fPV;
        }
    }
    for (I = 0; I < SMALockOnInfos.Length; I++)
    {
        fPV = APC.MyAlicePawn.CalcPotentialValue(SMALockOnInfos[I].CollisionLockOnLoc, NewCoorLoc);
        if (IsValidePV(fPV) && fPV < MinPV)
        {
            TargetActor = SMALockOnInfos[I].Actor;
            MinPV = fPV;
        }
    }
    if (TargetActor != none)
    {
        SelectTarget(TargetActor, ChoosedSocketID);
    }
    else
    {
        APC.ClearAllTargets();
    }
    return;
}

function bool ChooseRearTarget()
{
    local AliceGameKynapsePawn A, NearNPC;
    local GameBreakableActor BreakActor;
    local BreakableActorLockOnInfo BActorInfo, NearBActor;
    local TargetingNPCInfo TA;
    local float fDis, fMinDis, curSKDist, minSKDist, fMinDisBA;
    local int Sktidx;
    local bool bDestroyed, bNearNPC;
    
    if (!APC.MyAlicePawn.bEnableNoNPCInCamLocking)
    {
        return false;
    }
    fMinDis = 9999999.0;
    NearNPC = none;
    foreach APC.DynamicActors(class'AliceGameKynapsePawn', A)
    {
        if (!A.bHidden && A.bCanBeLockedOn && A.IsAliveAndWell() && isInTheRear(A.Location, A))
        {
            if (isTargetInCylinder(A.Location))
            {
                fDis = VSize(APC.MyAlicePawn.Location - A.Location);
                if (fDis < fMinDis)
                {
                    fMinDis = fDis;
                    NearNPC = A;
                }
            }
        }
    }
    fMinDisBA = 9999999.0;
    foreach APC.DynamicActors(class'GameBreakableActor', BreakActor)
    {
        BreakActor.APC = APC;
        BActorInfo = APC.TMode_BreakableActor.GetCurrentStepInfo(BreakActor);
        bDestroyed = (APC.MyAlicePawn.bEnableTargetOnDestroyedActor ? false : BActorInfo.BActor.bHidden);
        if (BActorInfo.BActor != none && !bDestroyed && BActorInfo.bIsLockable && !BActorInfo.BActor.bHidden && isInTheRear(BActorInfo.vLocation, BActorInfo.BActor))
        {
            if (!APC.MyAlicePawn.bEnableTargetOnDestroyedActor && BActorInfo.BActor.bPendingDestroySelf)
            {
                break;
            }
            if (isTargetInCylinder(BActorInfo.vLocation))
            {
                fDis = VSize(APC.MyAlicePawn.Location - BActorInfo.vLocation);
                if (fDis < fMinDisBA)
                {
                    fMinDisBA = fDis;
                    NearBActor = BActorInfo;
                }
            }
        }
    }
    if (NearBActor.BActor == none && NearNPC == none)
    {
        APC.ClearAllTargets();
        return false;
    }
    else if (NearBActor.BActor == none && NearNPC != none)
    {
        bNearNPC = true;
    }
    else if (NearBActor.BActor != none && NearNPC == none)
    {
        bNearNPC = false;
    }
    else
    {
        bNearNPC = fMinDisBA > fMinDis;
    }
    if (bNearNPC)
    {
        minSKDist = 9999999.0;
        TA.SocketIndex = -1;
        if (NearNPC.AnyLockableSocketaEnable())
        {
            for (Sktidx = 0; Sktidx < NearNPC.GetSocketNumber(); Sktidx++)
            {
                if (NearNPC.LockOnInfo.TargetSockets[Sktidx].bHideUI)
                {
                    continue;
                }
                if (NearNPC.LockOnInfo.TargetSockets[Sktidx].bEnable)
                {
                    curSKDist = VSize2D(APC.MyAlicePawn.Location - NearNPC.LockOnInfo.TargetSockets[Sktidx].CollisionLocation);
                    if (curSKDist < minSKDist)
                    {
                        TA.Pawn = NearNPC;
                        TA.SocketIndex = Sktidx;
                        if (NearNPC.IsAliveAndWell())
                        {
                            TA.CollisionSocketLocation = NearNPC.LockOnInfo.TargetSockets[Sktidx].CollisionLocation;
                            TA.CollisionSocketRotation = NearNPC.LockOnInfo.TargetSockets[Sktidx].CollisionRotation;
                            TA.LockOnSocketLocation = NearNPC.LockOnInfo.TargetSockets[Sktidx].LockOnLocation;
                            TA.LockOnSocketRotation = NearNPC.LockOnInfo.TargetSockets[Sktidx].LockOnRotation;
                            continue;
                        }
                        TA.CollisionSocketLocation = NearNPC.Location;
                        TA.CollisionSocketRotation = NearNPC.Rotation;
                        TA.LockOnSocketLocation = NearNPC.Location;
                        TA.LockOnSocketRotation = NearNPC.Rotation;
                    }
                }
            }
            if (TA.SocketIndex >= 0)
            {
                NotifyTargetWillChange(TA.Pawn, TA.SocketIndex);
                APC.TMode_CombatLockOn.TargetNPCSocket = TA;
                APC.TMode_CombatLockOn.TargetingActor = TA.Pawn;
                APC.TMode_CombatLockOn.SetAPCTargetingInfo();
                APC.TMode_CombatLockOn.PostLockOn();
                TA.Pawn.TriggerEventClass(class'SeqEvent_LockedOn', TA.Pawn, 0);
                APC.MyAlicePawn.OnSwitchLockOnTarget();
                return true;
            }
        }
    }
    else
    {
        NotifyTargetWillChange(NearBActor.BActor, 0);
        APC.TMode_BreakableActor.LockOnInfo = NearBActor;
        APC.TMode_BreakableActor.TargetingActor = NearBActor.BActor;
        APC.TMode_BreakableActor.SetAPCTargetingInfo();
        APC.TMode_BreakableActor.PostLockOn();
        APC.MyAlicePawn.OnSwitchLockOnTarget();
        APC.TargetNPCSocket.Pawn = none;
        return true;
    }
    return false;
}

function bool isTargetInCylinder(Vector vTargetLoc)
{
    local float fDis2D, fDisZ;
    
    fDis2D = VSize2D(APC.MyAlicePawn.Location - vTargetLoc);
    fDisZ = Abs(APC.MyAlicePawn.Location.Z - vTargetLoc.Z);
    if (fDis2D < APC.MyAlicePawn.fNoNPCInCamLockingRadius && fDisZ < APC.MyAlicePawn.fNoNPCInCamLockingHeight / 2.0)
    {
        return true;
    }
    return false;
}

function bool isInTheRear(Vector vTargetLoc, Actor Instigator)
{
    local bool bInRear, bBlocked;
    local Vector ftemp1, ftemp2;
    local float ftemp3;
    
    ftemp1 = Normal(vector(AlicePlayerCamera(APC.PlayerCamera).CameraCache.POV.Rotation));
    ftemp2 = Normal(vTargetLoc - AlicePlayerCamera(APC.PlayerCamera).CameraCache.POV.Location);
    ftemp3 = ftemp1 Dot ftemp2;
    bInRear = ftemp3 < 0.65;
    if (!bInRear)
    {
        return false;
    }
    bBlocked = IsLockOnBlocked(vTargetLoc);
    return !bBlocked;
}

function bool IsLockOnBlocked(Vector TargetLoc)
{
    local bool bPawnBlock;
    local Vector out_HitLocation, out_HitNormal, TraceExtent;
    local Actor TraceActor;
    local TraceHitInfo HitInfo;
    
    TraceActor = APC.Trace(out_HitLocation, out_HitNormal, TargetLoc, APC.MyAlicePawn.Location, true, TraceExtent, HitInfo, 8411);
    bPawnBlock = TraceActor != none && APC.shouldBlockLockOn(TraceActor) && !TraceActor.IsA('AliceGameKynapsePawn') && !TraceActor.IsA('GameBreakableActor') && !TraceActor.IsA('AlicePawn');
    if (bPawnBlock || TraceActor == none)
    {
        AliceCheatManager(APC.CheatManager).setLockonBlockActor(TraceActor);
    }
    return bPawnBlock;
}

function bool IsValidePV(const float PV)
{
    if (PV >= 0.0 && PV <= 1.0)
    {
        return true;
    }
    return false;
}

function HandleTargetSwitchCommond(float aTurn, float aLookUp)
{
    local SwitchCommond SCommand;
    
    if (Abs(aTurn) < 0.1 && Abs(aLookUp) < 0.1)
    {
        return;
    }
    if (Abs(aTurn) > Abs(aLookUp))
    {
        SCommand = (aTurn > float(0) ? 3 : 2);
    }
    else
    {
        SCommand = (aLookUp > float(0) ? 0 : 1);
    }
    MergeSwitchTarget(SCommand);
}

function UpdateNPCLockOnSocketInfo()
{
    APC.TargetNPCSocket.CollisionSocketLocation = APC.TargetNPCSocket.Pawn.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].CollisionLocation;
    APC.TargetNPCSocket.CollisionSocketRotation = APC.TargetNPCSocket.Pawn.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].CollisionRotation;
    APC.TargetNPCSocket.LockOnSocketLocation = APC.TargetNPCSocket.Pawn.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].LockOnLocation;
    APC.TargetNPCSocket.LockOnSocketRotation = APC.TargetNPCSocket.Pawn.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].LockOnRotation;
}

function bool TrySwitchLockOnSocket(AliceGameKynapsePawn npc)
{
    local int Sktidx, TargetSocketIndex;
    local float MinDist, curDist;
    local int CurrentSocketPriority, TempSocketPriority;
    
    CurrentSocketPriority = 0;
    TempSocketPriority = 0;
    MinDist = 100000000.0;
    TargetSocketIndex = -1;
    for (Sktidx = 0; Sktidx < npc.GetSocketNumber(); Sktidx++)
    {
        if (npc.LockOnInfo.TargetSockets[Sktidx].bHideUI)
        {
            TempSocketPriority = 0;
        }
        else
        {
            TempSocketPriority = 1;
        }
        if (npc.LockOnInfo.TargetSockets[Sktidx].bEnable && TempSocketPriority >= CurrentSocketPriority)
        {
            curDist = VSize2D(APC.Pawn.Location - npc.LockOnInfo.TargetSockets[Sktidx].CollisionLocation);
            if (curDist < APC.MyAlicePawn.TargetingSearchRadius && curDist < MinDist)
            {
                MinDist = curDist;
                TargetSocketIndex = Sktidx;
                CurrentSocketPriority = TempSocketPriority;
            }
        }
    }
    if (TargetSocketIndex >= 0)
    {
        APC.TargetNPCSocket.SocketIndex = TargetSocketIndex;
        NotifyTargetWillChange(npc, TargetSocketIndex);
        return true;
    }
    return false;
}

function bool NeedSwitchLockOnSocket()
{
    local AliceGameKynapsePawn npc;
    local int CurrentSocketPriority, TempSocketPriority, Sktidx;
    
    npc = AliceGameKynapsePawn(APC.TargetingActor);
    if (APC.TargetNPCSocket.SocketIndex >= 0 && APC.TargetNPCSocket.SocketIndex < npc.LockOnInfo.TargetSockets.Length)
    {
        if (!npc.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].bEnable)
        {
            return true;
        }
        else
        {
            if (npc.LockOnInfo.TargetSockets[APC.TargetNPCSocket.SocketIndex].bHideUI)
            {
                CurrentSocketPriority = 0;
            }
            else
            {
                CurrentSocketPriority = 1;
            }
            for (Sktidx = 0; Sktidx < npc.GetSocketNumber(); Sktidx++)
            {
                if (npc.LockOnInfo.TargetSockets[Sktidx].bEnable)
                {
                    if (npc.LockOnInfo.TargetSockets[Sktidx].bHideUI)
                    {
                        TempSocketPriority = 0;
                    }
                    else
                    {
                        TempSocketPriority = 1;
                    }
                    if (TempSocketPriority > CurrentSocketPriority)
                    {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

function Update(float DeltaTime)
{
    local AliceGameKynapsePawn npc;
    
    if (APC.TargetingActor == none)
    {
        DetermineFirstTarget();
    }
    else
    {
        npc = AliceGameKynapsePawn(APC.TargetingActor);
        if (!APC.MyAlicePawn.bEnableTargetOnDestroyedActor && npc != none && !npc.IsAliveAndWell())
        {
            APC.TMode_CombatLockOn.ForceSearchOnce();
            DetermineFirstTarget();
        }
        else if (npc != none && NeedSwitchLockOnSocket())
        {
            if (!TrySwitchLockOnSocket(npc))
            {
                APC.TMode_CombatLockOn.ForceSearchOnce();
                DetermineFirstTarget();
            }
        }
        if (npc != none)
        {
            UpdateNPCLockOnSocketInfo();
        }
    }
}

function float CalcAngleCamera(Vector TargetLocation)
{
    local Vector vTarget, vCameraFacing;
    local float fAngle;
    local Vector CamLoc;
    local Rotator CamRot;
    
    APC.GetPlayerViewPoint(CamLoc, CamRot);
    vCameraFacing = vector(CamRot);
    vCameraFacing.Z = 0.0;
    vCameraFacing = Normal(vCameraFacing);
    vTarget = TargetLocation - CamLoc;
    vTarget.Z = 0.0;
    vTarget = Normal(vTarget);
    fAngle = APC.CalcAngleBetweenVectors(vCameraFacing, vTarget);
    return fAngle;
}

function float CalcAnglePawn(Vector TargetLocation)
{
    local Vector vTarget, vPlayerFacing;
    local float fAngle;
    
    vPlayerFacing = vector(APC.Pawn.Rotation);
    vPlayerFacing.Z = 0.0;
    vPlayerFacing = Normal(vPlayerFacing);
    vTarget = TargetLocation - APC.Pawn.Location;
    vTarget.Z = 0.0;
    vTarget = Normal(vTarget);
    fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
    return fAngle;
}

function bool IsNPCAtLeft()
{
    local Vector vTarget, vPlayerFacing;
    local float fAngleNPC, fAngleBActor;
    
    vPlayerFacing = Normal(vector(APC.Pawn.Rotation));
    vTarget = Normal(APC.TMode_CombatLockOn.TargetNPCSocket.CollisionSocketLocation - APC.Pawn.Location);
    fAngleNPC = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
    vTarget = Normal(APC.TMode_BreakableActor.LockOnInfo.vLocation - APC.Pawn.Location);
    fAngleBActor = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
    if (fAngleNPC < fAngleBActor)
    {
        return true;
    }
    return false;
}

function bool SelectTarget(Actor TargetActor, optional int SocketID = 0)
{
    local int I;
    
    if (TargetActor.IsA('AliceGameKynapsePawn'))
    {
        if (TargetActor == APC.TargetNPCSocket.Pawn && APC.TargetNPCSocket.SocketIndex == SocketID)
        {
            return false;
        }
        for (I = 0; I < APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle.Length; I++)
        {
            if (TargetActor == APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I].Pawn && APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I].SocketIndex == SocketID)
            {
                NotifyTargetWillChange(TargetActor, SocketID);
                APC.TMode_CombatLockOn.TargetNPCSocket = APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I];
                APC.TMode_CombatLockOn.TargetingActor = TargetActor;
                APC.TMode_CombatLockOn.SetAPCTargetingInfo();
                APC.TMode_CombatLockOn.PostLockOn();
                TargetActor.TriggerEventClass(class'SeqEvent_LockedOn', TargetActor, 0);
                APC.MyAlicePawn.OnSwitchLockOnTarget();
                return true;
            }
        }
        return false;
    }
    else if (TargetActor.IsA('GameBreakableActor'))
    {
        if (TargetActor == APC.TargetingActor || GameBreakableActor(TargetActor).bPendingDestroySelf)
        {
            return false;
        }
        for (I = 0; I < APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle.Length; I++)
        {
            if (TargetActor == APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle[I].BActor)
            {
                NotifyTargetWillChange(TargetActor, SocketID);
                APC.TMode_BreakableActor.LockOnInfo = APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle[I];
                APC.TMode_BreakableActor.TargetingActor = TargetActor;
                APC.TMode_BreakableActor.SetAPCTargetingInfo();
                APC.TMode_BreakableActor.PostLockOn();
                APC.MyAlicePawn.OnSwitchLockOnTarget();
                APC.TargetNPCSocket.Pawn = none;
                return true;
            }
        }
        return false;
    }
    else if (TargetActor.IsA('DoomBarrierActor'))
    {
        if (TargetActor == APC.TargetingActor)
        {
            return false;
        }
        for (I = 0; I < APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle.Length; I++)
        {
            if (TargetActor == APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle[I].Actor)
            {
                NotifyTargetWillChange(TargetActor, SocketID);
                APC.TMode_SkeletalMeshActor.LockOnInfo = APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle[I];
                APC.TMode_SkeletalMeshActor.TargetingActor = TargetActor;
                APC.TMode_SkeletalMeshActor.SetAPCTargetingInfo();
                APC.TMode_SkeletalMeshActor.PostLockOn();
                APC.MyAlicePawn.OnSwitchLockOnTarget();
                APC.TargetNPCSocket.Pawn = none;
                return true;
            }
        }
    }
    return false;
}

function NotifyTargetWillChange(Actor TargetActor, optional int SocketID = 0)
{
    APC.UpdateNextCriticalUI(TargetActor, SocketID);
}

function float AdjustFirstTargetByPriority(out const array<float> TargetAngles, out const array<int> TargetPriorities)
{
    local int I, HighestPriority, TargetIndex;
    local float MinAngles;
    
    HighestPriority = 99999;
    MinAngles = 99999.0;
    for (I = 0; I < TargetAngles.Length; I++)
    {
        if (TargetPriorities[I] < HighestPriority)
        {
            HighestPriority = TargetPriorities[I];
            MinAngles = TargetAngles[I];
            TargetIndex = I;
            continue;
        }
        if (TargetPriorities[I] == HighestPriority)
        {
            if (TargetAngles[I] < MinAngles)
            {
                TargetIndex = I;
                MinAngles = TargetAngles[I];
            }
        }
    }
    return float(TargetIndex);
}

function DetermineFirstTarget()
{
    local array<Actor> MergeActors;
    local array<TargetingNPCInfo> NPCs;
    local array<BreakableActorLockOnInfo> BActors;
    local array<SkeletalMeshActorLockOnInfo> SMALockOnInfos;
    local array<float> TargetAngles;
    local array<int> TargetPriorities;
    local int I, iLength, NPCIndex, BActorIndex, SMAIndex, CurrentChoosedIndex, ChoosedPriority;
    local float NPCAngle, BActorAngle, SMAAngle, BIGNUM, MinAngle, ChoosedAngle;
    local Actor ChoosedActor, TargetActor;
    local int ChoosedSocketID;
    local array<int> SocketIDs;
    
    NPCs = APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle;
    BActors = APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle;
    SMALockOnInfos = APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle;
    iLength = NPCs.Length + BActors.Length + SMALockOnInfos.Length;
    if (iLength == 0)
    {
        if (!ChooseRearTarget())
        {
            APC.ClearTargetInfo();
        }
        return;
    }
    if (APC.MyAlicePawn.bUsePotentialField)
    {
        ChooseByPotentialField(NPCs, BActors, SMALockOnInfos);
        return;
    }
    if (APC.MyAlicePawn.bLockOnFromCamera)
    {
        TargetActor = ChooseFromCameraView(NPCs, BActors, SMALockOnInfos);
        if (TargetActor != none)
        {
            SelectTarget(TargetActor);
        }
        else
        {
            APC.ClearAllTargets();
        }
        return;
    }
    MergeActors.Length = 0;
    TargetAngles.Length = 0;
    TargetPriorities.Length = 0;
    NPCIndex = 0;
    BActorIndex = 0;
    SMAIndex = 0;
    BIGNUM = 9999999.0;
    MinAngle = BIGNUM;
    for (I = 0; I < iLength; I++)
    {
        if (NPCIndex < NPCs.Length)
        {
            NPCAngle = Abs(CalcAnglePawn(NPCs[NPCIndex].CollisionSocketLocation));
        }
        else
        {
            NPCAngle = BIGNUM;
        }
        if (BActorIndex < BActors.Length)
        {
            BActorAngle = Abs(CalcAnglePawn(BActors[BActorIndex].vLocation));
        }
        else
        {
            BActorAngle = BIGNUM;
        }
        if (SMAIndex < SMALockOnInfos.Length)
        {
            SMAAngle = Abs(CalcAngleCamera(SMALockOnInfos[SMAIndex].CollisionLockOnLoc));
        }
        ChoosedSocketID = 0;
        if (NPCAngle < BActorAngle && NPCAngle < SMAAngle)
        {
            ChoosedActor = NPCs[NPCIndex].Pawn;
            ChoosedSocketID = NPCs[NPCIndex].SocketIndex;
            ChoosedAngle = NPCAngle;
            ChoosedPriority = 0;
            NPCIndex++;
            if (MinAngle > NPCAngle)
            {
                MinAngle = NPCAngle;
                CurrentChoosedIndex = MergeActors.Length;
            }
        }
        else if (BActorAngle < NPCAngle && BActorAngle < SMAAngle)
        {
            ChoosedActor = BActors[BActorIndex].BActor;
            ChoosedAngle = BActorAngle;
            ChoosedPriority = BActors[BActorIndex].iPriority;
            BActorIndex++;
            if (MinAngle > BActorAngle)
            {
                MinAngle = BActorAngle;
                CurrentChoosedIndex = MergeActors.Length;
            }
        }
        else
        {
            ChoosedActor = SMALockOnInfos[SMAIndex].Actor;
            ChoosedAngle = SMAAngle;
            ChoosedPriority = 0;
            SMAIndex++;
            if (MinAngle > SMAAngle)
            {
                MinAngle = SMAAngle;
                CurrentChoosedIndex = MergeActors.Length;
            }
        }
        MergeActors.AddItem(ChoosedActor);
        TargetAngles.AddItem(ChoosedAngle);
        SocketIDs.AddItem(ChoosedSocketID);
        TargetPriorities.AddItem(ChoosedPriority);
    }
    CurrentChoosedIndex = int(AdjustFirstTargetByPriority(TargetAngles, TargetPriorities));
    if (CurrentChoosedIndex < 0 || CurrentChoosedIndex >= MergeActors.Length)
    {
        return;
    }
    TargetActor = MergeActors[CurrentChoosedIndex];
    SelectTarget(TargetActor, SocketIDs[CurrentChoosedIndex]);
}

function Actor ChooseByDistance(out const array<TargetingNPCInfo> NPCs, out const array<BreakableActorLockOnInfo> BActors)
{
    local int I;
    local Actor TargetActor;
    local float fDis, MinDis;
    
    MinDis = 9999999.0;
    for (I = 0; I < NPCs.Length; I++)
    {
        if (AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(NPCs[I].CollisionSocketLocation, APC.MyAlicePawn.FOVScale))
        {
            fDis = VSize(APC.Pawn.Location - NPCs[I].CollisionSocketLocation);
            if (fDis < MinDis)
            {
                TargetActor = NPCs[I].Pawn;
                MinDis = fDis;
            }
        }
    }
    for (I = 0; I < BActors.Length; I++)
    {
        if (AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(BActors[I].vLocation, APC.MyAlicePawn.FOVScale))
        {
            fDis = VSize(APC.Pawn.Location - BActors[I].vLocation);
            if (fDis < MinDis)
            {
                TargetActor = BActors[I].BActor;
                MinDis = fDis;
            }
        }
    }
    return TargetActor;
}

function Actor ChooseFromCameraView(out const array<TargetingNPCInfo> NPCs, out const array<BreakableActorLockOnInfo> BActors, out const array<SkeletalMeshActorLockOnInfo> SMALockOnInfos)
{
    local int I;
    local Actor TargetActor;
    local float fAngle, MinAngle;
    
    MinAngle = 999999.0;
    for (I = 0; I < NPCs.Length; I++)
    {
        if (AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(NPCs[I].CollisionSocketLocation, APC.MyAlicePawn.FOVScale))
        {
            fAngle = CalcAngleCamera(NPCs[I].CollisionSocketLocation);
            if (Abs(fAngle) < MinAngle)
            {
                TargetActor = NPCs[I].Pawn;
                MinAngle = Abs(fAngle);
            }
        }
    }
    for (I = 0; I < BActors.Length; I++)
    {
        if (AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(BActors[I].vLocation, APC.MyAlicePawn.FOVScale))
        {
            fAngle = CalcAngleCamera(BActors[I].vLocation);
            if (Abs(fAngle) < MinAngle)
            {
                TargetActor = BActors[I].BActor;
                MinAngle = Abs(fAngle);
            }
        }
    }
    for (I = 0; I < SMALockOnInfos.Length; I++)
    {
        if (AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(SMALockOnInfos[I].CollisionLockOnLoc, APC.MyAlicePawn.FOVScale))
        {
            fAngle = CalcAngleCamera(SMALockOnInfos[I].CollisionLockOnLoc);
            if (Abs(fAngle) < MinAngle)
            {
                TargetActor = SMALockOnInfos[I].Actor;
                MinAngle = Abs(fAngle);
            }
        }
    }
    return TargetActor;
}

function int CycleAdd(int iStart, int iStep, int iBase)
{
    local int iResult;
    
    iResult = iStart + iStep;
    if (iResult < 0)
    {
        iResult += iBase;
    }
    if (iResult > iBase - 1)
    {
        iResult -= iBase;
    }
    return iResult;
}

function float AdjustSwitchTargetByPriority(SwitchCommond SCommond, int OldIndex, out array<int> TargetPriorities)
{
    local int HighestPriority, TargetIndex, iStart, iEnd, iStep, iBase;
    
    iBase = TargetPriorities.Length;
    HighestPriority = 99999;
    if (SCommond == 0 || SCommond == 1)
    {
        if (APC.MyAlicePawn.bCycleSwitch)
        {
            iStart = (SCommond == 1 ? CycleAdd(OldIndex, -1, iBase) : CycleAdd(OldIndex, 1, iBase));
            iEnd = OldIndex;
        }
        else
        {
            iStart = (SCommond == 1 ? OldIndex - 1 : OldIndex + 1);
            iEnd = (SCommond == 1 ? -1 : TargetPriorities.Length);
        }
        iStep = (SCommond == 1 ? -1 : 1);
        TargetIndex = iEnd;
        while (iStart != iEnd)
        {
            if (TargetPriorities[iStart] < HighestPriority)
            {
                HighestPriority = TargetPriorities[iStart];
                TargetIndex = iStart;
            }
            if (APC.MyAlicePawn.bCycleSwitch)
            {
                iStart = CycleAdd(iStart, iStep, iBase);
                continue;
            }
            iStart += iStep;
        }
    }
    else
    {
        if (APC.MyAlicePawn.bCycleSwitch)
        {
            iStart = (SCommond == 2 ? CycleAdd(OldIndex, -1, iBase) : CycleAdd(OldIndex, 1, iBase));
            iEnd = OldIndex;
        }
        else
        {
            iStart = (SCommond == 2 ? OldIndex - 1 : OldIndex + 1);
            iEnd = (SCommond == 2 ? -1 : TargetPriorities.Length);
        }
        iStep = (SCommond == 2 ? -1 : 1);
        TargetIndex = iEnd;
        while (iStart != iEnd)
        {
            if (TargetPriorities[iStart] < HighestPriority)
            {
                HighestPriority = TargetPriorities[iStart];
                TargetIndex = iStart;
            }
            if (APC.MyAlicePawn.bCycleSwitch)
            {
                iStart = CycleAdd(iStart, iStep, iBase);
                continue;
            }
            iStart += iStep;
        }
    }
    return float(TargetIndex);
}

function bool DetermineSwitchTarget(SwitchCommond SCommond)
{
    local array<Actor> MergeActors;
    local array<TargetingNPCInfo> NPCs;
    local array<BreakableActorLockOnInfo> BActors;
    local array<int> TargetPriorities;
    local int I, iLength, NPCIndex, BActorIndex, CurrentChoosedIndex, ChoosedPriority;
    local float NPCAngle, BActorAngle, BIGNUM, NPCDist, BActorDist;
    local Actor ChoosedActor, TargetActor;
    local array<int> SocketIDs;
    local int ChoosedSocketID;
    local bool bNPC;
    local Vector CamLoc;
    local Rotator CamRot;
    
    MergeActors.Length = 0;
    TargetPriorities.Length = 0;
    NPCIndex = 0;
    BActorIndex = 0;
    BIGNUM = 9999999.0;
    SocketIDs.Length = 0;
    if (SCommond == 2 || SCommond == 3)
    {
        NPCs = APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle;
        BActors = APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle;
        iLength = NPCs.Length + BActors.Length;
        if (iLength <= 1)
        {
            return false;
        }
        for (I = 0; I < iLength; I++)
        {
            if (NPCIndex < NPCs.Length)
            {
                NPCAngle = CalcAngleCamera(NPCs[NPCIndex].CollisionSocketLocation);
            }
            else
            {
                NPCAngle = BIGNUM;
            }
            if (BActorIndex < BActors.Length)
            {
                BActorAngle = CalcAngleCamera(BActors[BActorIndex].vLocation);
            }
            else
            {
                BActorAngle = BIGNUM;
            }
            ChoosedSocketID = 0;
            if (NPCAngle < BActorAngle)
            {
                ChoosedActor = NPCs[NPCIndex].Pawn;
                ChoosedSocketID = NPCs[NPCIndex].SocketIndex;
                ChoosedPriority = 0;
                NPCIndex++;
                bNPC = true;
            }
            else
            {
                ChoosedActor = BActors[BActorIndex].BActor;
                ChoosedPriority = BActors[BActorIndex].iPriority;
                BActorIndex++;
                bNPC = false;
            }
            MergeActors.AddItem(ChoosedActor);
            TargetPriorities.AddItem(ChoosedPriority);
            SocketIDs.AddItem(ChoosedSocketID);
            if (!bNPC && APC.TargetingActor == ChoosedActor || bNPC && ChoosedActor == APC.TargetNPCSocket.Pawn && APC.TargetNPCSocket.SocketIndex == ChoosedSocketID)
            {
                CurrentChoosedIndex = MergeActors.Length - 1;
            }
        }
    }
    else
    {
        NPCs = APC.TMode_CombatLockOn.NPCSocketsToBeTargeted;
        BActors = APC.TMode_BreakableActor.BAsToBeTargeted;
        iLength = NPCs.Length + BActors.Length;
        AlicePlayerCamera(APC.PlayerCamera).GetCameraViewPoint(CamLoc, CamRot);
        if (iLength <= 1)
        {
            return false;
        }
        for (I = 0; I < iLength; I++)
        {
            if (NPCIndex < NPCs.Length)
            {
                NPCDist = VSize(NPCs[NPCIndex].CollisionSocketLocation - CamLoc);
            }
            else
            {
                NPCDist = BIGNUM;
            }
            if (BActorIndex < BActors.Length)
            {
                BActorDist = VSize(BActors[BActorIndex].vLocation - CamLoc);
            }
            else
            {
                BActorDist = BIGNUM;
            }
            ChoosedSocketID = 0;
            if (NPCDist < BActorDist)
            {
                ChoosedActor = NPCs[NPCIndex].Pawn;
                ChoosedSocketID = NPCs[NPCIndex].SocketIndex;
                ChoosedPriority = 0;
                NPCIndex++;
                bNPC = true;
            }
            else
            {
                ChoosedActor = BActors[BActorIndex].BActor;
                ChoosedPriority = BActors[BActorIndex].iPriority;
                BActorIndex++;
                bNPC = false;
            }
            MergeActors.AddItem(ChoosedActor);
            TargetPriorities.AddItem(ChoosedPriority);
            SocketIDs.AddItem(ChoosedSocketID);
            if (!bNPC && APC.TargetingActor == ChoosedActor || bNPC && ChoosedActor == APC.TargetNPCSocket.Pawn && APC.TargetNPCSocket.SocketIndex == ChoosedSocketID)
            {
                CurrentChoosedIndex = MergeActors.Length - 1;
            }
        }
    }
    CurrentChoosedIndex = int(AdjustSwitchTargetByPriority(SCommond, CurrentChoosedIndex, TargetPriorities));
    if (CurrentChoosedIndex < 0 || CurrentChoosedIndex >= MergeActors.Length)
    {
        return false;
    }
    TargetActor = MergeActors[CurrentChoosedIndex];
    return SelectTarget(TargetActor, SocketIDs[CurrentChoosedIndex]);
}

function MergeSwitchTarget(SwitchCommond SCommond)
{
    local bool bChanged;
    
    bChanged = DetermineSwitchTarget(SCommond);
    if (bChanged)
    {
        APC.TargetingActorSwitched();
    }
}

final simulated function Initialize(AlicePlayerController inPC)
{
    APC = inPC;
}

defaultproperties
{
}
