class SeqAct_SetDOFParams extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() float FalloffExponent;
var() float BlurKernelSize;
var() float MaxNearBlurAmount;
var() float MaxFarBlurAmount;
var() Color ModulateBlurColor;
var() float FocusNearInnerRadius;
var() float FocusFarInnerRadius;
var() float FocusDistance;
var() Vector FocusPosition;
var() float InterpolateSeconds;
var float InterpolateElapsed;
var() bool EnableDynamicDoF;
var() bool ShowRangefinderFilterKernel;
var() float AdaptationRate;
var() float WaitingTime;
var() Vector AimingPoint;
var() float MinFarInnerRadius;
var() float FarFocusDistance;
var() float DDofRange;
var() float ResetAdaptationRate;
var() float ResetDistDifference;
var float OldFalloffExponent;
var float OldBlurKernelSize;
var float OldMaxNearBlurAmount;
var float OldMaxFarBlurAmount;
var Color OldModulateBlurColor;
var float OldFocusNearInnerRadius;
var float OldFocusFarInnerRadius;
var float OldFocusDistance;
var Vector OldFocusPosition;

defaultproperties
{
    FalloffExponent=4.0
    BlurKernelSize=5.0
    MaxNearBlurAmount=1.0
    MaxFarBlurAmount=1.0
    ModulateBlurColor=(B=255,G=255,R=255,A=255)
    FocusNearInnerRadius=600.0
    FocusFarInnerRadius=600.0
    FocusDistance=600.0
    InterpolateSeconds=2.0
    EnableDynamicDoF=True
    AdaptationRate=10.0
    WaitingTime=5.0
    AimingPoint=(X=0.5,Y=0.45,Z=0.1)
    MinFarInnerRadius=100.0
    FarFocusDistance=700.0
    DDofRange=1000.0
    ResetAdaptationRate=120.0
    ResetDistDifference=100.0
    InputLinks(0)=(LinkDesc="Enable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Disable",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Depth Of Field"
    ObjCategory="Camera"
}
