class AliceCycleFloatManager extends Object
    notplaceable
    within AlicePlayerController;

struct CycleData
{
    var float PrePreJumpZ;
    var float PreJumpZ;
    var float JumpZ;
};

var bool bActive;
var bool bShowDebugInfo;
var bool bHasInputInWindow;
var bool bDisableAfterLanded;
var bool bFloatTrophyGot;
var bool bPSPlaying;
var float CycleBeginTime;
var float CurCycle;
var float InputTimeWindow;
var int CycleNum;
var int LastCycleNum;
var int MaxCycleNum;
var float LastCallTime;
var ParticleSystem JumpPS;
var ParticleSystem FloatFailPS;
var ParticleSystem FloatPS1;
var ParticleSystem FloatPS2;
var ParticleSystem FloatPS3;
var ParticleSystem FloatPS4;
var Emitter FloatEmitter;
var CycleFloatIndicatorManager indicatorManager;
var array<CycleData> CycleDatas;
var float doubleJumpTime;

function float getDoubleJumpTime()
{
    return doubleJumpTime;
}

function setDoubleJumpTime()
{
    doubleJumpTime = Outer.WorldInfo.TimeSeconds;
    CycleBeginTime = Outer.WorldInfo.TimeSeconds;
}

function hackCurCycle()
{
    if (CycleNum == 1)
    {
        CurCycle += 0.5;
    }
    else if (CycleNum == 2)
    {
        CurCycle += 0.26;
    }
    else if (CycleNum == 3)
    {
        CurCycle += 0.2;
    }
}

function bool IsCycleExpired()
{
    if (CycleNum >= MaxCycleNum)
    {
        return true;
    }
    return false;
}

function bool IsCycleExpiredEX()
{
    if (CycleNum > MaxCycleNum)
    {
        return true;
    }
    return false;
}

function ParticleSystem GetFloatPS()
{
    switch (CycleNum)
    {
        case 0:
            return FloatPS1;
            break;
        case 1:
            return FloatPS2;
            break;
        case 2:
            return FloatPS3;
            break;
        case 3:
            return FloatPS4;
            break;
        default:
    }
    return none;
}

function SpawnFloatParticle()
{
    if (FloatEmitter == none)
    {
        FloatEmitter = Outer.Spawn(class'Engine.EmitterSpawnable', , , Outer.Pawn.Location);
        if (FloatEmitter != none)
        {
            FloatEmitter.SetTemplate(GetFloatPS());
        }
    }
    if (FloatEmitter != none && GetFloatPS() != none)
    {
        FloatEmitter.ParticleSystemComponent.SetActive(true);
        bPSPlaying = true;
    }
    if (CycleNum == 0)
    {
        indicatorManager.startEffect();
    }
}

function OnEndFloat()
{
    StopFloatParticle();
    if (Outer.isNewCycleControl())
    {
    }
}

function StopFloatParticle()
{
    if (FloatEmitter != none)
    {
        FloatEmitter.ParticleSystemComponent.SetActive(false);
        bPSPlaying = false;
    }
    indicatorManager.stopEffect();
}

function PlayFloatParticle(float DeltaTime)
{
    local Rotator TargetRot, NewRot;
    local float UpWeight, RightWeight, RotSpeed;
    
    if (bPSPlaying)
    {
        FloatEmitter.SetLocation(Outer.MyAlicePawn.Location);
        Outer.GetFloatAnimInfo(UpWeight, RightWeight);
        RotSpeed = 1.0;
        TargetRot = Outer.MyAlicePawn.Rotation;
        if (Abs(RightWeight) > 0.1)
        {
            TargetRot.Roll = (RightWeight > float(0) ? 3000 : -3000);
        }
        if (Abs(UpWeight) > 0.1)
        {
            TargetRot.Pitch = (UpWeight > float(0) ? -3000 : 3000);
        }
        NewRot = RInterpTo(FloatEmitter.Rotation, TargetRot, DeltaTime, RotSpeed);
        FloatEmitter.SetRotation(NewRot);
        indicatorManager.Update(DeltaTime);
    }
    else
    {
        SpawnFloatParticle();
    }
    if (Outer.bInFloatVolume)
    {
        StopFloatParticle();
    }
}

function PlayJumpParticle()
{
    local Emitter DoubleJumpParticleEmitter;
    
    if (CycleNum < 0)
    {
        return;
    }
    DoubleJumpParticleEmitter = Outer.Spawn(class'Engine.EmitterSpawnable', , , Outer.MyAlicePawn.Location);
    if (DoubleJumpParticleEmitter != none)
    {
        DoubleJumpParticleEmitter.SetTemplate(JumpPS, true);
        DoubleJumpParticleEmitter.SetLocation(Outer.MyAlicePawn.Location);
    }
}

