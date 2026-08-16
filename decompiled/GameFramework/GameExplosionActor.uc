class GameExplosionActor extends Actor
    native
    notplaceable
    config(Weapon)
    hidecategories(Navigation);

var transient bool bHasExploded;
var bool bActiveReloadBonusActive;
var bool bDrawDebug;
var transient export editinline PointLightComponent ExplosionLight;
var transient float LightFadeTime;
var transient float LightFadeTimeRemaining;
var transient float LightInitialBrightness;
var transient export editinline RadialBlurComponent ExplosionRadialBlur;
var transient float RadialBlurFadeTime;
var transient float RadialBlurFadeTimeRemaining;
var transient float RadialBlurMaxBlurAmount;
var GameExplosion ExplosionTemplate;
var export editinline RB_RadialImpulseComponent RadialImpulseComponent;
var Controller InstigatorController;
var Actor HitActorFromPhysMaterialTrace;
var Vector HitLocationFromPhysMaterialTrace;
var transient float DirectionalExplosionMinDot;
var transient repretry Vector ExplosionDirection;

replication
{
    if (bNetInitial)
        ExplosionDirection;
}

protected simulated function CameraShake ChooseCameraShake(Vector Epicenter, PlayerController PC)
{
    local Vector CamX, CamY, CamZ, ToEpicenter;
    local float FwdDot, RtDot;
    local CameraShake ChosenShake;
    local Rotator NoPitchRot;
    
    if (ExplosionTemplate.bOrientCameraShakeTowardsEpicenter)
    {
        return ExplosionTemplate.CamShake;
    }
    else if (ExplosionTemplate.CamShake_Left != none || ExplosionTemplate.CamShake_Right != none || ExplosionTemplate.CamShake_Rear != none)
    {
        ToEpicenter = Epicenter - PC.PlayerCamera.Location;
        ToEpicenter.Z = 0.0;
        ToEpicenter = Normal(ToEpicenter);
        NoPitchRot = PC.PlayerCamera.Rotation;
        NoPitchRot.Pitch = 0;
        GetAxes(NoPitchRot, CamX, CamY, CamZ);
        FwdDot = CamX Dot ToEpicenter;
        if (FwdDot > 0.707)
        {
            ChosenShake = ExplosionTemplate.CamShake;
        }
        else if (FwdDot > -0.707)
        {
            RtDot = CamY Dot ToEpicenter;
            ChosenShake = (RtDot > 0.0 ? ExplosionTemplate.CamShake_Right : ExplosionTemplate.CamShake_Left);
        }
        else
        {
            ChosenShake = ExplosionTemplate.CamShake_Rear;
        }
    }
    if (ChosenShake == none)
    {
        ChosenShake = ExplosionTemplate.CamShake;
    }
    return ChosenShake;
}

simulated function SpawnCameraLensEffects()
{
    local PlayerController PC;
    
    if (ExplosionTemplate.CameraLensEffect != none)
    {
        foreach WorldInfo.LocalPlayerControllers(class'Engine.PlayerController', PC)
        {
            if (PC.Pawn != none && VSize(PC.Pawn.Location - Location) < ExplosionTemplate.CameraLensEffectRadius && PC.IsAimingAt(self, 0.1) && !IsBehindExplosion(PC.Pawn))
            {
                PC.ClientSpawnCameraLensEffect(ExplosionTemplate.CameraLensEffect);
            }
        }
    }
}

simulated function DoExplosionCameraEffects()
{
    local CameraShake Shake;
    local float ShakeScale;
    local PlayerController PC;
    
    foreach WorldInfo.LocalPlayerControllers(class'Engine.PlayerController', PC)
    {
        if (PC.PlayerCamera != none)
        {
            Shake = ChooseCameraShake(Location, PC);
            if (Shake != none)
            {
                ShakeScale = PC.PlayerCamera.CalcRadialShakeScale(PC.PlayerCamera, Location, ExplosionTemplate.CamShakeInnerRadius, ExplosionTemplate.CamShakeOuterRadius, ExplosionTemplate.CamShakeFalloff);
                if (ExplosionTemplate.bOrientCameraShakeTowardsEpicenter)
                {
                    PC.ClientPlayCameraShake(Shake, ShakeScale, ExplosionTemplate.bAutoControllerVibration, 2, rotator(Location - PC.ViewTarget.Location));
                    continue;
                }
                PC.ClientPlayCameraShake(Shake, ShakeScale, ExplosionTemplate.bAutoControllerVibration);
            }
        }
    }
    SpawnCameraLensEffects();
}

