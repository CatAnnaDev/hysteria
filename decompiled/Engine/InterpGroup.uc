class InterpGroup extends Object
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct InterpEdSelKey
{
    var InterpGroup Group;
    var int TrackIndex;
    var int KeyIndex;
    var float UnsnappedPosition;
};

var const native noexport Pointer VfTable_FInterpEdInputInterface;
var export array<InterpTrack> InterpTracks;
var name GroupName;
var() Color GroupColor;
var() array<AnimSet> GroupAnimSets;
var bool bCollapsed;
var transient bool bVisible;
var bool bIsFolder;
var bool bIsParented;
var transient bool bIsSelected;

defaultproperties
{
    GroupName="InterpGroup"
    GroupColor=(B=200,G=80,R=100,A=255)
    bVisible=True
}
