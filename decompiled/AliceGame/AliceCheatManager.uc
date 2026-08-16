class AliceCheatManager extends CheatManager
    notplaceable
    within AlicePlayerController;

struct PFActorInfo
{
    var Vector OldCoorLoc;
    var Vector NewCoorLoc;
    var float PFValue;
    var string actorName;
};

var bool bSlideFixedCamera;
var bool bInfiniteAmmo;
var bool bEnableAllWeaponsSelect;
var bool bShowHitInfo;
var bool bNewSteamVent;
var bool bShowChess;
var bool bTraceDetect;
var bool bSuperDamage;
var bool bShowTrophy;
var bool bShowVentCylinder;
var bool bShowPersistentData;
var bool bCanBlock;
var bool bCanClockBomb;
var bool bCanHysteria;
var bool bCalcPFInfo;
var bool bNewHoverControl;
var bool bNewCycleControl;
var bool bShowHeadSpeed;
var bool bUnlockAllBink;
var bool bUnlockAllMemory;
var bool bUnlockAllSnout;
var bool bUnlockAllSecret;
var bool bHoldWatchBeforeDodge;
var float SteamVentk0;
var float SteamVentb0;
var float SteamVentk1;
var float SteamVentb1;
var int iTick;
var int TD_LineNum;
var float TD_YawRange;
var float TD_PitchOffset;
var float TD_LineLength;
var array<Actor> TD_Actors;
var int VBMeleeDamage[6];
var int HorseMeleeDamage[6];
var int VBNoLockOnMeleeDamage[6];
var int HorseNoLockOnMeleeDamage[6];
var SeqAct_Interp CurrentMatinee;
var array<PFActorInfo> PFActorInfos;
var Vector unshrinkExtent;
var Actor tracedActor;
var float maxHeadSpeed;
var Actor unshrinkBlockActor;
var Actor lockonBlockActor;
var int backupHealthMax;
var Vector SafeTeleportLoc;
var float fUnshrinkBaseOffsetZ;

exec function setUnshrinkBaseOffsetZ(float I)
{
    fUnshrinkBaseOffsetZ = I;
}

exec function showKeyBinds()
{
    local int BindIndex;
    
    for (BindIndex = 0; BindIndex < Outer.PlayerInput.Bindings.Length; BindIndex++)
    {
        LogInternal("^^^^^^^^ " $ string(BindIndex) $ ": " $ string(Outer.PlayerInput.Bindings[BindIndex].Name) $ ", " $ Outer.PlayerInput.Bindings[BindIndex].Command $ " ^^^^^^^^^");
    }
}

exec function LogOutAllPickup()
{
    Outer.persistentDataManager.LogOutAllPickup();
}

function bool ShouldShowSkipUI()
{
    if (CurrentMatinee != none && CurrentMatinee.bIsPlaying && CurrentMatinee.bIsSkippable && CurrentMatinee.bShowSkipUI)
    {
        return true;
    }
    return false;
}

exec function GetAllDresses()
{
    Outer.persistentDataManager.setChapterCompleted(0);
    Outer.tryUnlockChapterCompleted(0);
    Outer.persistentDataManager.setChapterCompleted(1);
    Outer.tryUnlockChapterCompleted(1);
    Outer.persistentDataManager.setChapterCompleted(2);
    Outer.tryUnlockChapterCompleted(2);
    Outer.persistentDataManager.setChapterCompleted(3);
    Outer.tryUnlockChapterCompleted(3);
    Outer.persistentDataManager.setChapterCompleted(4);
    Outer.tryUnlockChapterCompleted(4);
    Outer.persistentDataManager.setChapterCompleted(5);
    Outer.tryUnlockChapterCompleted(5);
    Outer.ConsoleCommand("dlcsetstatus 2 AUTHENTICATED");
}

exec function ResetBlockPuzzle()
{
    if (Outer.BlockPuzzleActor != none)
    {
        Outer.BlockPuzzleActor.InitAssamble(true);
    }
}

