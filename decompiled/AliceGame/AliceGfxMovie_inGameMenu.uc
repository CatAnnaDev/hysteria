class AliceGfxMovie_inGameMenu extends AliceGFXMovie
    notplaceable;

var export editinline AudioComponent AC;
var bool bInfiniteAmmo;
var bool bIAmmo;
var bool bSuperDamage;
var bool bSDamage;
var bool bGMode;
var bool bIvMouse;
var int VBMeleeDamage[6];
var int HorseMeleeDamage[6];
var int VBNoLockOnMeleeDamage[6];
var int HorseNoLockOnMeleeDamage[6];
var() SoundCue OpenSound;
var() SoundCue CloseSound;
var() SoundCue HandMoveSound;
var() SoundCue HandMoveBigSound;
var() SoundCue SliderSound;
var() SoundCue StartPageSound;

function PlaySound(string Index)
{
    switch (Index)
    {
        case "OpenSound":
            PlaySoundWhenPause(OpenSound);
            break;
        case "CloseSound":
            PlaySoundWhenPause(CloseSound);
            break;
        case "HandMoveSound":
            PlaySoundWhenPause(HandMoveSound);
            break;
        case "HandMoveBigSound":
            PlaySoundWhenPause(HandMoveBigSound);
            break;
        case "SelectSound":
            PlaySoundWhenPause(SelectSound);
            break;
        case "SelectBackSound":
            PlaySoundWhenPause(SelectBackSound);
            break;
        case "SliderSound":
            PlaySoundWhenPause(SliderSound);
            break;
        case "StartPageSound":
            PlaySoundWhenPause(StartPageSound);
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

function leaveControl()
{
    APC.UI_SetGFXMovie(none);
    APC.UI_bUpdateKeySettings = false;
    APC.PlayerInput.EnableInputCommands(true);
}

function SetGFXMovie()
{
    APC.UI_SetGFXMovie(self);
    APC.UI_bUpdateKeySettings = true;
    APC.PlayerInput.EnableInputCommands(false);
}

function int getControlLayout()
{
    return APC.getControlLayout();
}

function setControlLayout(int I)
{
    APC.setControlLayout(I);
}

function SetLockOnModeSetting(bool bHold)
{
    if (APC != none)
    {
        APC.SetTargetingModeOption(bHold);
    }
}

function bool GetLockOnModeSetting()
{
    local bool bHold;
    
    if (APC == none)
    {
        bHold = true;
    }
    else
    {
        bHold = APC.bHoldTiggerToMaintainTargeting;
    }
    return bHold;
}

function QuitGame()
{
    Close();
    GetGameViewportClient().ConsoleCommand("quit");
}

function continueGame()
{
    if (APC != none)
    {
        APC.ContinueToGame();
    }
}

function SetInput(float X, float Y)
{
    ActionScriptVoid("_root.SetInput");
}

function InvertMouse()
{
    if (bIvMouse)
    {
        bIvMouse = false;
    }
    else
    {
        bIvMouse = true;
    }
    APC.PlayerInput.InvertMouse();
}

function bool getIvMouse()
{
    return bIvMouse;
}

function God()
{
    if (bGMode)
    {
        APC.bGodMode = false;
        bGMode = false;
    }
    else
    {
        APC.bGodMode = true;
        bGMode = true;
    }
}

function bool getGOD()
{
    return bGMode;
}

function SuperDamage()
{
    local WeaponForAlice WA;
    local int Index;
    
    bSDamage = !bSDamage;
    if (bSDamage)
    {
        foreach APC.WorldInfo.AllActors(class'WeaponForAlice', WA)
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
        foreach APC.WorldInfo.AllActors(class'WeaponForAlice', WA)
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

function bool getSuperDamage()
{
    return bSDamage;
}

function IA()
{
    local WeaponForAlice WA;
    
    bIAmmo = !bIAmmo;
    if (bIAmmo)
    {
        foreach APC.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.ShotCost[0] = -1;
            WA.ShotCost[2] = -1;
        }
    }
    else
    {
        foreach APC.WorldInfo.AllActors(class'WeaponForAlice', WA)
        {
            WA.ShotCost[0] = 1;
            WA.ShotCost[2] = 1;
        }
    }
}

function bool getIA()
{
    return bIAmmo;
}

function gotoPage(int pageNum)
{
    ActionScriptVoid("_root.gotoPage");
}

function OpenMenu()
{
    PlaySoundWhenPause(OpenSound);
    ActionScriptVoid("_root.openMenu");
}

function LoadCheckpoint(int cid)
{
    APC.WorldInfo.Game.MyCheckPointManager.LoadChapter(byte(cid));
}

function PlaySoundWhenPause(SoundCue Sound)
{
    AC = APC.GetPooledAudioComponent(Sound, APC, false, true, APC.Location);
    if (AC == none)
    {
        return;
    }
    AC.bIsUISound = true;
    AC.bUseOwnerLocation = false;
    AC.Location = APC.Location;
    AC.Play();
}

function ChangeAimIcon(int Id)
{
    APC.ChangeAimIcon(Id);
}

function ChangeResolution(string Mode)
{
    GetGameViewportClient().ConsoleCommand("Setres " $ Mode);
    APC.ChangeResolution(Mode);
}

event OnClose()
{
    bIsOpen = false;
    APC = none;
    AC = none;
}

defaultproperties
{
}
