class Weapon extends Inventory
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EWeaponFireType
{
    EWFT_InstantHit,
    EWFT_Projectile,
    EWFT_Custom,
    EWFT_None,
};

var byte CurrentFireMode;
var array<name> FiringStatesArray;
var array<EWeaponFireType> WeaponFireTypes;
var array<class<Projectile>> WeaponProjectiles;
var() array<float> FireInterval;
var(WeaponNoUsingNow) array<float> Spread;
var(WeaponNoUsingNow) array<float> InstantHitDamage;
var(WeaponNoUsingNow) array<float> InstantHitMomentum;
var array<class<DamageType>> InstantHitDamageTypes;
var() float EquipTime;
var() float PutDownTime;
var(WeaponNoUsingNow) Vector FireOffset;
var bool bWeaponPutDown;
var bool bCanThrow;
var bool bWasOptionalSet;
var bool bWasDoNotActivate;
var bool bInstantHit;
var bool bMeleeWeaponAbility;
var() float WeaponRange;
var() float WeaponMeleeRange;
var() export editinline SkeletalMeshComponent Mesh;
var(WeaponNoUsingNow) float DefaultAnimSpeed;
var config databinding float Priority;
var protectedwrite AIController AIController;
var array<byte> ShouldFireOnRelease;
var float AIRating;
var float CachedMaxRange;
var CombatGlobalConfig DefaultCombatGlobalConfig;
var Projectile ProjectileArchetype;

simulated function float GetTargetDistance()
{
    local float VeryFar;
    local Vector HitLocation, HitNormal, projStart, TargetLoc, X, Y, Z;
    local Rotator cameraRot;
    local PlayerController PC;
    
    VeryFar = 32768.0;
    PC = PlayerController(Instigator.Controller);
    PC.GetPlayerViewPoint(projStart, cameraRot);
    GetAxes(cameraRot, X, Y, Z);
    TargetLoc = projStart + X * VeryFar;
    if (none == GetTraceOwner().Trace(HitLocation, HitNormal, TargetLoc, projStart, true, , , 1))
    {
        return VeryFar;
    }
    return (HitLocation - projStart) Dot X;
}

simulated function CacheAIController()
{
    if (Instigator == none)
    {
        AIController = none;
    }
    else
    {
        AIController = AIController(Instigator.Controller);
    }
}

simulated function WeaponIsDown()
{
}

simulated function bool StillFiring(byte FireMode)
{
    return PendingFire(int(FireMode));
}

simulated function bool ShouldRefire()
{
    if (!HasAmmo(CurrentFireMode))
    {
        return false;
    }
    return StillFiring(CurrentFireMode);
}

simulated function NotifyFireSpecialMoveFinished(byte SpMove)
{
}

function NotifyWeaponFinishedFiring(byte FireMode)
{
    if (AIController != none)
    {
        AIController.NotifyWeaponFinishedFiring(self, FireMode);
    }
}

function NotifyWeaponFired(byte FireMode)
{
    if (AIController != none)
    {
        AIController.NotifyWeaponFired(self, FireMode);
    }
}

simulated function HandleFinishedFiring()
{
    GotoState('Active');
}

simulated event ChangeLevel(int Level)
{
}

simulated function bool TryPutDown()
{
    bWeaponPutDown = true;
    return true;
}

native simulated event Vector GetPhysicalFireStartLoc(optional Vector AimDir)
{
    AimDir;
}

simulated event Vector GetMuzzleLoc()
{
    if (Instigator != none)
    {
        return Instigator.GetPawnViewLocation() + (FireOffset >> Instigator.GetViewRotation());
    }
    return Location;
}

simulated function CustomFire()
{
}

