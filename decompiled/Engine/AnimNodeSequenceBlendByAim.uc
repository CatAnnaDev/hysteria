class AnimNodeSequenceBlendByAim extends AnimNodeSequenceBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Animations);

var() Vector2D Aim;
var const transient Vector2D PreviousAim;
var() Vector2D HorizontalRange;
var() Vector2D VerticalRange;
var() Vector2D AngleOffset;
var() name AnimName_LU;
var() name AnimName_LC;
var() name AnimName_LD;
var() name AnimName_CU;
var() name AnimName_CC;
var() name AnimName_CD;
var() name AnimName_RU;
var() name AnimName_RC;
var() name AnimName_RD;

native final function CheckAnimsUpToDate()
{
}

defaultproperties
{
    HorizontalRange=(X=-1.0,Y=1.0)
    VerticalRange=(X=-1.0,Y=1.0)
    Anims(0)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=1.0)
    Anims(1)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(2)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(3)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(4)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(5)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(6)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(7)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
    Anims(8)=(AnimName="None",AnimInfo=(AnimSeqName="None",AnimSeq="None",AnimLinkupIndex=0),Weight=0.0)
}
