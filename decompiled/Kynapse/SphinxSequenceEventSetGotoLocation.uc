class SphinxSequenceEventSetGotoLocation extends SphinxSequenceEventBase
    native
    notplaceable
    editinlinenew
    hidecategories(Movement,Collision,Advanced,Attachment,Display,Object,Movement,Collision,Advanced,Attachment,Display,Object);

struct native SphinxSquenceGotoInfo
{
    var() bool EnableFaceAlice;
    var() Vector GotoLocation;
    var() Rotator GotoRotator;
};

var() array<SphinxSquenceGotoInfo> GotoArray;

defaultproperties
{
    SequenceType="e_SphinxSequenceET_SetGotoLocation"
}
