class SeqVar_ObjectList extends SeqVar_Object
    native
    notplaceable
    hidecategories(Object);

var() array<Object> ObjList;

function SetObjectValue(Object NewValue)
{
    ObjList[0] = NewValue;
}

function Object GetObjectValue()
{
    return ObjList.Length > 0 ? ObjList[0] : none;
}

defaultproperties
{
    ObjName="Object List"
    ObjColor=(B=102,G=0,R=102,A=255)
}
