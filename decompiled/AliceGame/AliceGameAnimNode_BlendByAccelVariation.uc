class AliceGameAnimNode_BlendByAccelVariation extends AliceGameAnimNode_BlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var Vector Acceleration;
var Vector PreviousAcceleration;
var float AccelVariation;
var int LastChannel;
var() float BlendUpTime;
var() float BlendDownTime;
var() float BlendDownPerc;
var() array<float> Constraints;
var() bool bUseAccelerationSize;
var bool bPlayingTransitionAnim;
var bool bBlendUp;
var(Animations) float BlendDelayTime[4];
var int LastChildIndex;
var int PendingChildIndex;
var float PendingTimeToGo;

defaultproperties
{
    BlendUpTime=0.1
    BlendDownTime=0.1
    BlendDownPerc=0.2
    Constraints(0)=-165.0
    Constraints(1)=-115.0
    Constraints(2)=-75.0
    Constraints(3)=0.0
    Constraints(4)=75.0
    Constraints(5)=115.0
    Constraints(6)=165.0
    bSkipTickWhenZeroWeight=True
}
