class Player extends Object
    native
    notplaceable
    transient
    config(Engine);

var const native noexport Pointer VfTable_FExec;
var const transient PlayerController Actor;
var const int CurrentNetSpeed;
var globalconfig int ConfiguredInternetSpeed;
var globalconfig int ConfiguredLanSpeed;
var config float PP_DesaturationMultiplier;
var config float PP_HighlightsMultiplier;
var config float PP_MidTonesMultiplier;
var config float PP_ShadowsMultiplier;

native function SwitchController(PlayerController PC)
{
    PC;
}

defaultproperties
{
    ConfiguredInternetSpeed=10000
    ConfiguredLanSpeed=20000
    PP_DesaturationMultiplier=1.0
    PP_HighlightsMultiplier=1.0
    PP_MidTonesMultiplier=1.0
    PP_ShadowsMultiplier=1.0
}
