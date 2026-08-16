class DamageVolume extends DynamicPhysicsVolume
    placeable
    hidecategories(Navigation,Object,Display);

var() bool bKnockBack;
var() bool bInvincible;
var() bool bOnlyOnce;
var() EDamageStrengthType KnockBackType;
var() Actor DirectionActor;
var() KnockBackParameters KnockBackParameter;
var() SoundCue DamageSound;

function SetKnockBackPara(Actor Other)
{
    local Vector KnockBackdir;
    
    if (bKnockBack)
    {
        if (DirectionActor != none)
        {
            KnockBackdir = vector(DirectionActor.Rotation);
        }
        else
        {
            KnockBackdir = -vector(Other.Rotation);
        }
        if (AlicePawn(Other) != none && AlicePawn(Other).Mesh != none)
        {
            if (AlicePawn(Other).AbsKnockBackTotalTime >= 0.0 && AlicePawn(Other).AbsKnockBackScale >= 0.0)
            {
                AlicePawn(Other).Mesh.SetFakeRootMotionPara(AlicePawn(Other).AbsKnockBackScale, AlicePawn(Other).AbsKnockBackTotalTime, 10, rotator(KnockBackdir));
                AlicePawn(Other).Mesh.ActiveFakeRootMotion();
                AlicePawn(Other).Mesh.FakeRootMotionMode = 3;
            }
            else
            {
                AlicePawn(Other).Mesh.SetFakeRootMotionPara(KnockBackParameter.KnockBackScale, KnockBackParameter.KnockBackTotalTime, 10, rotator(KnockBackdir));
                AlicePawn(Other).Mesh.ActiveFakeRootMotion();
                AlicePawn(Other).Mesh.FakeRootMotionMode = 3;
            }
        }
    }
}

function CausePainTo(Actor Other)
{
    local Vector Momentum, HitLoc, VRand;
    local float fOffset, fSign1, fSign2, fSign3;
    
    if (AlicePawn(Other) != none && AlicePawn(Other).IsInInvincibleState())
    {
        return;
    }
    if (DamagePerSec > float(0))
    {
        if (WorldInfo.bSoftKillZ && Other.Physics != 1)
        {
            return;
        }
        if (DamageType == none || DamageType == class'Engine.DamageType')
        {
            LogInternal("No valid damagetype (" $ string(DamageType) $ ") specified for " $ PathName(self));
        }
        AliceGamePawn(Other).CurrentDmgStrength = KnockBackType;
        fSign1 = float(Rand(10) > 5 ? 1 : -1);
        fSign2 = float(Rand(10) > 5 ? 1 : -1);
        fSign3 = float(Rand(10) > 5 ? 1 : -1);
        VRand.X = FRand() * fSign1;
        VRand.Y = FRand() * fSign2;
        VRand.Z = FRand() * fSign3;
        VRand = Normal(VRand);
        fOffset = FRand() * float(20);
        HitLoc = Other.Location + vect(0.0, 0.0, 30.0) + VRand * fOffset;
        Momentum = VRand;
        Momentum = Normal(Momentum);
        Other.TakeDamage(int(DamagePerSec * PainInterval), DamageInstigator, HitLoc, Momentum, DamageType, , self);
    }
    else
    {
        AliceGamePawn(Other).CurrentDmgStrength = KnockBackType;
        Other.HealDamage(int(-DamagePerSec * PainInterval), DamageInstigator, DamageType);
    }
    SetKnockBackPara(Other);
    if (bInvincible)
    {
        AlicePawn(Other).StartInvincibleState();
    }
    if (bOnlyOnce)
    {
        bPainCausing = false;
    }
    AlicePawn(Other).PlaySound(DamageSound);
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

function SoundCue getDamageSound()
{
    return SoundCue'SFX_Combat.sfx_alice_damage_burn01_oil_Cue';
}

defaultproperties
{
    KnockBackType="EDSTR_Light"
    KnockBackParameter=(KnockBackScale=180.0,KnockBackTotalTime=0.4,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    DamageSound="SFX_Combat.sfx_alice_damage_burn01_oil_Cue"
    BrushComponent="Default__DamageVolume.BrushComponent0"
    Components(0)="Default__DamageVolume.BrushComponent0"
    CollisionComponent="Default__DamageVolume.BrushComponent0"
}
