class WeaponForNPC extends AliceGameWeapon
    abstract
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var() ProjectileLevelDataPackage ProjectData;
var config int DamageForNPCs;
var config int RadiusDamageForNPCs;
var bool CanMeleeHitOtherNPC;
var bool CanRadiusHitOtherNPC;
var transient bool bCannotBeShieldByAlice;

event PlayShieldPhysicsMaterialEffect(Pawn TargetPawn, ShieldTestResult ShieldResult, ShapeCollisionResult CollisionResult)
{
    local Vector ImpactLoc;
    local PhysicalMaterial PM;
    local ParticleSystem ImpactPS, PSFromProjectile;
    local Emitter ImpactEmitter;
    local SoundCue ImpactCue, CueFromWeapon;
    local class<EmitterCameraLensEffectBase> CameraEffect;
    local AlicePawn TargetAlice;
    local SkeletalMeshComponent ShieldMeshComponent;
    local Rotator ImpactRot;
    local bool bHitSpinningUmbrella;
    local int InDLCWeaponFlag, OutDLCMatFlag;
    
    InDLCWeaponFlag = GetDLCWeaponFlag();
    OutDLCMatFlag = 0;
    bHitSpinningUmbrella = false;
    if (TargetPawn == none)
    {
        return;
    }
    TargetAlice = AlicePawn(TargetPawn);
    if (TargetAlice != none)
    {
        bHitSpinningUmbrella = ShieldResult.bSpinningShield;
        ShieldMeshComponent = TargetAlice.Mesh;
        if (CollisionResult.HitBodySetUp != none)
        {
            PM = CollisionResult.HitBodySetUp.PhysMaterial;
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
        ImpactPS = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleForHitSpinningUmbrella(PM, self.Class) : class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticle(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag));
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
        CameraEffect = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag) : class'AlicePhysicalMaterialProperty'.static.DetermineWeaponCameraEffect(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag));
        if (CameraEffect != none)
        {
            if (TargetAlice != none && TargetAlice.Controller != none)
            {
                PlayerController(TargetAlice.Controller).ClientSpawnCameraLensEffect(CameraEffect);
            }
        }
        PSFromProjectile = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeaponForHitSpinningUmbrella(PM, self.Class, GetWeaponLevel()) : class'AlicePhysicalMaterialProperty'.static.DetermineWeaponParticleFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag));
        if (PSFromProjectile != none)
        {
            ImpactEmitter = Spawn(class'Engine.EmitterSpawnable', self, , ImpactLoc);
            if (ImpactEmitter != none)
            {
                ImpactEmitter.SetLocation(ImpactLoc);
                ImpactEmitter.SetTemplate(PSFromProjectile, true);
            }
        }
        ImpactCue = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundForHitSpinningUmbrella(PM, self.Class) : class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSound(PM, self.Class, InDLCWeaponFlag, OutDLCMatFlag));
        PlaySound(ImpactCue);
        CueFromWeapon = (bHitSpinningUmbrella ? class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeaponForHitSpinningUmbrella(PM, self.Class, GetWeaponLevel()) : class'AlicePhysicalMaterialProperty'.static.DetermineWeaponSoundFromWeapon(PM, self.Class, GetWeaponLevel(), InDLCWeaponFlag, OutDLCMatFlag));
        PlaySound(CueFromWeapon);
        return;
    }
}

simulated function NofityNPCRangeFireLauch()
{
    Instigator.StartFire(0);
}

simulated event Vector GetMuzzleLoc()
{
    local Vector OutLocation;
    
    if (Pawn(Owner).Mesh != none)
    {
        Pawn(Owner).Mesh.GetSocketWorldLocationAndRotation(RangeAttackSocket, OutLocation);
        return OutLocation;
    }
    else
    {
        return GetMuzzleLoc();
    }
}

simulated function Projectile ProjectileFire()
{
    local AliceGameProjectile tempProj;
    
    tempProj = AliceGameProjectile(ProjectileFire());
    if (tempProj != none)
    {
        tempProj.WeaponOwner = self;
    }
    return tempProj;
}

simulated event Destroyed()
{
    Mesh = none;
    Destroyed();
}

