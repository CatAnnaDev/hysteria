class AliceHud extends HUD
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

event PostRender()
{
    local AlicePlayerController APC;
    
    PostRender();
    APC = AlicePlayerController(PlayerOwner);
    if (APC.bTargetingModeActive && APC.TargetingActor != none && APC.TargetingActor.IsA('AliceGameKynapsePawn') && APC.TargetNPCSocket.Pawn != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.TargetNPCSocket.LockOnSocketLocation));
    }
    else if (APC.bTargetingModeActive && APC.TargetingActor != none && APC.TargetingActor.IsA('GameBreakableActor') && APC.TargetBActorInfo.BActor != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.TargetBActorInfo.vLocation + APC.TargetBActorInfo.LockOffsetUI));
    }
    else if (APC.bTargetingModeActive && APC.TargetingActor != none && APC.TargetingActor.IsA('DoomBarrierActor') && APC.TargetSMAInfo.Actor != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.TargetSMAInfo.UILockOnLoc));
    }
    if (!APC.bTargetingModeActive && APC.PreTargetingActor != none && APC.PreTargetingActor.IsA('AliceGameKynapsePawn') && APC.PreTargetNPCSocket.Pawn != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.PreTargetNPCSocket.LockOnSocketLocation));
    }
    else if (!APC.bTargetingModeActive && APC.PreTargetingActor != none && APC.PreTargetingActor.IsA('GameBreakableActor') && APC.PreTargetBActorInfo.BActor != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.PreTargetBActorInfo.vLocation + APC.PreTargetBActorInfo.LockOffsetUI));
    }
    else if (!APC.bTargetingModeActive && APC.PreTargetingActor != none && APC.PreTargetingActor.IsA('DoomBarrierActor') && APC.PreTargetSMAInfo.Actor != none)
    {
        APC.TargetNPCSocketLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.PreTargetSMAInfo.UILockOnLoc));
    }
    if (APC.bFirstPersonViewActive)
    {
        APC.CrossHairLocation2D = APC.UI_AdjustScreenPos(Canvas.Project(APC.CrossHairLocation));
    }
    AlicePlayerCamera(APC.PlayerCamera).SetProjectionInfo(Canvas.GetProjectionMatrix(), Canvas.ClipX, Canvas.ClipY, Canvas.GetViewMatrix(), Canvas.GetPerspectiveMatrix());
}

defaultproperties
{
}
