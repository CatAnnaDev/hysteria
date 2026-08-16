class CauseDamageActor extends Actor
    placeable
    hidecategories(Navigation);

var bool bPainCausing;
var() export editinline ParticleSystemComponent ParticleEffect;
var() float Radius;
var() float Duration;
var() float PainInterval;
var() float KnockBackScale;
var() float KnockBackTotalTime;
var() float SpikyDamage;

simulated function Destroyed()
{
    StopAliceDamage();
    Destroyed();
}

function StopAliceDamage()
{
    bPainCausing = false;
    AliceGamePawn(WorldInfo.GetLocalPlayerPawn()).StopCauseDamage();
}

function CauseAliceDamage()
{
    local SeqAct_CauseAliceDamage CauseDamageAction;
    
    CauseDamageAction = new(self) class'SeqAct_CauseAliceDamage';
    CauseDamageAction.InputLinks[0].bHasImpulse = true;
    CauseDamageAction.bPainCausing = true;
    CauseDamageAction.bOnlyOnce = false;
    CauseDamageAction.DamagePerSec = SpikyDamage;
    CauseDamageAction.PainInterval = PainInterval;
    CauseDamageAction.KnockBackType = 2;
    CauseDamageAction.KnockBackParameter.KnockBackScale = KnockBackScale;
    CauseDamageAction.KnockBackParameter.KnockBackTotalTime = KnockBackTotalTime;
    AliceGamePawn(WorldInfo.GetLocalPlayerPawn()).OnCauseAliceDamage(CauseDamageAction);
    bPainCausing = true;
}

function TickRadiusDamage()
{
    local float Distance;
    
    Distance = VSize2D(WorldInfo.GetLocalPlayerPawn().Location - Location);
    if (!bPainCausing && Distance < Radius)
    {
        CauseAliceDamage();
    }
    if (bPainCausing && Distance > Radius)
    {
        StopAliceDamage();
    }
}

event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    TickRadiusDamage();
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    AttachComponent(ParticleEffect);
}

defaultproperties
{
    ParticleEffect="Default__CauseDamageActor.ParticleEffectComp"
    bCollideWorld=True
    Components(0)="Default__CauseDamageActor.Sprite"
    Components(1)="Default__CauseDamageActor.ParticleEffectComp"
    Components(2)="Default__CauseDamageActor.CollisionCylinder"
    CollisionType="COLLIDE_TouchAll"
    CollisionComponent="Default__CauseDamageActor.CollisionCylinder"
}
