class AnimNodeBlendBySpeed extends AnimNodeBlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var float Speed;
var int LastChannel;
var() float BlendUpTime;
var() float BlendDownTime;
var() float BlendDownPerc;
var() array<float> Constraints;
var() bool bUseAcceleration;
var() float BlendUpDelay;
var() float BlendDownDelay;
var transient float BlendDelayRemaining;

defaultproperties
{
    BlendUpTime=0.1
    BlendDownTime=0.1
    BlendDownPerc=0.2
    Constraints(0)=0.0
    Constraints(1)=180.0
    Constraints(2)=350.0
    Constraints(3)=900.0
    bSkipTickWhenZeroWeight=True
}
