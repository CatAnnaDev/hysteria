class AliceSoundModeManager extends Object
    notplaceable
    within AlicePlayerController;

var name SMCombat;
var name SMSlomo;
var name SMShrink;
var name SMDefault;
var name SMMemory;
var name SMHysteria;
var name ShrinkBackupMode;
var name MemoryBackupMode;
var bool bLastTickSlomoFlag;
var array<name> backupModes;

function string showDebugInfo()
{
    local int I;
    local string Info;
    
    Info = "====== Current SoundMode: " $ string(GetCurSoundMode()) $ " ======\n" $ "====== Backup modes: ======= \n";
    for (I = 0; I < backupModes.Length; I++)
    {
        Info = Info $ string(backupModes[I]) $ "\n";
    }
    return Info;
}

function int getPriority(name Mode)
{
    local int iPriority;
    
    iPriority = 9;
    if (Mode == 'SM_Hysteria')
    {
        iPriority = 1;
    }
    else if (Mode == 'sm_shrink')
    {
        iPriority = 2;
    }
    else if (Mode == 'sm_slowmo_combat')
    {
        iPriority = 3;
    }
    else if (Mode == 'sm_combat')
    {
        iPriority = 4;
    }
    else if (Mode == 'sm_memory_pickup')
    {
        iPriority = 4;
    }
    else if (Mode == 'Default')
    {
        iPriority = 5;
    }
    return iPriority;
}

function NotifyMemoryModeEndTime(float MemorySoundDuration)
{
    Outer.SetTimer(MemorySoundDuration, false, 'EndMemoryMode');
}

function SetHysteriaMode(bool bSet)
{
    local int iCompare;
    
    iCompare = comparePriority(GetCurSoundMode(), SMHysteria);
    if (bSet)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(GetCurSoundMode());
            Outer.SetSoundMode(SMHysteria);
        }
        else if (iCompare < 0)
        {
            addUniqueItem(SMHysteria);
        }
        else
        {
            addUniqueItem(GetCurSoundMode());
            Outer.SetSoundMode(SMHysteria);
        }
    }
    else if (iCompare == 0)
    {
        removeDuplicateModes(SMHysteria);
        if (GetCurSoundMode() == SMHysteria)
        {
            Outer.SetSoundMode(getNextBackupMode());
        }
    }
    else if (iCompare < 0)
    {
        removeDuplicateModes(SMHysteria);
    }
}

function SetMemoryMode(bool bSet)
{
    local int iCompare;
    
    iCompare = comparePriority(GetCurSoundMode(), SMMemory);
    if (bSet)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(GetCurSoundMode());
            Outer.SetSoundMode(SMMemory);
        }
        else if (iCompare < 0)
        {
            addUniqueItem(SMMemory);
        }
        else
        {
            addUniqueItem(GetCurSoundMode());
            Outer.SetSoundMode(SMMemory);
        }
    }
    else if (iCompare == 0)
    {
        removeDuplicateModes(SMMemory);
        if (GetCurSoundMode() == SMMemory)
        {
            Outer.SetSoundMode(getNextBackupMode());
        }
    }
    else if (iCompare < 0)
    {
        removeDuplicateModes(SMMemory);
    }
}

function bool OnKismetSet(SeqAct_SetSoundMode Action)
{
    local int iCompare;
    local name NewMode;
    
    NewMode = Action.SoundMode.Name;
    iCompare = comparePriority(GetCurSoundMode(), NewMode);
    if (Action.InputLinks[0].bHasImpulse)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(GetCurSoundMode());
            Outer.SetSoundMode(NewMode);
        }
        else if (iCompare < 0)
        {
            addUniqueItem(NewMode);
        }
        else
        {
            addUniqueItem(GetCurSoundMode());
            Outer.SetSoundMode(NewMode);
        }
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(NewMode);
            if (GetCurSoundMode() == NewMode)
            {
                Outer.SetSoundMode(getNextBackupMode());
            }
        }
        else if (iCompare < 0)
        {
            removeDuplicateModes(SMShrink);
        }
    }
    return false;
}