exec function CollectBlockPuzzle()
{
    if (Outer.BlockPuzzleActor != none)
    {
        Outer.BlockPuzzleActor.CollectAllPieces();
    }
}

exec function CompleteBlockPuzzle()
{
    if (Outer.BlockPuzzleActor != none)
    {
        Outer.BlockPuzzleActor.BlockPuzzleComplete();
    }
}

exec function SkipBlockPuzzle()
{
    if (Outer.BlockPuzzleActor != none)
    {
        Outer.BlockPuzzleActor.OnSkipBlockPuzzle();
    }
}

exec function forceUnlockAllSecret()
{
    bUnlockAllSecret = true;
}

exec function forceUnlockAllSnout()
{
    bUnlockAllSnout = true;
}

exec function forceUnlockAllMemory()
{
    bUnlockAllMemory = true;
}

exec function forceUnlockAllBink()
{
    bUnlockAllBink = true;
}

exec function forceUnlockAllCave()
{
    local int I;
    
    for (I = 0; I < 16; I++)
    {
        Outer.CaveCompleted[I] = 1;
    }
}

exec function forceUnlockAllEnemy()
{
    local int I;
    
    for (I = 0; I < 20; I++)
    {
        Outer.UnlockEnemy[I] = 1;
    }
}

exec function forceUnlockAllChapter()
{
    local int I;
    
    for (I = 0; I < 6; I++)
    {
        Outer.ChapterCompleted[I] = 1;
    }
}

function resetDataForLondonSwitchArcheType()
{
    Outer.MyAlicePawn.HealthMax = backupHealthMax;
}

function backupDataForLondonSwitchArcheType()
{
    backupHealthMax = Outer.MyAlicePawn.HealthMax;
}

exec function setMaxHealth(int iMaxHealth)
{
    Outer.MyAlicePawn.HealthMax = iMaxHealth;
}

function Actor getLockonBlockActor()
{
    return lockonBlockActor;
}

function setLockonBlockActor(Actor blocker)
{
    if (lockonBlockActor != blocker && lockonBlockActor != none)
    {
        LogInternal("=== Lockon Block Actor: " $ string(blocker) $ " ===");
    }
    lockonBlockActor = blocker;
}

function Actor getUnshrinkBlockActor()
{
    return unshrinkBlockActor;
}

function setUnshrinkBlockActor(Actor blocker)
{
    if (unshrinkBlockActor != blocker && blocker != none)
    {
        LogInternal("=== Unshrink Block Actor: " $ string(blocker) $ " ===");
    }
    unshrinkBlockActor = blocker;
}

exec function showHeadSpeed()
{
    bShowHeadSpeed = (bShowHeadSpeed ? false : true);
}

function float getMaxHeadSpeed()
{
    return 1800.0;
}

function updateMaxHeadSpeed(Vector curHeadVelocity)
{
    local float curSpeed;
    
    curSpeed = VSize(curHeadVelocity);
    if (curSpeed > maxHeadSpeed)
    {
        maxHeadSpeed = curSpeed;
        Outer.ClientMessage("===== Max Head Speed: " $ string(maxHeadSpeed) $ " =====");
    }
}

function Actor getTracedActor()
{
    return tracedActor;
}

function traceTest()
{
    local Vector vStart, vEnd, HitLocation, HitNormal;
    
    vStart = Outer.MyAlicePawn.Location;
    vEnd = vStart + Normal(vector(Outer.MyAlicePawn.Rotation)) * float(200);
    tracedActor = Outer.MyAlicePawn.Trace(HitLocation, HitNormal, vEnd, vStart);
    Outer.DrawDebugLine(vStart, vEnd, 255, 0, 0);
}

exec function setUSE(float fURadius, float fUHeight)
{
    unshrinkExtent.X = fURadius;
    unshrinkExtent.Y = fURadius;
    unshrinkExtent.Z = fUHeight;
}

