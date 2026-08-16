class CheatManager extends Object
    native
    notplaceable
    within PlayerController;

var DebugCameraController DebugCameraControllerRef;
var class<DebugCameraController> DebugCameraControllerClass;
var const localized string ViewingFrom;
var const localized string OwnCamera;

exec function fullhealth()
{
    Outer.Pawn.Health = Outer.Pawn.HealthMax;
    LogInternal("Pawn.Health become to " @ string(Outer.Pawn.Health));
}

exec function NavMeshVerification(optional float interval = 0.5)
{
    if (interval < float(0))
    {
        Outer.ClearTimer('VerifyNavMeshObjects', Outer);
    }
    else
    {
        Outer.SetTimer(interval, true, 'VerifyNavMeshObjects', Outer);
    }
}

native exec function VerifyNavMeshObjects()
{
}

native exec function LogParticleActivateSystemCalls(bool bShouldLog)
{
    bShouldLog;
}

native exec function LogPlaySoundCalls(bool bShouldLog)
{
    bShouldLog;
}

function InitCheatManager()
{
}

exec function VerbosePathDebug()
{
    local Vector HitLoc, HitNorm, Start, End;
    local Rotator Rot;
    local Pawn P;
    
    Outer.GetPlayerViewPoint(Start, Rot);
    End = Start + vector(Rot) * float(10000);
    foreach Outer.TraceActors(class'Pawn', P, HitLoc, HitNorm, End, Start, vect(1.0, 1.0, 1.0))
    {
        Outer.Pawn.MessagePlayer("Verbosepathdebug trace hit" @ string(P));
        if (P != none && P.Controller != none)
        {
            P.Controller.NavigationHandle.bUltraVerbosePathDebugging = !P.Controller.NavigationHandle.bUltraVerbosePathDebugging;
        }
    }
}

exec function TestNavMeshPath(optional bool bDrawPath = true)
{
    local Actor HitActor;
    local Vector HitLoc, HitNorm, Start, End;
    local Rotator Rot;
    
    if (Outer.NavigationHandle == none)
    {
        Outer.NavigationHandle = new(Outer) class'NavigationHandle';
    }
    Outer.GetPlayerViewPoint(Start, Rot);
    End = Start + vector(Rot) * float(10000);
    HitActor = Outer.Trace(HitLoc, HitNorm, End, Start, false);
    if (HitActor != none)
    {
        class'NavMeshPath_Toward'.static.TowardPoint(Outer.NavigationHandle, HitLoc);
        class'NavMeshGoal_At'.static.AtLocation(Outer.NavigationHandle, HitLoc);
        Outer.NavigationHandle.bDebugConstraintsAndGoalEvals = true;
        if (Outer.NavigationHandle.FindPath())
        {
            Outer.DrawDebugLine(HitLoc, Start, 0, 255, 0, true);
            Outer.DrawDebugCoordinateSystem(HitLoc, rot(0, 0, 0), 25.0, true);
            if (bDrawPath)
            {
                Outer.NavigationHandle.DrawPathCache(, true);
            }
        }
        else
        {
            Outer.DrawDebugLine(HitLoc, Start, 255, 0, 0, true);
            Outer.DrawDebugCoordinateSystem(HitLoc, rot(0, 0, 0), 25.0, true);
            Outer.DrawDebugBox(Outer.Pawn.Location, Outer.Pawn.GetCollisionExtent(), 255, 0, 0, true);
        }
    }
}

exec function SetOnlineDebugLevel(int DebugLevel)
{
    if (Outer.OnlineSub != none)
    {
        Outer.OnlineSub.SetDebugSpewLevel(DebugLevel);
    }
}