simulated function Projectile ProjectileFire()
{
    local Vector StartTrace, EndTrace, RealStartLoc, AimDir;
    local ImpactInfo TestImpact;
    local Projectile SpawnedProjectile;
    
    IncrementFlashCount();
    if (Role == 3)
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        AimDir = vector(GetAdjustedAim(StartTrace));
        RealStartLoc = GetPhysicalFireStartLoc(AimDir);
        if (StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + AimDir * GetTraceRange();
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            if (TestImpact.HitActor != none)
            {
                AimDir = Normal(TestImpact.HitLocation - RealStartLoc);
            }
            else
            {
                AimDir = Normal(EndTrace - RealStartLoc);
            }
        }
        if (ProjectileArchetype != none)
        {
            SpawnedProjectile = Spawn(GetProjectileClass(), self, , RealStartLoc, , ProjectileArchetype);
        }
        else
        {
            SpawnedProjectile = Spawn(GetProjectileClass(), self, , RealStartLoc);
        }
        if (SpawnedProjectile != none && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.InitFromWeaponLevelData(self);
            SpawnedProjectile.Init(AimDir);
        }
        return SpawnedProjectile;
    }
    return none;
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local int TotalDamage;
    local KActorFromStatic NewKActor;
    local StaticMeshComponent HitStaticMesh;
    
    if (Impact.HitActor != none)
    {
        if (Pawn(Impact.HitActor) != none && !Pawn(Impact.HitActor).CanTakeDamage())
        {
            return;
        }
        NumHits = Max(NumHits, 1);
        TotalDamage = int(InstantHitDamage[int(CurrentFireMode)] * float(NumHits));
        if (Impact.HitActor.bWorldGeometry)
        {
            HitStaticMesh = StaticMeshComponent(Impact.HitInfo.HitComponent);
            if (HitStaticMesh != none && HitStaticMesh.CanBecomeDynamic())
            {
                NewKActor = class'KActorFromStatic'.static.MakeDynamic(HitStaticMesh);
                if (NewKActor != none)
                {
                    Impact.HitActor = NewKActor;
                }
            }
        }
        Impact.HitActor.TakeDamage(TotalDamage, Instigator.Controller, Impact.HitLocation, InstantHitMomentum[int(FiringMode)] * Impact.RayDir, InstantHitDamageTypes[int(FiringMode)], Impact.HitInfo, self);
    }
}

simulated function InstantFire()
{
    local Vector StartTrace, EndTrace;
    local array<ImpactInfo> ImpactList;
    local int Idx;
    local ImpactInfo RealImpact;
    
    StartTrace = Instigator.GetWeaponStartTraceLocation();
    EndTrace = StartTrace + vector(GetAdjustedAim(StartTrace)) * GetTraceRange();
    RealImpact = CalcWeaponFire(StartTrace, EndTrace, ImpactList);
    if (Role == 3)
    {
        SetFlashLocation(RealImpact.HitLocation);
    }
    for (Idx = 0; Idx < ImpactList.Length; Idx++)
    {
        ProcessInstantHit(CurrentFireMode, ImpactList[Idx]);
    }
}

static simulated function bool PassThroughDamage(Actor HitActor)
{
    return !HitActor.bBlockActors && HitActor.IsA('Trigger') || HitActor.IsA('TriggerVolume') || HitActor.IsA('InteractiveFoliageActor');
}

simulated function ImpactInfo CalcWeaponFire(Vector StartTrace, Vector EndTrace, optional out array<ImpactInfo> ImpactList, optional Vector Extent)
{
    local Vector HitLocation, HitNormal, Dir;
    local Actor HitActor;
    local TraceHitInfo HitInfo;
    local ImpactInfo CurrentImpact;
    local PortalTeleporter Portal;
    local float HitDist;
    local bool bOldBlockActors, bOldCollideActors;
    
    HitActor = GetTraceOwner().Trace(HitLocation, HitNormal, EndTrace, StartTrace, true, Extent, HitInfo, 1);
    if (HitActor == none)
    {
        HitLocation = EndTrace;
    }
    CurrentImpact.HitActor = HitActor;
    CurrentImpact.HitLocation = HitLocation;
    CurrentImpact.HitNormal = HitNormal;
    CurrentImpact.RayDir = Normal(EndTrace - StartTrace);
    CurrentImpact.StartTrace = StartTrace;
    CurrentImpact.HitInfo = HitInfo;
    ImpactList[ImpactList.Length] = CurrentImpact;
    if (HitActor != none)
    {
        if (PassThroughDamage(HitActor))
        {
            HitActor.bProjTarget = false;
            bOldCollideActors = HitActor.bCollideActors;
            bOldBlockActors = HitActor.bBlockActors;
            if (HitActor.IsA('Pawn'))
            {
                HitActor.SetCollision(false, false);
            }
            else if (bOldBlockActors)
            {
                HitActor.SetCollision(bOldCollideActors, false);
            }
            CurrentImpact = CalcWeaponFire(HitLocation, EndTrace, ImpactList, Extent);
            HitActor.bProjTarget = true;
            HitActor.SetCollision(bOldCollideActors, bOldBlockActors);
        }
        else
        {
            Portal = PortalTeleporter(HitActor);
            if (Portal != none && Portal.SisterPortal != none)
            {
                Dir = EndTrace - StartTrace;
                HitDist = VSize(HitLocation - StartTrace);
                StartTrace = Portal.TransformHitLocation(HitLocation);
                EndTrace = StartTrace + Portal.TransformVectorDir(Normal(Dir) * (VSize(Dir) - HitDist));
                CalcWeaponFire(StartTrace, EndTrace, ImpactList, Extent);
            }
        }
    }
    return CurrentImpact;
}

