class RB_Spring extends ActorComponent
    native
    notplaceable;

var const export editinline PrimitiveComponent Component1;
var const name BoneName1;
var const export editinline PrimitiveComponent Component2;
var const name BoneName2;
var const native int SceneIndex;
var const native bool bInHardware;
var() bool bEnableForceMassRatio;
var const native Pointer SpringData;
var const native float TimeSinceActivation;
var const float MinBodyMass;
var() float SpringSaturateDist;
var() float SpringMaxForce;
var() float MaxForceMassRatio;
var() InterpCurveFloat SpringMaxForceTimeScale;
var() float DampSaturateVel;
var() float DampMaxForce;

native function Clear()
{
}

native function SetComponents(PrimitiveComponent InComponent1, name InBoneName1, Vector Position1, PrimitiveComponent InComponent2, name InBoneName2, Vector Position2)
{
    InComponent1;
    InBoneName1;
    Position1;
    InComponent2;
    InBoneName2;
    Position2;
}

defaultproperties
{
    SpringMaxForceTimeScale=(Points=((InVal=0.0,OutVal=1.0,ArriveTangent=0.0,LeaveTangent=0.0,InterpMode="CIM_Linear")),InterpMethod="IMT_UseFixedTangentEvalAndNewAutoTangents")
    TickGroup="TG_PreAsyncWork"
}
