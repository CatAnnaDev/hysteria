class SeqAct_AndGate extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var transient bool bOpen;
var transient array<bool> LinkedOutputFiredStatus;
var native transient array<Pointer> LinkedOutputs;

defaultproperties
{
    bOpen=True
    bAutoActivateOutputLinks=False
    ObjName="AND Gate"
    ObjCategory="Misc"
}
