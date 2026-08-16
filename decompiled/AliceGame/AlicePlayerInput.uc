class AlicePlayerInput extends PlayerInput
    notplaceable
    transient
    config(Input)
    within PlayerController
    hidecategories(Object,UIRoot);

var Vector InputVector;
var Vector InputVectorCombo;
var float InputaUp;
var float RawJoySize;
var bool bDisableInputInCinematic;
var bool bIgnoreMoveForwardInput;
var bool bSecondController;
var float OriForward;
var float OriStrafe;
var AliceControlLayout layout;
var transient float aStrafeDuringIgnore;
var transient float aForwardDuringIgnore;
var transient Vector InputVectorDuringIgnore;
var transient float aLookUpInFPS;
var transient float aTurnInFPS;

function BindCommand(name BindName, name OldFireButton, string Command)
{
    local KeyBind NewBind;
    local int BindIndex;
    
    if (Left(Command, 1) == "\"" && Right(Command, 1) == "\"")
    {
        Command = Mid(Command, 1, Len(Command) - 2);
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == OldFireButton)
        {
            if (InStr(Bindings[BindIndex].Command, Command) != -1)
            {
                Bindings[BindIndex].Command -= Command;
                break;
            }
        }
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            if (InStr(Bindings[BindIndex].Command, Command) != -1)
            {
                return;
            }
        }
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            Bindings[BindIndex].Command @= "|";
            Bindings[BindIndex].Command @= Command;
            return;
        }
    }
    NewBind.Name = BindName;
    NewBind.Command = Command;
    Bindings[Bindings.Length] = NewBind;
}

function SetKeyBind(name BindName, string Command)
{
    local KeyBind NewBind;
    local int BindIndex;
    
    if (Left(Command, 1) == "\"" && Right(Command, 1) == "\"")
    {
        Command = Mid(Command, 1, Len(Command) - 2);
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            Bindings[BindIndex].Command = Command;
            return;
        }
    }
    NewBind.Name = BindName;
    NewBind.Command = Command;
    Bindings[Bindings.Length] = NewBind;
}

function setControlLayout(int Index)
{
    local int BindIndex;
    local array<KeyBind> KeyBindArray;
    
    if (Index == 1)
    {
        KeyBindArray = layout.KeyBindArray1;
    }
    else if (Index == 2)
    {
        KeyBindArray = layout.KeyBindArray2;
    }
    else
    {
        return;
    }
    for (BindIndex = 0; BindIndex < KeyBindArray.Length; BindIndex++)
    {
        SetKeyBind(KeyBindArray[BindIndex].Name, KeyBindArray[BindIndex].Command);
    }
    layout.LayoutIndex = Index;
    layout.SaveConfig();
    SaveConfig();
}

function InitControlLayout()
{
    layout = new(self) class'AliceControlLayout';
}

function float GetRawJoyUp()
{
    return RawJoyUp;
}

function float GetRawJoyRight()
{
    return RawJoyRight;
}

function bool IsKeyPressed(name KeyName)
{
    local int I;
    
    for (I = 0; I < PressedKeys.Length; I++)
    {
        if (PressedKeys[I] == KeyName)
        {
            return true;
        }
    }
    return false;
}

function PreProcessInput(float DeltaTime)
{
}

event bool IsMoveInputForwardIgnored()
{
    return bIgnoreMoveForwardInput;
}

event ExecInputKey(int ControllerId, name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    local AlicePlayerController APC;
    local AliceCheatManager ACM;
    local bool UPadReleased;
    
    APC = AlicePlayerController(Outer);
    if (APC == none)
    {
        return;
    }
    APC.notifyInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    APC.UI_UpdateKeySettings(bGamepad);
    if (!bSecondController)
    {
        return;
    }
    ACM = AliceCheatManager(APC.CheatManager);
    UPadReleased = false;
    switch (Event)
    {
        case 0:
            break;
        case 1:
            if (Key == 'XboxTypeS_Start')
            {
                ACM.SecondController();
            }
            if (APC.bSupportSecondController == false)
            {
                break;
            }
            if (Key == 'XboxTypeS_DPad_Left')
            {
                if (!Outer.IsPaused())
                {
                    ACM.FreezeFrame(0.0);
                    Outer.WorldInfo.bUpdateCameraInPause = true;
                }
                else
                {
                    Outer.SetPause(false);
                }
                UPadReleased = true;
            }
            else if (Key == 'XboxTypeS_DPad_Right')
            {
                ACM.AdvanceFrame();
                UPadReleased = true;
            }
            else if (Key == 'XboxTypeS_Back')
            {
                ACM.FreeCamera();
                ACM.TankControls();
            }
            else if (Key == 'XboxTypeS_X')
            {
                Outer.ConsoleCommand("shot");
            }
            break;
        default:
            break;
    }
    if (APC.bSupportSecondController == true)
    {
        if (IsKeyPressed('XboxTypeS_DPad_Left') || IsKeyPressed('XboxTypeS_DPad_Right'))
        {
            UPadReleased = true;
        }
        if (IsKeyPressed('XboxTypeS_DPad_Up') && !UPadReleased)
        {
            APC.CommandFOVScale += 0.1;
            ACM.ScaleFOV(APC.CommandFOVScale);
        }
        else if (IsKeyPressed('XboxTypeS_DPad_Down') && !UPadReleased)
        {
            APC.CommandFOVScale -= 0.1;
            ACM.ScaleFOV(APC.CommandFOVScale);
        }
        if (APC.PlayerCamera.CameraStyle != 'FreeCam')
        {
            if (IsKeyPressed('XboxTypeS_LeftTrigger'))
            {
                APC.CommandCameraRollDir = -1;
            }
            else if (IsKeyPressed('XboxTypeS_RightTrigger'))
            {
                APC.CommandCameraRollDir = 1;
            }
            else
            {
                APC.CommandCameraRollDir = 0;
            }
        }
    }
}

event ExecInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, bool bGamepad)
{
    local AlicePlayerController APC;
    
    if (Abs(Delta) > 0.3)
    {
        APC = AlicePlayerController(Outer);
        APC.SetCurControllerType(bGamepad);
    }
}

function bool IsInputFree()
{
    local bool bRightStickFree, bLeftStickFree, bMouseFree;
    
    bRightStickFree = !(Abs(RawJoyLookUp) > float(0) || Abs(RawJoyLookRight) > float(0));
    bLeftStickFree = !(Abs(RawJoyUp) > float(0) || Abs(RawJoyRight) > float(0));
    bMouseFree = !(Abs(aMouseX) > float(0) || Abs(aMouseY) > float(0));
    return bRightStickFree && bLeftStickFree && bMouseFree && PressedKeys.Length == 0;
}

event PlayerInput(float DeltaTime)
{
    local float FOVScale, TimeScale, RTimeScale;
    
    RawJoyUp = aBaseY;
    RawJoyRight = aStrafe;
    RawJoyLookRight = aTurn;
    RawJoyLookUp = aLookUp;
    RawJoySize = Sqrt(RawJoyUp * RawJoyUp + RawJoyRight * RawJoyRight);
    if (bSecondController)
    {
        return;
    }
    DeltaTime /= Outer.WorldInfo.TimeDilation;
    if (Outer.bDemoOwner && Outer.WorldInfo.NetMode == 3)
    {
        DeltaTime /= Outer.WorldInfo.DemoPlayTimeDilation;
    }
    PreProcessInput(DeltaTime);
    TimeScale = 2.0;
    RTimeScale = 60.0 * DeltaTime;
    aLookUpInFPS = aLookUp * RTimeScale * LookUpScaleForFP;
    aTurnInFPS = aTurn * RTimeScale * LookRightScaleForFP;
    aBaseY *= TimeScale * MoveForwardSpeed;
    aStrafe *= TimeScale * MoveStrafeSpeed;
    aUp *= TimeScale * MoveStrafeSpeed;
    aTurn *= RTimeScale * LookRightScale;
    aLookUp *= RTimeScale * LookUpScale;
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
    aLookUpInFPS *= FOVScale;
    aTurnInFPS *= FOVScale;
    if (bStrafe > 0)
    {
        aStrafe += aBaseX + aMouseX;
    }
    else
    {
        aTurn += aBaseX + aMouseX;
        aTurnInFPS += aBaseX + aMouseX;
    }
    aLookUp += aMouseY;
    aLookUpInFPS += aMouseY;
    if (bInvertMouse)
    {
        aLookUp *= -1.0;
        aLookUpInFPS *= -1.0;
    }
    if (bInvertTurn)
    {
        aTurn *= -1.0;
        aTurnInFPS *= -1.0;
    }
    aForward += aBaseY;
    Outer.HandleWalking();
    InputVectorCombo.X = aForward;
    InputVectorCombo.Y = aStrafe;
    InputVectorCombo.Z = 0.0;
    OriForward = aForward;
    OriStrafe = aStrafe;
    if (Outer.IsMoveInputIgnored())
    {
        aStrafeDuringIgnore = aStrafe;
        aForwardDuringIgnore = aForward;
        aForward = 0.0;
        aStrafe = 0.0;
        aUp = 0.0;
    }
    else if (IsMoveInputForwardIgnored())
    {
        aForwardDuringIgnore = aForward;
        aForward = 0.0;
    }
    if (Outer.IsLookInputIgnored())
    {
        aTurn = 0.0;
        aLookUp = 0.0;
        aLookUpInFPS = 0.0;
        aTurnInFPS = 0.0;
    }
    InputVector.X = aForward;
    InputVector.Y = aStrafe;
    InputVector.Z = 0.0;
    InputVectorDuringIgnore.X = aForwardDuringIgnore;
    InputVectorDuringIgnore.Y = aStrafeDuringIgnore;
    InputVectorDuringIgnore.Z = 0.0;
    InputaUp = aUp;
}

defaultproperties
{
}
