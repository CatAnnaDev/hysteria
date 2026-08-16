class InterpTrack extends Object
    abstract
    native
    noexport
    notplaceable
    collapsecategories
    hidecategories(Object);

enum ETrackActiveCondition
{
    ETAC_Always,
    ETAC_GoreEnabled,
    ETAC_GoreDisabled,
};

var const native noexport Pointer VfTable_FInterpEdInputInterface;
var native noexport Pointer CurveEdVTable;
var class<InterpTrackInst> TrackInstClass;
var() ETrackActiveCondition ActiveCondition;
var string TrackTitle;
var bool bOnePerGroup;
var bool bDirGroupOnly;
var bool bDisableTrack;
var bool bIsAnimControlTrack;
var transient bool bVisible;
var transient bool bIsSelected;
var transient bool bIsRecording;

defaultproperties
{
    TrackInstClass="InterpTrackInst"
    TrackTitle="Track"
    bVisible=True
}
