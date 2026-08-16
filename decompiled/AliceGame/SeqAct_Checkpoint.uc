class SeqAct_Checkpoint extends SeqAct_Latent
    native
    notplaceable
    hidecategories(Object);

var() bool bUnlockChapter;
var() ChapterNameList UnlockedChapter;
var Actor TeleportTargetPlayer;
var transient float ActivationTime;

event bool Update(float DeltaTime)
{
    local AliceGameEngine Engine;
    local AlicePlayerController PC;
    local bool Ret;
    
    Ret = false;
    foreach GetWorldInfo().LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        Engine = AliceGameEngine(PC.Player.Outer);
    }
    LogInternal("SeqAct_Checkpoint time" @ string(ActivationTime) @ "real time" @ string(GetWorldInfo().TimeSeconds) @ string(Engine.PendingCheckpointAction));
    if (Engine.PendingCheckpointAction != 0 && Engine.PendingCheckpointAction != 5)
    {
        Ret = true;
    }
    if (GetWorldInfo().TimeSeconds <= ActivationTime)
    {
        Ret = true;
    }
    return Ret;
}

final function bool ShouldTeleport(Pawn TestPawn, Vector TeleportLocation)
{
    return true;
}

static event int GetObjClassVersion()
{
    return GetObjClassVersion() + 2;
}

event Deactivated()
{
    if (OutputLinks.Length > 1)
    {
        OutputLinks[1].bHasImpulse = true;
    }
}

exec function LoadCheckpoint()
{
}

exec function SaveCheckpoint()
{
    local AliceGameEngine Engine;
    local AlicePlayerController PC;
    local AliceGameInfo agi;
    
    agi = AliceGameInfo(GetWorldInfo().Game);
    foreach GetWorldInfo().LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        Engine = AliceGameEngine(PC.Player.Outer);
        if (PC.Pawn != none)
        {
            Engine.PendingCheckpointLocation = PC.Pawn.Location;
            continue;
        }
        Engine.PendingCheckpointLocation = PC.Location;
    }
    agi.SavePersistentSaveDataAndCheckPoint(agi.GFxHUDMenu);
}

event Activated()
{
    if (InputLinks[0].bHasImpulse)
    {
        if (bUnlockChapter)
        {
            GetWorldInfo().Game.MyCheckPointManager.LastCheckPoint = UnlockedChapter;
            GetWorldInfo().Game.MyCheckPointManager.AliceChapterLockState[int(UnlockedChapter)] = 1;
        }
        SaveCheckpoint();
    }
    else if (InputLinks[1].bHasImpulse)
    {
        LoadCheckpoint();
    }
    OutputLinks[0].bHasImpulse = true;
    ActivationTime = GetWorldInfo().TimeSeconds;
}

defaultproperties
{
    ActivationTime=-100000.0
    bCallHandler=False
    bAutoActivateOutputLinks=False
    InputLinks(0)=(LinkDesc="Save",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Load",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    OutputLinks(0)=(Links=(),LinkDesc="Out",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    OutputLinks(1)=(Links=(),LinkDesc="Finished",bHasImpulse=False,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",ActivateDelay=0.0,DrawY=0,bHidden=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    VariableLinks(0)=(ExpectedType="Engine.SeqVar_Object",LinkedVariables=(),LinkDesc="Teleport Target",LinkVar="None",PropertyName="TeleportTargetPlayer",bWriteable=False,bModifiesLinkedObject=False,bHidden=False,MinVars=1,MaxVars=1,DrawX=0,CachedProperty="None",bAllowAnyType=False,bMoving=False,bClampedMax=False,bClampedMin=False,OverrideDelta=0)
    ObjName="Checkpoint"
    ObjCategory="CheckPoint"
}
