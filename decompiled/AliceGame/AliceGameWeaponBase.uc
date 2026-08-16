class AliceGameWeaponBase extends Weapon
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

enum EWeaponAttackCollisionMode
{
    EWeaponAttackCollisionMode_BodyCylinderComponent,
    EWeaponAttackCollisionMode_BonesAABB,
    EWEaponAttackCollisionMode_BonesShapes,
};

enum EWeaponMeleeAttackMessage
{
    EMeleeAttackMsg_None,
    EMeleeAttackMsg_Active,
    EMeleeAttackMsg_Deactive,
    EMeleeAttackMsg_KeyPoseCheck,
};

enum EWeaponPositionType
{
    EWPT_AttachToSocket,
    EWPT_Independent,
    EWPT_PartOfPawnMesh,
};

struct native MeleeAttackMessage
{
    var EWeaponMeleeAttackMessage MeleeAttackMsg;
    var float MsgTime;
    var() float AttackDamage;
    var() EAnimWeaponAttackCollisionMode WeaponAttackCollisionMode;
    var() EAnimWeaponAttackCollisionMode PawnAttackCollisionMode;
    var() int AttackPhysicsAssetConfigID;
    var() int KnockBackParamConfigID;
    var() float RetriggerTime;
    var() int MaxTriggerCount;
    var() EDamageStrengthType DmgStrength;
    var() ForceFeedbackWaveform FFWaveform;
    var() bool bNPCWeaponCanAttackOtherNPC;
    var() int DamageForNPCs;
    var() bool ActivateOnWeaponHit;
};

struct native ShieldTestResult
{
    var int ShieldIndex;
    var bool bSpinningShield;
};

struct native ShapeCollisionResult
{
    var Vector HitDirection;
    var RB_BodySetup HitBodySetUp;
    var int EffectSocketIndex;
};

var array<MeleeAttackMessage> MeleeAttackMessageArray;
var transient bool bMeleeAttackCollisionTestActive;
var transient bool bNeedMeleeAttackCollisionCheckThisFrame;
var(WeaponCollision) bool bUseBodyCheck;
var bool bNotUsePhysX;
var transient bool BackUpMeleeEnvCollisionResult;
var transient bool bPreCalcAreaCheckSucess;
var transient bool bPreCalcDamageTargetShield;
var transient bool bPreCalcDeathCheckSucess;
var transient bool bPreCalcDeathDamageTargetShield;
var transient bool bRadiusAttackCollisionTestActive;
var transient bool bTraceShieldAngleCheckFromSocket;
var transient bool bUseRadiusZDiffCheck;
var transient bool bTraceAttackLocationOnGround;
var(WeaponCollision) EWeaponPositionType WeaponPositionType;
var EDamageStrengthType CurrentDamageStrength;
var(WeaponCollision) EWeaponAttackCollisionMode SelfCollisionMode;
var(WeaponCollision) EWeaponAttackCollisionMode AttackCollisionMode;
var(InstantFire) EDamageStrengthType InstantHitDamageStrength;
var const int CurrentKnockBackParamID;
var const int CurrentCollisionPhysicsAssetID;
var transient float MeleeAttackRetriggerTime;
var transient int MeleeAttackMaxTriggerCount;
var(WeaponCollision) float SelfCollisionScale;
var(WeaponCollision) float AttackCollisionScale;
var(WeaponCollision) array<PhysicsAsset> SelfCollisionPhysicsAsset;
var(WeaponAnim) AliceGameAnimNode_BlendBySlot_Weapon SlotNode;
var export editinline AttackActorInfo MeleeAttackActorList;
var export editinline AttackActorInfo RadiusAttackActorList;
var transient Vector BackUpMeleeEnvCollisionLocation;
var(InstantFire) int InstantRangeAttackKnockBackParamID;
var() float RagdollImpulseScale;
var transient float PreCalcDist;
var transient Rotator PreCalcAngle;
var transient int PreCalcDamageShieldIndex;
var transient Pawn PreCalcDamageTarget;
var transient int PreCalcDeathDamageShieldIndex;
var transient Pawn PreCalcDeathDamageTarget;
var transient name RadiusAttackSocket;
var transient float RadiusDamageLeftTime;
var transient float RadiusDamageLength;
var transient float RadiusDamageValue;
var transient float RadiusDamageRetriggerTime;
var transient int RadiusDamageMaxTriggerCount;
var transient Vector RadiusAttackLocation;
var transient float RadiusZDiffCheckHeight;
var transient float TraceGroundZDiff;

