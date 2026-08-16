class SeqCond_SwitchBase extends SequenceCondition
    abstract
    native
    placeable
    hidecategories(Object);

event RemoveValueEntry(int RemoveIndex)
{
}

event InsertValueEntry(int InsertIndex)
{
}

event bool IsFallThruEnabled(int ValueIndex)
{
    return false;
}

event VerifyDefaultCaseValue()
{
}

defaultproperties
{
    OutputLinks(0)=(Links=(),LinkDesc="Default",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjCategory="Switch"
}
