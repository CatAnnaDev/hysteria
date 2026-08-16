class AliceGFxMovie_HUD extends AliceGFXMovie
    notplaceable;

var bool bShowTarget;
var() SoundCue TutorialSound;

function PlaySound(string Index)
{
    switch (Index)
    {
        case "SelectSound":
            PlaySoundWhenPause(SelectSound);
            break;
        case "SelectBackSound":
            PlaySoundWhenPause(SelectBackSound);
            break;
        case "OptionHighLightSound":
            PlaySoundWhenPause(OptionHighLightSound);
            break;
        case "UpgradeWeaponSuccessSound":
            PlaySoundWhenPause(UpgradeWeaponSuccessSound);
            break;
        default:
    }
}

function PlaySoundWhenPause(SoundCue Sound)
{
    local AudioComponent AC;
    
    AC = GetAlicePlayerController().GetPooledAudioComponent(Sound, GetAlicePlayerController(), false, true, GetAlicePlayerController().Location);
    if (AC == none)
    {
        return;
    }
    AC.bIsUISound = true;
    AC.bUseOwnerLocation = false;
    AC.Location = GetAlicePlayerController().Location;
    AC.Play();
}

function ShowLockOnUI()
{
    ActionScriptVoid("_root.ShowLockOnUI");
}

function SetCinematicMode(bool bCinamatic)
{
    ActionScriptVoid("_root.SetCinematicMode");
}

function notifyUIUpgradeHealth(float healthCur, float HealthMax)
{
    ActionScriptVoid("_root.notifyUIUpgradeHealth");
}

function showCat(float fShow, string sText)
{
    ActionScriptVoid("_root.showCat");
}

function ReSetUIAfterLoadCheckPoint()
{
    ActionScriptVoid("_root.ReSetUIAfterLoadCheckPoint");
}

function showDeath()
{
    SetFocus(true, true);
    ActionScriptVoid("_root.showDeath");
}

function deathQuitGame()
{
    local AliceGameEngine Age;
    local AlicePlayerController PC;
    
    PC = GetAlicePlayerController();
    Age = PC.getAliceGameEngine();
    Age.StartStateName = 'PlayerWalking';
    donotShowStartScreen();
    GetGameViewportClient().ConsoleCommand("open AliceEntry");
}

function deathRestartGame()
{
    local AlicePlayerController PC;
    
    PC = GetAlicePlayerController();
    if (PC != none)
    {
        if (PC.respawn_info.Level == 2)
        {
            PC.bConfirmToRespawn = true;
        }
        else
        {
            AliceGameInfo(PC.WorldInfo.Game).LoadLastCheckpointFromTitleMenu();
        }
    }
    SetFocus(false, false);
}

function showChessPuzzleLeftStep(int leftStep)
{
    ActionScriptVoid("_root.showChessPuzzleLeftStep");
}

function showBlockPuzzleLeftStep(int leftStep)
{
    ActionScriptVoid("_root.showBlockPuzzleLeftStep");
}

function closeMoveCircle()
{
    ActionScriptVoid("_root.closeMoveCircle");
}

function showMoveCircle()
{
    ActionScriptVoid("_root.showMoveCircle");
}

function showBlockPuzzleUI(bool bShow)
{
    if (bShow)
    {
        ActionScriptVoid("_root.ShowEmoInhabit");
    }
    else
    {
        ActionScriptVoid("_root.HideEmoInhabit");
    }
}

function UpdateCrossHairPosition(AlicePlayerController ParamApc)
{
    if (ParamApc != none && ParamApc.bShowFPS_Reticule)
    {
        UpdateCrossHairPosition6(ParamApc.CrossHairLocation2D.X, ParamApc.CrossHairLocation2D.Y, 2.0, 0.0, 10.0, 10.0);
    }
}

function UpdateCrossHairPosition6(float XPos, float YPos, float Something0, float Something1, float Something2, float Something3)
{
    ActionScriptVoid("_root.addPoint");
}

function Hide(bool bInCinematicMode)
{
    ActionScriptVoid("_root.Hide");
}

function PlayTutorialSound()
{
    GetAlicePlayerController().PlaySound(TutorialSound);
}

function ShowInteractDescrible(bool bShow, string sText)
{
    ActionScriptVoid("_root.showInteractDescrible");
}

function ShowInteractPressX(float Duration, string sText)
{
    ActionScriptVoid("_root.showInteractPressX");
}

function ShowPOIUIHint(float fDuration, string sText)
{
    ActionScriptVoid("_root.showPoiuiHint");
}

