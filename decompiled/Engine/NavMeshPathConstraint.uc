class NavMeshPathConstraint extends Object
    native
    notplaceable;

var NavMeshPathConstraint NextConstraint;
var int NumNodesProcessed;
var int NumThrownOutNodes;
var float AddedDirectCost;
var float AddedHeuristicCost;

event string GetDumpString()
{
    return string(self);
}

event Recycle()
{
    NextConstraint = none;
    NumThrownOutNodes = 0;
    AddedDirectCost = 0.0;
    AddedHeuristicCost = 0.0;
    NumNodesProcessed = 0;
}

defaultproperties
{
}
