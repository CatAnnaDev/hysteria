class SeqAct_Speak extends SeqAct_PlaySound
    native
    notplaceable
    hidecategories(Object);

var() const bool bTurnHeadTowardsAddressee;
var() const bool bTurnBodyTowardsAddressee;
var() const bool bUseTTS;
var transient bool bPCMGenerated;
var transient bool bSpokenLineACHasStartedPlaying;
var() const float ExtraHeadTurnTowardTime;
var() const name GestureAnimName;
var() const ETTSSpeaker TTSSpeaker;
var() const localized string TTSSpokenText;
var transient SoundCue TTSSoundCue;
var transient export editinline AudioComponent SpokenLineAC;
var transient float ExtraDelayStartTime;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

defaultproperties
{
    bTurnHeadTowardsAddressee=True
    PlaySound="Alice_Actions.Knife_Swing_TEMPCue"
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Speaker",LinkVar="None",PropertyName="Speaker",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="SpeakingTo",LinkVar="None",PropertyName="SpeakingTo",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Speak"
}