function PlayFloatFailParticle()
{
    local Emitter FloatFailEmitter;
    
    FloatFailEmitter = Outer.Spawn(class'Engine.EmitterSpawnable', , , Outer.MyAlicePawn.Location);
    if (FloatFailEmitter != none && FloatFailPS != none)
    {
        FloatFailEmitter.SetTemplate(FloatFailPS, true);
    }
}

function CycleFloatInput()
{
    if (!AlicePawn(Outer.Pawn).bCanFloat)
    {
        return;
    }
    if (Outer.isJumpPadJumping() || AlicePawn(Outer.Pawn).bHasDodgeInAir)
    {
        return;
    }
    if (bDisableAfterLanded)
    {
        if (Outer.MyAlicePawn.bIsDoubleJumping)
        {
        }
        else
        {
            return;
        }
    }
    if (!bActive)
    {
        LastCallTime = Outer.WorldInfo.TimeSeconds;
        return;
    }
    if (Outer.isNewCycleControl())
    {
        if (Outer.Pawn.Physics != 17)
        {
            if (Outer.MyAlicePawn.isAButtonPressed() && Outer.Pawn.Physics == 2)
            {
            }
            else
            {
                LastCallTime = Outer.WorldInfo.TimeSeconds;
                return;
            }
        }
        else if (CycleNum >= MaxCycleNum)
        {
            return;
        }
        else
        {
            OnEndFloat();
            Outer.interface_gotoState('PlayerWalking');
            Outer.MyAlicePawn.SetPhysics(2);
            Outer.MyAlicePawn.bFloatDown = false;
        }
    }
    if (CycleNum > MaxCycleNum - 1)
    {
        if (Outer.isNewCycleControl())
        {
            return;
        }
        else
        {
            LastCallTime = Outer.WorldInfo.TimeSeconds;
            AlicePawn(Outer.Pawn).bExitFloatWhenMissWindow = true;
            return;
        }
    }
    if (CycleNum == -1)
    {
        CycleNum = 1;
        CurCycle = AlicePawn(Outer.Pawn).FirstCycle * AlicePawn(Outer.Pawn).CycleRatio;
        hackCurCycle();
        bHasInputInWindow = false;
        AlicePawn(Outer.Pawn).Velocity.Z = GetFloatJumpZ();
        AlicePawn(Outer.Pawn).DoSpecialMove(4, true);
        indicatorManager.startEffect();
        PlayJumpParticle();
        bDisableAfterLanded = false;
        if (LastCycleNum < 0)
        {
            LastCycleNum = 0;
        }
        else if (!bHasInputInWindow)
        {
            LastCycleNum++;
        }
        bHasInputInWindow = false;
    }
    else if (TimeAtCurCycle())
    {
        bHasInputInWindow = true;
        AlicePawn(Outer.Pawn).Velocity.Z = GetFloatJumpZ();
        AlicePawn(Outer.Pawn).DoSpecialMove(4, true);
        if (bShowDebugInfo)
        {
            Outer.ClientMessage("Cycle Float Input ");
        }
        PlayJumpParticle();
        if (true || !IsInState('PlayerFloat'))
        {
            CycleBeginTime = Outer.WorldInfo.TimeSeconds;
            CycleNum++;
            CurCycle *= AlicePawn(Outer.Pawn).CycleRatio;
            hackCurCycle();
            if (LastCycleNum < 0)
            {
                LastCycleNum = 0;
            }
            else if (!bHasInputInWindow)
            {
                LastCycleNum++;
            }
        }
        indicatorManager.startEffect();
    }
    else if (CycleNum >= 0 && CycleNum < MaxCycleNum)
    {
        bHasInputInWindow = true;
        AlicePawn(Outer.Pawn).Velocity.Z = GetFloatJumpZ();
        AlicePawn(Outer.Pawn).DoSpecialMove(4, true);
        PlayJumpParticle();
        bDisableAfterLanded = false;
        CycleBeginTime = Outer.WorldInfo.TimeSeconds;
        CycleNum++;
        CurCycle *= AlicePawn(Outer.Pawn).CycleRatio;
        hackCurCycle();
        if (LastCycleNum < 0)
        {
            LastCycleNum = 0;
        }
        else if (!bHasInputInWindow)
        {
            LastCycleNum++;
        }
        bHasInputInWindow = false;
        indicatorManager.startEffect();
    }
    if (!TimeAtIngoreWindow())
    {
        AlicePawn(Outer.Pawn).bExitFloatWhenMissWindow = false;
    }
    else
    {
        LastCallTime = Outer.WorldInfo.TimeSeconds;
    }
    if (bShowDebugInfo)
    {
        Outer.ClientMessage("CycleNum: " $ string(CycleNum));
    }
}

