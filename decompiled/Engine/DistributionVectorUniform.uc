class DistributionVectorUniform extends DistributionVector
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() Vector Max;
var() Vector Min;
var bool bLockAxes;
var() bool bUseExtremes;
var() EDistributionVectorLockFlags LockedAxes;
var() EDistributionVectorMirrorFlags MirrorFlags[3];

defaultproperties
{
    MirrorFlags="EDVMF_Different"
    MirrorFlags[1]="EDVMF_Different"
    MirrorFlags[2]="EDVMF_Different"
}