state NPCWeaponRangeFire
{
    simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
    {
        local AlicePawn ap;
        local Vector FakeRootMotionDirection;
        local Rotator FakeRootMotionRot, DiffRot;
        
        if (Impact.HitActor != none)
        {
            if (AliceGameKynapsePawn(Impact.HitActor) != none)
            {
                return;
            }
            ap = AlicePawn(Impact.HitActor);
            if (ap != none)
            {
                ap.CurrentDmgStrength = InstantHitDamageStrength;
            }
            if (ap != none && ap.Mesh != none && ap.ShouldDoKnockBack(ap.CurrentDmgStrength) && DefaultCombatGlobalConfig.KnockBackParas.Length != 0 && InstantRangeAttackKnockBackParamID >= 0)
            {
                FakeRootMotionDirection = Instigator.Location - ap.Location;
                FakeRootMotionDirection.Z = 0.0;
                FakeRootMotionRot = rotator(FakeRootMotionDirection);
                if (Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw)) > float(0))
                {
                    DiffRot = Normalize(FakeRootMotionRot - Instigator.Rotation);
                    if (DiffRot.Yaw > 0)
                    {
                        FakeRootMotionRot = Normalize(FakeRootMotionRot + MakeRotator(0, int(Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw))), 0));
                    }
                    else
                    {
                        FakeRootMotionRot = Normalize(FakeRootMotionRot + MakeRotator(0, int(-Abs(float(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackRefAngle.Yaw))), 0));
                    }
                }
                if (ap.AbsKnockBackTotalTime >= 0.0 && ap.AbsKnockBackScale >= 0.0)
                {
                    ap.Mesh.SetFakeRootMotionPara(ap.AbsKnockBackScale, ap.AbsKnockBackTotalTime, 10, FakeRootMotionRot);
                    ap.Mesh.ActiveFakeRootMotion();
                    ap.Mesh.FakeRootMotionMode = 3;
                }
                else
                {
                    ap.Mesh.SetFakeRootMotionPara(DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackScale, DefaultCombatGlobalConfig.KnockBackParas[InstantRangeAttackKnockBackParamID].KnockBackTotalTime, 10, FakeRootMotionRot);
                    ap.Mesh.ActiveFakeRootMotion();
                    ap.Mesh.FakeRootMotionMode = 3;
                }
            }
            ProcessInstantHit(FiringMode, Impact, NumHits);
        }
    }
    
    simulated event EndState(name NextStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        NotifyWeaponFinishedFiring(CurrentFireMode);
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        FireAmmunition();
        if (bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        Instigator.StopFire(0);
        HandleFinishedFiring();
    }
    
    simulated event bool IsFiring()
    {
        return true;
    }
    
    Stop;
}

simulated state WeaponPuttingDown
{
    simulated event EndState(name NextStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        bWeaponPutDown = false;
        ForceEndFire();
        WeaponIsDown();
    }
    
    Stop;
}

simulated state WeaponEquipping
{
    simulated event EndState(name NextStateName)
    {
    }
    
    simulated event BeginState(name PreviousStateName)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ "Self:" @ string(self) @ "Instigator:" @ string(Instigator) @ string(GetStateName()) $ "::" $ string(GetFuncName()) @ "", 'Inventory');
        bWeaponPutDown = false;
        WeaponEquipped();
    }
    
    Stop;
}

state NPCWeaponMeleeFire
{
    simulated function BeginFire(byte FireModeNum)
    {
    }
    
    simulated event EndState(name NextStateName)
    {
    }
    
    simulated event BeginState(name PreviousStateName)
    {
    }
    
    simulated event bool IsFiring()
    {
        return true;
    }
    
    Stop;
}

defaultproperties
{
    DamageForNPCs=-1
    RadiusDamageForNPCs=-1
    AmmoCount=999999
    WeaponFireWaveForm="Default__WeaponForNPC.ForceFeedbackWaveformShooting1"
    WeaponFireWaveForm[1]="Default__WeaponForNPC.ForceFeedbackWaveformShooting2"
    MeleeAttackActorList="Default__WeaponForNPC.MeleeAttackActorinfo"
    RadiusAttackActorList="Default__WeaponForNPC.RadiusAttackActorinfo"
    FiringStatesArray(0)="NPCWeaponRangeFire"
    FiringStatesArray(1)="NPCWeaponMeleeFire"
    InstantHitDamage(0)=0.0
    InstantHitDamage(1)=0.0
    WeaponMeleeRange=300.0
    CollisionType="COLLIDE_CustomDefault"
}