exec function DumpVoiceMutingState()
{
    local UniqueNetId NetId;
    local PlayerController PC;
    local int MuteIndex;
    
    LogInternal("");
    LogInternal("Voice state");
    LogInternal("-------------------------------------------------------------");
    LogInternal("");
    if (Outer.OnlineSub != none)
    {
        Outer.OnlineSub.DumpVoiceRegistration();
    }
    if (Outer.WorldInfo.NetMode != 3)
    {
        LogInternal("Muting state");
        foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
        {
            LogInternal("  Player: " $ PC.PlayerReplicationInfo.PlayerName);
            LogInternal("    Gameplay mutes: ");
            for (MuteIndex = 0; MuteIndex < PC.GameplayVoiceMuteList.Length; MuteIndex++)
            {
                NetId = PC.GameplayVoiceMuteList[MuteIndex];
                LogInternal("      " $ class'OnlineSubsystem'.static.UniqueNetIdToString(NetId));
            }
            LogInternal("    System mutes: ");
            for (MuteIndex = 0; MuteIndex < PC.VoiceMuteList.Length; MuteIndex++)
            {
                NetId = PC.VoiceMuteList[MuteIndex];
                LogInternal("      " $ class'OnlineSubsystem'.static.UniqueNetIdToString(NetId));
            }
            LogInternal("    Voice packet filter: ");
            for (MuteIndex = 0; MuteIndex < PC.VoicePacketFilter.Length; MuteIndex++)
            {
                NetId = PC.VoicePacketFilter[MuteIndex];
                LogInternal("      " $ class'OnlineSubsystem'.static.UniqueNetIdToString(NetId));
            }
            LogInternal("");
        }
    }
}

exec function DumpOnlineSessionState()
{
    local int PlayerIndex;
    
    if (Outer.WorldInfo.NetMode != 3)
    {
        LogInternal("");
        LogInternal("GameInfo state");
        LogInternal("-------------------------------------------------------------");
        LogInternal("");
        LogInternal("Class: " $ string(Outer.WorldInfo.Game.Class.Name));
        LogInternal("  MaxPlayersAllowed: " $ string(Outer.WorldInfo.Game.MaxPlayersAllowed));
        LogInternal("  MaxPlayers: " $ string(Outer.WorldInfo.Game.MaxPlayers));
        LogInternal("  NumPlayers: " $ string(Outer.WorldInfo.Game.NumPlayers));
        LogInternal("  MaxSpectatorsAllowed: " $ string(Outer.WorldInfo.Game.MaxSpectatorsAllowed));
        LogInternal("  MaxSpectators: " $ string(Outer.WorldInfo.Game.MaxSpectators));
        LogInternal("  NumSpectators: " $ string(Outer.WorldInfo.Game.NumSpectators));
        LogInternal("  NumBots: " $ string(Outer.WorldInfo.Game.NumBots));
        LogInternal("  bUseSeamlessTravel: " $ string(Outer.WorldInfo.Game.bUseSeamlessTravel));
        LogInternal("  bRequiresPushToTalk: " $ string(Outer.WorldInfo.Game.bRequiresPushToTalk));
        LogInternal("  bHasNetworkError: " $ string(Outer.WorldInfo.Game.bHasNetworkError));
        LogInternal("  OnlineGameSettingsClass: " $ string(Outer.WorldInfo.Game.OnlineGameSettingsClass));
        LogInternal("  OnlineStatsWriteClass: " $ string(Outer.WorldInfo.Game.OnlineStatsWriteClass));
        LogInternal("  bUsingArbitration: " $ string(Outer.WorldInfo.Game.bUsingArbitration));
        if (Outer.WorldInfo.Game.bUsingArbitration)
        {
            LogInternal("  bHasArbitratedHandshakeBegun: " $ string(Outer.WorldInfo.Game.bHasArbitratedHandshakeBegun));
            LogInternal("  bNeedsEndGameHandshake: " $ string(Outer.WorldInfo.Game.bNeedsEndGameHandshake));
            LogInternal("  bIsEndGameHandshakeComplete: " $ string(Outer.WorldInfo.Game.bIsEndGameHandshakeComplete));
            LogInternal("  bHasEndGameHandshakeBegun: " $ string(Outer.WorldInfo.Game.bHasEndGameHandshakeBegun));
            LogInternal("  ArbitrationHandshakeTimeout: " $ string(Outer.WorldInfo.Game.ArbitrationHandshakeTimeout));
            LogInternal("  Number of pending arbitration PCs: " $ string(Outer.WorldInfo.Game.PendingArbitrationPCs.Length));
            for (PlayerIndex = 0; PlayerIndex < Outer.WorldInfo.Game.PendingArbitrationPCs.Length; PlayerIndex++)
            {
                LogInternal("    Player: " $ Outer.WorldInfo.Game.PendingArbitrationPCs[PlayerIndex].PlayerReplicationInfo.PlayerName $ " PC (" $ string(Outer.WorldInfo.Game.PendingArbitrationPCs[PlayerIndex].Name) $ ")");
            }
            LogInternal("  Number of arbitration PCs: " $ string(Outer.WorldInfo.Game.ArbitrationPCs.Length));
            for (PlayerIndex = 0; PlayerIndex < Outer.WorldInfo.Game.ArbitrationPCs.Length; PlayerIndex++)
            {
                LogInternal("    Player: " $ Outer.WorldInfo.Game.ArbitrationPCs[PlayerIndex].PlayerReplicationInfo.PlayerName $ " PC (" $ string(Outer.WorldInfo.Game.ArbitrationPCs[PlayerIndex].Name) $ ")");
            }
        }
    }
    Outer.DebugLogPRIs();
    if (Outer.OnlineSub != none)
    {
        Outer.OnlineSub.DumpSessionState();
    }
}

