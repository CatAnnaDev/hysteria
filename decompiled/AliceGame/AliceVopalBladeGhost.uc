class AliceVopalBladeGhost extends Actor
    native
    notplaceable
    hidecategories(Navigation);

var ParticleSystem GhostFlightEffectsTemplate;
var export editinline ParticleSystemComponent GhostFlightEffects;
var AliceGameWeaponBase WeaponOwner;
var transient Vector BeginLocation;
var transient Rotator BeginRotation;
var transient float MaxAttackLength;
var export editinline AliceGameProjectileTrace_VBGhost GhostTrace;
var transient EDamageStrengthType GhostDmgStrength;
var class<DamageType> GhostDmgType;
var class<AliceGameWeaponBase> DummyWeaponClass;
var float DamageValue;

function int GetWeaponLevel()
{
    return 1;
}

event PlayShieldPhysicsMaterialEffect(Pawn TargetPawn, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult)
{
    local Vector ImpactLoc;
    local PhysicalMaterial PM;
    local ParticleSystem ImpactPS, PSFromProjectile;
    local Emitter ImpactEmitter;
    local SoundCue ImpactCue, CueFromWeapon;
    local AliceGameKynapsePawn TargetNPC;
    local SkeletalMeshComponent ShieldMeshComponent;
    local Rotator ImpactRot;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = 0;
    InDLCWeaponFlag = AlicePawn(Instigator).GetVorpalBlade().GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (TargetPawn == none)
    {
        return;
    }
    TargetNPC = AliceGameKynapsePawn(TargetPawn);
    if (TargetNPC != none && ShieldResult.ShieldIndex >= 0 && ShieldResult.ShieldIndex < TargetNPC.ShieldComponentsArray.Length)
    {
        ShieldMeshComponent = TargetNPC.NPCAttachmentComponentsArray[TargetNPC.ShieldComponentsArray[ShieldResult.ShieldIndex].ComponentIndex].CurrentAttachmentMeshComponent;
        if (TargetNPC != none && ShieldResult.ShieldIndex >= 0 && ShieldResult.ShieldIndex < TargetNPC.ShieldComponentsArray.Length)
        {
            if (CollisionResult.HitBodySetUp != none)
            {
                PM = CollisionResult.HitBodySetUp.PhysMaterial;
            }
        }
        if (CollisionResult.EffectSocketIndex == -1 || !ShieldMeshComponent.GetSocketWorldLocationAndRotation(CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex], ImpactLoc, ImpactRot))
        {
            ImpactLoc = ShieldMeshComponent.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            ImpactRot = rot(0, 0, 1);
        }
        if (PM == none)
        {
            return;
        }
        ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        if (ImpactPS != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(ImpactPS, true);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(ImpactCue);
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
        return;
    }
}

