class AnimNodeBlendList extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var array<float> TargetWeight;
var float BlendTimeToGo;
var int ActiveChildIndex;
var() bool bPlayActiveChild;
var() bool bForceChildFullWeightWhenBecomingRelevant;
var() bool bSkipBlendWhenNotRendered;
var const float SliderPosition;
var() editoronly int EditorActiveChildIndex;

native function SetActiveChild(int ChildIndex, float BlendTime)
{
    ChildIndex;
    BlendTime;
}

defaultproperties
{
    bForceChildFullWeightWhenBecomingRelevant=True
    bSkipBlendWhenNotRendered=True
    Children(0)=(Name="Child1",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    CategoryDesc="BlendBy"
}