simulated function Tick(float DeltaTime)
{
    local float Pct;
    
    if (ExplosionLight != none)
    {
        if (LightFadeTimeRemaining >= float(0))
        {
            Pct = LightFadeTimeRemaining / LightFadeTime;
            Pct *= Pct;
            ExplosionLight.SetLightProperties(LightInitialBrightness * Pct);
            LightFadeTimeRemaining -= DeltaTime;
        }
        else
        {
            ExplosionLight.SetEnabled(false);
        }
    }
    if (ExplosionRadialBlur != none)
    {
        if (RadialBlurFadeTimeRemaining >= float(0))
        {
            Pct = RadialBlurFadeTimeRemaining / RadialBlurFadeTime;
            Pct *= Pct;
            ExplosionRadialBlur.SetBlurScale(Pct * RadialBlurMaxBlurAmount);
            RadialBlurFadeTimeRemaining -= DeltaTime;
        }
        else
        {
            ExplosionRadialBlur.SetBlurScale(0.0);
        }
    }
}

simulated function DoExplosionDamage()
{
    if (ExplosionTemplate != none)
    {
        if (ExplosionTemplate.Damage > 0.0 && ExplosionTemplate.DamageRadius > 0.0)
        {
            HurtExplosion(ExplosionTemplate.Damage, ExplosionTemplate.DamageRadius, ExplosionTemplate.DamageFalloffExponent, ExplosionTemplate.MyDamageType, ExplosionTemplate.MomentumTransferScale, Location, ExplosionTemplate.ActorToIgnoreForDamage, ExplosionTemplate.ActorClassToIgnoreForDamage, InstigatorController, false);
        }
        if (Role == 3)
        {
            DoCringesAndKnockdowns();
        }
    }
}

simulated function DrawDebug()
{
    local Color C;
    local float Angle;
    
    if (ExplosionTemplate.bDirectionalExplosion)
    {
        C.R = 255;
        C.G = 128;
        C.B = 16;
        C.A = 255;
        Angle = ExplosionTemplate.DirectionalExplosionAngleDeg * 0.017453292;
        DrawDebugCone(Location, ExplosionDirection, ExplosionTemplate.DamageRadius, Angle, Angle, 8, C, true);
    }
    else
    {
        DrawDebugSphere(Location, ExplosionTemplate.DamageRadius, 10, 255, 128, 16, true);
    }
}

