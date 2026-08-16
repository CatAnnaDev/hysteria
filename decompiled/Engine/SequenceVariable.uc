class SequenceVariable extends SequenceObject
    abstract
    native
    notplaceable
    hidecategories(Object);

var() name VarName;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    ObjName="Undefined Variable"
    ObjColor=(B=0,G=0,R=0,A=255)
    bDrawLast=True
}
