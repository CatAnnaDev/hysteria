class AlicePhysicalMaterialProperty extends PhysicalMaterialPropertyBase
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Game)
    hidecategories(Object,Object);

struct native SlideParam
{
    var() bool bCanControlWhenSlide;
    var() bool bCanJumpWhenSlide;
    var() ParticleSystem SlidePS;
};

struct native ImpactFXBallistic extends ImpactFXBase
{
    var const string WeaponType;
    var() class<WeaponForAlice> WeaponClass;
};

struct native ImpactFXProjectile extends ImpactFXBase
{
    var const string ProjectileType;
    var() class<AliceGameProjectile> ProjectileClass;
};

struct native ImpactFXExplosion
{
    var const string WeaponType;
    var() class<AliceGameWeapon> WeaponClass;
    var() editinline array<DecalData> DecalData;
    var() SoundCue ImpactCue;
    var ParticleSystem DefaultImpactPS;
    var() bool bUseRandomImpactPS;
    var() array<ParticleSystem> RandomImpactPS;
    var() array<SoundCue> ImpactCueWeapon;
    var() array<ParticleSystem> ImpactPSWeapon;
    var() class<EmitterCameraLensEffectBase> CameraEffect;
    var() float CameraEffectRadius;
    var array<SoundCue> CriticalWeaponCue;
    var array<ParticleSystem> CriticalWeaponPS;
    var() bool bProjectOnSurface;
    var() float ProjectionDistance;
};

struct native ImpactFXBase
{
    var() editinline array<DecalData> DecalData;
    var() SoundCue ImpactCue;
    var() ParticleSystem ImpactPS;
    var() array<SoundCue> ImpactCueWeapon;
    var() array<ParticleSystem> ImpactPSWeapon;
    var() class<EmitterCameraLensEffectBase> CameraEffect;
    var() float CameraEffectRadius;
    var array<SoundCue> CriticalWeaponCue;
    var array<ParticleSystem> CriticalWeaponPS;
    var() bool bProjectOnSurface;
    var() float ProjectionDistance;
};

struct native FootStepDatum
{
    var() string ArcheTypeName;
    var() SoundCue DefaultSound;
    var() ParticleSystem DefaultParticle;
    var() ParticleSystem LandedParticle;
    var() SoundCue LandedSound;
    var() DecalData DefaultDecal;
    var() array<AnimNotifyDatum> AnimNotify;
};

struct native AnimNotifyDatum
{
    var() name AnimSeqName;
    var() SoundCue AnimSound;
    var() ParticleSystem AnimParticle;
    var() editinline array<DecalData> DecalData;
};

var config array<string> ArcheTypeNames;
var config array<string> WeaponNames;
var config array<string> ProjectileNames;
var config array<string> BallisticNames;
var() editinline array<FootStepDatum> FootStepInfo;
var() editinline ImpactFXExplosion DefaultFXInfoExplosion;
var() editinline array<ImpactFXExplosion> FXInfoWeapon;
var() editinline array<ImpactFXExplosion> FXInfoWeapon_DLC;
var() editinline array<ImpactFXProjectile> FXInfoProjectile;
var() editinline array<ImpactFXProjectile> FXInfoProjectile_DLC;
var() editinline array<ImpactFXExplosion> FXInfoWeaponHitSpinningUmbrella;
var() editinline array<ImpactFXProjectile> FXInfoProjectileHitSpinningUmbrella;
var() editinline ImpactFXBallistic DefaultFXInfoBallistic;
var() editinline array<ImpactFXBallistic> FXInfoBallistic;
var() editinline SlideParam SlideInfo;

static final simulated function SoundCue DetermineLandedSound(PhysicalMaterial PhysMaterial, int FootStepInfoID)
{
    local AlicePhysicalMaterialProperty Property;
    
    if (PhysMaterial != none && PhysMaterial.PhysicalMaterialProperty != none && AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty) != none)
    {
        Property = AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        return Property.FootStepInfo[FootStepInfoID].LandedSound;
    }
    return none;
}