simulated function Explode(GameExplosion NewExplosionTemplate, optional Vector Direction)
{
    local float HowLongToLive;
    local PhysicalMaterial PhysMat;
    
    ExplosionTemplate = NewExplosionTemplate;
    if (ExplosionTemplate.bDirectionalExplosion)
    {
        ExplosionDirection = Normal(Direction);
        DirectionalExplosionMinDot = Cos(ExplosionTemplate.DirectionalExplosionAngleDeg * 0.017453292);
    }
    HowLongToLive = ExplosionTemplate.DamageDelay + 0.01;
    if (!bHasExploded)
    {
        if (ExplosionTemplate.bAllowPerMaterialFX)
        {
            PhysMat = GetPhysicalMaterial();
            if (PhysMat != none)
            {
                UpdateExplosionTemplateWithPerMaterialFX(PhysMat);
            }
        }
        if (WorldInfo.NetMode != 1)
        {
            if (ExplosionTemplate.ParticleEmitterTemplate != none)
            {
                SpawnExplosionParticleSystem(ExplosionTemplate.ParticleEmitterTemplate);
            }
            SpawnExplosionDecal();
            if (ExplosionTemplate.ExploLight != none)
            {
                ExplosionLight = new(self) class'Engine.PointLightComponent'(ExplosionTemplate.ExploLight);
                if (ExplosionLight != none)
                {
                    AttachComponent(ExplosionLight);
                    ExplosionLight.SetEnabled(true);
                    SetTimer(ExplosionTemplate.ExploLightFadeOutTime);
                    LightFadeTime = ExplosionTemplate.ExploLightFadeOutTime;
                    LightFadeTimeRemaining = LightFadeTime;
                    HowLongToLive = FMax(LightFadeTime + 0.2, HowLongToLive);
                    LightInitialBrightness = ExplosionTemplate.ExploLight.Brightness;
                }
            }
            if (ExplosionTemplate.ExploRadialBlur != none)
            {
                ExplosionRadialBlur = new(self) class'Engine.RadialBlurComponent'(ExplosionTemplate.ExploRadialBlur);
                if (ExplosionRadialBlur != none)
                {
                    AttachComponent(ExplosionRadialBlur);
                    RadialBlurFadeTime = ExplosionTemplate.ExploRadialBlurFadeOutTime;
                    RadialBlurFadeTimeRemaining = RadialBlurFadeTime;
                    RadialBlurMaxBlurAmount = ExplosionTemplate.ExploRadialBlurMaxBlur;
                    SetTimer(FMax(RadialBlurFadeTime, LightFadeTime));
                    HowLongToLive = FMax(RadialBlurFadeTime + 0.2, HowLongToLive);
                }
            }
            if (ExplosionTemplate.ExplosionSound != none)
            {
                PlaySound(ExplosionTemplate.ExplosionSound, true, true, false, Location, true);
            }
            DoExplosionCameraEffects();
            RadialImpulseComponent.ImpulseRadius = FMax(ExplosionTemplate.DamageRadius, ExplosionTemplate.KnockDownRadius);
            RadialImpulseComponent.ImpulseStrength = ExplosionTemplate.MyDamageType.default.default.RadialDamageImpulse;
            RadialImpulseComponent.bVelChange = ExplosionTemplate.MyDamageType.default.default.bRadialDamageVelChange;
            RadialImpulseComponent.ImpulseFalloff = 0;
            RadialImpulseComponent.FireImpulse(Location);
            if (ExplosionTemplate.bCausesFracture)
            {
                DoBreakFracturedMeshes(Location, ExplosionTemplate.FractureMeshRadius, ExplosionTemplate.FracturePartVel, ExplosionTemplate.MyDamageType);
            }
            SpawnExplosionFogVolume();
            if (FluidSurfaceActor(HitActorFromPhysMaterialTrace) != none)
            {
                FluidSurfaceActor(HitActorFromPhysMaterialTrace).FluidComponent.ApplyForce(HitLocationFromPhysMaterialTrace, 1024.0, 20.0, false);
            }
        }
        if (ExplosionTemplate.DamageDelay > 0.0)
        {
            SetTimer(ExplosionTemplate.DamageDelay, false, 'DoExplosionDamage');
        }
        else
        {
            DoExplosionDamage();
        }
        if (Role == 3)
        {
            MakeNoise(1.0);
        }
        if (bDrawDebug)
        {
            DrawDebug();
        }
        bHasExploded = true;
        if (!bPendingDelete && !bDeleteMe)
        {
            LifeSpan = HowLongToLive;
        }
    }
}

simulated function SpawnExplosionFogVolume()
{
}

simulated function SpawnExplosionDecal()
{
}

simulated function SpawnExplosionParticleSystem(ParticleSystem Template)
{
}

protected simulated function UpdateExplosionTemplateWithPerMaterialFX(PhysicalMaterial PhysMaterial)
{
}

protected function KnockdownPawn(GamePawn Victim, float DistFromExplosion)
{
    Victim.LastHitBy = InstigatorController;
    Victim.ServerKnockdown(, vect(1.0, 1.0, 1.0), Location, ExplosionTemplate.KnockDownRadius * 2.0, ExplosionTemplate.KnockDownStrength);
}

protected function CringePawn(GamePawn Victim, float DistFromExplosion)
{
    local float CringeTime;
    
    CringeTime = GetRangeValueByPct(ExplosionTemplate.CringeDuration, ExplosionTemplate.CringeRadius / DistFromExplosion);
    Victim.Cringe(CringeTime);
}

