class MorphNodeWeight extends MorphNodeWeightBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var float NodeWeight;
var float OldNodeWeight;

native function ResetNodeWeight(float NewWeight)
{
    NewWeight;
}

native function SetNodeWeight(float NewWeight)
{
    NewWeight;
}

defaultproperties
{
    OldNodeWeight=1.0
    NodeConns(0)=(ChildNodes=(),ConnName="In",DrawY=0)
    bDrawSlider=True
}
