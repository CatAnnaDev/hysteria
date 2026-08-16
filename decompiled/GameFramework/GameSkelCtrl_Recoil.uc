class GameSkelCtrl_Recoil extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

enum ERecoilStart
{
    ERS_Zero,
    ERS_Random,
};

struct native RecoilDef
{
    var transient float TimeToGo;
    var() float TimeDuration;
    var() Vector RotAmplitude;
    var() Vector RotFrequency;
    var Vector RotSinOffset;
    var() RecoilParams RotParams;
    var transient Rotator RotOffset;
    var() Vector LocAmplitude;
    var() Vector LocFrequency;
    var Vector LocSinOffset;
    var() RecoilParams LocParams;
    var transient Vector LocOffset;
};

struct native RecoilParams
{
    var() ERecoilStart X;
    var() ERecoilStart Y;
    var() ERecoilStart Z;
    var const transient byte Padding;
};

var() bool bBoneSpaceRecoil;
var() transient bool bPlayRecoil;
var transient bool bOldPlayRecoil;
var transient bool bApplyControl;
var() RecoilDef Recoil;
var() Vector2D Aim;

defaultproperties
{
    Recoil=(TimeToGo=0.0,TimeDuration=0.33,RotAmplitude=(X=0.0,Y=0.0,Z=0.0),RotFrequency=(X=0.0,Y=0.0,Z=0.0),RotSinOffset=(X=0.0,Y=0.0,Z=0.0),RotParams=(X="ERS_Zero",Y="ERS_Zero",Z="ERS_Zero",Padding=0),RotOffset=(Pitch=0,Yaw=0,Roll=0),LocAmplitude=(X=0.0,Y=0.0,Z=0.0),LocFrequency=(X=0.0,Y=0.0,Z=0.0),LocSinOffset=(X=0.0,Y=0.0,Z=0.0),LocParams=(X="ERS_Zero",Y="ERS_Zero",Z="ERS_Zero",Padding=0),LocOffset=(X=0.0,Y=0.0,Z=0.0))
    CategoryDesc="Recoil"
}
