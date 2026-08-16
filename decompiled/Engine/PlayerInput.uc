class PlayerInput extends Input
    native
    notplaceable
    transient
    config(Input)
    within PlayerController
    hidecategories(Object,UIRoot);

var const bool bUsingGamepad;
var globalconfig bool bInvertMouse;
var globalconfig bool bInvertTurn;
var bool bWasForward;
var bool bWasBack;
var bool bWasLeft;
var bool bWasRight;
var bool bEdgeForward;
var bool bEdgeBack;
var bool bEdgeLeft;
var bool bEdgeRight;
var globalconfig bool bEnableMouseSmoothing;
var bool bEnableFOVScaling;
var transient bool bLockTurnUntilRelease;
var const name LastAxisKeyName;
var float DoubleClickTimer;
var globalconfig float DoubleClickTime;
var globalconfig float MouseSensitivity;
var input float aBaseX;
var input float aBaseY;
var input float aBaseZ;
var input float aMouseX;
var input float aMouseY;
var input float aForward;
var input float aTurn;
var input float aStrafe;
var input float aUp;
var input float aLookUp;
var input float aRightAnalogTrigger;
var input float aLeftAnalogTrigger;
var input float aPS3AccelX;
var input float aPS3AccelY;
var input float aPS3AccelZ;
var input float aPS3Gyro;
var transient float RawJoyUp;
var transient float RawJoyRight;
var transient float RawJoyLookRight;
var transient float RawJoyLookUp;
var() config float MoveForwardSpeed;
var() config float MoveStrafeSpeed;
var() config float LookRightScale;
var() config float LookUpScale;
var() config float LookRightScaleForFP;
var() config float LookUpScaleForFP;
var input byte bStrafe;
var input byte bXAxis;
var input byte bYAxis;
var float ZeroTime[2];
var float SmoothedMouse[2];
var int MouseSamples;
var float MouseSamplingTotal;
var transient float AutoUnlockTurnTime;

function float SmoothMouse(float aMouse, float DeltaTime, out byte SampleCount, int Index)
{
    local float MouseSamplingTime;
    
    if (DeltaTime < 0.25)
    {
        MouseSamplingTime = MouseSamplingTotal / float(MouseSamples);
        if (aMouse == float(0))
        {
            ZeroTime[Index] += DeltaTime;
            if (ZeroTime[Index] < MouseSamplingTime)
            {
                aMouse = SmoothedMouse[Index] * DeltaTime / MouseSamplingTime;
            }
            else
            {
                SmoothedMouse[Index] = 0.0;
            }
        }
        else
        {
            ZeroTime[Index] = 0.0;
            if (SmoothedMouse[Index] != float(0))
            {
                if (DeltaTime < MouseSamplingTime * float(int(SampleCount) + int(1)))
                {
                    aMouse = aMouse * DeltaTime / (MouseSamplingTime * float(SampleCount));
                }
                else
                {
                    SampleCount = byte(DeltaTime / MouseSamplingTime);
                }
            }
            SmoothedMouse[Index] = aMouse / float(SampleCount);
        }
    }
    else
    {
        ClearSmoothing();
    }
    SampleCount = 0;
    return aMouse;
}

exec function ClearSmoothing()
{
    local int I;
    
    for (I = 0; I < 2; I++)
    {
        ZeroTime[I] = 0.0;
        SmoothedMouse[I] = 0.0;
    }
    MouseSamplingTotal = default.MouseSamplingTotal;
    MouseSamples = default.MouseSamples;
}

exec function SmartJump()
{
    Jump();
}

exec function Jump()
{
    Outer.bPressedJump = true;
}

