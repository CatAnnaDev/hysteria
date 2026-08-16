class AnimNotify_PlayParticleEffect extends AnimNotify
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() ParticleSystem PSTemplate;
var() bool bIsExtremeContent;
var() bool bAttach;
var() editoronly bool bPreview;
var() bool bSkipIfOwnerIsHidden;
var() bool bIgnoreOwnerHiddenIfAttached;
var() name SocketName;
var() name BoneName;
var() int ComponentIndex;
var() float DrawScale;

defaultproperties
{
    bSkipIfOwnerIsHidden=True
    bIgnoreOwnerHiddenIfAttached=True
    DrawScale=1.0
}