exec function TestLevel()
{
    local Actor A, Found;
    local bool bFoundErrors;
    
    foreach Outer.AllActors(class'Actor', A)
    {
        bFoundErrors = bFoundErrors || A.CheckForErrors();
        if (bFoundErrors && Found == none)
        {
            Found = A;
        }
    }
    if (bFoundErrors)
    {
        LogInternal("Found problem with " $ string(Found));
        assert(false);
    }
}

function EnableDebugCamera()
{
    local Player P;
    local Vector eyeLoc;
    local Rotator eyeRot;
    
    P = Outer.Player;
    if (P != none && Outer.Pawn != none && Outer.IsLocalPlayerController())
    {
        if (DebugCameraControllerRef == none)
        {
            DebugCameraControllerRef = Outer.Spawn(DebugCameraControllerClass);
        }
        DebugCameraControllerRef.OryginalPlayer = P;
        DebugCameraControllerRef.OryginalControllerRef = Outer;
        Outer.GetPlayerViewPoint(eyeLoc, eyeRot);
        DebugCameraControllerRef.SetLocation(eyeLoc);
        DebugCameraControllerRef.SetRotation(eyeRot);
        DebugCameraControllerRef.PlayerCamera.SetFOV(Outer.GetFOVAngle());
        DebugCameraControllerRef.PlayerCamera.UpdateCamera(0.0);
        P.SwitchController(DebugCameraControllerRef);
        DebugCameraControllerRef.OnActivate(Outer);
    }
}

exec function ToggleDebugCamera()
{
    local PlayerController PC;
    local DebugCameraController DCC;
    
    foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (PC.bIsPlayer && PC.IsLocalPlayerController())
        {
            DCC = DebugCameraController(PC);
            if (DCC != none && DCC.OryginalControllerRef == none)
            {
                break;
            }
            break;
        }
    }
    if (DCC != none && DCC.OryginalControllerRef != none)
    {
        DCC.DisableDebugCamera();
    }
    else if (PC != none)
    {
        EnableDebugCamera();
    }
}

exec function StreamLevelOut(name PackageName)
{
    SetLevelStreamingStatus(PackageName, false, false);
}

exec function OnlyLoadLevel(name PackageName)
{
    SetLevelStreamingStatus(PackageName, true, false);
}

exec function StreamLevelIn(name PackageName)
{
    SetLevelStreamingStatus(PackageName, true, true);
}

