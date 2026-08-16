class DebugCameraInput extends PlayerInput
    notplaceable
    transient
    config(Input)
    within PlayerController
    hidecategories(Object,UIRoot);

function bool InputKey(int ControllerId, name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = false)
{
    local PlayerController PC;
    local DebugCameraController DCC;
    
    foreach Outer.WorldInfo.AllControllers(class'PlayerController', PC)
    {
        if (PC.bIsPlayer && PC.IsLocalPlayerController())
        {
            DCC = DebugCameraController(PC);
            if (DCC != none && DCC.OryginalControllerRef == none)
            {
                break;
            }
            return DCC.NativeInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
        }
    }
    return false;
}

defaultproperties
{
    Bindings(0)=(Name="MoveUp",Command="Axis aUp Speed=1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(1)=(Name="MoveDown",Command="Axis aUp Speed=-1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(2)=(Name="MoveForward",Command="Axis aBaseY Speed=1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(3)=(Name="MoveBackward",Command="Axis aBaseY Speed=-1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(4)=(Name="TurnLeft",Command="Axis aBaseX Speed=-200.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(5)=(Name="TurnRight",Command="Axis aBaseX  Speed=+200.0 AbsoluteAxis=100",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(6)=(Name="StrafeLeft",Command="Axis aStrafe Speed=-1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(7)=(Name="StrafeRight",Command="Axis aStrafe Speed=+1.0",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(8)=(Name="Q",Command="MoveDown",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(9)=(Name="E",Command="MoveUp",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(10)=(Name="W",Command="MoveForward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(11)=(Name="S",Command="MoveBackward",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(12)=(Name="A",Command="StrafeLeft",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(13)=(Name="D",Command="StrafeRight",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(14)=(Name="MouseX",Command="Count bXAxis | Axis aMouseX",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(15)=(Name="MouseY",Command="Count bYAxis | Axis aMouseY",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(16)=(Name="Left",Command="TurnLeft",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(17)=(Name="Right",Command="TurnRight",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(18)=(Name="C",Command="ToggleDebugCamera",Control=False,Shift=False,Alt=True,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(19)=(Name="LeftShift",Command="MoreSpeed | OnRelease NormalSpeed",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(20)=(Name="XboxTypeS_LeftThumbstick",Command="ToggleDebugCamera",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(21)=(Name="XboxTypeS_LeftX",Command="Axis aStrafe Speed=1.0 DeadZone=0.3",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(22)=(Name="XboxTypeS_LeftY",Command="Axis aBaseY Speed=1.0 DeadZone=0.3",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(23)=(Name="XboxTypeS_RightX",Command="Axis aTurn Speed=1.0 DeadZone=0.2",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(24)=(Name="XboxTypeS_RightY",Command="Axis aLookup Speed=0.8 DeadZone=0.2",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(25)=(Name="XboxTypeS_LeftTrigger",Command="MoveDown",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(26)=(Name="XboxTypeS_RightTrigger",Command="MoveUp",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(27)=(Name="XboxTypeS_A",Command="SetFreezeRendering",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    Bindings(28)=(Name="XboxTypeS_B",Command="MoreSpeed | OnRelease NormalSpeed",Control=False,Shift=False,Alt=False,bIgnoreCtrl=False,bIgnoreShift=False,bIgnoreAlt=False)
    __OnReceivedNativeInputKey__Delegate="None"
}