function UpdateFloatDownSpeed()
{
}

function float GetFloatJumpZ()
{
    local float fResult;
    
    if (CycleNum < 0 || CycleNum > MaxCycleNum - 1)
    {
        return 0.0;
    }
    if (CycleNum <= 0)
    {
        if (Outer.WorldInfo.TimeSeconds - getDoubleJumpTime() < AlicePawn(Outer.Pawn).PrePreDuration)
        {
            fResult = CycleDatas[CycleNum].PrePreJumpZ;
        }
        else if (Outer.WorldInfo.TimeSeconds - getDoubleJumpTime() < AlicePawn(Outer.Pawn).PreDuration)
        {
            fResult = CycleDatas[CycleNum].PreJumpZ;
        }
        else
        {
            fResult = CycleDatas[CycleNum].JumpZ;
        }
        CycleBeginTime = Outer.WorldInfo.TimeSeconds;
    }
    else if (Outer.WorldInfo.TimeSeconds - CycleBeginTime < AlicePawn(Outer.Pawn).PrePreDuration)
    {
        fResult = CycleDatas[CycleNum].PrePreJumpZ;
        CycleBeginTime = Outer.WorldInfo.TimeSeconds;
    }
    else if (Outer.WorldInfo.TimeSeconds - CycleBeginTime < AlicePawn(Outer.Pawn).PreDuration)
    {
        fResult = CycleDatas[CycleNum].PreJumpZ;
        if (bShowDebugInfo)
        {
            Outer.ClientMessage("PreJumpZ: " $ string(fResult));
        }
        CycleBeginTime = Outer.WorldInfo.TimeSeconds;
    }
    else
    {
        fResult = CycleDatas[CycleNum].JumpZ;
        if (bShowDebugInfo)
        {
            Outer.ClientMessage("JumpZ: " $ string(fResult));
        }
        CycleBeginTime = Outer.WorldInfo.TimeSeconds;
    }
    Outer.stuckManager.clearStuckFlag();
    return fResult;
}

function showDebugInfo(string sTag, float CurrentTime, float fCycleBeginTime, float fResult)
{
    Outer.ClientMessage("=== " $ sTag $ ", CycleNum: " $ string(CycleNum) $ ", CurrentTime: " $ string(CurrentTime) $ ", CycleBeginTime: " $ string(fCycleBeginTime) $ ", Diff: " $ string(CurrentTime - fCycleBeginTime) $ ", FinalJumpZ: " $ string(fResult) $ " ===");
}

function bool TimeAtCycleBegin()
{
    if (Outer.WorldInfo.TimeSeconds > CycleBeginTime && Outer.WorldInfo.TimeSeconds < CycleBeginTime + 0.5)
    {
        return true;
    }
    return false;
}

function bool TimeAtCurCycle()
{
    if (Outer.WorldInfo.TimeSeconds > CycleBeginTime && Outer.WorldInfo.TimeSeconds < CycleBeginTime + CurCycle)
    {
        return true;
    }
    return false;
}

function bool TimeAtIngoreWindow()
{
    if (Outer.WorldInfo.TimeSeconds > CycleBeginTime + CurCycle && Outer.WorldInfo.TimeSeconds < CycleBeginTime + CurCycle + AlicePawn(Outer.Pawn).ForceIgnoreInputWindow)
    {
        return true;
    }
    return false;
}

function bool TimeAtInputWindow()
{
    if (!TimePastCycle() && Outer.WorldInfo.TimeSeconds > CycleBeginTime + (CurCycle - InputTimeWindow))
    {
        return true;
    }
    return false;
}

function string showDebugTime()
{
    local string Info;
    
    Info = "CycleBeginTime: " $ string(CycleBeginTime) $ ", CycleEndTime: " $ string(CycleBeginTime + CurCycle) $ ", CurrentTime: " $ string(Outer.WorldInfo.TimeSeconds) $ " \n" $ "bHasInputInWindow: " $ string(bHasInputInWindow);
    return Info;
}

function bool TimePastCycle()
{
    return Outer.WorldInfo.TimeSeconds > CycleBeginTime + CurCycle;
}

function DrawDebugUI()
{
    local int LineColor;
    
    if (CycleNum < 0 || CycleNum > MaxCycleNum - 1)
    {
        return;
    }
    LineColor = int((float(1) - (Outer.WorldInfo.TimeSeconds - CycleBeginTime) / CurCycle) * float(255));
    LineColor = int(FClamp(float(LineColor), 0.0, 255.0));
    Outer.DrawDebugLine(Outer.Pawn.Location, Outer.Pawn.Location + vector(Outer.Pawn.Rotation) * float(200), byte(LineColor), 0, 0);
    if (TimeAtInputWindow())
    {
        Outer.DrawDebugLine(Outer.Pawn.Location, Outer.Pawn.Location - vector(Outer.Pawn.Rotation) * float(200), 0, 255, 0);
    }
}