function SetLevelStreamingStatus(name PackageName, bool bShouldBeLoaded, bool bShouldBeVisible)
{
    local PlayerController PC;
    local int I;
    
    if (PackageName != 'All')
    {
        foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
        {
            PC.ClientUpdateLevelStreamingStatus(PackageName, bShouldBeLoaded, bShouldBeVisible, false);
        }
    }
    else
    {
        foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
        {
            for (I = 0; I < Outer.WorldInfo.StreamingLevels.Length; I++)
            {
                PC.ClientUpdateLevelStreamingStatus(Outer.WorldInfo.StreamingLevels[I].PackageName, bShouldBeLoaded, bShouldBeVisible, false);
            }
        }
    }
}

exec function AllWeapons()
{
}

exec function Loaded()
{
    if (Outer.WorldInfo.NetMode != 0)
    {
        return;
    }
    AllWeapons();
    AllAmmo();
}

exec function ViewClass(class<Actor> aClass)
{
    local Actor Other, first;
    local bool bFound;
    
    first = none;
    foreach Outer.AllActors(aClass, Other)
    {
        if (bFound || first == none)
        {
            first = Other;
            if (bFound)
            {
                break;
            }
        }
        if (Other == Outer.ViewTarget)
        {
            bFound = true;
        }
    }
    if (first != none)
    {
        if (Pawn(first) != none)
        {
            Outer.ClientMessage(ViewingFrom @ first.GetHumanReadableName(), 'Event');
        }
        else
        {
            Outer.ClientMessage(ViewingFrom @ string(first), 'Event');
        }
        Outer.SetViewTarget(first);
        Outer.FixFOV();
    }
    else
    {
        ViewSelf(false);
    }
}

exec function ViewBot()
{
    local Actor first;
    local bool bFound;
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(class'AIController', C)
    {
        if (C.Pawn != none && C.PlayerReplicationInfo != none)
        {
            if (bFound || first == none)
            {
                first = C;
                if (bFound)
                {
                    break;
                }
            }
            if (C.PlayerReplicationInfo == Outer.RealViewTarget)
            {
                bFound = true;
            }
        }
    }
    if (first != none)
    {
        LogInternal("view " $ string(first));
        Outer.SetViewTarget(first);
        Outer.SetCameraMode('ThirdPerson');
        Outer.FixFOV();
    }
    else
    {
        ViewSelf(true);
    }
}

exec function ViewFlag()
{
    local AIController C;
    
    foreach Outer.WorldInfo.AllControllers(class'AIController', C)
    {
        if (C.PlayerReplicationInfo != none && C.PlayerReplicationInfo.bHasFlag)
        {
            Outer.SetViewTarget(C.Pawn);
            return;
        }
    }
}

exec function ViewActor(name actorName)
{
    local Actor A;
    
    foreach Outer.AllActors(class'Actor', A)
    {
        if (A.Name == actorName)
        {
            Outer.SetViewTarget(A);
            Outer.SetCameraMode('ThirdPerson');
            return;
        }
    }
}

exec function ViewPlayer(string S)
{
    local Controller P;
    
    foreach Outer.WorldInfo.AllControllers(class'Controller', P)
    {
        if (P.bIsPlayer && P.PlayerReplicationInfo.PlayerName ~= S)
        {
            break;
        }
    }
    if (P.Pawn != none)
    {
        Outer.ClientMessage(ViewingFrom @ P.PlayerReplicationInfo.PlayerName, 'Event');
        Outer.SetViewTarget(P.Pawn);
    }
}

exec function ViewSelf(optional bool bQuiet)
{
    Outer.ResetCameraMode();
    if (Outer.Pawn != none)
    {
        Outer.SetViewTarget(Outer.Pawn);
    }
    else
    {
        Outer.SetViewTarget(Outer);
    }
    if (!bQuiet)
    {
        Outer.ClientMessage(OwnCamera, 'Event');
    }
    Outer.FixFOV();
}

exec function RememberSpot()
{
    if (Outer.Pawn != none)
    {
        Outer.SetDestinationPosition(Outer.Pawn.Location);
    }
    else
    {
        Outer.SetDestinationPosition(Outer.Location);
    }
}

exec function FractureAllMeshesToMaximizeMemoryUsage()
{
    local FracturedStaticMeshActor FracActor;
    
    foreach Outer.AllActors(class'FracturedStaticMeshActor', FracActor)
    {
        FracActor.HideFragmentsToMaximizeMemoryUsage();
    }
}

