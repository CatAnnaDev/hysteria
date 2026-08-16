class SphinxSequenceEventFadeComponent extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

var() const name TimeVaryParamName;
var() const bool UseDuplicate;
var() const int ComponentID;

defaultproperties
{
    TimeVaryParamName="FadeOutAlpha"
    UseDuplicate=True
    SequenceType="e_SphinxSequenceET_FadeComponent"
}