static final simulated function ParticleSystem DetermineLandedParticle(PhysicalMaterial PhysMaterial, int FootStepInfoID)
{
    local AlicePhysicalMaterialProperty Property;
    
    if (PhysMaterial != none && PhysMaterial.PhysicalMaterialProperty != none && AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty) != none)
    {
        Property = AlicePhysicalMaterialProperty(PhysMaterial.PhysicalMaterialProperty);
        return Property.FootStepInfo[FootStepInfoID].LandedParticle;
    }
    return none;
}

native static function PhysicalMaterial GetPhysMatFromStaticMesh(StaticMesh StaticMesh)
{
    StaticMesh;
}

static final simulated function PhysicalMaterial GetPhysMatFromBreakableActor(GameBreakableActor BreakableActor)
{
    if (BreakableActor.StaticMeshComponent != none && BreakableActor.StaticMeshComponent.PhysMaterialOverride != none)
    {
        return BreakableActor.StaticMeshComponent.PhysMaterialOverride;
    }
    else if (BreakableActor.StaticMeshComponent != none && BreakableActor.StaticMeshComponent.StaticMesh != none)
    {
        return GetPhysMatFromStaticMesh(BreakableActor.StaticMeshComponent.StaticMesh);
    }
    return none;
}

static final simulated function PhysicalMaterial GetPhysMatFromInterpActor(InterpActor Interp_Actor)
{
    if (Interp_Actor.StaticMeshComponent != none && Interp_Actor.StaticMeshComponent.PhysMaterialOverride != none)
    {
        return Interp_Actor.StaticMeshComponent.PhysMaterialOverride;
    }
    else if (Interp_Actor.StaticMeshComponent != none && Interp_Actor.StaticMeshComponent.StaticMesh != none)
    {
        return GetPhysMatFromStaticMesh(Interp_Actor.StaticMeshComponent.StaticMesh);
    }
    return none;
}

static final simulated function DecalData DetermineFootStepDecalData(PhysicalMaterial PhysMaterial, int FootStepInfoID, name AnimSeqName)
{
    local AlicePhysicalMaterialProperty Property;
    local DecalData DecalData;
    local PhysicalMaterial PM;
    local int I;
    
    DecalData.bIsValid = false;
    if (PhysMaterial == none)
    {
        return DecalData;
    }
    PM = PhysMaterial;
    while (!DecalData.bIsValid && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FootStepInfo[FootStepInfoID].AnimNotify.Length; I++)
            {
                if (Property.FootStepInfo[FootStepInfoID].AnimNotify[I].AnimSeqName == AnimSeqName && Property.FootStepInfo[FootStepInfoID].AnimNotify[I].DecalData.Length > 0)
                {
                    DecalData = GetCookedDecalData(Property.FootStepInfo[FootStepInfoID].AnimNotify[I].DecalData[0]);
                    break;
                }
            }
            if (!DecalData.bIsValid)
            {
                DecalData = GetCookedDecalData(Property.FootStepInfo[FootStepInfoID].DefaultDecal);
            }
        }
        PM = PM.Parent;
    }
    return DecalData;
}

