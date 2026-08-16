class CycleFloatIndicatorManager extends Object
    notplaceable
    within AliceCycleFloatManager;

var bool bClockWise;
var bool bInitPositionRandom;
var float Radius;
var float theta;
var float thetaInit;
var float thetaSpeed;
var float relativeZ;
var ParticleSystem indicatorPS;
var array<Emitter> indicatorEmitters;

function startEffect()
{
    local int I, leftCycleNum, Angle;
    local Vector vLocation;
    local Emitter Emitter;
    
    if (indicatorEmitters.Length > 0)
    {
        stopEffect();
    }
    leftCycleNum = Outer.MaxCycleNum - Outer.CycleNum;
    if (leftCycleNum <= 0)
    {
        return;
    }
    if (bInitPositionRandom)
    {
        theta = RandRange(-3.1415927, 3.1415927);
    }
    else
    {
        theta = thetaInit;
    }
    indicatorEmitters.Length = 0;
    Angle = int(float(2) * 3.1415927 / float(leftCycleNum));
    for (I = 0; I < leftCycleNum; I++)
    {
        Emitter = Outer.Outer.Spawn(class'Engine.EmitterSpawnable', , , Outer.Outer.Pawn.Location);
        if (Emitter != none && indicatorPS != none)
        {
            Emitter.SetTemplate(indicatorPS);
            Emitter.SetHidden(false);
            indicatorEmitters.AddItem(Emitter);
            Emitter.SetBase(Outer.Outer.MyAlicePawn);
            vLocation.X = Radius * Cos(theta + float(I * Angle));
            vLocation.Y = Radius * Sin(theta + float(I * Angle));
            vLocation.Z = relativeZ;
            Emitter.SetRelativeLocation(vLocation);
        }
    }
}

function stopEffect()
{
    local Emitter indicator;
    
    foreach indicatorEmitters(indicator)
    {
        indicator.SetHidden(true);
        indicator.LifeSpan = 0.1;
    }
    indicatorEmitters.Length = 0;
}

function Update(float DeltaTime)
{
    local int I, Angle;
    local Vector vLocation;
    
    if (indicatorEmitters.Length <= 0)
    {
        startEffect();
    }
    theta += DeltaTime * thetaSpeed * float(bClockWise ? 1 : -1);
    if (indicatorEmitters.Length == 0)
    {
        return;
    }
    Angle = int(float(2) * 3.1415927 / float(indicatorEmitters.Length));
    for (I = 0; I < indicatorEmitters.Length; I++)
    {
        vLocation.X = Radius * Cos(theta + float(I * Angle));
        vLocation.Y = Radius * Sin(theta + float(I * Angle));
        vLocation.Z = relativeZ;
        indicatorEmitters[I].SetRelativeLocation(vLocation);
    }
}

defaultproperties
{
    bInitPositionRandom=True
    Radius=100.0
    thetaInit=0.8
    thetaSpeed=2.0
    indicatorPS="GFX_Alice.Glide.FloatIndicator"
}
