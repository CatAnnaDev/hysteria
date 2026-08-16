class KynapseFpdModifierComputeTargetPoint_ShortCut extends KynapseFpdModifierComputeTargetPoint
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object)
    autoexpandcategories(KynapseFpdModifierComputeTargetPoint_ShortCut);

var() const float SamplingStep;
var() const float UpdatePeriod;

defaultproperties
{
    SamplingStep=0.2
    UpdatePeriod=0.1
    ClassName="Fpd::CComputeTargetPoint_ShortCut"
}