simulated event TriggerRadiusDamageLight()
{
}

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
    local int TotalDamage;
    
    if (Impact.HitActor != none)
    {
        if (Pawn(Impact.HitActor) != none && !Pawn(Impact.HitActor).CanTakeDamage())
        {
            return;
        }
        NumHits = Max(NumHits, 1);
        TotalDamage = int(InstantHitDamage[int(CurrentFireMode)] * float(NumHits));
        Impact.HitActor.TakeDamage(TotalDamage, Instigator.Controller, Impact.HitLocation, InstantHitMomentum[int(FiringMode)] * Impact.RayDir, InstantHitDamageTypes[int(FiringMode)], Impact.HitInfo, self);
    }
}

function ShowWeaponHitInfo(Vector HitLocation, Vector HitNormal)
{
    local Vector Origin, vDirection, LineEnd;
    local float ConeLength, AngleWidth, AngleHeight, LineLength;
    local int NumSides;
    local Color DrawColor;
    
    if (AliceCheatManager(AlicePlayerController(AlicePawn(Instigator).Controller).CheatManager).bShowHitInfo)
    {
        if (VSize(HitNormal) == float(0))
        {
            DrawDebugLine(HitLocation, HitLocation + vect(0.0, 0.0, 1.0) * float(2000), 255, 0, 0, true);
        }
        else
        {
            LineLength = 200.0;
            LineEnd = HitLocation + HitNormal * LineLength;
            DrawDebugLine(HitLocation, LineEnd, 0, 255, 0, true);
            ConeLength = 10.0;
            Origin = LineEnd + HitNormal * ConeLength;
            vDirection = -HitNormal;
            AngleWidth = 30.0 * (3.1415927 / 180.0);
            AngleHeight = 30.0 * (3.1415927 / 180.0);
            NumSides = 8;
            DrawColor.R = 0;
            DrawColor.G = 255;
            DrawColor.B = 0;
            DrawDebugCone(Origin, vDirection, ConeLength, AngleWidth, AngleHeight, NumSides, DrawColor, true);
        }
    }
}

event SetWeaponEnviorCollision(bool bEnable)
{
    local AlicePlayerController APC;
    
    APC = AlicePlayerController(AlicePawn(Instigator).Controller);
    if (APC != none)
    {
        APC.SetWeaponEnviormentCollision(bEnable);
    }
}

event bool IsEnableWeaponEnviorCollision()
{
    local AlicePlayerController APC;
    
    if (Instigator == none || AlicePawn(Instigator) == none)
    {
        return false;
    }
    APC = AlicePlayerController(AlicePawn(Instigator).Controller);
    if (APC != none)
    {
        return APC.bEnableWeaponEnviormentCollision;
    }
    return false;
}

function int GetWeaponLevel()
{
    return 0;
}

simulated function InstantFire()
{
    InstantFire();
}

function PhysicalMaterial GetWeaponHitPhysMat(PhysicalMaterial HitMaterial, Actor HitActor)
{
    if (HitMaterial != none)
    {
        return HitMaterial;
    }
    else if (HitActor.IsA('InterpActor'))
    {
        return class'AlicePhysicalMaterialProperty'.static.GetPhysMatFromInterpActor(InterpActor(HitActor));
    }
    else if (HitActor.IsA('GameBreakableActor'))
    {
        return class'AlicePhysicalMaterialProperty'.static.GetPhysMatFromBreakableActor(GameBreakableActor(HitActor));
    }
}