function DebugUpdate(float DeltaTime)
{
    PlayFloatParticle(DeltaTime);
}

function Update(float DeltaTime)
{
    if (!bActive || !AlicePawn(Outer.Pawn).bCanFloat)
    {
        return;
    }
    if (TimePastCycle())
    {
        StartNewCycle();
    }
    UpdateFloatDownSpeed();
    if (bShowDebugInfo)
    {
        DrawDebugUI();
    }
    PlayFloatParticle(DeltaTime);
}

function StartNewCycle()
{
    if (!bActive || !AlicePawn(Outer.Pawn).bCanFloat || Outer.bInFloatVolume)
    {
        return;
    }
    if (CycleNum >= 0 && !bHasInputInWindow)
    {
        if (Outer.isNewCycleControl())
        {
            if (TimePastCycle())
            {
                AlicePawn(Outer.Pawn).bExitFloatWhenMissWindow = true;
                AlicePawn(Outer.Pawn).DoSpecialMove(63, true);
                PlayFloatFailParticle();
                return;
            }
            else
            {
                indicatorManager.startEffect();
                return;
            }
        }
        else
        {
            AlicePawn(Outer.Pawn).bExitFloatWhenMissWindow = true;
            AlicePawn(Outer.Pawn).DoSpecialMove(63, true);
            PlayFloatFailParticle();
            return;
        }
    }
    if (CycleNum == -1)
    {
        Outer.MyAlicePawn.TriggerContextEventClass(0, 0);
    }
    else if (CycleNum == 1)
    {
        Outer.MyAlicePawn.TriggerContextEventClass(15, 0);
    }
    if (CycleNum > 0)
    {
        if (TimeAtCurCycle())
        {
            bHasInputInWindow = false;
        }
        return;
    }
    bDisableAfterLanded = false;
    if (Outer.isNewCycleControl() && CycleNum > -1)
    {
        return;
    }
    CycleBeginTime = Outer.WorldInfo.TimeSeconds;
    CycleNum++;
    CurCycle *= AlicePawn(Outer.Pawn).CycleRatio;
    hackCurCycle();
    if (LastCycleNum < 0)
    {
        LastCycleNum = 0;
    }
    else if (!bHasInputInWindow)
    {
        LastCycleNum++;
    }
    bHasInputInWindow = false;
    if (bShowDebugInfo)
    {
        Outer.ClientMessage("CycleNum: " $ string(CycleNum) $ "   LastCycleNum: " $ string(LastCycleNum));
    }
}

function jumpPadInit()
{
    Init();
    CycleNum = 0;
}

function Init()
{
    CycleNum = -1;
    LastCycleNum = -1;
    bHasInputInWindow = false;
    AlicePawn(Outer.Pawn).bExitFloatWhenMissWindow = false;
    CurCycle = AlicePawn(Outer.Pawn).FirstCycle / AlicePawn(Outer.Pawn).CycleRatio;
    MaxCycleNum = AlicePawn(Outer.Pawn).MaxCycleFloat;
}

function PostBeginPlay()
{
    if (indicatorManager == none)
    {
        indicatorManager = new(self) class'CycleFloatIndicatorManager';
    }
}

function SetActive(bool _bActive)
{
    bActive = _bActive;
}

defaultproperties
{
    bActive=True
    bDisableAfterLanded=True
    InputTimeWindow=0.5
    CycleNum=-1
    LastCycleNum=-1
    MaxCycleNum=3
    JumpPS="GFX_Alice.Glide.GlideReinitiation"
    FloatFailPS="GFX_Alice.Glide.GlideFail"
    FloatPS1="GFX_Alice.Glide.GlideTrail"
    FloatPS2="GFX_Alice.Glide.GlideTrail_Lvl2"
    FloatPS3="GFX_Alice.Glide.GlideTrail_Lvl3"
    FloatPS4="GFX_Alice.Glide.GlideTrail_Lvl4"
    CycleDatas(0)=(PrePreJumpZ=150.0,PreJumpZ=350.0,JumpZ=600.0)
    CycleDatas(1)=(PrePreJumpZ=150.0,PreJumpZ=350.0,JumpZ=600.0)
    CycleDatas(2)=(PrePreJumpZ=150.0,PreJumpZ=350.0,JumpZ=600.0)
}
