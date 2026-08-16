class MaterialExpressionCustom extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

enum ECustomMaterialOutputType
{
    CMOT_Float1,
    CMOT_Float2,
    CMOT_Float3,
    CMOT_Float4,
};

struct native CustomInput
{
    var() string InputName;
    var ExpressionInput Input;
};

var() string Code;
var() ECustomMaterialOutputType OutputType;
var() string Description;
var() array<CustomInput> Inputs;

defaultproperties
{
    OutputType="CMOT_Float3"
    Description="Custom"
    Inputs(0)=(InputName="",Input=(Expression="None",Mask=0,MaskR=0,MaskG=0,MaskB=0,MaskA=0,GCC64_Padding=0))
    MenuCategories(0)="Custom"
}