event PlayPhysicalMaterialHitWall(Vector HitLocation, Vector HitNormal, PhysicalMaterial HitMaterial, Actor HitActor)
{
    local Vector NewHitLocation, NewHitNormal;
    local ParticleSystem ImpactPS, PSFromWeapon;
    local EmitterSpawnable ImpactEmitter;
    local PhysicalMaterial PM, outPM;
    local SoundCue ImpactCue;
    local DecalData DecalData;
    local MaterialInstanceTimeVarying MITV_Decal;
    local int bProjectOnSurface, FXIndex, I;
    local float ProjectionDistance;
    local array<int> DecalBuffer;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    ShowWeaponHitInfo(HitLocation, HitNormal);
    PM = GetWeaponHitPhysMat(HitMaterial, HitActor);
    if (PM == none)
    {
        return;
    }
    WorldInfo.LogPhysMatInfo("FXInfoWeapon", string(Name), string(PM.Name));
    NewHitLocation = HitLocation;
    NewHitNormal = HitNormal;
    ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    if (ImpactPS != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , NewHitLocation);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(NewHitLocation);
            ImpactEmitter.SetTemplate(ImpactPS, true);
            ImpactEmitter.SetRotation(rotator(HitNormal));
        }
    }
    ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(ImpactCue);
    PSFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
    if (PSFromWeapon != none)
    {
        ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , NewHitLocation);
        if (ImpactEmitter != none)
        {
            ImpactEmitter.SetLocation(NewHitLocation);
            ImpactEmitter.SetTemplate(PSFromWeapon, true);
            ImpactEmitter.SetRotation(rotator(HitNormal));
        }
    }
    ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
    PlaySound(ImpactCue);
    class'AlicePhysicalMaterialProperty'.static.DetermineWeaponDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
    if (GetWeaponLevel() == 0)
    {
        if (DecalBuffer.Length > 0)
        {
            DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, Rand(DecalBuffer.Length), bProjectOnSurface, ProjectionDistance);
            if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
            {
                if (DecalData.DecalMaterial != none)
                {
                    if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                    {
                        MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                        MITV_Decal.SetParent(DecalData.DecalMaterial);
                        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, NewHitLocation, rotator(-NewHitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                        MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                    }
                    else
                    {
                        WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, NewHitLocation, rotator(-NewHitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
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
            if (DecalData.bIsValid && DecalData.Width != float(0) && DecalData.Height != float(0))
            {
                if (DecalData.DecalMaterial != none)
                {
                    if (MaterialInstanceTimeVarying(DecalData.DecalMaterial) != none)
                    {
                        MITV_Decal = new(none) class'Engine.MaterialInstanceTimeVarying';
                        MITV_Decal.SetParent(DecalData.DecalMaterial);
                        WorldInfo.MyDecalManager.SpawnDecal(MITV_Decal, NewHitLocation, rotator(-NewHitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, false, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                        MITV_Decal.SetScalarStartTime('FadeOut', 0.0);
                        continue;
                    }
                    WorldInfo.MyDecalManager.SpawnDecal(DecalData.DecalMaterial, NewHitLocation, rotator(-NewHitNormal), DecalData.Width, DecalData.Height, DecalData.Thickness, true, DecalData.bRandomizeRotation ? FRand() * 360.0 : 0.0, , , , , , , DecalData.LifeSpan, , , DecalData.BlendRange);
                }
            }
        }
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
    local bool bNPCWeaponHitNPC;
    
    bNPCWeaponHitNPC = WeaponForNPC(self) != none && AliceGameKynapsePawn(TargetPawn) != none;
    InDLCWeaponFlag = GetDLCWeaponFlag();
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
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            class'AlicePhysicalMaterialProperty'.static.DetermineWeaponDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
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
        }
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
            if (ImpactPS != none)
            {
                TargetPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot);
                ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
                if (ImpactEmitter != none)
                {
                    ImpactEmitter.SetLocation(ImpactLoc);
                    ImpactEmitter.SetRotation(ImpactRot);
                    ImpactEmitter.SetTemplate(ImpactPS, true);
                }
            }
        }
        CameraEffect = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        if (CameraEffect != none)
        {
            ap = AlicePawn(TargetPawn);
            if (ap != none && ap.Controller != none)
            {
                PlayerController(ap.Controller).ClientSpawnCameraLensEffect(CameraEffect);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        if (PSFromProjectile != none)
        {
            ImpactLoc = TargetPawn.Location;
            ImpactRot = rot(0, 0, 1);
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc, ImpactRot);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetRotation(ImpactRot);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
            PlaySound(ImpactCue);
        }
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
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
        SocketName = CollisionResult.HitBodySetUp.EffectSocketNameArray[CollisionResult.EffectSocketIndex];
        if (CollisionResult.EffectSocketIndex == -1 || !TargetPawn.Mesh.GetSocketWorldLocationAndRotation(SocketName, ImpactLoc, ImpactRot))
        {
            ImpactLoc = TargetPawn.Mesh.GetBoneLocation(CollisionResult.HitBodySetUp.BoneName);
            ImpactRot = rot(0, 0, 1);
        }
        WorldInfo.LogPhysMatInfo("FXInfoWeapon", string(Name), string(PM.Name));
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            class'AlicePhysicalMaterialProperty'.static.DetermineWeaponDecalData(PM, self.Class, InDLCWeaponFlag, outPM, FXIndex, OutDLCMatFlag, GetWeaponLevel(), DecalBuffer);
            if (GetWeaponLevel() == 0)
            {
                if (DecalBuffer.Length > 0)
                {
                    DecalData = class'AlicePhysicalMaterialProperty'.static.GetWeaponDecalData(OutDLCMatFlag, outPM, FXIndex, Rand(DecalBuffer.Length), bProjectOnSurface, ProjectionDistance);
                    if (DecalData.bIsValid)
                    {
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
        }
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            ImpactPS = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
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
        }
        CameraEffect = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
        if (CameraEffect != none)
        {
            ap = AlicePawn(TargetPawn);
            if (ap != none && ap.Controller != none)
            {
                PlayerController(ap.Controller).ClientSpawnCameraLensEffect(CameraEffect);
            }
        }
        PSFromProjectile = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
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
        if (!(bRadiusAttack && HobbyHorse(self) != none || bNPCWeaponHitNPC))
        {
            ImpactCue = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag);
            PlaySound(ImpactCue);
        }
        CueFromWeapon = class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag);
        PlaySound(CueFromWeapon);
    }
}

event PlayMeleeAttackEffectOnAttachedActor(AliceGameNPCAttachedActor AttachedActor, ShapeCollisionResult CollisionResult)
{
}

event PlayShieldPhysicsMaterialEffect(Pawn TargetPawn, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult)
{
}

event PostBeginPlay()
{
    PostBeginPlay();
    MeleeAttackActorList.Reset();
    RadiusAttackActorList.Reset();
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBySlot_Weapon Node;
    local SkeletalMeshComponent SkelComp;
    
    SlotNode = none;
    SkelComp = Mesh;
    if (SkelComp != none)
    {
        if (SkelComp.Animations == none && SkelComp.AnimTreeTemplate != none)
        {
            SkelComp.SetAnimTreeTemplate(SkelComp.AnimTreeTemplate);
        }
        foreach SkelComp.AllAnimNodes(class'AliceGameAnimNode_BlendBySlot_Weapon', Node)
        {
            switch (Node.NodeName)
            {
                case 'Slot_Main':
                    SlotNode = Node;
                    continue;
                default:
            }
        }
    }
}

simulated function SkeletalMeshComponent GetMuzzleSocketMesh()
{
    return GetWeaponMesh();
}

simulated function int GetDLCWeaponFlag()
{
    return 0;
}

native simulated function bool CanPredictMeleeAttackPawn(Pawn TargetPawn)
{
    TargetPawn;
}

native simulated function bool CanRadiusAttackActor(Actor TargetActor)
{
    TargetActor;
}

native simulated function bool CanMeleeAttackActor(Actor TargetActor)
{
    TargetActor;
}

native simulated function bool ShouldTriggerKnockback(Pawn TargetPawn)
{
    TargetPawn;
}

native simulated function MeleeAttackEnviormentCollisionCheck()
{
}

native simulated function SkeletalMeshComponent GetWeaponMesh()
{
}

native simulated function StopWeaponSlotAnim(float BlendOutTime)
{
    BlendOutTime;
}

native simulated function PlayWeaponSlotAnim(name Sequence, optional float fDesiredRate, optional bool bLoop, optional float BlendInTime, optional float BlendOutTime)
{
    Sequence;
    fDesiredRate;
    bLoop;
    BlendInTime;
    BlendOutTime;
}

native final function SendKeyPoseMeleeAttackCollisionMessage(optional float MsgTime = -1.0)
{
    MsgTime;
}

native final function SendDeactiveMeleeAttackMessage(optional float MsgTime = -1.0)
{
    MsgTime;
}

native final function SendActiveMeleeAttackMessage(out MeleeAttackMessage ActiveMsg)
{
    ActiveMsg;
}

native final function ScriptPreAttackHit(Pawn HitPawn, optional int hitCount = 1, optional bool bInShield = false, optional int ShieldIndex = -1)
{
    HitPawn;
    hitCount;
    bInShield;
    ShieldIndex;
}

native final function AttachWeaponToInstigatorMeshSocket(optional name SocketName)
{
    SocketName;
}

defaultproperties
{
    bNotUsePhysX=True
    SelfCollisionMode="EWeaponAttackCollisionMode_BonesAABB"
    AttackCollisionMode="EWeaponAttackCollisionMode_BonesAABB"
    CurrentKnockBackParamID=-1
    MeleeAttackActorList="Default__AliceGameWeaponBase.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__AliceGameWeaponBase.RadiusAttackActorinfo"
    InstantRangeAttackKnockBackParamID=-1
    RagdollImpulseScale=100.0
}