function Vector getUnshrinkExtent()
{
    return unshrinkExtent;
}

exec function disarm()
{
    Outer.RemoveAliceWeapon(class'VorpalBlade');
    Outer.RemoveAliceWeapon(class'HobbyHorse');
    Outer.RemoveAliceWeapon(class'EyeStaff');
    Outer.RemoveAliceWeapon(class'TeapotCannon');
    Outer.MyAlicePawn.bCanCombat = false;
    Outer.MyAlicePawn.bCanLockon = false;
    Outer.MyAlicePawn.bCanShrink = false;
    Outer.MyAlicePawn.bCanClockBomb = false;
    Outer.MyAlicePawn.bCanDodge = false;
    Outer.MyAlicePawn.bCanBlock = false;
    Outer.MyAlicePawn.bCanHysteria = false;
    Outer.MyAlicePawn.bCanDeflect = false;
    bCanBlock = false;
    Outer.MyAlicePawn.bCanDeflectSpin = 0;
    bCanClockBomb = false;
    bCanHysteria = false;
    Outer.MyAlicePawn.bCanAiming = false;
}

exec function arm()
{
    Outer.AddNewAliceWeapon(class'VorpalBlade', 1);
    Outer.AddNewAliceWeapon(class'HobbyHorse', 1);
    Outer.AddNewAliceWeapon(class'EyeStaff', 1);
    Outer.AddNewAliceWeapon(class'TeapotCannon', 1);
    Outer.FlushWeaponLevelRealTime();
    Outer.MyAlicePawn.bCanCombat = true;
    Outer.MyAlicePawn.bCanLockon = true;
    Outer.MyAlicePawn.bCanShrink = true;
    Outer.MyAlicePawn.bCanClockBomb = true;
    Outer.MyAlicePawn.bCanDodge = true;
    Outer.MyAlicePawn.bCanBlock = true;
    Outer.MyAlicePawn.bCanHysteria = true;
    Outer.MyAlicePawn.bCanDeflect = true;
    bCanBlock = true;
    Outer.MyAlicePawn.bCanDeflectSpin = 1;
    bCanClockBomb = true;
    bCanHysteria = true;
    Outer.MyAlicePawn.bJumpCapable = true;
    Outer.MyAlicePawn.bCanDoubleJump = true;
    Outer.MyAlicePawn.bCanFloat = true;
    Outer.MyAlicePawn.bCanAiming = true;
    Outer.MyAlicePawn.bCanShowPath = true;
    Outer.MyAlicePawn.bCanShowCat = true;
    Outer.MyAlicePawn.bCanEnableSonar = true;
}

function bool canHysteria()
{
    return bCanHysteria;
}

function bool canClockBomb()
{
    return bCanClockBomb;
}

function bool canBlock()
{
    return bCanBlock;
}

exec function enableInput(bool bEnabled)
{
    Outer.PlayerInput.EnableInputCommands(bEnabled);
}

exec function showPersistentData(bool bShow)
{
    bShowPersistentData = bShow;
}

function bool isShowPersistentData()
{
    return bShowPersistentData;
}

exec function LeaveHysteria()
{
    Outer.MyAlicePawn.DebugLeaveHysteria();
}

exec function showVentCylinder()
{
    bShowVentCylinder = (bShowVentCylinder ? false : true);
}

function bool isShowVentCylinder()
{
    return bShowVentCylinder;
}

function bool isShowTrophy()
{
    return bShowTrophy;
}

exec function showTrophy(optional bool bShow = true)
{
    bShowTrophy = bShow;
}

function bool isNewCycleControl()
{
    return bNewCycleControl;
}

exec function NewCycleControl()
{
    bNewCycleControl = (bNewCycleControl ? false : true);
}

