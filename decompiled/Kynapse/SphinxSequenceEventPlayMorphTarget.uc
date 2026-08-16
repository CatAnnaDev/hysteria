class SphinxSequenceEventPlayMorphTarget extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const float MorphStartValue;
var() const float MorphEndValue;
var() const float MorphTime;
var() name MorphNodeName;

defaultproperties
{
    MorphEndValue=1.0
    MorphTime=1.0
    MorphNodeName="NAME_None"
    SequenceType="e_SphinxSequenceET_PlayMorphTarget"
}