exec function FractureAllMeshes()
{
    local FracturedStaticMeshActor FracActor;
    
    foreach Outer.AllActors(class'FracturedStaticMeshActor', FracActor)
    {
        FracActor.HideOneFragment();
    }
}

exec function DestroyFractures(optional float Radius)
{
    local FracturedStaticMeshActor FracActor;
    
    if (Radius == 0.0)
    {
        Radius = 256.0;
    }
    foreach Outer.CollidingActors(class'FracturedStaticMeshActor', FracActor, Radius, Outer.Pawn.Location, true)
    {
        if (FracActor.Physics == 0)
        {
            FracActor.BreakOffPartsInRadius(Outer.Pawn.Location, Radius, 500.0, true);
        }
    }
}

exec function PlayersOnly()
{
    if (Outer.WorldInfo.bPlayersOnly || Outer.WorldInfo.bPlayersOnlyPending)
    {
        Outer.WorldInfo.bPlayersOnly = false;
        Outer.WorldInfo.bPlayersOnlyPending = false;
    }
    else
    {
        Outer.WorldInfo.bPlayersOnlyPending = !Outer.WorldInfo.bPlayersOnlyPending;
    }
}

exec function Weapon GiveWeapon(string WeaponClassStr)
{
    local Weapon Weap;
    local class<Weapon> WeaponClass;
    
    WeaponClass = class<Weapon>(DynamicLoadObject(WeaponClassStr, class'Core.Class'));
    Weap = Weapon(Outer.Pawn.FindInventoryType(WeaponClass));
    if (Weap != none)
    {
        return Weap;
    }
    return Weapon(Outer.Pawn.CreateInventory(WeaponClass));
}

exec function Summon(string ClassName)
{
    local class<Actor> NewClass;
    local Vector SpawnLoc;
    
    LogInternal("Fabricate " $ ClassName);
    NewClass = class<Actor>(DynamicLoadObject(ClassName, class'Core.Class'));
    if (NewClass != none)
    {
        if (Outer.Pawn != none)
        {
            SpawnLoc = Outer.Pawn.Location;
        }
        else
        {
            SpawnLoc = Outer.Location;
        }
        Outer.Spawn(NewClass, , , SpawnLoc + float(72) * vector(Outer.Rotation) + vect(0.0, 0.0, 1.0) * float(15));
    }
}

exec function Avatar(name ClassName)
{
    local Pawn P, TargetPawn, FirstPawn, OldPawn;
    local bool bPickNextPawn;
    
    foreach Outer.DynamicActors(class'Pawn', P)
    {
        if (P == Outer.Pawn)
        {
            bPickNextPawn = true;
            continue;
        }
        if (P.IsA(ClassName))
        {
            if (FirstPawn == none)
            {
                FirstPawn = P;
            }
            if (bPickNextPawn)
            {
                TargetPawn = P;
                break;
            }
        }
    }
    if (TargetPawn == none)
    {
        TargetPawn = FirstPawn;
    }
    if (TargetPawn != none)
    {
        TargetPawn.DetachFromController(true);
        if (Outer.Pawn != none)
        {
            OldPawn = Outer.Pawn;
            Outer.Pawn.DetachFromController();
        }
        Outer.Possess(TargetPawn, false);
        if (OldPawn != none)
        {
            OldPawn.SpawnDefaultController();
        }
    }
    else
    {
        LogInternal("Avatar: Couldn't find any Pawn to possess of class '" $ string(ClassName) $ "'");
    }
}

exec function KillPawns()
{
    KillAllPawns(class'Pawn');
}

