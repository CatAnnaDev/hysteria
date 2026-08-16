class DistributionVector extends Component
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EDistributionVectorMirrorFlags
{
    EDVMF_Same,
    EDVMF_Different,
    EDVMF_Mirror,
};

enum EDistributionVectorLockFlags
{
    EDVLF_None,
    EDVLF_XY,
    EDVLF_XZ,
    EDVLF_YZ,
    EDVLF_XYZ,
};

struct native RawDistributionVector extends RawDistribution
{
    var() export editinline noclear DistributionVector Distribution;
};

var const native noexport Pointer VfTable_FCurveEdInterface;
var(Baked) bool bCanBeBaked;
var bool bIsDirty;

native function Vector GetVectorValue(optional float F = 0.0, optional int LastExtreme = 0)
{
    F;
    LastExtreme;
}

defaultproperties
{
    bCanBeBaked=True
    bIsDirty=True
}
