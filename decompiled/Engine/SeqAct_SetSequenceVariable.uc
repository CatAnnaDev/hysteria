class SeqAct_SetSequenceVariable extends SequenceAction
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
    ObjName="Set Variable"
    ObjCategory="Set Variable"
}