simulated function Actor GetTraceOwner()
{
    return Instigator != none ? Instigator : self;
}

simulated event float GetTraceRange()
{
    return WeaponRange;
}

simulated function Rotator GetAdjustedAim(Vector StartFireLoc)
{
    local Rotator R;
    
    if (Instigator != none)
    {
        R = Instigator.GetAdjustedAimFor(self, StartFireLoc);
    }
    return AddSpread(R);
}

simulated function FireAmmunition()
{
    ConsumeAmmo(CurrentFireMode);
    PlayFiringSound();
    switch (WeaponFireTypes[int(CurrentFireMode)])
    {
        case 0:
            InstantFire();
            break;
        case 1:
            ProjectileFire();
            break;
        case 2:
            CustomFire();
            break;
        default:
    }
    NotifyWeaponFired(CurrentFireMode);
}

simulated function FireModeUpdated(byte FiringMode, bool bViaReplication)
{
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
    CurrentFireMode = FiringModeNum;
    if (Instigator != none)
    {
        Instigator.SetFiringMode(self, FiringModeNum);
    }
}

simulated function SendToFiringState(byte FireModeNum)
{
    if (int(FireModeNum) >= FiringStatesArray.Length)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Invalid FireModeNum", 'Inventory');
        return;
    }
    if (FiringStatesArray[int(FireModeNum)] == 'None' || WeaponFireTypes[int(FireModeNum)] == 3)
    {
        return;
    }
    SetCurrentFireMode(FireModeNum);
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ string(FireModeNum) @ "Sending to state:" @ string(FiringStatesArray[int(FireModeNum)]), 'Inventory');
    GotoState(FiringStatesArray[int(FireModeNum)]);
}

simulated function ForceEndFire()
{
    local int I;
    
    if (InvManager != none)
    {
        for (I = 0; I < GetPendingFireLength(); I++)
        {
            if (PendingFire(I))
            {
                EndFire(byte(I));
            }
        }
    }
}

simulated function EndFire(byte FireModeNum)
{
    ClearPendingFire(int(FireModeNum));
}

reliable server function ServerStopFire(byte FireModeNum)
{
    EndFire(FireModeNum);
}

simulated function StopFire(byte FireModeNum)
{
    EndFire(FireModeNum);
    if (Role < 3)
    {
        ServerStopFire(FireModeNum);
    }
}

simulated function BeginFire(byte FireModeNum)
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "FireModeNum:" @ string(FireModeNum), 'Inventory');
    SetPendingFire(int(FireModeNum));
}

reliable server function ServerStartFire(byte FireModeNum)
{
    if (Instigator == none || !Instigator.bNoWeaponFiring)
    {
        BeginFire(FireModeNum);
    }
}

simulated function StartFire(byte FireModeNum)
{
    if (Instigator == none || !Instigator.bNoWeaponFiring)
    {
        if (Role < 3)
        {
            ServerStartFire(FireModeNum);
        }
        BeginFire(FireModeNum);
    }
}

simulated function WeaponCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot)
{
}

reliable client simulated function ClientWeaponSet(bool bOptionalSet, optional bool bDoNotActivate)
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "bOptionalSet:" @ string(bOptionalSet) @ "bDoNotActivate:" @ string(bDoNotActivate) @ "Instigator:" @ string(Instigator) @ "InvManager:" @ string(InvManager), 'Inventory');
    bWasOptionalSet = bOptionalSet;
    bWasDoNotActivate = bDoNotActivate;
    if (Instigator == none)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Instigator == None, going to PendingClientWeaponSet", 'Inventory');
        GotoState('PendingClientWeaponSet');
        return;
    }
    if (InvManager == none)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "InvManager == None, going to PendingClientWeaponSet", 'Inventory');
        GotoState('PendingClientWeaponSet');
        return;
    }
    InvManager.ClientWeaponSet(self, bOptionalSet, bDoNotActivate);
}

