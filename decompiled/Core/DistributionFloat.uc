class DistributionFloat extends Component
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native RawDistributionFloat extends RawDistribution
{
    var() export editinline noclear DistributionFloat Distribution;
};

var const native noexport Pointer VfTable_FCurveEdInterface;
var(Baked) bool bCanBeBaked;
var bool bIsDirty;

native function float GetFloatValue(optional float F = 0.0)
{
    F;
}

defaultproperties
{
    bCanBeBaked=True
    bIsDirty=True
}
