class MaterialExpression extends Object
    abstract
    native
    notplaceable
    within Material
    hidecategories(Object);

struct ExpressionInput
{
    var MaterialExpression Expression;
    var int Mask;
    var int MaskR;
    var int MaskG;
    var int MaskB;
    var int MaskA;
    var int GCC64_Padding;
};

var deprecated int EditorX;
var deprecated int EditorY;
var editoronly int MaterialExpressionEditorX;
var editoronly int MaterialExpressionEditorY;
var bool bRealtimePreview;
var transient bool bNeedToUpdatePreview;
var bool bIsParameterExpression;
var bool bShowOutputNameOnPin;
var bool bHidePreviewWindow;
var const MaterialExpressionCompound Compound;
var() string Desc;
var array<name> MenuCategories;

defaultproperties
{
}