reliable client simulated function ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    ClientGivenTo(NewOwner, bDoNotActivate);
    ClientWeaponSet(true, bDoNotActivate);
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return FOVAngle;
}

simulated function GetViewAxes(out Vector XAxis, out Vector YAxis, out Vector ZAxis)
{
    local Rotator AimRot;
    
    AimRot = Instigator.GetBaseAimRotation();
    GetAxes(AimRot, XAxis, YAxis, ZAxis);
}

simulated function DetachWeapon()
{
}

simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional name SocketName)
{
}

function ClearFlashLocation()
{
    if (Instigator != none)
    {
        Instigator.ClearFlashLocation(self);
    }
}

function SetFlashLocation(Vector HitLocation)
{
    if (Instigator != none)
    {
        Instigator.SetFlashLocation(self, CurrentFireMode, HitLocation);
    }
}

simulated function ClearFlashCount()
{
    if (Instigator != none)
    {
        Instigator.ClearFlashCount(self);
    }
}

simulated function IncrementFlashCount()
{
    if (Instigator != none)
    {
        Instigator.IncrementFlashCount(self, CurrentFireMode);
    }
}

simulated function WeaponEmpty()
{
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    if (ItemClass == Class)
    {
        return true;
    }
    return false;
}

simulated function PutDownWeapon()
{
    GotoState('WeaponPuttingDown');
}

simulated function Activate()
{
    if (!IsFiring())
    {
        GotoState('WeaponEquipping');
    }
}

simulated function TimeWeaponEquipping()
{
    SetTimer(EquipTime > float(0) ? EquipTime : 0.01, false, 'WeaponEquipped');
}

simulated function TimeWeaponPutDown()
{
    SetTimer(PutDownTime > float(0) ? PutDownTime : 0.01, false, 'WeaponIsDown');
}

simulated function RefireCheckTimer()
{
}

simulated function TimeWeaponFiring(byte FireModeNum)
{
    if (!IsTimerActive('RefireCheckTimer'))
    {
        SetTimer(GetFireInterval(FireModeNum), true, 'RefireCheckTimer');
    }
}

simulated function float GetFireInterval(byte FireModeNum)
{
    return FireInterval[int(FireModeNum)] > float(0) ? FireInterval[int(FireModeNum)] : 0.01;
}

simulated function PlayFiringSound()
{
}

simulated function StopFireEffects(byte FireModeNum)
{
}

simulated function PlayFireEffects(byte FireModeNum, optional Vector HitLocation)
{
}

simulated function StopWeaponAnimation()
{
    local AnimNodeSequence AnimSeq;
    
    if (WorldInfo.NetMode == 1)
    {
        return;
    }
    AnimSeq = GetWeaponAnimNodeSeq();
    if (AnimSeq != none)
    {
        AnimSeq.StopAnim();
    }
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional SkeletalMeshComponent SkelMesh)
{
    local AnimNodeSequence WeapNode;
    local AnimTree Tree;
    
    if (WorldInfo.NetMode == 1)
    {
        return;
    }
    if (SkelMesh == none)
    {
        SkelMesh = Mesh;
    }
    if (SkelMesh == none || GetWeaponAnimNodeSeq() == none)
    {
        return;
    }
    if (fDesiredDuration > 0.0)
    {
        SkelMesh.PlayAnim(Sequence, fDesiredDuration, bLoop);
    }
    else
    {
        Tree = AnimTree(SkelMesh.Animations);
        if (Tree != none)
        {
            WeapNode = AnimNodeSequence(Tree.Children[0].Anim);
        }
        else
        {
            WeapNode = AnimNodeSequence(SkelMesh.Animations);
        }
        WeapNode.SetAnim(Sequence);
        WeapNode.PlayAnim(bLoop, DefaultAnimSpeed);
    }
}

simulated function WeaponPlaySound(SoundCue Sound, optional float NoiseLoudness)
{
    if (Sound == none || Instigator == none)
    {
        return;
    }
    Instigator.PlaySound(Sound, false, true);
}

simulated function AnimNodeSequence GetWeaponAnimNodeSeq()
{
    local AnimTree Tree;
    local AnimNodeSequence AnimSeq;
    local SkeletalMeshComponent SkelMesh;
    
    SkelMesh = Mesh;
    if (SkelMesh != none)
    {
        Tree = AnimTree(SkelMesh.Animations);
        if (Tree != none)
        {
            AnimSeq = AnimNodeSequence(Tree.Children[0].Anim);
        }
        else
        {
            AnimSeq = AnimNodeSequence(SkelMesh.Animations);
        }
        return AnimSeq;
    }
    return none;
}

