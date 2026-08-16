class SeqVar_ObjectVolume extends SeqVar_Object
    native
    notplaceable
    hidecategories(Object);

var float LastUpdateTime;
var array<Object> ContainedObjects;
var() array<class<Object>> ExcludeClassList;
var() bool bCollidingOnly;

defaultproperties
{
    ExcludeClassList(0)="Trigger"
    ExcludeClassList(1)="Volume"
    bCollidingOnly=True
    ObjName="Object Volume"
}
