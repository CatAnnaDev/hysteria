class SequenceObject extends Object
    abstract
    native
    notplaceable
    hidecategories(Object);

var const int ObjInstanceVersion;
var const Sequence ParentSequence;
var editoronly int ObjPosX;
var editoronly int ObjPosY;
var editoronly string ObjName;
var editoronly string ObjCategory;
var editoronly array<string> ObjRemoveInProject;
var editoronly Color ObjColor;
var() string ObjComment;
var bool bDeletable;
var bool bDrawFirst;
var bool bDrawLast;
var() bool bOutputObjCommentToScreen;
var() bool bSuppressAutoComment;
var int DrawWidth;
var int DrawHeight;

static event int GetObjClassVersion()
{
    return 1;
}

event bool IsPastingIntoUISequenceAllowed()
{
    return IsValidUISequenceObject();
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return false;
}

event bool IsPastingIntoLevelSequenceAllowed()
{
    return IsValidLevelSequenceObject();
}

event bool IsValidLevelSequenceObject()
{
    return true;
}

native final function WorldInfo GetWorldInfo()
{
}

native final function ScriptLog(string LogText, optional bool bWarning = true)
{
    LogText;
    bWarning;
}

defaultproperties
{
    ObjName="Undefined"
    ObjColor=(B=255,G=255,R=255,A=255)
    bDeletable=True
    bSuppressAutoComment=True
}