exec function Health(int HP)
{
    Outer.Pawn.Health = HP;
    AlicePawn(Outer.Pawn).HealthRegen = float(Outer.Pawn.Health);
    AlicePawn(Outer.Pawn).HealthRegenWaitCount = 0.0;
    Outer.ClientMessage("Alice's Health set to " $ string(Outer.Pawn.Health));
    AliceGameInfo(Outer.WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Outer.Pawn.Health, Outer.Pawn.HealthMax);
}

exec function sethealth(float percentage)
{
    Outer.Pawn.Health = int(float(Outer.Pawn.HealthMax) * percentage * 0.01);
    AlicePawn(Outer.Pawn).HealthRegen = float(Outer.Pawn.Health);
    AlicePawn(Outer.Pawn).HealthRegenWaitCount = 0.0;
    Outer.ClientMessage("Pawn.Health become to " $ string(Outer.Pawn.Health));
    AliceGameInfo(Outer.WorldInfo.Game).GFxHUDMenu.UpdateAliceHealth(Outer.Pawn.Health, Outer.Pawn.HealthMax);
}

exec function ChangeAliceDress(int DressIndex)
{
    Outer.ChangeAliceWonderlandDress(DressIndex, true, none);
}

exec function NewHoverControl()
{
    bNewHoverControl = (bNewHoverControl ? false : true);
}

exec function CycleFloat()
{
    if (Outer.CycleFloatManager.bActive)
    {
        Outer.CycleFloatManager.bActive = false;
        Outer.CycleFloatManager.bShowDebugInfo = false;
    }
    else
    {
        Outer.CycleFloatManager.bActive = true;
        Outer.CycleFloatManager.bShowDebugInfo = true;
    }
    Outer.MyAlicePawn.FloatDownGravityZ = -200.0;
}

function DoTraceDetect()
{
    local Vector out_HitLocation, out_HitNormal, TraceDest, TraceStart, TraceExtent;
    local TraceHitInfo HitInfo;
    local int I;
    local float MostLeftYaw, TargetYaw;
    local Rotator TargetRotation;
    local Actor TraceActor;
    
    if (!bTraceDetect)
    {
        return;
    }
    TD_Actors.Length = 0;
    TraceStart = Outer.Pawn.Location;
    MostLeftYaw = float(Outer.Pawn.Rotation.Yaw) - float(TD_LineNum - 1) * 0.5 * (TD_YawRange / float(TD_LineNum - 1));
    for (I = 0; I < TD_LineNum; I++)
    {
        TargetYaw = MostLeftYaw + float(I) * (TD_YawRange / float(TD_LineNum - 1));
        TargetRotation.Yaw = int(TargetYaw);
        TargetRotation.Pitch = int(TD_PitchOffset);
        TraceDest = TraceStart + Normal(vector(TargetRotation)) * TD_LineLength;
        TraceActor = Outer.Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, true, TraceExtent, HitInfo);
        if (TraceActor != none)
        {
            Outer.DrawDebugLine(TraceStart, TraceDest, 255, 0, 0);
            TD_Actors.AddItem(TraceActor);
            continue;
        }
        Outer.DrawDebugLine(TraceStart, TraceDest, 0, 255, 0);
    }
}

exec function setTDLineLength(float fLineLength)
{
    TD_LineLength = fLineLength;
}

exec function setTDPitchOffset(float PitchOffset)
{
    TD_PitchOffset = PitchOffset;
}

exec function setTDYawRange(float YawRange)
{
    TD_YawRange = YawRange;
}

exec function setTDLineNum(int LineNum)
{
    TD_LineNum = LineNum;
}

exec function ToggleTrace()
{
    bTraceDetect = (bTraceDetect ? false : true);
}

function Update()
{
    iTick++;
    DoTraceDetect();
}