final function ProcessInputMatching(float DeltaTime)
{
    local float Value;
    local int I, MatchIdx;
    local bool bMatch;
    
    for (I = 0; I < Outer.InputRequests.Length; I++)
    {
        if (Outer.InputRequests[I].MatchIdx >= 0 && Outer.InputRequests[I].MatchIdx < Outer.InputRequests[I].Inputs.Length)
        {
            if (Outer.InputRequests[I].MatchActor == none)
            {
                Outer.InputRequests[I].MatchActor = Outer;
            }
            MatchIdx = Outer.InputRequests[I].MatchIdx;
            if (MatchIdx != 0 && Outer.InputRequests[I].Inputs[MatchIdx].TimeDelta > 0.0 && Outer.WorldInfo.TimeSeconds - Outer.InputRequests[I].LastMatchTime >= Outer.InputRequests[I].Inputs[MatchIdx].TimeDelta)
            {
                Outer.InputRequests[I].LastMatchTime = 0.0;
                Outer.InputRequests[I].MatchIdx = 0;
                if (Outer.InputRequests[I].FailedFuncName != 'None')
                {
                    Outer.InputRequests[I].MatchActor.SetTimer(0.01, false, Outer.InputRequests[I].FailedFuncName);
                }
                continue;
            }
            Value = 0.0;
            switch (Outer.InputRequests[I].Inputs[MatchIdx].Type)
            {
                case 0:
                    Value = aStrafe;
                    break;
                case 1:
                    Value = aBaseY;
                    break;
                default:
            }
            switch (Outer.InputRequests[I].Inputs[MatchIdx].Action)
            {
                case 0:
                    bMatch = Value >= Outer.InputRequests[I].Inputs[MatchIdx].Value;
                    break;
                case 1:
                    bMatch = Value <= Outer.InputRequests[I].Inputs[MatchIdx].Value;
                    break;
                default:
            }
            if (bMatch)
            {
                Outer.InputRequests[I].LastMatchTime = Outer.WorldInfo.TimeSeconds;
                Outer.InputRequests[I].MatchIdx++;
                if (Outer.InputRequests[I].MatchIdx >= Outer.InputRequests[I].Inputs.Length)
                {
                    if (Outer.InputRequests[I].MatchDelegate != none)
                    {
                        Outer.__InputMatchDelegate__Delegate = Outer.InputRequests[I].MatchDelegate;
                        Outer.InputMatchDelegate();
                    }
                    if (Outer.InputRequests[I].MatchFuncName != 'None')
                    {
                        Outer.InputRequests[I].MatchActor.SetTimer(0.01, false, Outer.InputRequests[I].MatchFuncName);
                    }
                    Outer.InputRequests[I].LastMatchTime = 0.0;
                    Outer.InputRequests[I].MatchIdx = 0;
                }
            }
        }
    }
}

function EDoubleClickDir CheckForDoubleClickMove(float DeltaTime)
{
    local EDoubleClickDir DoubleClickMove, OldDoubleClick;
    
    if (Outer.DoubleClickDir == 5)
    {
        DoubleClickMove = 5;
    }
    else
    {
        DoubleClickMove = 0;
    }
    if (DoubleClickTime > 0.0)
    {
        if (Outer.DoubleClickDir == 5)
        {
            if (Outer.Pawn != none && Outer.Pawn.Physics == 1)
            {
                DoubleClickTimer = 0.0;
                Outer.DoubleClickDir = 6;
            }
        }
        else if (Outer.DoubleClickDir != 6)
        {
            OldDoubleClick = Outer.DoubleClickDir;
            Outer.DoubleClickDir = 0;
            if (bEdgeForward && bWasForward)
            {
                Outer.DoubleClickDir = 3;
            }
            else if (bEdgeBack && bWasBack)
            {
                Outer.DoubleClickDir = 4;
            }
            else if (bEdgeLeft && bWasLeft)
            {
                Outer.DoubleClickDir = 1;
            }
            else if (bEdgeRight && bWasRight)
            {
                Outer.DoubleClickDir = 2;
            }
            if (Outer.DoubleClickDir == 0)
            {
                Outer.DoubleClickDir = OldDoubleClick;
            }
            else if (Outer.DoubleClickDir != OldDoubleClick)
            {
                DoubleClickTimer = DoubleClickTime + 0.5 * DeltaTime;
            }
            else
            {
                DoubleClickMove = Outer.DoubleClickDir;
            }
        }
        if (Outer.DoubleClickDir == 6)
        {
            DoubleClickTimer = FMin(DoubleClickTimer - DeltaTime, 0.0);
            if (DoubleClickTimer < -0.35)
            {
                Outer.DoubleClickDir = 0;
                DoubleClickTimer = DoubleClickTime;
            }
        }
        else if (Outer.DoubleClickDir != 0 && Outer.DoubleClickDir != 5)
        {
            DoubleClickTimer -= DeltaTime;
            if (DoubleClickTimer < float(0))
            {
                Outer.DoubleClickDir = 0;
                DoubleClickTimer = DoubleClickTime;
            }
        }
    }
    return DoubleClickMove;
}

