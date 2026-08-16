class MatineeActor extends Actor
    native
    nativereplication
    notplaceable
    hidecategories(Navigation);

const MAX_AIGROUP_NUMBER = 10;

var const repretry SeqAct_Interp InterpAction;
var repretry bool bIsPlaying;
var repretry bool bReversePlayback;
var repretry bool bPaused;
var transient bool AllAIGroupsInitialized;
var repretry float PlayRate;
var repretry float Position;
var repretry name AIGroupNames[10];
var repretry Pawn AIGroupPawns[10];
var transient int AIGroupInitStage[10];
var float ClientSidePositionErrorTolerance;

replication
{
    if (bNetInitial && Role == 3)
        InterpAction;
    if (bNetDirty && Role == 3)
        bIsPlaying, bReversePlayback, bPaused, PlayRate, Position, AIGroupNames, AIGroupPawns;
}

function CheckPriorityRefresh()
{
    local Controller C;
    local int I;
    
    if (InterpAction != none)
    {
        for (I = 0; I < InterpAction.GroupInst.Length; I++)
        {
            if (InterpGroupInstDirector(InterpAction.GroupInst[I]) != none)
            {
                bNetDirty = true;
                bForceNetUpdate = true;
                return;
            }
        }
        foreach WorldInfo.AllControllers(class'Controller', C)
        {
            if (C.bIsPlayer && C.Pawn != none && InterpAction.LatentActors.Find(C.Pawn) != -1 || C.Pawn.Base != none && InterpAction.LatentActors.Find(C.Pawn.Base) != -1)
            {
                bNetDirty = true;
                bForceNetUpdate = true;
                return;
            }
        }
    }
}

event Update()
{
    local InterpGroupInstAI AIGroupInst;
    local int GroupID;
    
    bIsPlaying = InterpAction.bIsPlaying;
    bReversePlayback = InterpAction.bReversePlayback;
    bPaused = InterpAction.bPaused;
    PlayRate = InterpAction.PlayRate;
    Position = InterpAction.Position;
    bForceNetUpdate = true;
    if (bIsPlaying)
    {
        SetTimer(1.0, true, 'CheckPriorityRefresh');
    }
    else
    {
        ClearTimer('CheckPriorityRefresh');
    }
    if (InterpAction != none)
    {
        for (GroupID = 0; GroupID < InterpAction.GroupInst.Length; ++GroupID)
        {
            AIGroupInst = InterpGroupInstAI(InterpAction.GroupInst[GroupID]);
            if (AIGroupInst != none)
            {
                AddAIGroupActor(AIGroupInst);
            }
        }
    }
}

native function AddAIGroupActor(InterpGroupInstAI AIGroupInst)
{
    AIGroupInst;
}

defaultproperties
{
    PlayRate=1.0
    Position=-1.0
    ClientSidePositionErrorTolerance=0.1
    bAlwaysRelevant=True
    bReplicateMovement=False
    bSkipActorPropertyReplication=True
    bOnlyDirtyReplication=True
    Components(0)="Default__MatineeActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    NetUpdateFrequency=1.0
    NetPriority=2.7
}