function bool FireOnRelease()
{
    return ShouldFireOnRelease.Length > 0 && ShouldFireOnRelease[int(CurrentFireMode)] != 0;
}

function float SuggestDefenseStyle()
{
    return 0.0;
}

function float SuggestAttackStyle()
{
    return 0.0;
}

function bool CanAttack(Actor Other)
{
    return true;
}

function float RangedAttackTime()
{
    return 0.0;
}

function bool RecommendLongRangedAttack()
{
    return false;
}

function bool FocusOnLeader(bool bLeaderFiring)
{
    return false;
}

function bool RecommendRangedAttack()
{
    return false;
}

simulated function float GetWeaponRating()
{
    if (InvManager != none)
    {
        return InvManager.GetWeaponRatingFor(self);
    }
    if (!HasAnyAmmo())
    {
        return -1.0;
    }
    return 1.0;
}

function float RelativeStrengthVersus(Pawn P, float Dist)
{
    return 0.0;
}

function float GetAIRating()
{
    return AIRating;
}

function float GetDamageRadius()
{
    local class<Projectile> CurrentProjectileClass;
    
    CurrentProjectileClass = GetProjectileClass();
    if (CurrentProjectileClass == none)
    {
        return 0.0;
    }
    return CurrentProjectileClass.default.default.DamageRadius;
}

simulated function float MaxRange()
{
    local int I;
    
    if (CachedMaxRange > float(0))
    {
        return CachedMaxRange;
    }
    if (bInstantHit)
    {
        CachedMaxRange = WeaponRange;
    }
    for (I = 0; I < WeaponProjectiles.Length; I++)
    {
        if (WeaponProjectiles[I] != none)
        {
            CachedMaxRange = FMax(CachedMaxRange, WeaponProjectiles[I].static.GetRange());
        }
    }
    return CachedMaxRange;
}

simulated function Rotator AddSpread(Rotator BaseAim)
{
    local Vector X, Y, Z;
    local float CurrentSpread, RandY, RandZ;
    
    CurrentSpread = Spread[int(CurrentFireMode)];
    if (CurrentSpread == float(0))
    {
        return BaseAim;
    }
    else
    {
        GetAxes(BaseAim, X, Y, Z);
        RandY = FRand() - 0.5;
        RandZ = Sqrt(0.5 - Square(RandY)) * (FRand() - 0.5);
        return rotator(X + RandY * CurrentSpread * Y + RandZ * CurrentSpread * Z);
    }
}

function class<Projectile> GetProjectileClass()
{
    return int(CurrentFireMode) < WeaponProjectiles.Length ? WeaponProjectiles[int(CurrentFireMode)] : none;
}

final simulated function ClearAllPendingFire()
{
    if (InvManager != none)
    {
        InvManager.ClearAllPendingFire(self);
    }
}

final simulated function ClearPendingFire(int FireMode)
{
    if (InvManager != none)
    {
        InvManager.ClearPendingFire(self, FireMode);
    }
}

final simulated function SetPendingFire(int FireMode)
{
    if (InvManager != none)
    {
        InvManager.SetPendingFire(self, FireMode);
    }
}

final simulated function bool PendingFire(int FireMode)
{
    if (InvManager != none)
    {
        return InvManager.IsPendingFire(self, FireMode);
    }
    return false;
}

final simulated function int GetPendingFireLength()
{
    if (InvManager != none)
    {
        return InvManager.GetPendingFireLength(self);
    }
    return 0;
}

simulated function bool HasAnyAmmo()
{
    return true;
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    return true;
}

final event DebugAddAmmo(int Amount)
{
    AddAmmo(Amount);
}

function int AddAmmo(int Amount)
{
}

function ConsumeAmmo(byte FireModeNum)
{
}