function ShowKismetCustomUI(float Duration, string sText, EKismetToggleUIType Type)
{
    switch (Type)
    {
        case 0:
            ActionScriptVoid("_root.showTutorial");
            break;
        case 1:
            ActionScriptVoid("_root.showInspect");
            break;
        case 3:
            ActionScriptVoid("_root.showChapter");
            break;
        case 4:
            ActionScriptVoid("_root.showEnemy");
            break;
        default:
    }
}

function ShowCancelMatineeHint(bool bShow, string sText)
{
    ActionScriptVoid("_root.ShowCancelMatineeHint");
}

function ShowLockOnUIHint(int show, string sText)
{
    ActionScriptVoid("_root.showLockOnUIHint");
}

function ToggleCritical(bool Actived)
{
    ActionScriptVoid("_root.toggleCritical");
}

function ShowCrossHair(bool bShow)
{
    ActionScriptVoid("_root.ShowAimIndicator");
}

function ShowLockOnIndicator(bool bShow)
{
    ActionScriptVoid("_root.ShowLockOnIndicator");
}

function ChangeAimIcon(int Id)
{
    ActionScriptVoid("_root.ChangeAimIcon");
}

function UpdateAimTargetUI(bool bOnTarget)
{
    ActionScriptVoid("_root.UpdateAimTargetUI");
}

function ChangeResolution(string Mode)
{
    ActionScriptVoid("_root.ChangeResolution");
}

function exitInteractState()
{
    local AlicePlayerController PC;
    
    SetFocus(false);
    foreach class'Engine.UIScene'.static.GetWorldInfo().LocalPlayerControllers(class'AlicePlayerController', PC)
    {
        PC.exitInteractState();
    }
}

function HideUpgradeUI()
{
    SetFocus(false);
}

function ShowWeaponFoundUI(int WeaponID)
{
    local array<ASValue> args;
    local ASValue val;
    
    val.N = float(WeaponID);
    val.Type = 2;
    args.AddItem(val);
    Invoke("_root.showWeaponFound", args);
    SetFocus(true);
}

function ShowWeaponUpgradeUI(int WeaponID)
{
    local array<ASValue> args;
    local ASValue val;
    
    val.N = float(WeaponID);
    val.Type = 2;
    args.AddItem(val);
    Invoke("_root.showWeaponUpgrade", args);
    SetFocus(true);
}

function SetTeapotCannonAmmo(float newAmmoCount, float maxCount)
{
    local array<ASValue> args;
    local ASValue val1, val2;
    
    if (newAmmoCount > maxCount)
    {
        newAmmoCount = maxCount;
    }
    val1.N = newAmmoCount;
    val1.Type = 2;
    args.AddItem(val1);
    val2.N = maxCount;
    val2.Type = 2;
    args.AddItem(val2);
    Invoke("_root.UpdateTeaPotAmmo", args);
    ShowAmmoUI();
}

function forceSetTeapotCannonAmmo()
{
    ActionScriptVoid("_root.forceUpdateTeaPotAmmo");
}

function forceSetEyestaffAmmo()
{
    ActionScriptVoid("_root.forceUpdateEyestaffAmmo");
}

function SetEyestaffAmmo(float newAmmoCount, float maxCount)
{
    local array<ASValue> args;
    local ASValue val1, val2;
    
    if (newAmmoCount > maxCount)
    {
        newAmmoCount = maxCount;
    }
    val1.N = newAmmoCount;
    val1.Type = 2;
    args.AddItem(val1);
    val2.N = maxCount;
    val2.Type = 2;
    args.AddItem(val2);
    Invoke("_root.UpdateEyestaffAmmo", args);
    ShowAmmoUI();
}

function changeRangedWeapon(int Id)
{
    ActionScriptVoid("_root.changeRangedWeapon");
}

function NotifyChangedWeapon(int NewWeaponID)
{
    ActionScriptVoid("_root.changeWeapon");
}

function SetMFTotalCount(int TotalCount)
{
    ActionScriptVoid("_root.setMemoryCount");
}

function ShowPickupTip(string strTip, int PickUpType)
{
    ActionScriptVoid("_root.showMemory");
}

function ShowHUD()
{
    ActionScriptVoid("_root.showHUD");
}

function hideHUD()
{
    ActionScriptVoid("_root.hideHUD");
}

function ShowAmmoUI()
{
    local array<ASValue> args;
    local ASValue val;
    
    val.Type = 1;
    args.AddItem(val);
    Invoke("_root.showAmmoUI", args);
}

function DrawChessDesc(AlicePlayerController ParamApc, string Desc)
{
    local array<ASValue> args;
    local ASValue val;
    
    val.S = Desc;
    val.Type = 3;
    args.AddItem(val);
    Invoke("_root.addChessText", args);
    GetPlatform();
}

function DrawObjectiveDesc(AlicePlayerController ParamApc, string Desc)
{
    local array<ASValue> args;
    local ASValue val;
    
    val.S = Desc;
    val.Type = 3;
    args.AddItem(val);
    Invoke("_root.addObjectiveText", args);
    GetPlatform();
}

