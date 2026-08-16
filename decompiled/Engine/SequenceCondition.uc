class SequenceCondition extends SequenceOp
    abstract
    native
    notplaceable
    hidecategories(Object);

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    bAutoActivateOutputLinks=False
    ObjName="Undefined Condition"
    ObjColor=(B=255,G=0,R=0,A=255)
}