simulated function GetWeaponDebug(out array<string> DebugInfo)
{
    local string T;
    local int I;
    
    DebugInfo[DebugInfo.Length] = "Weapon:" $ GetItemName(string(self)) @ "State:" $ string(GetStateName()) @ "Instigator:" $ string(Instigator) @ "Owner:" $ string(Owner);
    DebugInfo[DebugInfo.Length] = "IsFiring():" $ string(IsFiring()) @ "CurrentFireMode:" $ string(CurrentFireMode) @ "bWeaponPutDown:" $ string(bWeaponPutDown);
    if (Instigator != none)
    {
        DebugInfo[DebugInfo.Length] = "ShotCount:" $ string(Instigator.ShotCount) @ "FlashCount:" $ string(Instigator.FlashCount) @ "FlashLocation:" $ string(Instigator.FlashLocation);
    }
    T = "PendingFires:";
    for (I = 0; I < GetPendingFireLength(); I++)
    {
        T = T $ string(PendingFire(I)) $ " ";
    }
    DebugInfo[DebugInfo.Length] = T;
    if (Timers.Length > 0)
    {
        for (I = 0; I < Timers.Length; I++)
        {
            DebugInfo[DebugInfo.Length] = "Timer" @ string(Timers[I].FuncName) @ string(Timers[I].Count) @ string(Timers[I].Rate) @ string(int(Timers[I].Count / Timers[I].Rate * float(100))) $ "%";
        }
    }
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local array<string> DebugInfo;
    local int I;
    
    GetWeaponDebug(DebugInfo);
    HUD.Canvas.SetDrawColor(0, 255, 0);
    for (I = 0; I < DebugInfo.Length; I++)
    {
        HUD.Canvas.DrawText("  " @ DebugInfo[I]);
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0, out_YPos);
    }
}

simulated function bool DenyClientWeaponSet()
{
    return false;
}

simulated event bool IsFiring()
{
    return false;
}

reliable client simulated function ClientWeaponThrown()
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
    GotoState('Inactive');
    if (Instigator != none && Instigator.Weapon == self)
    {
        Instigator.Weapon = none;
    }
    ForceEndFire();
    DetachWeapon();
}

simulated function bool CanThrow()
{
    return bCanThrow;
}

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    if (!CanThrow())
    {
        return;
    }
    GotoState('Inactive');
    ForceEndFire();
    DetachWeapon();
    DropFrom(StartLocation, StartVelocity);
    AIController = none;
}

simulated function bool DoOverridePrevWeapon()
{
    return false;
}

simulated function bool DoOverrideNextWeapon()
{
    return false;
}

function HolderDied()
{
    ServerStopFire(CurrentFireMode);
}

simulated function bool IsActiveWeapon()
{
    if (InvManager != none)
    {
        return InvManager.IsActiveWeapon(self);
    }
    return false;
}

function ItemRemovedFromInvManager()
{
    LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
    GotoState('Inactive');
    ForceEndFire();
    DetachWeapon();
    ClientWeaponThrown();
    ItemRemovedFromInvManager();
    if (IsActiveWeapon())
    {
        Instigator.Weapon = none;
    }
}

simulated event ParticleSystem GetWeaponLeveDateEffect(int WeaponEffectIndex)
{
}

simulated event ParticleSystem GetWeaponLeveDateTrails()
{
}

simulated event Destroyed()
{
    DetachWeapon();
    Destroyed();
}

state PendingClientWeaponSet
{
    simulated event EndState(name NextStateName)
    {
        ClearTimer('PendingWeaponSetTimer');
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        SetTimer(0.03, true, 'PendingWeaponSetTimer');
    }
    
    simulated function PendingWeaponSetTimer()
    {
        ClientWeaponSet(bWasOptionalSet, bWasDoNotActivate);
    }
    
    Stop;
}

simulated state WeaponPuttingDown
{
    simulated event EndState(name NextStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        ClearTimer('WeaponIsDown');
    }
    
    reliable client simulated function ClientWeaponThrown()
    {
        WeaponIsDown();
        Global.ClientWeaponThrown();
    }
    
    simulated function bool TryPutDown()
    {
        return false;
    }
    
    simulated function WeaponIsDown()
    {
        if (InvManager.CancelWeaponChange())
        {
            return;
        }
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        DetachWeapon();
        GotoState('Inactive');
        InvManager.ChangedWeapon();
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        TimeWeaponPutDown();
        bWeaponPutDown = false;
        ForceEndFire();
    }
    
    Stop;
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        GotoState('Active');
    }
    
    simulated event EndState(name NextStateName)
    {
        ClearTimer('WeaponEquipped');
    }
    
    simulated function Activate()
    {
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        TimeWeaponEquipping();
        bWeaponPutDown = false;
    }
    
    Stop;
}

