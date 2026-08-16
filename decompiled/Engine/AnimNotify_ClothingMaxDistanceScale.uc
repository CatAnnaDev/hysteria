class AnimNotify_ClothingMaxDistanceScale extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EMaxDistanceScaleMode
{
    MDSM_Multiply,
    MDSM_Substract,
};

var() float StartScale;
var() float EndScale;
var() EMaxDistanceScaleMode ScaleMode;
var float Duration;

defaultproperties
{
    StartScale=1.0
    EndScale=1.0
}