static final simulated function SoundCue DetermineCriticalBallisticSound(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoBallistic[I].CriticalWeaponCue.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoBallistic[I].CriticalWeaponCue[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineCriticalBallisticParticle(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoBallistic[I].CriticalWeaponPS.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoBallistic[I].CriticalWeaponPS[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function SoundCue DetermineBallisticSoundFromWeapon(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoBallistic[I].ImpactCueWeapon.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoBallistic[I].ImpactCueWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function SoundCue DetermineBallisticSound(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass)
                {
                    Cue = Property.FXInfoBallistic[I].ImpactCue;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineBallisticParticleFromWeapon(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoBallistic[I].ImpactPSWeapon.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoBallistic[I].ImpactPSWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function ParticleSystem DetermineBallisticParticle(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass)
                {
                    PS = Property.FXInfoBallistic[I].ImpactPS;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function int DetermineBallisticDecalData(PhysicalMaterial PhysMaterial, class<WeaponForAlice> InWeaponClass, out PhysicalMaterial outPM, out int outFXIndex)
{
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, DecalDataNum;
    
    DecalDataNum = 0;
    if (PhysMaterial == none)
    {
        return DecalDataNum;
    }
    PM = PhysMaterial;
    while (DecalDataNum == 0 && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoBallistic.Length; I++)
            {
                if (Property.FXInfoBallistic[I].WeaponClass == InWeaponClass)
                {
                    outPM = PM;
                    outFXIndex = I;
                    DecalDataNum = Property.FXInfoBallistic[I].DecalData.Length;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return DecalDataNum;
}

static final simulated function SoundCue DetermineCriticalProjectileSound(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectile.Length; I++)
            {
                if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile[I].CriticalWeaponCue.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoProjectile[I].CriticalWeaponCue[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineCriticalProjectileParticle(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectile.Length; I++)
            {
                if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile[I].CriticalWeaponPS.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoProjectile[I].CriticalWeaponPS[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function SoundCue DetermineCriticalWeaponSound(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeapon.Length; I++)
            {
                if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon[I].CriticalWeaponCue.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoWeapon[I].CriticalWeaponCue[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineCriticalWeaponParticle(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeapon.Length; I++)
            {
                if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon[I].CriticalWeaponPS.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoWeapon[I].CriticalWeaponPS[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function SoundCue DetermineWeaponSoundFromWeaponForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeaponHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoWeaponHitSpinningUmbrella[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeaponHitSpinningUmbrella[I].ImpactCueWeapon.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoWeaponHitSpinningUmbrella[I].ImpactCueWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function SoundCue DetermineWeaponSoundFromWeapon(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon_DLC[I].ImpactCueWeapon.Length >= WeaponLevel)
                    {
                        Cue = Property.FXInfoWeapon_DLC[I].ImpactCueWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || Cue == none)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon[I].ImpactCueWeapon.Length >= WeaponLevel)
                    {
                        Cue = Property.FXInfoWeapon[I].ImpactCueWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return Cue;
}

static final simulated function SoundCue DetermineWeaponSoundForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeaponHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoWeaponHitSpinningUmbrella[I].WeaponClass == InWeaponClass)
                {
                    Cue = Property.FXInfoWeaponHitSpinningUmbrella[I].ImpactCue;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function SoundCue DetermineWeaponSound(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass)
                    {
                        Cue = Property.FXInfoWeapon_DLC[I].ImpactCue;
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (Cue == none || InDLCWeaponFlag == 0)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass)
                    {
                        Cue = Property.FXInfoWeapon[I].ImpactCue;
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineWeaponParticleFromWeaponForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeaponHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoWeaponHitSpinningUmbrella[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeaponHitSpinningUmbrella[I].ImpactPSWeapon.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoWeaponHitSpinningUmbrella[I].ImpactPSWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function ParticleSystem DetermineWeaponParticleFromWeapon(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int WeaponLevel, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon_DLC[I].ImpactPSWeapon.Length >= WeaponLevel)
                    {
                        PS = Property.FXInfoWeapon_DLC[I].ImpactPSWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || PS == none)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass && WeaponLevel >= 1 && Property.FXInfoWeapon[I].ImpactPSWeapon.Length >= WeaponLevel)
                    {
                        PS = Property.FXInfoWeapon[I].ImpactPSWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return PS;
}

static final simulated function class<EmitterCameraLensEffectBase> DetermineWeaponCameraEffectForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass)
{
    local class<EmitterCameraLensEffectBase> PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeaponHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoWeaponHitSpinningUmbrella[I].WeaponClass == InWeaponClass)
                {
                    PS = Property.FXInfoWeaponHitSpinningUmbrella[I].CameraEffect;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function class<EmitterCameraLensEffectBase> DetermineWeaponCameraEffect(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local class<EmitterCameraLensEffectBase> PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass)
                    {
                        PS = Property.FXInfoWeapon_DLC[I].CameraEffect;
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (PS == none || InDLCWeaponFlag == 0)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass)
                    {
                        PS = Property.FXInfoWeapon[I].CameraEffect;
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return PS;
}

static final simulated function ParticleSystem DetermineWeaponParticleForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, Len;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoWeaponHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoWeaponHitSpinningUmbrella[I].WeaponClass == InWeaponClass)
                {
                    if (Property.FXInfoWeaponHitSpinningUmbrella[I].bUseRandomImpactPS)
                    {
                        Len = Property.FXInfoWeaponHitSpinningUmbrella[I].RandomImpactPS.Length;
                        if (Len > 0)
                        {
                            PS = Property.FXInfoWeaponHitSpinningUmbrella[I].RandomImpactPS[Rand(Len)];
                        }
                    }
                    else
                    {
                        PS = none;
                    }
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function ParticleSystem DetermineWeaponParticle(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, Len;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass)
                    {
                        if (Property.FXInfoWeapon_DLC[I].bUseRandomImpactPS)
                        {
                            Len = Property.FXInfoWeapon_DLC[I].RandomImpactPS.Length;
                            if (Len > 0)
                            {
                                PS = Property.FXInfoWeapon_DLC[I].RandomImpactPS[Rand(Len)];
                                OutDLCMatFlag = InDLCWeaponFlag;
                            }
                        }
                        else
                        {
                            PS = none;
                        }
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (PS == none || InDLCWeaponFlag == 0)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass)
                    {
                        if (Property.FXInfoWeapon[I].bUseRandomImpactPS)
                        {
                            Len = Property.FXInfoWeapon[I].RandomImpactPS.Length;
                            if (Len > 0)
                            {
                                PS = Property.FXInfoWeapon[I].RandomImpactPS[Rand(Len)];
                                OutDLCMatFlag = 0;
                            }
                        }
                        else
                        {
                            PS = none;
                        }
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return PS;
}

static final simulated function int DetermineWeaponDecalData(PhysicalMaterial PhysMaterial, class<AliceGameWeaponBase> InWeaponClass, int InDLCWeaponFlag, out PhysicalMaterial outPM, out int outFXIndex, out int OutDLCMatFlag, int iWeaponLevel, out array<int> vDecalBuffer)
{
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, J, DecalDataNum;
    
    OutDLCMatFlag = 0;
    DecalDataNum = 0;
    vDecalBuffer.Length = 0;
    if (PhysMaterial == none)
    {
        return DecalDataNum;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (DecalDataNum == 0 && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon_DLC.Length; I++)
                {
                    if (Property.FXInfoWeapon_DLC[I].WeaponClass == InWeaponClass)
                    {
                        outPM = PM;
                        outFXIndex = I;
                        DecalDataNum = Property.FXInfoWeapon_DLC[I].DecalData.Length;
                        if (DecalDataNum == 0)
                        {
                            PM = PM.Parent;
                            break;
                            continue;
                        }
                        for (J = 0; J < DecalDataNum; J++)
                        {
                            if (Property.FXInfoWeapon_DLC[I].DecalData[J].WeaponLevel == iWeaponLevel)
                            {
                                vDecalBuffer.AddItem(J);
                                OutDLCMatFlag = InDLCWeaponFlag;
                            }
                        }
                        break;
                    }
                }
                if (I == Property.FXInfoWeapon_DLC.Length)
                {
                    PM = PM.Parent;
                }
            }
        }
    }
    if (DecalDataNum == 0 || InDLCWeaponFlag == 0)
    {
        PM = PhysMaterial;
        while (DecalDataNum == 0 && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoWeapon.Length; I++)
                {
                    if (Property.FXInfoWeapon[I].WeaponClass == InWeaponClass)
                    {
                        outPM = PM;
                        outFXIndex = I;
                        DecalDataNum = Property.FXInfoWeapon[I].DecalData.Length;
                        if (DecalDataNum == 0)
                        {
                            PM = PM.Parent;
                            break;
                            continue;
                        }
                        for (J = 0; J < DecalDataNum; J++)
                        {
                            if (Property.FXInfoWeapon[I].DecalData[J].WeaponLevel == iWeaponLevel)
                            {
                                vDecalBuffer.AddItem(J);
                                OutDLCMatFlag = 0;
                            }
                        }
                        break;
                    }
                }
                if (I == Property.FXInfoWeapon.Length)
                {
                    PM = PM.Parent;
                }
            }
        }
    }
    return DecalDataNum;
}

static final simulated function SoundCue DetermineProjectileSoundFromProjForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectileHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoProjectileHitSpinningUmbrella[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactCueWeapon.Length >= WeaponLevel)
                {
                    Cue = Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactCueWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function SoundCue DetermineProjectileSoundFromProj(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile_DLC.Length; I++)
                {
                    if (Property.FXInfoProjectile_DLC[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile_DLC[I].ImpactCueWeapon.Length >= WeaponLevel)
                    {
                        Cue = Property.FXInfoProjectile_DLC[I].ImpactCueWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || Cue == none)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile.Length; I++)
                {
                    if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile[I].ImpactCueWeapon.Length >= WeaponLevel)
                    {
                        Cue = Property.FXInfoProjectile[I].ImpactCueWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return Cue;
}

static final simulated function SoundCue DetermineProjectileSoundForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (Cue == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectileHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoProjectileHitSpinningUmbrella[I].ProjectileClass == InProjectileClass)
                {
                    Cue = Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactCue;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return Cue;
}

static final simulated function SoundCue DetermineProjectileSound(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local SoundCue Cue;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile_DLC.Length; I++)
                {
                    if (Property.FXInfoProjectile_DLC[I].ProjectileClass == InProjectileClass)
                    {
                        Cue = Property.FXInfoProjectile_DLC[I].ImpactCue;
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || Cue == none)
    {
        PM = PhysMaterial;
        while (Cue == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile.Length; I++)
                {
                    if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass)
                    {
                        Cue = Property.FXInfoProjectile[I].ImpactCue;
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return Cue;
}

static final simulated function ParticleSystem DetermineProjectileParticleFromProjForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectileHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoProjectileHitSpinningUmbrella[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactPSWeapon.Length >= WeaponLevel)
                {
                    PS = Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactPSWeapon[WeaponLevel - 1];
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function ParticleSystem DetermineProjectileParticleFromProj(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int WeaponLevel, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (WeaponLevel == 0)
    {
        WeaponLevel = 1;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile_DLC.Length; I++)
                {
                    if (Property.FXInfoProjectile_DLC[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile_DLC[I].ImpactPSWeapon.Length >= WeaponLevel)
                    {
                        PS = Property.FXInfoProjectile_DLC[I].ImpactPSWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || PS == none)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile.Length; I++)
                {
                    if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass && WeaponLevel >= 1 && Property.FXInfoProjectile[I].ImpactPSWeapon.Length >= WeaponLevel)
                    {
                        PS = Property.FXInfoProjectile[I].ImpactPSWeapon[WeaponLevel - 1];
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return PS;
}

static final simulated function ParticleSystem DetermineProjectileParticleForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    if (PhysMaterial == none)
    {
        return none;
    }
    PM = PhysMaterial;
    while (PS == none && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectileHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoProjectileHitSpinningUmbrella[I].ProjectileClass == InProjectileClass)
                {
                    PS = Property.FXInfoProjectileHitSpinningUmbrella[I].ImpactPS;
                    break;
                }
            }
        }
        PM = PM.Parent;
    }
    return PS;
}

static final simulated function ParticleSystem DetermineProjectileParticle(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int InDLCWeaponFlag, out int OutDLCMatFlag)
{
    local ParticleSystem PS;
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I;
    
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return none;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile_DLC.Length; I++)
                {
                    if (Property.FXInfoProjectile_DLC[I].ProjectileClass == InProjectileClass)
                    {
                        PS = Property.FXInfoProjectile_DLC[I].ImpactPS;
                        OutDLCMatFlag = InDLCWeaponFlag;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    if (InDLCWeaponFlag == 0 || PS == none)
    {
        PM = PhysMaterial;
        while (PS == none && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile.Length; I++)
                {
                    if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass)
                    {
                        PS = Property.FXInfoProjectile[I].ImpactPS;
                        OutDLCMatFlag = 0;
                        break;
                    }
                }
            }
            PM = PM.Parent;
        }
    }
    return PS;
}

static final simulated function int DetermineProjectileDecalDataForHitSpinningUmbrella(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, out PhysicalMaterial outPM, out int outFXIndex, int iWeaponLevel, out array<int> vDecalBuffer)
{
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, J, DecalDataNum;
    
    DecalDataNum = 0;
    vDecalBuffer.Length = 0;
    if (PhysMaterial == none)
    {
        return DecalDataNum;
    }
    PM = PhysMaterial;
    while (DecalDataNum == 0 && PM != none)
    {
        Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
        if (Property != none)
        {
            for (I = 0; I < Property.FXInfoProjectileHitSpinningUmbrella.Length; I++)
            {
                if (Property.FXInfoProjectileHitSpinningUmbrella[I].ProjectileClass == InProjectileClass)
                {
                    outPM = PM;
                    outFXIndex = I;
                    DecalDataNum = Property.FXInfoProjectileHitSpinningUmbrella[I].DecalData.Length;
                    if (DecalDataNum == 0)
                    {
                        PM = PM.Parent;
                        break;
                        continue;
                    }
                    for (J = 0; J < DecalDataNum; J++)
                    {
                        if (Property.FXInfoProjectileHitSpinningUmbrella[I].DecalData[J].WeaponLevel == iWeaponLevel)
                        {
                            vDecalBuffer.AddItem(J);
                        }
                    }
                    break;
                }
            }
            if (I == Property.FXInfoProjectileHitSpinningUmbrella.Length)
            {
                PM = PM.Parent;
            }
        }
    }
    return DecalDataNum;
}

static final simulated function int DetermineProjectileDecalData(PhysicalMaterial PhysMaterial, class<AliceGameProjectile> InProjectileClass, int InDLCWeaponFlag, out PhysicalMaterial outPM, out int outFXIndex, out int OutDLCMatFlag, int iWeaponLevel, out array<int> vDecalBuffer)
{
    local AlicePhysicalMaterialProperty Property;
    local PhysicalMaterial PM;
    local int I, J, DecalDataNum;
    
    DecalDataNum = 0;
    vDecalBuffer.Length = 0;
    OutDLCMatFlag = 0;
    if (PhysMaterial == none)
    {
        return DecalDataNum;
    }
    if (InDLCWeaponFlag == 1)
    {
        PM = PhysMaterial;
        while (DecalDataNum == 0 && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile_DLC.Length; I++)
                {
                    if (Property.FXInfoProjectile_DLC[I].ProjectileClass == InProjectileClass)
                    {
                        outPM = PM;
                        outFXIndex = I;
                        DecalDataNum = Property.FXInfoProjectile_DLC[I].DecalData.Length;
                        if (DecalDataNum == 0)
                        {
                            PM = PM.Parent;
                            break;
                            continue;
                        }
                        for (J = 0; J < DecalDataNum; J++)
                        {
                            if (Property.FXInfoProjectile_DLC[I].DecalData[J].WeaponLevel == iWeaponLevel)
                            {
                                vDecalBuffer.AddItem(J);
                                OutDLCMatFlag = InDLCWeaponFlag;
                            }
                        }
                        break;
                    }
                }
                if (I == Property.FXInfoProjectile_DLC.Length)
                {
                    PM = PM.Parent;
                }
            }
        }
    }
    if (InDLCWeaponFlag == 0 || DecalDataNum == 0)
    {
        PM = PhysMaterial;
        while (DecalDataNum == 0 && PM != none)
        {
            Property = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty);
            if (Property != none)
            {
                for (I = 0; I < Property.FXInfoProjectile.Length; I++)
                {
                    if (Property.FXInfoProjectile[I].ProjectileClass == InProjectileClass)
                    {
                        outPM = PM;
                        outFXIndex = I;
                        DecalDataNum = Property.FXInfoProjectile[I].DecalData.Length;
                        if (DecalDataNum == 0)
                        {
                            PM = PM.Parent;
                            break;
                            continue;
                        }
                        for (J = 0; J < DecalDataNum; J++)
                        {
                            if (Property.FXInfoProjectile[I].DecalData[J].WeaponLevel == iWeaponLevel)
                            {
                                vDecalBuffer.AddItem(J);
                                OutDLCMatFlag = InDLCWeaponFlag;
                            }
                        }
                        break;
                    }
                }
                if (I == Property.FXInfoProjectile.Length)
                {
                    PM = PM.Parent;
                }
            }
        }
    }
    return DecalDataNum;
}

static final simulated function DecalData GetBallisticDecalData(PhysicalMaterial PM, int FXIndex, int DecalDataIndex, out int bProjectOnSurface, out float ProjectionDistance)
{
    local ImpactFXBallistic FXInfo;
    local DecalData DecalData;
    
    if (PM == none)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    FXInfo = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty).FXInfoBallistic[FXIndex];
    bProjectOnSurface = int(FXInfo.bProjectOnSurface);
    ProjectionDistance = FXInfo.ProjectionDistance;
    if (DecalDataIndex < 0 || DecalDataIndex >= FXInfo.DecalData.Length)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    return GetCookedDecalData(FXInfo.DecalData[DecalDataIndex]);
}

static final simulated function DecalData GetWeaponDecalData(int DLCMatFlag, PhysicalMaterial PM, int FXIndex, int DecalDataIndex, out int bProjectOnSurface, out float ProjectionDistance)
{
    local ImpactFXExplosion FXInfo;
    local DecalData DecalData;
    
    if (PM == none)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    if (DLCMatFlag == 0)
    {
        FXInfo = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty).FXInfoWeapon[FXIndex];
    }
    else if (DLCMatFlag == 1)
    {
        FXInfo = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty).FXInfoWeapon_DLC[FXIndex];
    }
    bProjectOnSurface = int(FXInfo.bProjectOnSurface);
    ProjectionDistance = FXInfo.ProjectionDistance;
    if (DecalDataIndex < 0 || DecalDataIndex >= FXInfo.DecalData.Length)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    return GetCookedDecalData(FXInfo.DecalData[DecalDataIndex]);
}

static final simulated function DecalData GetProjectileDecalDataForHitSpinningUmbrella(PhysicalMaterial PM, int FXIndex, int DecalDataIndex, out int bProjectOnSurface, out float ProjectionDistance)
{
    local ImpactFXProjectile FXInfo;
    local DecalData DecalData;
    
    if (PM == none)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    FXInfo = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty).FXInfoProjectileHitSpinningUmbrella[FXIndex];
    bProjectOnSurface = int(FXInfo.bProjectOnSurface);
    ProjectionDistance = FXInfo.ProjectionDistance;
    if (DecalDataIndex < 0 || DecalDataIndex >= FXInfo.DecalData.Length)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    return GetCookedDecalData(FXInfo.DecalData[DecalDataIndex]);
}

static final simulated function DecalData GetProjectileDecalData(int DLCMatFlag, PhysicalMaterial PM, int FXIndex, int DecalDataIndex, out int bProjectOnSurface, out float ProjectionDistance)
{
    local ImpactFXProjectile FXInfo;
    local DecalData DecalData;
    
    if (PM == none)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    FXInfo = AlicePhysicalMaterialProperty(PM.PhysicalMaterialProperty).FXInfoProjectile[FXIndex];
    bProjectOnSurface = int(FXInfo.bProjectOnSurface);
    ProjectionDistance = FXInfo.ProjectionDistance;
    if (DecalDataIndex < 0 || DecalDataIndex >= FXInfo.DecalData.Length)
    {
        DecalData.bIsValid = false;
        return DecalData;
    }
    return GetCookedDecalData(FXInfo.DecalData[DecalDataIndex]);
}

static final simulated function DecalData GetCookedDecalData(DecalData RawDecalData)
{
    local float RandomScale;
    local DecalData DecalData;
    
    DecalData.DecalMaterial = RawDecalData.DecalMaterial;
    DecalData.Width = RawDecalData.Width;
    DecalData.Height = RawDecalData.Height;
    DecalData.WidthSK = RawDecalData.WidthSK;
    DecalData.HeightSK = RawDecalData.HeightSK;
    DecalData.Thickness = RawDecalData.Thickness;
    DecalData.LifeSpan = RawDecalData.LifeSpan;
    if (DecalData.LifeSpan <= float(0))
    {
        DecalData.LifeSpan = 100000000.0;
    }
    RandomScale = GetRangeValueByPct(RawDecalData.RandomScalingRange, FRand());
    DecalData.Width *= RandomScale;
    DecalData.Height *= RandomScale;
    DecalData.WidthSK *= RandomScale;
    DecalData.HeightSK *= RandomScale;
    DecalData.BlendRange = RawDecalData.BlendRange;
    DecalData.bIsValid = DecalData.DecalMaterial != none;
    DecalData.RandomRadiusOffset = RawDecalData.RandomRadiusOffset;
    DecalData.bRandomizeRotation = RawDecalData.bRandomizeRotation;
    return DecalData;
}

defaultproperties
{
    ArcheTypeNames(0)="ArcheType_AliceLondon"
    ArcheTypeNames(1)="ArcheType_AliceWonderland"
    ArcheTypeNames(2)="L_LondonCop_Archetype"
    ArcheTypeNames(3)="W_EyePot_Archetype"
    ArcheTypeNames(4)="W_MadCap_Fork_Archetype"
    ArcheTypeNames(5)="W_MadCap_Spoon_Archetype"
    ArcheTypeNames(6)="W_Automaton_Archetype"
    ArcheTypeNames(7)="W_Automaton_Swarm_Archetype"
    ArcheTypeNames(8)="W_CannonCrab_Archetype"
    ArcheTypeNames(9)="W_LostSoul_Archetype"
    ArcheTypeNames(10)="W_IceSnark_Archetype"
    ArcheTypeNames(11)="W_DoomTank_Archetype"
    ArcheTypeNames(12)="W_DoomSwarm_Archetype"
    ArcheTypeNames(13)="W_DoomGrunt_Archetype"
    ArcheTypeNames(14)="W_LionChop_Archetype"
    ArcheTypeNames(15)="W_SamuraiWasp_Archetype"
    ArcheTypeNames(16)="W_DoomAgile_Archetype"
    ArcheTypeNames(17)="W_CardGuard_Archetype"
    ArcheTypeNames(18)="W_DoomGrunt_mini_Archetype"
    ArcheTypeNames(19)="W_DollGirl_Archetype"
    ArcheTypeNames(20)="W_DollBoy_Archetype"
    ArcheTypeNames(21)="W_BitchBaby_Archetype"
    ArcheTypeNames(22)="W_WaspEmpress_Archetype"
    ArcheTypeNames(23)="W_DollMakerHandBoy_Archetype"
    ArcheTypeNames(24)="W_DollMakerHandGirl_Archetype"
    ArcheTypeNames(25)="W_DoomGrub_Archetype"
    ArcheTypeNames(26)="W_Executioner_Archetype"
    ArcheTypeNames(27)="W_Executioner_Chase_Archetype"
    ArcheTypeNames(28)="W_SamuraiWasp_Daimyo_Archetype"
    ArcheTypeNames(29)="ArcheType_AliceGiantMode"
    WeaponNames(0)="VorpalBlade"
    WeaponNames(1)="AliceVorpalBladeGhostDummyWeapon"
    WeaponNames(2)="HobbyHorse"
    WeaponNames(3)="NPCWeapon_General_Melee_Blunt1"
    WeaponNames(4)="NPCWeapon_General_Melee_Blunt2"
    WeaponNames(5)="NPCWeapon_General_Melee_Blunt3"
    WeaponNames(6)="NPCWeapon_General_Melee_Blunt4"
    WeaponNames(7)="NPCWeapon_General_Melee_Sharp1"
    WeaponNames(8)="NPCWeapon_General_Melee_Sharp2"
    WeaponNames(9)="NPCWeapon_General_Melee_Sharp3"
    WeaponNames(10)="NPCWeapon_General_Melee_Sharp4"
    ProjectileNames(0)="PepperGrinderPrimaryProjectile"
    ProjectileNames(1)="PepperGrinderAlternateProjectile"
    ProjectileNames(2)="TeapotCannonProjectile"
    ProjectileNames(3)="ClockBombProjectile"
    DefaultFXInfoExplosion=(WeaponType="",WeaponClass="None",DecalData=(),ImpactCue="None",DefaultImpactPS="None",bUseRandomImpactPS=False,RandomImpactPS=(),ImpactCueWeapon=(),ImpactPSWeapon=(),CameraEffect="None",CameraEffectRadius=800.0,CriticalWeaponCue=(),CriticalWeaponPS=(),bProjectOnSurface=False,ProjectionDistance=0.0)
    DefaultFXInfoBallistic=(WeaponType="",WeaponClass="None",DecalData=(),ImpactCue="None",ImpactPS="None",ImpactCueWeapon=(),ImpactPSWeapon=(),CameraEffect="None",CameraEffectRadius=800.0,CriticalWeaponCue=(),CriticalWeaponPS=(),bProjectOnSurface=False,ProjectionDistance=0.0)
}