function CatchDoubleClickInput()
{
    if (!Outer.IsMoveInputIgnored())
    {
        bEdgeForward = bWasForward ^^ aBaseY > float(0);
        bEdgeBack = bWasBack ^^ aBaseY < float(0);
        bEdgeLeft = bWasLeft ^^ aStrafe < float(0);
        bEdgeRight = bWasRight ^^ aStrafe > float(0);
        bWasForward = aBaseY > float(0);
        bWasBack = aBaseY < float(0);
        bWasLeft = aStrafe < float(0);
        bWasRight = aStrafe > float(0);
    }
}

event PlayerInput(float DeltaTime)
{
    local float FOVScale, TimeScale;
    
    RawJoyUp = aBaseY;
    RawJoyRight = aStrafe;
    RawJoyLookRight = aTurn;
    RawJoyLookUp = aLookUp;
    DeltaTime /= Outer.WorldInfo.TimeDilation;
    if (Outer.bDemoOwner && Outer.WorldInfo.NetMode == 3)
    {
        DeltaTime /= Outer.WorldInfo.DemoPlayTimeDilation;
    }
    PreProcessInput(DeltaTime);
    TimeScale = 100.0 * DeltaTime;
    aBaseY *= TimeScale * MoveForwardSpeed;
    aStrafe *= TimeScale * MoveStrafeSpeed;
    aUp *= TimeScale * MoveStrafeSpeed;
    aTurn *= TimeScale * LookRightScale;
    aLookUp *= TimeScale * LookUpScale;
    PostProcessInput(DeltaTime);
    ProcessInputMatching(DeltaTime);
    CatchDoubleClickInput();
    if (bEnableFOVScaling)
    {
        FOVScale = Outer.GetFOVAngle() * 0.01111;
    }
    else
    {
        FOVScale = 1.0;
    }
    AdjustMouseSensitivity(FOVScale);
    if (bEnableMouseSmoothing)
    {
        aMouseX = SmoothMouse(aMouseX, DeltaTime, bXAxis, 0);
        aMouseY = SmoothMouse(aMouseY, DeltaTime, bYAxis, 1);
    }
    aLookUp *= FOVScale;
    aTurn *= FOVScale;
    if (bStrafe > 0)
    {
        aStrafe += aBaseX + aMouseX;
    }
    else
    {
        aTurn += aBaseX + aMouseX;
    }
    aLookUp += aMouseY;
    if (bInvertMouse)
    {
        aLookUp *= -1.0;
    }
    if (bInvertTurn)
    {
        aTurn *= -1.0;
    }
    aForward += aBaseY;
    Outer.HandleWalking();
    if (bLockTurnUntilRelease)
    {
        if (RawJoyLookRight != float(0))
        {
            aTurn = 0.0;
            if (AutoUnlockTurnTime > 0.0)
            {
                AutoUnlockTurnTime -= DeltaTime;
                if (AutoUnlockTurnTime < 0.0)
                {
                    bLockTurnUntilRelease = false;
                }
            }
        }
        else
        {
            bLockTurnUntilRelease = false;
        }
    }
    if (Outer.IsMoveInputIgnored())
    {
        aForward = 0.0;
        aStrafe = 0.0;
        aUp = 0.0;
    }
    if (Outer.IsLookInputIgnored())
    {
        aTurn = 0.0;
        aLookUp = 0.0;
    }
}

event ExecInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
}

event ExecInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
}

native function DisablePlayerInput(bool bDisableIt, float fDisabledTime)
{
    bDisableIt;
    fDisabledTime;
}

function AdjustMouseSensitivity(float FOVScale)
{
    aMouseX *= MouseSensitivity * FOVScale;
    aMouseY *= MouseSensitivity * FOVScale;
}