protected function DoCringesAndKnockdowns()
{
    local GamePawn Victim;
    local float DistFromExplosion;
    local Vector ExplosionToVictimDir;
    local float KnockDownRad, CringeRad;
    
    if (ExplosionTemplate != none && WorldInfo.NetMode != 3)
    {
        KnockDownRad = ExplosionTemplate.KnockDownRadius;
        CringeRad = ExplosionTemplate.CringeRadius;
        foreach VisibleCollidingActors(class'GamePawn', Victim, FMax(CringeRad, KnockDownRad), Location, true)
        {
            if (!Victim.bRespondToExplosions || Victim.InGodMode())
            {
                break;
            }
            if (ShouldDoCringeFor(Victim))
            {
                ExplosionToVictimDir = Victim.Location - Location;
                DistFromExplosion = VSize(ExplosionToVictimDir);
                if (DistFromExplosion == 0.0)
                {
                    DistFromExplosion = 1.0;
                    ExplosionToVictimDir = vect(0.0, 0.0, 1.0);
                }
                else
                {
                    ExplosionToVictimDir /= DistFromExplosion;
                }
                if (DistFromExplosion < KnockDownRad)
                {
                    KnockdownPawn(Victim, DistFromExplosion);
                    continue;
                }
                if (DistFromExplosion < CringeRad)
                {
                    CringePawn(Victim, DistFromExplosion);
                }
            }
        }
    }
}

protected function bool ShouldDoCringeFor(GamePawn Victim)
{
    if ((InstigatorController == none || !WorldInfo.GRI.OnSameTeam(InstigatorController, Victim) || ExplosionTemplate.bAllowTeammateCringes || Victim == ExplosionTemplate.Attachee || Instigator == Victim && Instigator.IsHumanControlled()) && ClassIsChildOf(Victim.Class, ExplosionTemplate.ActorClassToIgnoreForKnockdownsAndCringes) == false && !IsBehindExplosion(Victim))
    {
        return true;
    }
    else
    {
        return false;
    }
}

protected simulated function DoBreakFracturedMeshes(Vector ExploOrigin, float DamageRadius, float RBStrength, class<DamageType> dmgType)
{
    local FracturedStaticMeshActor FracActor;
    local byte bWantPhysChunksAndParticles;
    
    foreach CollidingActors(class'Engine.FracturedStaticMeshActor', FracActor, DamageRadius, ExploOrigin, true)
    {
        if (FracActor.Physics == 0 && FracActor.IsFracturedByDamageType(dmgType) && !IsBehindExplosion(FracActor))
        {
            if (FracActor.FractureEffectIsRelevant(false, Instigator, bWantPhysChunksAndParticles))
            {
                FracActor.BreakOffPartsInRadius(ExploOrigin, DamageRadius, RBStrength, bWantPhysChunksAndParticles == 1 ? true : false);
            }
        }
    }
}

protected simulated function HurtExplosion(float BaseDamage, float DamageRadius, float DamageFalloffExp, class<DamageType> DamageType, float MomentumScale, Vector ExploOrigin, Actor IgnoredActor, class<Actor> ActorClassToIgnoreForDamage, Controller InstigatedByController, bool bDoFullDamage)
{
    local Actor Victim, HitActor;
    local Vector HitL, HitN, Dir;
    local bool bDamageBlocked;
    local float ColRadius, ColHeight;
    local array<Actor> VictimsList;
    local Box BBox;
    local Vector BBoxCenter;
    local Controller ModInstigator;
    local Pawn VictimPawn;
    local class<DamageType> ModDamageType;
    
    if (bDebug)
    {
        LogInternal(string(WorldInfo.TimeSeconds) @ string(self) @ string(GetFuncName()) @ "BaseDamage:" @ string(BaseDamage) @ "DamageRadius:" @ string(DamageRadius) @ "DamageFalloffExp:" @ string(DamageFalloffExp) @ "IgnoredActor:" @ string(IgnoredActor) @ "HitActor:" @ string(ExplosionTemplate.HitActor));
    }
    if (bDebug)
    {
        LogInternal("ExplosionTemplate.bUseOverlapCheck:'" $ string(ExplosionTemplate.bUseOverlapCheck) $ "'");
    }
    foreach CollidingActors(class'Engine.Actor', Victim, DamageRadius, ExploOrigin, ExplosionTemplate.bUseOverlapCheck)
    {
        bDamageBlocked = false;
        VictimPawn = Pawn(Victim);
        if (Victim != self && Victim != IgnoredActor && !Victim.bWorldGeometry || Victim.bCanBeDamaged && ClassIsChildOf(Victim.Class, ActorClassToIgnoreForDamage) == false && !IsBehindExplosion(Victim))
        {
            ModDamageType = DamageType;
            ModInstigator = InstigatedByController;
            if (bDebug)
            {
                LogInternal("Check vs Victim" @ string(Victim) @ "CurDamInfo" @ string(ModDamageType) @ string(ModInstigator) @ "Checks..." @ string(ExplosionTemplate.AttacheeController) @ string(VictimPawn) @ string(WorldInfo.GRI.OnSameTeam(ExplosionTemplate.AttacheeController, VictimPawn.Controller)));
            }
            if (ExplosionTemplate.AttacheeController != none && VictimPawn != none && !WorldInfo.GRI.IsCoopMultiplayerGame() && !WorldInfo.GRI.OnSameTeam(ExplosionTemplate.AttacheeController, VictimPawn.Controller))
            {
                if (bDebug)
                {
                    LogInternal("Change instigator to" @ string(ExplosionTemplate.AttacheeController) @ string(ExplosionTemplate.Attachee));
                }
                ModInstigator = ExplosionTemplate.AttacheeController;
            }
            if (DoFullDamageToActor(Victim))
            {
                bDamageBlocked = false;
                bDoFullDamage = true;
            }
            else
            {
                Victim.GetComponentsBoundingBox(BBox);
                BBoxCenter = (BBox.Min + BBox.Max) * 0.5;
                HitActor = Trace(HitL, HitN, BBoxCenter, ExploOrigin, false, , , 1);
                if (HitActor != none && HitActor != Victim)
                {
                    bDamageBlocked = true;
                }
            }
            if (!bDamageBlocked)
            {
                Victim.TakeRadiusDamage(ModInstigator, BaseDamage, DamageRadius, ModDamageType, MomentumScale, ExploOrigin, bDoFullDamage, Owner != none ? Owner : self, DamageFalloffExp);
                VictimsList[VictimsList.Length] = Victim;
            }
        }
    }
    if (ExplosionTemplate.bFullDamageToAttachee && VictimsList.Find(ExplosionTemplate.Attachee) == -1)
    {
        Victim = ExplosionTemplate.Attachee;
        Victim.GetBoundingCylinder(ColRadius, ColHeight);
        Dir = Normal(Victim.Location - ExploOrigin);
        Victim.TakeDamage(int(BaseDamage), InstigatedByController, Victim.Location - 0.5 * (ColHeight + ColRadius) * Dir, MomentumScale * Dir, DamageType, , Owner != none ? Owner : self);
    }
}