function ChangeAliceEnvironment(bool bInLondon)
{
    ActionScriptVoid("_root.ChangeAliceEnvironment");
}

function UpdateTeethNumber(int XPValue, bool bCanUpgrade)
{
    ActionScriptVoid("_root.UpdateTeeth");
}

function UpdateAliceHealth(int curHealth, int maxHealth)
{
    ActionScriptVoid("_root.UpdateAliceHealth");
}

function int getAliceHealthMax()
{
    return GetAlicePlayerController().MyAlicePawn.HealthMax;
}

function int getAliceHealth()
{
    return GetAlicePlayerController().MyAlicePawn.Health;
}

function showHealthyUpgrade(int Count)
{
    ActionScriptVoid("_root.showHealthyUpgrade");
}

function ShowBombCountDown(float Time)
{
    ActionScriptVoid("_root.showBombCountDown");
}

function showBombHit(bool bShowBoob)
{
    ActionScriptVoid("_root.showBombHit");
}

function ShowSaveHint(bool bShow)
{
    ActionScriptVoid("_root.ShowSaveHint");
}

function UpdateTargetPosition(AlicePlayerController ParamApc)
{
    if (ParamApc != none)
    {
        if (ParamApc.TargetNPCSocket.Pawn != none && !ParamApc.TargetNPCSocket.Pawn.ShouldHideLockOnUI(ParamApc.TargetNPCSocket.SocketIndex) || ParamApc.PreTargetNPCSocket.Pawn != none && !ParamApc.PreTargetNPCSocket.Pawn.ShouldHideLockOnUI(ParamApc.PreTargetNPCSocket.SocketIndex))
        {
            UpdateTargetPosition7(ParamApc.TargetNPCSocketLocation2D.X, ParamApc.TargetNPCSocketLocation2D.Y, float(ParamApc.bTargetingModeActive ? 1 : 0), GetNPCUIScale(ParamApc), ParamApc.bTargetingModeActive ? string(ParamApc.TargetNPCSocket.Pawn.Name) : string(ParamApc.PreTargetNPCSocket.Pawn.Name), 0.0, ParamApc.bAimOnTarget);
        }
        else if (ParamApc.TargetBActorInfo.BActor != none && !ParamApc.TargetBActorInfo.BActor.ShouldHideLockOnUI() || ParamApc.PreTargetBActorInfo.BActor != none && !ParamApc.PreTargetBActorInfo.BActor.ShouldHideLockOnUI())
        {
            UpdateTargetPosition6(ParamApc.TargetNPCSocketLocation2D.X, ParamApc.TargetNPCSocketLocation2D.Y, float(ParamApc.bTargetingModeActive ? 1 : 0), GetBActorUIScale(ParamApc), ParamApc.bTargetingModeActive ? string(ParamApc.TargetBActorInfo.BActor.Name) : string(ParamApc.PreTargetBActorInfo.BActor.Name), 100.0);
        }
        else if (ParamApc.TargetSMAInfo.Actor != none || ParamApc.PreTargetSMAInfo.Actor != none)
        {
            if (ParamApc.TargetSMAInfo.Actor != none)
            {
                UpdateTargetPosition6(ParamApc.TargetNPCSocketLocation2D.X, ParamApc.TargetNPCSocketLocation2D.Y, float(ParamApc.bTargetingModeActive ? 1 : 0), GetSMAInfoUIScale(ParamApc), ParamApc.bTargetingModeActive ? string(ParamApc.TargetSMAInfo.Actor.Name) : string(ParamApc.TargetSMAInfo.Actor.Name), 100.0);
            }
            else if (ParamApc.PreTargetSMAInfo.Actor != none)
            {
                UpdateTargetPosition6(ParamApc.TargetNPCSocketLocation2D.X, ParamApc.TargetNPCSocketLocation2D.Y, float(ParamApc.bTargetingModeActive ? 1 : 0), GetSMAInfoUIScale(ParamApc), ParamApc.bTargetingModeActive ? string(ParamApc.PreTargetSMAInfo.Actor.Name) : string(ParamApc.PreTargetSMAInfo.Actor.Name), 100.0);
            }
        }
        else
        {
            UpdateTargetPositionNULL(-100.0, -100.0, 1.0);
        }
    }
}

function UpdateTargetPosition7(float XPos, float YPos, float maybeZpos, float Scale, string PawnName, float Something, bool bAimOnTarget)
{
    ActionScriptVoid("_root.addPoint");
}

function UpdateTargetPosition6(float XPos, float YPos, float maybeZpos, float Scale, string PawnName, float Something)
{
    ActionScriptVoid("_root.addPoint");
}