exec function SuperDamage()
{
    local WeaponForAlice WA;
    local int Index;
    
    bSuperDamage = !bSuperDamage;
    if (bSuperDamage)
    {
        foreach Outer.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.bSuperDamage = true;
            if (WeaponForAliceMelee(WA) != none)
            {
                if (VorpalBlade(WA) != none)
                {
                    for (Index = 0; Index < 6; Index++)
                    {
                        VBMeleeDamage[Index] = WeaponForAliceMelee(WA).MeleeDamage[Index];
                        VBNoLockOnMeleeDamage[Index] = WeaponForAliceMelee(WA).NoLockOnMeleeDamage[Index];
                    }
                }
                if (HobbyHorse(WA) != none)
                {
                    for (Index = 0; Index < 6; Index++)
                    {
                        HorseMeleeDamage[Index] = WeaponForAliceMelee(WA).MeleeDamage[Index];
                        HorseNoLockOnMeleeDamage[Index] = WeaponForAliceMelee(WA).NoLockOnMeleeDamage[Index];
                    }
                }
                for (Index = 0; Index < 6; Index++)
                {
                    WeaponForAliceMelee(WA).MeleeDamage[Index] = 100000;
                    WeaponForAliceMelee(WA).NoLockOnMeleeDamage[Index] = 100000;
                }
            }
        }
    }
    else
    {
        foreach Outer.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.bSuperDamage = false;
            if (VorpalBlade(WA) != none)
            {
                for (Index = 0; Index < 6; Index++)
                {
                    WeaponForAliceMelee(WA).MeleeDamage[Index] = VBMeleeDamage[Index];
                    WeaponForAliceMelee(WA).NoLockOnMeleeDamage[Index] = VBNoLockOnMeleeDamage[Index];
                }
            }
            if (HobbyHorse(WA) != none)
            {
                for (Index = 0; Index < 6; Index++)
                {
                    WeaponForAliceMelee(WA).MeleeDamage[Index] = HorseMeleeDamage[Index];
                    WeaponForAliceMelee(WA).NoLockOnMeleeDamage[Index] = HorseNoLockOnMeleeDamage[Index];
                }
            }
        }
    }
}

exec function ShowChessPuzzle()
{
    bShowChess = (bShowChess ? false : true);
}

exec function ExecAlice1()
{
    Outer.getAliceGameEngine().LaunchAlice1();
}

exec function ConstrainedAspectRatio()
{
    Outer.getAliceGameEngine().bConstrainAspectRatio = !Outer.getAliceGameEngine().bConstrainAspectRatio;
    if (Outer.getAliceGameEngine().bConstrainAspectRatio)
    {
        Outer.ClientMessage("Constrained Aspect Ratio " @ string(Outer.getAliceGameEngine().ConstrainedAspectRatio) @ " ON !!!");
    }
    else
    {
        Outer.ClientMessage("Constrained Aspect Ratio " @ string(Outer.getAliceGameEngine().ConstrainedAspectRatio) @ " OFF !!!");
    }
}

exec function AllDresses()
{
    Outer.EnableAllDresses();
}

exec function ResetKeys()
{
    Outer.getAliceGameEngine().ExecResetKeyBindings();
}

exec function SetSndVol(int SoundType, float fVol)
{
    Outer.getAliceGameEngine().SetSoundVolume(SoundType, fVol);
}

exec function Dress(int Index)
{
    if (Outer.MyAlicePawn.SwitchToDress(Index) == false)
    {
        Outer.ClientMessage("Failed to switch dress !!!");
    }
}

exec function TankControls()
{
    Outer.bProjectInputToControllerSpace = !Outer.bProjectInputToControllerSpace;
    if (Outer.bProjectInputToControllerSpace == true)
    {
        Outer.ClientMessage("Tank Controls on");
    }
    else
    {
        Outer.ClientMessage("Tank Controls off");
    }
}

exec function DutchAngle(float Angle)
{
    local int nAngle;
    
    nAngle = int(Angle * 32767.0 / 180.0);
    Outer.CommandCameraRoll = NormalizeRotAxis(nAngle);
}