function KillAllPawns(class<Pawn> aClass)
{
    local Pawn P;
    
    Outer.WorldInfo.Game.KillBots();
    foreach Outer.DynamicActors(class'Pawn', P)
    {
        if (ClassIsChildOf(P.Class, aClass) && !P.IsPlayerPawn())
        {
            if (P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }
    }
}

exec function KillAll(class<Actor> aClass)
{
    local Actor A;
    local PlayerController PC;
    
    foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
    {
        PC.ClientMessage("Killed all " $ string(aClass));
    }
    if (ClassIsChildOf(aClass, class'AIController'))
    {
        Outer.WorldInfo.Game.KillBots();
        return;
    }
    if (ClassIsChildOf(aClass, class'Pawn'))
    {
        KillAllPawns(class<Pawn>(aClass));
        return;
    }
    foreach Outer.DynamicActors(class'Actor', A)
    {
        if (ClassIsChildOf(A.Class, aClass))
        {
            A.Destroy();
        }
    }
}

exec function SetSpeed(float F)
{
    Outer.Pawn.GroundSpeed = Outer.Pawn.default.GroundSpeed * F;
    Outer.Pawn.WaterSpeed = Outer.Pawn.default.WaterSpeed * F;
}

exec function SetGravity(float F)
{
    Outer.WorldInfo.WorldGravityZ = F;
}

exec function SetJumpZ(float F)
{
    Outer.Pawn.JumpZ = F;
}

exec function Slomo(float T)
{
    Outer.WorldInfo.Game.DebugGameSpeed = T;
}

exec function AffectedByHitEffects()
{
    if (Outer.bAffectedByHitEffects)
    {
        Outer.bAffectedByHitEffects = false;
        Outer.ClientMessage("EffectsAffect mode off");
        return;
    }
    Outer.bAffectedByHitEffects = true;
    Outer.ClientMessage("EffectsAffect Mode on");
}

exec function God()
{
    if (Outer.bGodMode)
    {
        Outer.bGodMode = false;
        Outer.ClientMessage("God mode off");
        return;
    }
    Outer.bGodMode = true;
    Outer.ClientMessage("God Mode on");
}

exec function AllAmmo()
{
}

exec function Ghost()
{
    if (Outer.Pawn != none && Outer.Pawn.CheatGhost())
    {
        Outer.bCheatFlying = true;
        Outer.GotoState('PlayerFlying');
        Outer.Pawn.AirSpeed *= 2.0;
    }
    else
    {
        Outer.bCollideWorld = false;
    }
    Outer.ClientMessage("You feel ethereal");
}

exec function Walk()
{
    Outer.bCheatFlying = false;
    if (Outer.Pawn != none && Outer.Pawn.CheatWalk())
    {
        Outer.Restart(false);
    }
}

exec function Fly()
{
    if (Outer.Pawn != none && Outer.Pawn.CheatFly())
    {
        Outer.ClientMessage("You feel much lighter");
        Outer.bCheatFlying = true;
        Outer.GotoState('PlayerFlying');
    }
}

exec function Amphibious()
{
    Outer.Pawn.UnderWaterTime = 999999.0;
}

exec function EndPath()
{
}

exec function ChangeSize(float F)
{
    Outer.Pawn.CylinderComponent.SetCylinderSize(Outer.Pawn.default.CylinderComponent.CollisionRadius * F, Outer.Pawn.default.CylinderComponent.CollisionHeight * F);
    Outer.Pawn.SetDrawScale(F);
    Outer.Pawn.SetLocation(Outer.Pawn.Location);
}

exec function Teleport()
{
    local Actor HitActor;
    local Vector HitNormal, HitLocation, ViewLocation;
    local Rotator ViewRotation;
    
    Outer.GetPlayerViewPoint(ViewLocation, ViewRotation);
    HitActor = Outer.Trace(HitLocation, HitNormal, ViewLocation + float(1000000) * vector(ViewRotation), ViewLocation, true);
    if (HitActor != none)
    {
        HitLocation += HitNormal * 4.0;
    }
    Outer.ViewTarget.SetLocation(HitLocation);
}

exec function KillViewedActor()
{
    if (Outer.ViewTarget != none)
    {
        if (Pawn(Outer.ViewTarget) != none && Pawn(Outer.ViewTarget).Controller != none)
        {
            Pawn(Outer.ViewTarget).Controller.Destroy();
        }
        Outer.ViewTarget.Destroy();
        Outer.SetViewTarget(none);
    }
}

exec function WriteToLog(string Param)
{
    LogInternal("NOW! " $ Param);
}

exec function SafeFrame()
{
    Outer.myHUD.bShowSafeFrame = !Outer.myHUD.bShowSafeFrame;
}

exec function PerfHUD()
{
    Outer.ConsoleCommand("toggledrawevents");
    Outer.ConsoleCommand("pause");
    Outer.ConsoleCommand("FreezeRendering");
}

exec function NeverPauseCamera()
{
    Outer.WorldInfo.bUpdateCameraInPause = !Outer.WorldInfo.bUpdateCameraInPause;
}

exec function AdvanceFrame()
{
    if (Outer.IsPaused())
    {
        Outer.WorldInfo.bFrameAdvance = true;
    }
}

exec function FreezeFrame(float Delay)
{
    Outer.WorldInfo.Game.SetPause(Outer, Outer.CanUnpause);
    Outer.WorldInfo.PauseDelay = Outer.WorldInfo.TimeSeconds + Delay;
    Outer.myHUD.FlushClientMessages();
}

exec function ToggleScreenLog()
{
    if (Outer.myHUD.bShowScreenLog)
    {
        Outer.myHUD.FlushClientMessages();
    }
    Outer.myHUD.bShowScreenLog = !Outer.myHUD.bShowScreenLog;
}

exec function ListDynamicActors()
{
    local Actor A;
    local int I;
    
    foreach Outer.DynamicActors(class'Actor', A)
    {
        I++;
        LogInternal(string(I) @ string(A));
    }
    LogInternal("Num dynamic actors: " $ string(I));
}

exec function DebugPause()
{
    Outer.WorldInfo.Game.DebugPause();
}

exec function DebugAI(optional coerce name Category)
{
}

exec function FXStop(class<Pawn> aClass)
{
    local Pawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;
    
    if (Outer.WorldInfo.NetMode == 0)
    {
        ClosestPawn = none;
        ClosestPawnDistance = 10000000.0;
        foreach Outer.DynamicActors(class'Pawn', P)
        {
            if (ClassIsChildOf(P.Class, aClass) && P != PlayerController(Outer.Owner).Pawn)
            {
                ThisDistance = VSize(P.Location - PlayerController(Outer.Owner).Pawn.Location);
                if (ThisDistance < ClosestPawnDistance)
                {
                    ClosestPawn = P;
                    ClosestPawnDistance = ThisDistance;
                }
            }
        }
        if (ClosestPawn.Mesh != none)
        {
            ClosestPawn.Mesh.StopFaceFXAnim();
        }
    }
}

exec function FXPlay(class<Pawn> aClass, string FXAnimPath)
{
    local Pawn P, ClosestPawn;
    local float ThisDistance, ClosestPawnDistance;
    local string FxAnimGroup, FxAnimName;
    local int dotPos;
    
    if (Outer.WorldInfo.NetMode == 0)
    {
        ClosestPawn = none;
        ClosestPawnDistance = 10000000.0;
        foreach Outer.DynamicActors(class'Pawn', P)
        {
            if (ClassIsChildOf(P.Class, aClass) && P != PlayerController(Outer.Owner).Pawn)
            {
                ThisDistance = VSize(P.Location - PlayerController(Outer.Owner).Pawn.Location);
                if (ThisDistance < ClosestPawnDistance)
                {
                    ClosestPawn = P;
                    ClosestPawnDistance = ThisDistance;
                }
            }
        }
        if (ClosestPawn.Mesh != none)
        {
            dotPos = InStr(FXAnimPath, ".");
            if (dotPos != -1)
            {
                FxAnimGroup = Left(FXAnimPath, dotPos);
                FxAnimName = Right(FXAnimPath, Len(FXAnimPath) - dotPos - 1);
                ClosestPawn.Mesh.PlayFaceFXAnim(none, FxAnimName, FxAnimGroup, none);
            }
        }
    }
}

defaultproperties
{
    DebugCameraControllerClass="DebugCameraController"
    ViewingFrom="Now viewing from"
    OwnCamera="Now viewing from own camera"
}