function PostProcessInput(float DeltaTime)
{
}

function PreProcessInput(float DeltaTime)
{
}

function DrawHUD(HUD H)
{
}

exec function SetSensitivity(float F)
{
    MouseSensitivity = F;
}

exec function bool InvertTurn()
{
    bInvertTurn = !bInvertTurn;
    SaveConfig();
    return bInvertTurn;
}

exec function bool InvertMouse()
{
    bInvertMouse = !bInvertMouse;
    SaveConfig();
    return bInvertMouse;
}

defaultproperties
{
    bEnableMouseSmoothing=True
    DoubleClickTime=0.25
    MouseSensitivity=60.0
    MoveForwardSpeed=4800.0
    MoveStrafeSpeed=4800.0
    LookRightScale=300.0
    LookUpScale=-250.0
    LookRightScaleForFP=500.0
    LookUpScaleForFP=-350.0
    MouseSamples=1
    MouseSamplingTotal=0.0083
    Bindings(0)=(Name="Fire",Command="Button bFire | StartFire | OnRelease StopFire",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(1)=(Name="AltFire",Command="StartAltFire | OnRelease StopAltFire",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(2)=(Name="MoveForward",Command="Axis aBaseY Speed=1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(3)=(Name="MoveBackward",Command="Axis aBaseY Speed=-1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(4)=(Name="TurnLeft",Command="Axis aBaseX Speed=-200.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(5)=(Name="TurnRight",Command="Axis aBaseX  Speed=+200.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(6)=(Name="StrafeLeft",Command="Axis aStrafe Speed=-1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(7)=(Name="StrafeRight",Command="Axis aStrafe Speed=+1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(8)=(Name="Jump",Command="Jump | Axis aUp Speed=+1.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(9)=(Name="Duck",Command="Button bDuck | Axis aUp Speed=-1.0  AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(10)=(Name="Look",Command="Button bLook",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(11)=(Name="Pause",Command="Pause",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(12)=(Name="LookToggle",Command="Toggle bLook",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(13)=(Name="LookUp",Command="Axis aLookUp Speed=+25.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(14)=(Name="LookDown",Command="Axis aLookUp Speed=-25.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(15)=(Name="CenterView",Command="Button bSnapLevel",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(16)=(Name="Walking",Command="Button bRun",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(17)=(Name="Strafe",Command="Button bStrafe",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(18)=(Name="NextWeapon",Command="NextWeapon",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(19)=(Name="ViewTeam",Command="ViewClass Pawn",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(20)=(Name="TurnToNearest",Command="Button bTurnToNearest",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(21)=(Name="Turn180",Command="Button bTurn180",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(22)=(Name="MouseX",Command="Count bXAxis | Axis aMouseX",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(23)=(Name="MouseY",Command="Count bYAxis | Axis aMouseY",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(24)=(Name="LeftControl",Command="Jump",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(25)=(Name="SpaceBar",Command="Jump | CANCELMATINEE",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(26)=(Name="Escape",Command="CloseEditorViewport | onrelease ShowMenu",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(27)=(Name="E",Command="Use",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(28)=(Name="MouseScrollUp",Command="PrevWeapon",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(29)=(Name="MouseScrollDown",Command="NextWeapon",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(30)=(Name="C",Command="DoDuck",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(31)=(Name="P",Command="TogglePhysicsMode",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(32)=(Name="B",Command="ToggleSpeaking true | OnRelease ToggleSpeaking false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(33)=(Name="T",Command="Talk",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(34)=(Name="Y",Command="TeamTalk",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(35)=(Name="Up",Command="MoveForward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(36)=(Name="Down",Command="MoveBackward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(37)=(Name="Left",Command="TurnLeft",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(38)=(Name="Right",Command="TurnRight",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(39)=(Name="W",Command="MoveForward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(40)=(Name="S",Command="MoveBackward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(41)=(Name="A",Command="StrafeLeft",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(42)=(Name="D",Command="StrafeRight",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(43)=(Name="LeftShift",Command="Walking",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(44)=(Name="F1",Command="viewmode wireframe",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(45)=(Name="F2",Command="viewmode unlit",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(46)=(Name="F3",Command="viewmode lit",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(47)=(Name="F4",Command="viewmode shadercomplexity",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(48)=(Name="F5",Command="quicksave",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(49)=(Name="F6",Command="quickload",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(50)=(Name="F7",Command="set D3DRenderDevice bUsePostProcessEffects False",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(51)=(Name="F8",Command="set D3DRenderDevice bUsePostProcessEffects True",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(52)=(Name="F9",Command="shot",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(53)=(Name="Comma",Command="ToggleMobileEmulation",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(54)=(Name="XboxTypeS_A",Command="Jump",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(55)=(Name="XboxTypeS_B",Command="ChangeShrinkingMode",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(56)=(Name="XboxTypeS_B",Command="ChangePosture",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(57)=(Name="XboxTypeS_X",Command="ChangeCrouchingMode true | OnRelease ChangeCrouchingMode false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(58)=(Name="XboxTypeS_Y",Command="NextWeapon",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(59)=(Name="XboxTypeS_Back",Command="",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(60)=(Name="XboxTypeS_Start",Command="|onrelease showmenu",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(61)=(Name="XboxTypeS_LeftShoulder",Command="obj list",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(62)=(Name="XboxTypeS_RightShoulder",Command="mem",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(63)=(Name="XboxTypeS_DPad_Up",Command="MoveForward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(64)=(Name="XboxTypeS_DPad_Down",Command="MoveBackward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(65)=(Name="XboxTypeS_DPad_Left",Command="TurnLeft",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(66)=(Name="XboxTypeS_DPad_Right",Command="TurnRight",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(67)=(Name="XboxTypeS_RightTrigger",Command="Fire",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(68)=(Name="XboxTypeS_LeftTrigger",Command="ChangeCameraMode true | OnRelease ChangeCameraMode false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(69)=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(70)=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(71)=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(72)=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=0.8 DeadZone=0.2",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(73)=(Name="XboxTypeS_LeftTriggerAxis",Command="Axis aLeftAnalogTrigger Speed=1.0 DeadZone=0.11",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(74)=(Name="XboxTypeS_RightTriggerAxis",Command="Axis aRightAnalogTrigger Speed=1.0 DeadZone=0.11",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(75)=(Name="XboxTypeS_Back",Command="CheshireCatAppear| TryToCancelMatinee | togglephysicsmode",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(76)=(Name="XboxTypeS_LeftShoulder",Command="ChangeShrinkingMode | OnRelease UnShrinking | TiggerSprint true|OnRelease TiggerSprint false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(77)=(Name="XboxTypeS_RightTrigger",Command="OnRelease SwimAttack|RangeWeaponFirePress|OnRelease RangeWeaponFireRelease | DiscardWatch|Button RightTrigger",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(78)=(Name="XboxTypeS_RightShoulder",Command="SwitchEmotion | TriggerDodge true | OnRelease TriggerDodge false | DiscardWatch | CycleFloatInputRB",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(79)=(Name="XboxTypeS_X",Command="TurretCannonFire|OnRelease ShootPinball |ChargePinballCannon| SwimTurnBack180 | BoostRoll true|OnRelease BoostRoll false | PickUpActor | Pickup | DropCarried | use | push | EjectAliceFromCannon |FireGiantWeapon | VorpalBladeFirePress | OnRelease VorpalBladeFireRelease | QuitFPS  | StartContextAction | interactInLondonX | InteractBlockPiece",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(80)=(Name="XboxTypeS_Y",Command="TurretMineFire|GiantStomp | HobbyHorseFirePress | OnRelease HobbyHorseFireRelease | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(81)=(Name="XboxTypeS_DPad_Up",Command="TryToSwitchRangeWeapon true | Button cA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(82)=(Name="XboxTypeS_DPad_Down",Command="TryToSwitchRangeWeapon false | Button dA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(83)=(Name="XboxTypeS_DPad_Left",Command="TryToSwitchRangeWeapon true | DiscardWatch | Button bA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(84)=(Name="XboxTypeS_DPad_Right",Command="TryToSwitchRangeWeapon false | DiscardWatch | Button eA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(85)=(Name="XboxTypeS_RightThumbstick",Command="EnterFPSByRS | On bA Bugit  | On cA togglephysicsmode | On dA ToggleGhost | On eA StatUnitAndStatFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(86)=(Name="XboxTypeS_LeftThumbstick",Command="OnRelease ToggleCloseFollowCamera | TriggerHysteria",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(87)=(Name="XboxTypeS_LeftTrigger",Command="TogglePOI true | OnRelease TogglePOI false | ChangeCameraMode true | OnRelease ChangeCameraMode false | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(88)=(Name="XboxTypeS_Start",Command="ShowJournalMenu",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(89)=(Name="XboxTypeS_B",Command="StartClockBombContextAction|TurretMineFire|CloneButtonPressed | GiantStompOnButtonB | OnRelease CloneButtonReleased | OnRelease  ExitFromCannon true|DropCarried| OnEndUpgradeUI | HeadSwitchEject | MoveBlockPieceB",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(90)=(Name="XboxTypeS_A",Command="TurretCannonFire|Jump|EjectAliceFromCannon|DropCarried|use|push|LaunchFromJumpPad | OnRelease JumpButtonReleased | QuitFPS |TriggerBlock true| OnRelease TriggerBlock false | ToggleSonar | MoveBlockPieceA | DiscardWatch | FireGiantWeapon | CycleFloatInputA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(91)=(Name="Escape",Command="CloseEditorViewport | onrelease ShowMenu |ShowJournalMenu",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(92)=(Name="One",Command="SwitchToVorpalBlade | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(93)=(Name="Two",Command="SwitchToEyeStaff | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(94)=(Name="Three",Command="SwitchToHobbyHorse | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(95)=(Name="Four",Command="SwitchToTeapotCannon | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(96)=(Name="T",Command="EnterFPSByRS | OnRelease ToggleCloseFollowCamera ",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(97)=(Name="Y",Command="",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(98)=(Name="U",Command="",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(99)=(Name="L",Command="OpenSamepleMenu",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(100)=(Name="E",Command="TriggerBlock true | OnRelease TriggerBlock false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(101)=(Name="C",Command="TogglePOI true | OnRelease TogglePOI false | CheshireCatAppear | StartContextAction | interactInLondonX | InteractBlockPiece | PickUpActor | Pickup | DropCarried | use | push | QuitFPS | TurretCannonFire |OnRelease ShootPinball |ChargePinballCannon| SwimTurnBack180 | BoostRoll true | OnRelease BoostRoll false | EjectAliceFromCannon | FireGiantWeapon ",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(102)=(Name="LeftMouseButton",Command="MeleeAttack | OnRelease QuitWeaponAttack | TurretCannonFire | DiscardWatch | StartContextAction | FireGiantWeapon | QuitFPS",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(103)=(Name="RightMouseButton",Command="RangeWeaponFirePress | OnRelease RangeWeaponFireRelease | TurretMineFire | OnRelease SwimAttack | DiscardWatch | Button RightTrigger | GiantStomp",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(104)=(Name="Q",Command="CloneButtonPressed | OnRelease CloneButtonReleased | StartClockBombContextAction",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(105)=(Name="LeftControl",Command="ChangeShrinkingMode | OnRelease UnShrinking",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(106)=(Name="MouseScrollUp",Command="SwitchToPG",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(107)=(Name="MouseScrollDown",Command="SwitchToTC",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(108)=(Name="Tab",Command="SwitchToLeftLockTarget",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(109)=(Name="CapsLock",Command="ChangeCameraMode true | OnRelease ChangeCameraMode false | QuitFPS | DiscardWatch",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(110)=(Name="SpaceBar",Command="Jump | CycleFloatInputA | TryToCancelMatinee | DiscardWatch | OnRelease ShootPinball | ChargePinballCannon | MoveBlockPieceA",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(111)=(Name="Enter",Command="TriggerHysteria",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(112)=(Name="R",Command="SwitchMeleeWeapon",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(113)=(Name="LeftShift",Command="TriggerDodge true | OnRelease TriggerDodge false",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
}
