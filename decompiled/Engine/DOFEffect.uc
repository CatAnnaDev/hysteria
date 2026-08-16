class DOFEffect extends PostProcessEffect
    abstract
    native
    notplaceable
    hidecategories(Object);

enum EFocusType
{
    FOCUS_Distance,
    FOCUS_Position,
    FOCUS_Sphere,
};

var() float FalloffExponent;
var() float BlurKernelSize;
var() float MaxNearBlurAmount;
var() float MaxFarBlurAmount;
var() Color ModulateBlurColor;
var() EFocusType FocusType;
var() float FocusNearInnerRadius;
var() float FocusFarInnerRadius;
var() float FocusDistance;
var() Vector FocusPosition;
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

defaultproperties
{
    FalloffExponent=2.0
    BlurKernelSize=2.0
    MaxNearBlurAmount=1.0
    MaxFarBlurAmount=1.0
    ModulateBlurColor=(B=255,G=255,R=255,A=255)
    FocusNearInnerRadius=400.0
    FocusFarInnerRadius=400.0
    FocusDistance=800.0
    EnableDynamicDoF=True
    AdaptationRate=10.0
    WaitingTime=5.0
    AimingPoint=(X=0.5,Y=0.45,Z=0.1)
    MinFarInnerRadius=100.0
    FarFocusDistance=900.0
    DDofRange=1000.0
    ResetAdaptationRate=120.0
    ResetDistDifference=100.0
}
