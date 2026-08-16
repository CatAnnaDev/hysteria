class AliceAnimNotify_PlayMorph extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() const float MorphStartValue;
var() const float MorphEndValue;
var() const float MorphTime;
var() name MorphNodeName;

defaultproperties
{
    MorphEndValue=1.0
    MorphTime=1.0
    MorphNodeName="NAME_None"
}