simulated state WeaponFiring
{
    simulated event EndState(name NextStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "NextStateName:" @ string(NextStateName), 'Inventory');
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        NotifyWeaponFinishedFiring(CurrentFireMode);
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "PreviousStateName:" @ string(PreviousStateName), 'Inventory');
        FireAmmunition();
        TimeWeaponFiring(CurrentFireMode);
    }
    
    simulated function RefireCheckTimer()
    {
        if (bWeaponPutDown)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Weapon put down requested during fire, put it down now", 'Inventory');
            PutDownWeapon();
            return;
        }
        if (ShouldRefire())
        {
            FireAmmunition();
            return;
        }
        HandleFinishedFiring();
    }
    
    simulated event bool IsFiring()
    {
        return true;
    }
    
    Stop;
}

simulated state Active
{
    simulated function bool TryPutDown()
    {
        PutDownWeapon();
        return true;
    }
    
    simulated function Activate()
    {
    }
    
    simulated function bool ReadyToFire(bool bFinished)
    {
        return true;
    }
    
    simulated function BeginFire(byte FireModeNum)
    {
        if (!bDeleteMe && Instigator != none)
        {
            Global.BeginFire(FireModeNum);
            if (PendingFire(int(FireModeNum)) && HasAmmo(FireModeNum))
            {
                SendToFiringState(FireModeNum);
            }
        }
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        local int I;
        
        if (Role == 3)
        {
            CacheAIController();
        }
        if (bWeaponPutDown)
        {
            LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "Weapon put down requested during transition, put it down now", 'Inventory');
            PutDownWeapon();
        }
        else if (!HasAnyAmmo())
        {
            WeaponEmpty();
        }
        else
        {
            for (I = 0; I < GetPendingFireLength(); I++)
            {
                if (PendingFire(I))
                {
                    BeginFire(byte(I));
                    break;
                }
            }
        }
    }
    
    Stop;
}

auto state Inactive
{
    simulated function bool TryPutDown()
    {
        return false;
    }
    
    simulated function StartFire(byte FireModeNum)
    {
    }
    
    reliable server function ServerStopFire(byte FireModeNum)
    {
        ClearPendingFire(int(FireModeNum));
    }
    
    reliable server function ServerStartFire(byte FireModeNum)
    {
        Global.ServerStartFire(FireModeNum);
        WarnInternal(string(WorldInfo.TimeSeconds) @ string(Instigator) @ "received ServerStartFire in Inactive State!!!");
        if (Instigator != none && Instigator.Weapon == self)
        {
            WarnInternal(" - I'm the current weapon, so gotostate active and start firing");
            GotoState('Active');
        }
        else if (InvManager != none && InvManager.PendingWeapon == self)
        {
            if (Instigator.Weapon.IsInState('WeaponPuttingDown'))
            {
                WarnInternal(" - I'm the pending weapon, and current weapon is being put down, so force switch now");
                Instigator.Weapon.WeaponIsDown();
            }
            else
            {
                WarnInternal(" - I'm the pending weapon, but current weapon is NOT being put down, so resync client and server");
                InvManager.SetCurrentWeapon(self);
                InvManager.ServerSetCurrentWeapon(self);
                if (Instigator.Weapon != self && InvManager.PendingWeapon == self && Instigator.Weapon.IsInState('WeaponPuttingDown'))
                {
                    Instigator.Weapon.WeaponIsDown();
                }
            }
        }
        else if (Instigator != none)
        {
            WarnInternal(" - I'm just in the inventory, so resync client and server");
            InvManager.SetCurrentWeapon(self);
            InvManager.ServerSetCurrentWeapon(self);
            if (Instigator.Weapon != self && InvManager.PendingWeapon == self && Instigator.Weapon.IsInState('WeaponPuttingDown'))
            {
                Instigator.Weapon.WeaponIsDown();
            }
        }
    }
    
    simulated event BeginState(name PreviousStateName)
    {
    }
    
    Stop;
}

defaultproperties
{
    EquipTime=0.33
    PutDownTime=0.33
    bCanThrow=True
    WeaponRange=16384.0
    DefaultAnimSpeed=1.0
    Priority=-1.0
    AIRating=0.5
    DefaultCombatGlobalConfig="AliceWeapon_Archetype.CombatGlobalConfig"
    ItemName="Weapon"
    RespawnTime=30.0
    bReplicateInstigator=True
    bOnlyDirtyReplication=False
}
