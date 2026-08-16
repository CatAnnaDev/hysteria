class SequenceFrame extends SequenceObject
    native
    notplaceable
    hidecategories(Object);

var() int SizeX;
var() int SizeY;
var() int BorderWidth;
var() bool bDrawBox;
var() bool bFilled;
var() bool bTileFill;
var() Color BorderColor;
var() Color FillColor;
var() editoronly Texture2D FillTexture;
var() editoronly Material FillMaterial;

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    SizeX=128
    SizeY=64
    BorderWidth=1
    bFilled=True
    BorderColor=(B=0,G=0,R=0,A=255)
    FillColor=(B=255,G=255,R=255,A=16)
    ObjName="Sequence Comment"
    ObjComment="Comment"
    bDrawFirst=True
}
