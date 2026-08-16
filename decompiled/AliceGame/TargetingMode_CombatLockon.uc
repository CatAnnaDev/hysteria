class TargetingMode_CombatLockon extends TargetingModeBase
    notplaceable
    hidecategories(Navigation);

var transient TargetingNPCInfo TargetNPCSocket;
var transient array<TargetingNPCInfo> NPCSocketsToBeTargeted;
var transient array<TargetingNPCInfo> NPCSocketsToBeTargetedSortedByAngle;

simulated function PostLockOff()
{
    local AliceGameKynapsePawn npc;
    
    npc = AliceGameKynapsePawn(APC.TargetingActor);
    if (npc != none)
    {
        npc.OnNotLockedOn();
        npc.TriggerEventClass(class'SeqEvent_LockedOn', self, 1);
    }
    APC.ResetMaterialsForNPCs();
    APC.TargetNPCSocket.Pawn = none;
    APC.TargetNPCSocket.SocketIndex = -1;
    ResetDefaultTransientVariables();
}

simulated function PostLockOn()
{
    local AliceGameKynapsePawn npc;
    
    npc = AliceGameKynapsePawn(APC.TargetingActor);
    if (npc != none)
    {
        npc.OnLockedOn();
        npc.TriggerEventClass(class'SeqEvent_LockedOn', self, 0);
        npc.OnEventBeLockOn();
    }
    if (!APC.IsInState('PlayerLockOnTarget'))
    {
        APC.GotoState('PlayerLockOnTarget');
    }
}

