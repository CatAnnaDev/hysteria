class InterpTrackToggle extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

enum ETrackToggleAction
{
    ETTA_Off,
    ETTA_On,
    ETTA_Toggle,
    ETTA_Trigger,
};

struct native ToggleTrackKey
{
    var float Time;
    var() ETrackToggleAction ToggleAction;
};

var array<ToggleTrackKey> ToggleTrack;
var() bool bActivateSystemEachUpdate;
var() bool bFireEventsWhenForwards;
var() bool bFireEventsWhenBackwards;
var() bool bFireEventsWhenJumpingForwards;

defaultproperties
{
    bFireEventsWhenForwards=True
    bFireEventsWhenBackwards=True
    bFireEventsWhenJumpingForwards=True
    TrackInstClass="InterpTrackInstToggle"
    TrackTitle="Toggle"
}
