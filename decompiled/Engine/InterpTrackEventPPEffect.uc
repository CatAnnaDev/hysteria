class InterpTrackEventPPEffect extends InterpTrackEvent
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native PPEffectEvent
{
    var float Time;
    var() name EffectName;
    var() bool bShowInEditor;
    var() bool bShowInGame;
    var() bool bSetNewMaterial;
    var() bool bUseScreenAsTexture;
    var() MaterialInterface NewMaterial;
    var() array<EventPPEffect_MatParameter> MatParameters;
};

struct native EventPPEffect_MatParameter
{
    var() name ParamName;
    var() float ScalarValue;
    var() bool bActiveVaryingTime;
};

var() array<PPEffectEvent> PPEffectEvents;
var() bool bAllowLoop;

defaultproperties
{
    bFireEventsWhenForwards=False
    bFireEventsWhenBackwards=False
    TrackInstClass="InterpTrackInstEventPPEffect"
    TrackTitle="Event PPEffect"
}