event PlayPhysicalMaterialEffect(Pawn TargetPawn, ShapeCollisionResult CollisionResult, bool bRadiusAttack)
{
    local Vector ImpactLoc;
    local Rotator ImpactRot;
    local PhysicalMaterial PM, outPM;
    local ParticleSystem ImpactPS, PSFromProjectile;
    local Emitter ImpactEmitter;
    local SoundCue ImpactCue, CueFromWeapon;
    local name SocketName;
    local class<EmitterCameraLensEffectBase> CameraEffect;
    local AlicePawn ap;
    local DecalData DecalData;
    local AliceGamePawn AGPawn;
    local int bProjectOnSurface, FXIndex, I;
    local float ProjectionDistance;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = 0;
    InDLCWeaponFlag = AlicePawn(Instigator).GetVorpalBlade().GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    if (TargetPawn == none)
    {
        return;
    }
    if (CollisionResult.HitBodySetUp.BoneName == 'None' || CollisionResult.HitBodySetUp.PhysMaterial == none)
    {
        PM = AliceGameKynapsePawn(TargetPawn).PhysMaterial;
        if (PM != none)
        {
            SocketName = AliceGameKynapsePawn(TargetPawn).PhysicalMaterialSocket;
        }
        else
        {
            PM = AlicePawn(TargetPawn).PhysMaterial;
            if (PM != none)
            {
                SocketName = AlicePawn(TargetPawn).PhysicalMaterialSocket;
            }
            else
            {
                return;
            }
        }
        if (PM != none)
        {
            WorldInfo.LogPhysMatInfo("FXInfoWeapon", string(Name), string(PM.Name));
        }
        class'AlicePhysicalMaterialProperty'.static.DetermineWeaponDecalData(PM, DummyWeaponClass, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
        if (GetWeaponLevel() == 0)
        {
            if (DecalBuffer.Length > 0)
            {
                DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, Rand(DecalBuffer.Length), bProjectOnSurface, ProjectionDistance);
                if (DecalData.bIsValid)
                {
                    TargetPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
                    if (DecalData.DecalMaterial != none && TargetPawn != none)
                    {
                        AGPawn = AliceGamePawn(TargetPawn);
                        if (AGPawn != none)
                        {
                            AGPawn.LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, 'None', DecalData);
                            if (bool(bProjectOnSurface))
                            {
                                AGPawn.LeaveDecal360AroundPawn(DecalData, ProjectionDistance);
                            }
                        }
                    }
                }
            }
        }
        else
        {
            foreach DecalBuffer(I)
            {
                DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
                if (DecalData.bIsValid)
                {
                    TargetPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
                    if (DecalData.DecalMaterial != none && TargetPawn != none)
                    {
                        AGPawn = AliceGamePawn(TargetPawn);
                        if (AGPawn != none)
                        {
                            AGPawn.LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, 'None', DecalData);
                            if (bool(bProjectOnSurface))
                            {
                                AGPawn.LeaveDecal360AroundPawn(DecalData, ProjectionDistance);
                            }
                        }
                    }
                }
            }
        }
        CameraEffect = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        if (CameraEffect != none)
        {
            ap = AlicePawn(TargetPawn);
            if (ap != none && ap.Controller != none)
            {
                PlayerController(ap.Controller).ClientSpawnCameraLensEffect(CameraEffect);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactLoc = TargetPawn.Location;
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(ImpactCue);
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
        return;
    }
    else
    {
        PM = CollisionResult.HitBodySetUp.PhysMaterial;
        if (PM == none)
        {
            return;
        }
        if (CollisionResult.EffectSocketIndex == -1 || !TargetPawn.Mesh.GetSocketWorldLocationAndRotation(CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex], ImpactLoc, ImpactRot))
        {
            ImpactLoc = TargetPawn.Mesh.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            ImpactRot = rot(0, 0, 1);
        }
        WorldInfo.LogPhysMatInfo("FXInfoWeapon", string(Name), string(PM.Name));
        class'AlicePhysicalMaterialProperty'.static.DetermineWeaponDecalData(PM, DummyWeaponClass, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
        if (GetWeaponLevel() == 0)
        {
            if (DecalBuffer.Length > 0)
            {
                DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, Rand(DecalBuffer.Length), bProjectOnSurface, ProjectionDistance);
                if (DecalData.bIsValid)
                {
                    TargetPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
                    if (DecalData.DecalMaterial != none && TargetPawn != none)
                    {
                        AGPawn = AliceGamePawn(TargetPawn);
                        if (AGPawn != none)
                        {
                            AGPawn.LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, 'None', DecalData);
                            if (bool(bProjectOnSurface))
                            {
                                AGPawn.LeaveDecal360AroundPawn(DecalData, ProjectionDistance);
                            }
                        }
                    }
                }
            }
        }
        else
        {
            foreach DecalBuffer(I)
            {
                DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, I, bProjectOnSurface, ProjectionDistance);
                if (DecalData.bIsValid)
                {
                    if (DecalData.DecalMaterial != none && TargetPawn != none)
                    {
                        AGPawn = AliceGamePawn(TargetPawn);
                        if (AGPawn != none)
                        {
                            AGPawn.LeaveDecalOnPawn(ImpactLoc, ImpactRot, none, CollisionResult.HitBodySetUp.BoneName, DecalData);
                            if (bool(bProjectOnSurface))
                            {
                                AGPawn.LeaveDecal360AroundPawn(DecalData, ProjectionDistance);
                            }
                        }
                    }
                }
            }
        }
        ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        if (ImpactPS != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(ImpactPS, true);
            }
        }
        CameraEffect = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        if (CameraEffect != none)
        {
            ap = AlicePawn(TargetPawn);
            if (ap != none && ap.Controller != none)
            {
                PlayerController(ap.Controller).ClientSpawnCameraLensEffect(CameraEffect);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, DummyWeaponClass, InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(ImpactCue);
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, DummyWeaponClass, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
    }
}

simulated function Destroyed()
{
    Destroyed();
    if (GhostTrace != none)
    {
        GhostTrace.TargetEnemyActor = none;
        GhostTrace = none;
    }
}

simulated function ShutDown()
{
    SetPhysics(0);
    GhostFlightEffects.DeactivateSystem();
    HideProjectile();
    SetCollision(false, false);
    if (bNetTemporary)
    {
        if (WorldInfo.NetMode == 1)
        {
            Destroy();
        }
        else
        {
            RemoteRole = 0;
            LifeSpan = FMax(LifeSpan, 2.0);
        }
    }
    else
    {
        bTearOff = true;
        if (WorldInfo.NetMode == 1)
        {
            LifeSpan = 0.15;
        }
        else
        {
            LifeSpan = FMax(LifeSpan, 2.0);
        }
    }
}

simulated function HideProjectile()
{
    local MeshComponent ComponentIt;
    
    foreach ComponentList(class'Engine.MeshComponent', ComponentIt)
    {
        ComponentIt.SetHidden(true);
    }
}

simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor TargetActor = none)
{
    ShutDown();
}

simulated function MyOnParticleSystemFinished(ParticleSystemComponent PSC)
{
}

event SpawnFlightEffects()
{
    GhostFlightEffects.SetTemplate(GhostFlightEffectsTemplate);
    GhostFlightEffects.SetAbsolute(false, false, false);
    GhostFlightEffects.SetLODLevel(WorldInfo.bDropDetail ? 1 : 0);
    GhostFlightEffects.__OnSystemFinished__Delegate = MyOnParticleSystemFinished;
    GhostFlightEffects.bUpdateComponentInTick = true;
    AttachComponent(GhostFlightEffects);
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    SpawnFlightEffects();
}

native final function GhostDamage(Actor Target)
{
    Target;
}

native final function FlightParaInit()
{
}

defaultproperties
{
    GhostFlightEffects="Default__AliceVopalBladeGhost.Particle"
    GhostTrace="Default__AliceVopalBladeGhost.VopalBladeGhostTrace"
    GhostDmgType="DmgType_VorpalBladeGhost"
    DummyWeaponClass="AliceVopalBladeGhostDummyWeapon"
    Physics="PHYS_Projectile"
    LifeSpan=14.0
}
