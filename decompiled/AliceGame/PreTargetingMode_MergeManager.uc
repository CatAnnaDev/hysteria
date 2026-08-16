class PreTargetingMode_MergeManager extends Object
    notplaceable;

var transient AlicePlayerController APC;

function ChooseByPotentialField(out const array<TargetingNPCInfo> NPCs, out const array<BreakableActorLockOnInfo> BActors, out const array<SkeletalMeshActorLockOnInfo> SMALockOnInfos)
{
    local int I, ChoosedSocketID;
    local Actor TargetActor;
    local float fPV, MinPV;
    local Vector NewCoorLoc;
    
    MinPV = 999999.0;
    if (AliceCheatManager(APC.CheatManager).bCalcPFInfo)
    {
        AliceCheatManager(APC.CheatManager).PFActorInfos.Length = 0;
    }
    for (I = 0; I < NPCs.Length; I++)
    {
        fPV = APC.MyAlicePawn.CalcPotentialValue(NPCs[I].CollisionSocketLocation, NewCoorLoc);
        if (IsValidePV(fPV) && fPV < MinPV)
        {
            TargetActor = NPCs[I].Pawn;
            ChoosedSocketID = NPCs[I].SocketIndex;
            MinPV = fPV;
        }
        if (AliceCheatManager(APC.CheatManager).bCalcPFInfo)
        {
            AliceCheatManager(APC.CheatManager).AddPFInfo(NPCs[I].CollisionSocketLocation, NewCoorLoc, fPV, string(NPCs[I].Pawn.Name));
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
        if (AliceCheatManager(APC.CheatManager).bCalcPFInfo)
        {
            AliceCheatManager(APC.CheatManager).AddPFInfo(BActors[I].vLocation, NewCoorLoc, fPV, string(BActors[I].BActor.Name));
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
        if (AliceCheatManager(APC.CheatManager).bCalcPFInfo)
        {
            AliceCheatManager(APC.CheatManager).AddPFInfo(SMALockOnInfos[I].CollisionLockOnLoc, NewCoorLoc, fPV, string(SMALockOnInfos[I].Actor.Name));
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

function bool IsValidePV(const float PV)
{
    if (PV >= 0.0 && PV <= 1.0)
    {
        return true;
    }
    return false;
}

function Update(float DeltaTime)
{
    DeterminePreTarget();
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

function bool SelectTarget(Actor TargetActor, optional int SocketID = 0)
{
    local int I;
    
    if (TargetActor.IsA('AliceGameKynapsePawn'))
    {
        for (I = 0; I < APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle.Length; I++)
        {
            if (TargetActor == APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I].Pawn && APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I].SocketIndex == SocketID)
            {
                NotifyTargetWillChange(TargetActor, SocketID);
                APC.PreTargetingActor = TargetActor;
                APC.PreTargetNPCSocket = APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle[I];
                APC.PreTargetBActorInfo.BActor = none;
                return true;
            }
        }
        return false;
    }
    else if (TargetActor.IsA('GameBreakableActor'))
    {
        for (I = 0; I < APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle.Length; I++)
        {
            if (TargetActor == APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle[I].BActor)
            {
                NotifyTargetWillChange(TargetActor, SocketID);
                APC.PreTargetingActor = TargetActor;
                APC.PreTargetBActorInfo = APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle[I];
                APC.PreTargetNPCSocket.Pawn = none;
                return true;
            }
        }
        return false;
    }
    else if (TargetActor.IsA('DoomBarrierActor'))
    {
        for (I = 0; I < APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle.Length; I++)
        {
            NotifyTargetWillChange(TargetActor, SocketID);
            APC.PreTargetingActor = TargetActor;
            APC.PreTargetSMAInfo = APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle[I];
            APC.PreTargetNPCSocket.Pawn = none;
            APC.PreTargetBActorInfo.BActor = none;
            return true;
        }
    }
    return false;
}

function float AdjustPreTargetByPriority(out const array<float> TargetAngles, out const array<int> TargetPriorities)
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

function DeterminePreTarget()
{
    local array<Actor> MergeActors;
    local array<TargetingNPCInfo> NPCs;
    local array<BreakableActorLockOnInfo> BActors;
    local array<SkeletalMeshActorLockOnInfo> SMALockOnInfos;
    local array<float> TargetAngles;
    local array<int> TargetPriorities;
    local int I, iLength, NPCIndex, BActorIndex, CurrentChoosedIndex, ChoosedPriority;
    local float NPCAngle, BActorAngle, BIGNUM, MinAngle, ChoosedAngle;
    local Actor ChoosedActor, TargetActor;
    
    NPCs = APC.TMode_CombatLockOn.NPCSocketsToBeTargetedSortedByAngle;
    BActors = APC.TMode_BreakableActor.BAsToBeTargetedSortedByAngle;
    SMALockOnInfos = APC.TMode_SkeletalMeshActor.SMAsToBeTargetedSortedByAngle;
    iLength = NPCs.Length + BActors.Length + SMALockOnInfos.Length;
    if (iLength == 0)
    {
        APC.PreTargetingActor = none;
        APC.PreTargetNPCSocket.Pawn = none;
        APC.PreTargetBActorInfo.BActor = none;
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
        if (NPCAngle < BActorAngle)
        {
            ChoosedActor = NPCs[NPCIndex].Pawn;
            ChoosedAngle = NPCAngle;
            ChoosedPriority = 0;
            NPCIndex++;
            if (MinAngle > NPCAngle)
            {
                MinAngle = NPCAngle;
                CurrentChoosedIndex = MergeActors.Length;
            }
        }
        else
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
        MergeActors.AddItem(ChoosedActor);
        TargetAngles.AddItem(ChoosedAngle);
        TargetPriorities.AddItem(ChoosedPriority);
    }
    CurrentChoosedIndex = int(AdjustPreTargetByPriority(TargetAngles, TargetPriorities));
    TargetActor = MergeActors[CurrentChoosedIndex];
    SelectTarget(TargetActor);
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

function NotifyTargetWillChange(Actor TargetActor, optional int SocketID = 0)
{
    APC.UpdateNextCriticalUI(TargetActor, SocketID);
}

final simulated function Initialize(AlicePlayerController inPC)
{
    APC = inPC;
}

defaultproperties
{
}
