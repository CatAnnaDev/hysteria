class DistributionVectorUniformCurve extends DistributionVector
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() InterpCurveTwoVectors ConstantCurve;
var bool bLockAxes1;
var bool bLockAxes2;
var() bool bUseExtremes;
var() EDistributionVectorLockFlags LockedAxes[2];
var() EDistributionVectorMirrorFlags MirrorFlags[3];

defaultproperties
{
    MirrorFlags="EDVMF_Different"
    MirrorFlags[1]="EDVMF_Different"
    MirrorFlags[2]="EDVMF_Different"
}