function SetShrinkMode(bool bSet)
{
    local int iCompare;
    
    iCompare = comparePriority(GetCurSoundMode(), SMShrink);
    if (bSet)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(GetCurSoundMode());
            Outer.SetSoundMode(SMShrink);
        }
        else if (iCompare < 0)
        {
            addUniqueItem(SMShrink);
        }
        else
        {
            addUniqueItem(GetCurSoundMode());
            Outer.SetSoundMode(SMShrink);
        }
    }
    else if (iCompare == 0)
    {
        removeDuplicateModes(SMShrink);
        if (GetCurSoundMode() == SMShrink)
        {
            Outer.SetSoundMode(getNextBackupMode());
        }
    }
    else if (iCompare < 0)
    {
        removeDuplicateModes(SMShrink);
    }
}

function name GetCurSoundMode()
{
    local AudioDevice Audio;
    
    Audio = class'Engine.Engine'.static.GetAudioDevice();
    if (Audio != none)
    {
        return Audio.CurrentMode.Name;
    }
    return 'Invalid';
}

function setMeleeAttackSlomoMode(bool bEnable)
{
    Outer.PlaySound(Outer.MeleeSlomoSoundCue);
}

function Update()
{
    local int iCompare;
    
    iCompare = comparePriority(GetCurSoundMode(), SMSlomo);
    if (!bLastTickSlomoFlag && Outer.WorldInfo.bSlomoSoundMode)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(GetCurSoundMode());
            Outer.SetSoundMode(SMSlomo);
        }
        else if (iCompare < 0)
        {
            addUniqueItem(SMSlomo);
        }
        else
        {
            addUniqueItem(GetCurSoundMode());
            Outer.SetSoundMode(SMSlomo);
        }
    }
    else if (bLastTickSlomoFlag && !Outer.WorldInfo.bSlomoSoundMode)
    {
        if (iCompare == 0)
        {
            removeDuplicateModes(SMSlomo);
            if (GetCurSoundMode() == SMSlomo)
            {
                Outer.SetSoundMode(getNextBackupMode());
            }
        }
        else if (iCompare < 0)
        {
            removeDuplicateModes(SMSlomo);
        }
    }
    bLastTickSlomoFlag = Outer.WorldInfo.bSlomoSoundMode;
}

function name getNextBackupMode()
{
    local name nextMode;
    local int I, IP, minP;
    
    minP = 99;
    nextMode = SMDefault;
    for (I = 0; I < backupModes.Length; I++)
    {
        IP = getPriority(backupModes[I]);
        if (IP < minP)
        {
            minP = IP;
            nextMode = backupModes[I];
        }
    }
    if (minP == 99)
    {
        return SMDefault;
    }
    return nextMode;
}

function addUniqueItem(name Mode)
{
    local int I;
    
    removeDuplicateModes(Mode);
    for (I = 0; I < backupModes.Length; I++)
    {
        if (comparePriority(backupModes[I], Mode) == 0)
        {
            backupModes.Remove(I--, 1);
        }
    }
    backupModes.AddItem(Mode);
}

function removeDuplicateModes(name Mode)
{
    local int I;
    
    for (I = 0; I < backupModes.Length; I++)
    {
        if (backupModes[I] == Mode)
        {
            backupModes.Remove(I--, 1);
        }
    }
}

function int comparePriority(name n1, name n2)
{
    local int priority1, priority2;
    
    priority1 = getPriority(n1);
    priority2 = getPriority(n2);
    return priority1 - priority2;
}

defaultproperties
{
    SMCombat="sm_combat"
    SMSlomo="sm_slowmo_combat"
    SMShrink="sm_shrink"
    SMDefault="Default"
    SMMemory="sm_memory_pickup"
    SMHysteria="SM_Hysteria"
    ShrinkBackupMode="Default"
}