function UpdateTargetPositionNULL(float XPos, float YPos, float maybeZpos)
{
    ActionScriptVoid("_root.addPoint");
}

function float GetSMAInfoUIScale(AlicePlayerController ParamApc)
{
    local float fDist, fRatio;
    local Vector CamLoc;
    local Rotator CamRot;
    
    fRatio = 1.0;
    AlicePlayerCamera(ParamApc.PlayerCamera).GetCameraViewPoint(CamLoc, CamRot);
    if (ParamApc.bTargetingModeActive)
    {
        fDist = VSize(ParamApc.TargetSMAInfo.Actor.Location - CamLoc);
    }
    else
    {
        fDist = VSize(ParamApc.PreTargetSMAInfo.Actor.Location - CamLoc);
    }
    if (fDist > ParamApc.MyAlicePawn.MaxNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale;
    }
    else if (fDist < ParamApc.MyAlicePawn.MinNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MinLockUIScale;
    }
    else
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale + (ParamApc.MyAlicePawn.MinLockUIScale - ParamApc.MyAlicePawn.MaxLockUIScale) * ((ParamApc.MyAlicePawn.MaxNPCToCamDistance - fDist) / (ParamApc.MyAlicePawn.MaxNPCToCamDistance - ParamApc.MyAlicePawn.MinNPCToCamDistance));
    }
    return fRatio;
}

function float GetBActorUIScale(AlicePlayerController ParamApc)
{
    local float fDist, fRatio;
    local Vector CamLoc;
    local Rotator CamRot;
    
    fRatio = 1.0;
    AlicePlayerCamera(ParamApc.PlayerCamera).GetCameraViewPoint(CamLoc, CamRot);
    if (ParamApc.bTargetingModeActive)
    {
        fDist = VSize(ParamApc.TargetBActorInfo.BActor.StaticMeshComponent.Bounds.Origin - CamLoc);
    }
    else
    {
        fDist = VSize(ParamApc.PreTargetBActorInfo.BActor.StaticMeshComponent.Bounds.Origin - CamLoc);
    }
    if (fDist > ParamApc.MyAlicePawn.MaxNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale;
    }
    else if (fDist < ParamApc.MyAlicePawn.MinNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MinLockUIScale;
    }
    else
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale + (ParamApc.MyAlicePawn.MinLockUIScale - ParamApc.MyAlicePawn.MaxLockUIScale) * ((ParamApc.MyAlicePawn.MaxNPCToCamDistance - fDist) / (ParamApc.MyAlicePawn.MaxNPCToCamDistance - ParamApc.MyAlicePawn.MinNPCToCamDistance));
    }
    return fRatio;
}

function float GetNPCUIScale(AlicePlayerController ParamApc)
{
    local float fDist, fRatio;
    local Vector CamLoc;
    local Rotator CamRot;
    
    fRatio = 1.0;
    AlicePlayerCamera(ParamApc.PlayerCamera).GetCameraViewPoint(CamLoc, CamRot);
    if (ParamApc.bTargetingModeActive)
    {
        fDist = VSize(ParamApc.TargetNPCSocket.Pawn.Location - CamLoc);
    }
    else
    {
        fDist = VSize(ParamApc.PreTargetNPCSocket.Pawn.Location - CamLoc);
    }
    if (fDist > ParamApc.MyAlicePawn.MaxNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale;
    }
    else if (fDist < ParamApc.MyAlicePawn.MinNPCToCamDistance)
    {
        fRatio = ParamApc.MyAlicePawn.MinLockUIScale;
    }
    else
    {
        fRatio = ParamApc.MyAlicePawn.MaxLockUIScale + (ParamApc.MyAlicePawn.MinLockUIScale - ParamApc.MyAlicePawn.MaxLockUIScale) * ((ParamApc.MyAlicePawn.MaxNPCToCamDistance - fDist) / (ParamApc.MyAlicePawn.MaxNPCToCamDistance - ParamApc.MyAlicePawn.MinNPCToCamDistance));
    }
    return fRatio;
}

function BombCount()
{
    ActionScriptVoid("_root.BombCount");
}

function CancelHysteriaCount(int Count)
{
    ActionScriptVoid("_root.CancelHysteriaCount");
}

function CancelHysteriaReady()
{
    ActionScriptVoid("_root.CancelHysteriaReady");
}

function HysteriaOut()
{
    ActionScriptVoid("_root.HysteriaOut");
}

function HysteriaInto(float HysteriaDuration)
{
    ActionScriptVoid("_root.HysteriaInto");
}

function HysteriaReady()
{
    ActionScriptVoid("_root.HysteriaReady");
}

event OnClose()
{
    bIsOpen = false;
    APC = none;
}

defaultproperties
{
}
