class SeqVar_Object extends SequenceVariable
    native
    notplaceable
    hidecategories(Object);

var() Object ObjValue;
var transient Vector ActorLocation;
var const array<class<Object>> SupportedClasses;

function SetObjectValue(Object NewValue)
{
    ObjValue = NewValue;
}

function Object GetObjectValue()
{
    return ObjValue;
}

defaultproperties
{
    SupportedClasses(0)="Core.Object"
    ObjName="Object"
    ObjCategory="Object"
    ObjColor=(B=255,G=0,R=255,A=255)
}