simulated function SwitchTargetingActor(bool bLeft)
{
    local int I, Index;
    
    if (!bInitialized || !bActive)
    {
        return;
    }
    if (NPCSocketsToBeTargetedSortedByAngle.Length <= 1)
    {
        return;
    }
    Index = -1;
    for (I = 0; I < NPCSocketsToBeTargetedSortedByAngle.Length; I++)
    {
        if (NPCSocketsToBeTargetedSortedByAngle[I].Pawn == TargetNPCSocket.Pawn && NPCSocketsToBeTargetedSortedByAngle[I].SocketIndex == TargetNPCSocket.SocketIndex)
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
    if (Index < 0 || Index >= NPCSocketsToBeTargetedSortedByAngle.Length)
    {
        return;
    }
    if (TargetNPCSocket.Pawn != none)
    {
        TargetNPCSocket.Pawn.TriggerEventClass(class'SeqEvent_LockedOn', self, 1);
    }
    TargetNPCSocket = NPCSocketsToBeTargetedSortedByAngle[Index];
    TargetNPCSocket.Pawn.LockOnInfo.currentIndexOfTargetingSocket = TargetNPCSocket.SocketIndex;
    TargetingActor = TargetNPCSocket.Pawn;
}

simulated function UpdateAPCTargetSocketLocationAndRotation(Vector newCollisionLoc, Rotator newCollisionRot, Vector newLockOnLoc, Rotator newLockOnRot)
{
    APC.TargetNPCSocket.CollisionSocketLocation = newCollisionLoc;
    APC.TargetNPCSocket.CollisionSocketRotation = newCollisionRot;
    APC.TargetNPCSocket.LockOnSocketLocation = newLockOnLoc;
    APC.TargetNPCSocket.LockOnSocketRotation = newLockOnRot;
}

simulated function SetAPCTargetingInfo()
{
    if (TargetingActor != APC.TargetingActor)
    {
        if (APC.bTargetingModeActive)
        {
            if (APC.TargetingActor != none)
            {
                AliceGameKynapsePawn(APC.TargetingActor).OnNotLockedOn();
            }
            AliceGameKynapsePawn(TargetingActor).OnLockedOn();
        }
        APC.TargetingActor = TargetingActor;
    }
    APC.TargetNPCSocket = TargetNPCSocket;
}

simulated function FindAvailableTargets(Vector vCenterOfSearch, float fRadius, float fZDiff, bool bUpdateTargetingActor)
{
    local AliceGameKynapsePawn A;
    local float MinDist, curDist, nextDist;
    local bool bTargetingActorInList, bSeenByGD;
    local Vector vPlayerFacing, vTarget, CamLoc;
    local Rotator CamRot;
    local float fAngle;
    local array<float> Angles;
    local int I, J, T;
    local TargetingNPCInfo TA, TB, TAWithMinDist;
    local int Sktidx;
    local float angleThreshold;
    local Color debugColor;
    local int CurrentSocketPriority, TempSocketPriority;
    
    MinDist = fRadius;
    NPCSocketsToBeTargeted.Length = 0;
    if (APC.IsMoveInputIgnored())
    {
        if (VSize(AlicePlayerInput(APC.PlayerInput).InputVectorDuringIgnore) > float(0))
        {
            vPlayerFacing = AlicePlayerInput(APC.PlayerInput).InputVectorDuringIgnore;
        }
        else
        {
            vPlayerFacing = vector(PlayerPawn.Rotation);
        }
    }
    else if (VSize(AlicePlayerInput(APC.PlayerInput).InputVector) > float(0))
    {
        vPlayerFacing = AlicePlayerInput(APC.PlayerInput).InputVector;
    }
    else
    {
        vPlayerFacing = vector(PlayerPawn.Rotation);
    }
    angleThreshold = PlayerPawn.NonLockOnAutoTargetAngleRange * 0.017453292 * 0.5;
    debugColor.R = 255;
    debugColor.G = 128;
    debugColor.B = 16;
    debugColor.A = 128;
    if (PlayerPawn.bDrawTargetCone)
    {
        APC.DrawDebugCone(PlayerPawn.Location, vPlayerFacing, fRadius, angleThreshold, 0.0, 8, debugColor, false);
    }
    foreach DynamicActors(class'AliceGameKynapsePawn', A)
    {
        bSeenByGD = (APC.MyAlicePawn.bLockOnFromCamera ? AlicePlayerCamera(APC.PlayerCamera).CanSeeEx(A.Location, APC.MyAlicePawn.FOVScale, true) : true);
        if (!A.bHidden && A.bCanBeLockedOn && bSeenByGD)
        {
            if (!PlayerPawn.bEnableTargetOnDestroyedActor && !A.IsAliveAndWell())
            {
                break;
            }
            if (PlayerPawn.bEnableTargetOnDestroyedActor)
            {
                if (!APC.bTargetingModeActive && !A.IsAliveAndWell())
                {
                    break;
                }
                if (APC.bTargetingModeActive && A != TargetingActor && !A.IsAliveAndWell())
                {
                    break;
                }
            }
            if (A.AnyLockableSocketaEnable())
            {
                CurrentSocketPriority = 0;
                TempSocketPriority = 0;
                for (Sktidx = 0; Sktidx < A.GetSocketNumber(); Sktidx++)
                {
                    if (A.LockOnInfo.TargetSockets[Sktidx].bHideUI)
                    {
                        TempSocketPriority = 0;
                    }
                    else
                    {
                        TempSocketPriority = 1;
                    }
                    if (A.LockOnInfo.TargetSockets[Sktidx].bEnable && TempSocketPriority >= CurrentSocketPriority)
                    {
                        curDist = VSize2D(vCenterOfSearch - A.LockOnInfo.TargetSockets[Sktidx].CollisionLocation);
                        if (curDist < fRadius && Abs(vCenterOfSearch.Z - A.LockOnInfo.TargetSockets[Sktidx].CollisionLocation.Z) < fZDiff)
                        {
                            TA.Pawn = A;
                            TA.SocketIndex = Sktidx;
                            CurrentSocketPriority = TempSocketPriority;
                            if (A.IsAliveAndWell())
                            {
                                TA.CollisionSocketLocation = A.LockOnInfo.TargetSockets[Sktidx].CollisionLocation;
                                TA.CollisionSocketRotation = A.LockOnInfo.TargetSockets[Sktidx].CollisionRotation;
                                TA.LockOnSocketLocation = A.LockOnInfo.TargetSockets[Sktidx].LockOnLocation;
                                TA.LockOnSocketRotation = A.LockOnInfo.TargetSockets[Sktidx].LockOnRotation;
                            }
                            else
                            {
                                TA.CollisionSocketLocation = A.Location;
                                TA.CollisionSocketRotation = A.Rotation;
                                TA.LockOnSocketLocation = A.Location;
                                TA.LockOnSocketRotation = A.Rotation;
                            }
                            NPCSocketsToBeTargeted.AddItem(TA);
                            if (MinDist > curDist)
                            {
                                TAWithMinDist = TA;
                                MinDist = curDist;
                            }
                            if (TargetNPCSocket.Pawn != none && A == TargetNPCSocket.Pawn && Sktidx == TargetNPCSocket.SocketIndex)
                            {
                                bTargetingActorInList = true;
                                TargetNPCSocket.CollisionSocketLocation = TA.CollisionSocketLocation;
                                TargetNPCSocket.CollisionSocketRotation = TA.CollisionSocketRotation;
                                TargetNPCSocket.LockOnSocketLocation = TA.LockOnSocketLocation;
                                TargetNPCSocket.LockOnSocketRotation = TA.LockOnSocketRotation;
                            }
                        }
                    }
                }
                continue;
            }
            if (A.Mesh == none && PlayerPawn.bEnableTargetOnDestroyedActor)
            {
                curDist = VSize2D(vCenterOfSearch - A.Location);
                if (curDist < fRadius && Abs(vCenterOfSearch.Z - A.Location.Z) < fZDiff)
                {
                    TA.Pawn = A;
                    TA.SocketIndex = -1;
                    TA.CollisionSocketLocation = A.Location;
                    TA.CollisionSocketRotation = A.Rotation;
                    TA.LockOnSocketLocation = A.Location;
                    TA.LockOnSocketRotation = A.Rotation;
                    NPCSocketsToBeTargeted.AddItem(TA);
                    if (MinDist > curDist)
                    {
                        TAWithMinDist = TA;
                        MinDist = curDist;
                    }
                    if (TargetNPCSocket.Pawn != none && A == TargetNPCSocket.Pawn)
                    {
                        bTargetingActorInList = true;
                        TargetNPCSocket.CollisionSocketLocation = TA.CollisionSocketLocation;
                        TargetNPCSocket.CollisionSocketRotation = TA.CollisionSocketRotation;
                        TargetNPCSocket.LockOnSocketLocation = TA.LockOnSocketLocation;
                        TargetNPCSocket.LockOnSocketRotation = TA.LockOnSocketRotation;
                    }
                }
            }
        }
    }
    if (NPCSocketsToBeTargeted.Length == 0)
    {
        TargetNPCSocket.Pawn = none;
        TargetNPCSocket.SocketIndex = 0;
        TargetingActor = none;
        NPCSocketsToBeTargetedSortedByAngle.Length = 0;
        return;
    }
    for (I = 0; I < NPCSocketsToBeTargeted.Length; I++)
    {
        T = NPCSocketsToBeTargeted.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            TA = NPCSocketsToBeTargeted[J];
            curDist = VSize2D(PlayerPawn.Location - TA.CollisionSocketLocation);
            TB = NPCSocketsToBeTargeted[J + 1];
            nextDist = VSize2D(PlayerPawn.Location - TB.CollisionSocketLocation);
            if (curDist > nextDist)
            {
                NPCSocketsToBeTargeted[J] = NPCSocketsToBeTargeted[J + 1];
                NPCSocketsToBeTargeted[J + 1] = TA;
            }
        }
    }
    NPCSocketsToBeTargetedSortedByAngle.Length = 0;
    Angles.Length = 0;
    APC.GetPlayerViewPoint(CamLoc, CamRot);
    for (I = 0; I < NPCSocketsToBeTargeted.Length; I++)
    {
        vTarget = NPCSocketsToBeTargeted[I].CollisionSocketLocation - CamLoc;
        vPlayerFacing = vector(CamRot);
        fAngle = APC.CalcAngleBetweenVectors(vPlayerFacing, vTarget);
        if (Abs(fAngle) < PlayerPawn.LockConeAngle / 180.0 * 3.1415927 && !APC.MyAlicePawn.IsLockOnBlocked(NPCSocketsToBeTargeted[I].Pawn.Location))
        {
            NPCSocketsToBeTargetedSortedByAngle.AddItem(NPCSocketsToBeTargeted[I]);
            Angles.AddItem(fAngle);
        }
    }
    for (I = 0; I < NPCSocketsToBeTargetedSortedByAngle.Length; I++)
    {
        T = NPCSocketsToBeTargetedSortedByAngle.Length - I - 1;
        for (J = 0; J < T; J++)
        {
            if (Angles[J] > Angles[J + 1])
            {
                TA = NPCSocketsToBeTargetedSortedByAngle[J];
                NPCSocketsToBeTargetedSortedByAngle[J] = NPCSocketsToBeTargetedSortedByAngle[J + 1];
                NPCSocketsToBeTargetedSortedByAngle[J + 1] = TA;
                fAngle = Angles[J];
                Angles[J] = Angles[J + 1];
                Angles[J + 1] = fAngle;
            }
        }
    }
    for (I = 0; I < NPCSocketsToBeTargetedSortedByAngle.Length; I++)
    {
        NPCSocketsToBeTargetedSortedByAngle[I].Pawn.fAngleToAlice = Angles[I];
        NPCSocketsToBeTargetedSortedByAngle[I].Pawn.AngleIndex = I;
    }
    if (bUpdateTargetingActor && TargetNPCSocket.Pawn == none || TargetNPCSocket.Pawn != none && !bTargetingActorInList || TargetNPCSocket.Pawn != APC.TargetNPCSocket.Pawn)
    {
        TargetNPCSocket = TAWithMinDist;
        TargetNPCSocket.Pawn.LockOnInfo.currentIndexOfTargetingSocket = TargetNPCSocket.SocketIndex;
        TargetingActor = TargetNPCSocket.Pawn;
    }
}

simulated function ResetDefaultTransientVariables()
{
    NPCSocketsToBeTargeted.Length = 0;
    NPCSocketsToBeTargetedSortedByAngle.Length = 0;
    TargetNPCSocket.Pawn = none;
    TargetNPCSocket.SocketIndex = -1;
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
    ForceSearchOnce();
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

simulated function ForceSearchOnce()
{
    if (APC == none || PlayerPawn == none)
    {
        return;
    }
    ResetDefaultTransientVariables();
    GetSearchConditionParameters();
    FindAvailableTargets(SearchCenter, SearchRadius, SearchZDiff, true);
}

defaultproperties
{
    SearchTargetType="AliceGameKynapsePawn"
}
