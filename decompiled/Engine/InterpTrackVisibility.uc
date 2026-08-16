class InterpTrackVisibility extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

enum EVisibilityTrackCondition
{
    EVTC_Always,
    EVTC_GoreEnabled,
    EVTC_GoreDisabled,
};

enum EVisibilityTrackAction
{
    EVTA_Hide,
    EVTA_Show,
    EVTA_Toggle,
};

struct native VisibilityTrackKey
{
    var float Time;
    var() EVisibilityTrackAction Action;
    var EVisibilityTrackCondition ActiveCondition;
};

var array<VisibilityTrackKey> VisibilityTrack;
var() bool bFireEventsWhenForwards;
var() bool bFireEventsWhenBackwards;
var() bool bFireEventsWhenJumpingForwards;

defaultproperties
{
    bFireEventsWhenForwards=True
    bFireEventsWhenBackwards=True
    bFireEventsWhenJumpingForwards=True
    TrackInstClass="InterpTrackInstVisibility"
    TrackTitle="Visibility"
}