exec function DofBlurAmount(float Amount)
{
    Outer.WorldInfo.DefaultPostProcessSettings.DOF_MaxNearBlurAmount = Amount;
    Outer.WorldInfo.DefaultPostProcessSettings.DOF_MaxFarBlurAmount = Amount;
}

exec function DOF()
{
    if (!Outer.WorldInfo.ToggleHideDOF())
    {
        Outer.ClientMessage("DOF on");
    }
    else
    {
        Outer.ClientMessage("DOF off");
    }
}

exec function ScaleFOV(float Scale)
{
    Outer.CommandFOVScale = Scale;
    if (Outer.CommandFOVScale < 0.01)
    {
        Outer.CommandFOVScale = 0.01;
    }
}

exec function FreeCamera()
{
    if (Outer.PlayerCamera.CameraStyle != 'FreeCam')
    {
        Outer.PlayerCamera.CameraStyle = 'FreeCam';
        Outer.ClientMessage("Free Camera on");
    }
    else
    {
        Outer.PlayerCamera.CameraStyle = 'ThirdPerson';
        Outer.ClientMessage("Free Camera off");
    }
}

exec function SecondController()
{
    Outer.bSupportSecondController = !Outer.bSupportSecondController;
    if (!Outer.bSupportSecondController || !Outer.DoesAliceGameSupportSecondController())
    {
        GameFreeCamera(AlicePlayerCamera(Outer.PlayerCamera).FreeCam).ControllerIndex = 0;
        Outer.ClientMessage("Second Controller off");
    }
    else
    {
        GameFreeCamera(AlicePlayerCamera(Outer.PlayerCamera).FreeCam).ControllerIndex = 1;
        Outer.ClientMessage("Second Controller on");
    }
}

exec function TSOff()
{
    Outer.AliceGameUseTextureStreaming(false);
    Outer.ClientMessage("Texture Streaming off");
}

exec function TSOn()
{
    Outer.AliceGameUseTextureStreaming(true);
    Outer.ClientMessage("Texture Streaming on");
}

exec function StreamAllLevelsIn()
{
    Outer.LoadAllLevels();
}

exec function SetSteamVent(optional bool bNew = true)
{
    bNewSteamVent = bNew;
}

exec function ShowHitInfo()
{
    bShowHitInfo = (bShowHitInfo ? false : true);
}

exec function SetSteamVentParam(float K, float B, optional int GroupID = 0)
{
    if (GroupID == 0)
    {
        SteamVentk0 = K;
        SteamVentb0 = B;
    }
    else
    {
        SteamVentk1 = K;
        SteamVentb1 = B;
    }
}

exec function GetSteamVentParam(out float K, out float B, optional int GroupID = 0)
{
    if (GroupID == 0)
    {
        K = SteamVentk0;
        B = SteamVentb0;
    }
    else
    {
        K = SteamVentk1;
        B = SteamVentb1;
    }
}

exec function ChangeSlideCamera()
{
    bSlideFixedCamera = (bSlideFixedCamera ? false : true);
}

exec function ChangeFloatCamera()
{
    AlicePawn(Outer.Pawn).ChangeFloatCamera();
}

exec function SetGlideType(int iType)
{
    AlicePawn(Outer.Pawn).SetGlideType(iType);
}

exec function ToggleHide(optional bool bHide = true, optional bool bDrawHint = true)
{
    local AlicePlayerCamera AliceCamera;
    
    AliceCamera = AlicePlayerCamera(Outer.PlayerCamera);
    if (AliceCamera != none)
    {
        AliceCamera.ToggleHide(bHide, bDrawHint);
    }
}

exec function ShowJumpPadRadius()
{
    local JumpPadMushroom MPad;
    
    foreach Outer.WorldInfo.AllActors(class'JumpPadMushroom', MPad)
    {
        MPad.ShowRadius();
    }
}

exec function ShowIPRadius()
{
    local SphinxInterstingPoint Ammo;
    
    foreach Outer.WorldInfo.AllActors(class'Kynapse.SphinxInterstingPoint', Ammo)
    {
        Ammo.ShowRadius();
    }
}

