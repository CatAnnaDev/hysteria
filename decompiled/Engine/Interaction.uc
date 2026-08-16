class Interaction extends UIRoot
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var delegate<OnReceivedNativeInputKey> __OnReceivedNativeInputKey__Delegate;
var delegate<OnReceivedNativeInputAxis> __OnReceivedNativeInputAxis__Delegate;
var delegate<OnReceivedNativeInputChar> __OnReceivedNativeInputChar__Delegate;
var delegate<OnInitialize> __OnInitialize__Delegate;

function NotifyPlayerRemoved(int PlayerIndex, LocalPlayer RemovedPlayer)
{
}

function NotifyPlayerAdded(int PlayerIndex, LocalPlayer AddedPlayer)
{
}

function NotifyGameSessionEnded()
{
}

function Initialized()
{
}

delegate OnInitialize()
{
}

native final function Init()
{
}

event PostRender(Canvas Canvas)
{
}

event Tick(float DeltaTime)
{
}

delegate bool OnReceivedNativeInputChar(int ControllerId, string Unicode)
{
}

delegate bool OnReceivedNativeInputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
}

delegate bool OnReceivedNativeInputKey(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed = 1.0, optional bool bGamepad)
{
}

defaultproperties
{
    __OnInitialize__Delegate="None"
}
