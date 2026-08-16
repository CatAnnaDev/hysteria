class GameEffectSpeedController extends Object
    native
    notplaceable;

enum EGameEffectSpeedControlPriority
{
    EGameEffectSpeedControlPriority_0,
    EGameEffectSpeedControlPriority_1,
    EGameEffectSpeedControlPriority_2,
    EGameEffectSpeedControlPriority_3,
};

struct native GameEffectSpeedControlPara
{
    var float CurScale;
    var float MinScale;
    var float DecTime;
    var float FrzTime;
    var float IncTime;
    var EGameEffectSpeedControlPriority Priority;
};

var array<GameEffectSpeedControlPara> SpeedControlParaQueue;
var transient int QueueFrontIndex;
var transient int QueueEndIndex;

native function QueueReset()
{
}

native function bool InQueueSpeedControlPara(float MinScale, float DecTime, float FrzTime, float IncTime, EGameEffectSpeedControlPriority Priority)
{
    MinScale;
    DecTime;
    FrzTime;
    IncTime;
    Priority;
}

defaultproperties
{
}
