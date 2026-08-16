class UIComp_DrawComponents extends UIComponent
    native
    notplaceable
    within UIObject;

enum EFadeType
{
    EFT_None,
    EFT_Fading,
    EFT_Pulsing,
};

var(Rendering) transient EFadeType FadeType;
var(Rendering) transient float FadeAlpha;
var(Rendering) transient float FadeTarget;
var(Rendering) transient float FadeTime;
var transient float LastRenderTime;
var transient float FadeRate;
var delegate<OnFadeComplete> __OnFadeComplete__Delegate;

delegate OnFadeComplete(UIComp_DrawComponents Sender)
{
}

native final function ResetFade()
{
}

native final function Pulse(optional float MaxAlpha = 1.0, optional float MinAlpha = 0.0, optional float PulseRate = 1.0)
{
    MaxAlpha;
    MinAlpha;
    PulseRate;
}

native final function Fade(float FromAlpha, float ToAlpha, float TargetFadeTime)
{
    FromAlpha;
    ToAlpha;
    TargetFadeTime;
}

defaultproperties
{
}