exec function EnableAllWeaponsSelect()
{
    bEnableAllWeaponsSelect = true;
}

exec function IA()
{
    local WeaponForAlice WA;
    
    bInfiniteAmmo = !bInfiniteAmmo;
    if (bInfiniteAmmo)
    {
        foreach Outer.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.ShotCost[0] = -1;
            WA.ShotCost[2] = -1;
        }
    }
    else
    {
        foreach Outer.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.ShotCost[0] = 1;
            WA.ShotCost[2] = 1;
        }
    }
}

exec function ToggleGhost()
{
    local AlicePawn P;
    
    if (AlicePlayerInput(Outer.PlayerInput).IsKeyPressed('XboxTypeS_RightThumbstick') && AlicePlayerInput(Outer.PlayerInput).IsKeyPressed('XboxTypeS_DPad_Down'))
    {
        P = AlicePawn(Outer.Pawn);
        if (Outer.bCheatFlying)
        {
            P.AirSpeed = P.default.AirSpeed;
            Walk();
            if (P.bInRollingMode)
            {
                AlicePlayerController(P.Controller).RollTest();
            }
        }
        else if (!AlicePlayerInput(Outer.PlayerInput).bDisableInputInCinematic && !P.bInLockOnMode)
        {
            Ghost();
        }
    }
}

exec function Walk()
{
    Outer.bCheatFlying = false;
    if (Outer.Pawn != none && Outer.Pawn.CheatWalk())
    {
        Outer.Restart(false);
    }
}

function ShowPFInfos(Canvas Canvas)
{
    local int I;
    local Vector ScreenLoc;
    local string Line1, Line2;
    local float XL, YL;
    
    Canvas.SetDrawColor(255, 0, 0);
    for (I = 0; I < PFActorInfos.Length; I++)
    {
        ScreenLoc = Canvas.Project(PFActorInfos[I].OldCoorLoc);
        Line1 = string(int(PFActorInfos[I].NewCoorLoc.X)) $ ", " $ string(int(PFActorInfos[I].NewCoorLoc.Y)) $ ", " $ string(int(PFActorInfos[I].NewCoorLoc.Z)) $ "  " $ " PFValue: " $ string(PFActorInfos[I].PFValue);
        Canvas.StrLen(Line1, XL, YL);
        Canvas.SetPos(ScreenLoc.X - XL / 2.0, ScreenLoc.Y);
        Canvas.DrawText(Line1, false);
        Line2 = PFActorInfos[I].actorName;
        Canvas.StrLen(Line2, XL, YL);
        Canvas.SetPos(ScreenLoc.X - XL / 2.0, ScreenLoc.Y + float(15));
        Canvas.DrawText(Line2, false);
    }
}

function AddPFInfo(Vector _OldCoorLoc, Vector _NewCoorLoc, float _PFValue, string _ActorName)
{
    local PFActorInfo Info;
    
    Info.OldCoorLoc = _OldCoorLoc;
    Info.NewCoorLoc = _NewCoorLoc;
    Info.PFValue = _PFValue;
    Info.actorName = _ActorName;
    PFActorInfos.AddItem(Info);
}

defaultproperties
{
    bSlideFixedCamera=True
    bCanBlock=True
    bCanClockBomb=True
    bCanHysteria=True
    bCalcPFInfo=True
    bNewHoverControl=True
    SteamVentk0=0.003
    SteamVentb0=280.0
    SteamVentk1=-3.0
    SteamVentb1=3000.0
    TD_LineNum=9
    TD_YawRange=25000.0
    TD_PitchOffset=5000.0
    TD_LineLength=200.0
    unshrinkExtent=(X=34.0,Y=34.0,Z=79.0)
    maxHeadSpeed=5.0
    fUnshrinkBaseOffsetZ=2.0
}
