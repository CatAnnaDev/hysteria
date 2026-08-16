class GFxAction_CloseMovie extends SequenceAction
    native
    notplaceable
    hidecategories(Object);

var() GFxMovie Movie;
var() bool bUnload;

event bool IsValidLevelSequenceObject()
{
    return true;
}

defaultproperties
{
    bUnload=True
    ObjName="Close GFx Movie"
    ObjCategory="GFx"
}
