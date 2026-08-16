class InterpTrackEvent extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native EventTrackKey
{
    var float Time;
    var() name EventName;
};

var array<EventTrackKey> EventTrack;
var() bool bFireEventsWhenForwards;
var() bool bFireEventsWhenBackwards;
var() bool bFireEventsWhenJumpingForwards;

defaultproperties
{
    bFireEventsWhenForwards=True
    bFireEventsWhenBackwards=True
    TrackInstClass="InterpTrackInstEvent"
    TrackTitle="Event"
}