protected simulated function bool IsBehindExplosion(Actor A)
{
    if (ExplosionTemplate.bDirectionalExplosion && !IsZero(ExplosionDirection))
    {
        return ExplosionDirection Dot (A.Location - Location) < DirectionalExplosionMinDot;
    }
    return false;
}

simulated function bool DoFullDamageToActor(Actor Victim)
{
    return Victim.bStatic || Victim.IsA('KActor') || Victim.IsA('InterpActor') || Victim.IsA('FracturedStaticMeshPart');
}

protected simulated function PhysicalMaterial GetPhysicalMaterial()
{
    local PhysicalMaterial retval;
    local Vector TraceStart, TraceDest, OutHitNorm, ExploNormal;
    local TraceHitInfo OutHitInfo;
    
    TraceStart = Location + vect(0.0, 0.0, 1.0) * 256.0;
    TraceDest = Location - vect(0.0, 0.0, 1.0) * 16.0;
    HitActorFromPhysMaterialTrace = Trace(HitLocationFromPhysMaterialTrace, OutHitNorm, TraceDest, TraceStart, true, vect(0.0, 0.0, 0.0), OutHitInfo, 1 | 2);
    if (FluidSurfaceActor(HitActorFromPhysMaterialTrace) != none)
    {
        retval = OutHitInfo.PhysMaterial;
        return retval;
    }
    ExploNormal = vector(Rotation);
    TraceStart = Location + ExploNormal * 8.0;
    TraceDest = TraceStart - ExploNormal * 64.0;
    HitActorFromPhysMaterialTrace = Trace(HitLocationFromPhysMaterialTrace, OutHitNorm, TraceDest, TraceStart, true, vect(0.0, 0.0, 0.0), OutHitInfo, 1);
    if (HitActorFromPhysMaterialTrace != none)
    {
        retval = OutHitInfo.PhysMaterial;
    }
    return retval;
}

event PreBeginPlay()
{
    PreBeginPlay();
    if (Instigator != none && InstigatorController == none)
    {
        InstigatorController = Instigator.Controller;
    }
}

defaultproperties
{
    RadialImpulseComponent="Default__GameExplosionActor.ImpulseComponent0"
    Components(0)="Default__GameExplosionActor.ImpulseComponent0"
    CollisionType="COLLIDE_CustomDefault"
}
