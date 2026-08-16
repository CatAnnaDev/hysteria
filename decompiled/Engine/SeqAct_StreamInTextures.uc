class SeqAct_StreamInTextures extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var deprecated bool bLocationBased;
var const bool bStreamingActive;
var() float Seconds;
var const float StopTimestamp;
var() array<Object> LocationActors;
var() array<MaterialInterface> ForceMaterials;
var(CinematicMipLevels) const TextureGroupContainer CinematicTextureGroups;
var const native transient int SelectedCinematicTextureGroups;

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 1;
}

event bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return true;
}

defaultproperties
{
    Seconds=15.0
    InputLinks(0)=(LinkDesc="Start",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    VariableLinks(0)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Actor",LinkVar="None",PropertyName="Targets",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(1)=(ExpectedType="SeqVar_Object",LinkedVariables=(),LinkDesc="Location",LinkVar="None",PropertyName="LocationActors",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=255,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Stream In Textures"
    ObjCategory="Actor"
}
