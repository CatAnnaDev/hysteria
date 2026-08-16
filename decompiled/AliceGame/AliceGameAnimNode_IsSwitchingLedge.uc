class AliceGameAnimNode_IsSwitchingLedge extends AliceGameAnimNode_BlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var int iStatus;

defaultproperties
{
    iStatus=-1
    bPlayActiveChild=True
    Children(0)=(Name="TRUE",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="FALSE",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    bSkipTickWhenZeroWeight=True
}
