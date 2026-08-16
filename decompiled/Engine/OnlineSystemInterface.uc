class OnlineSystemInterface extends Interface
    abstract
    notplaceable;

var delegate<OnLinkStatusChange> __OnLinkStatusChange__Delegate;
var delegate<OnExternalUIChange> __OnExternalUIChange__Delegate;
var delegate<OnControllerChange> __OnControllerChange__Delegate;
var delegate<OnConnectionStatusChange> __OnConnectionStatusChange__Delegate;
var delegate<OnStorageDeviceChange> __OnStorageDeviceChange__Delegate;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;

function EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
}

function bool GetTitleFileContents(string Filename, out array<byte> FileContents)
{
}

function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
}

function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
}

function bool ReadTitleFile(string FileToRead)
{
}

delegate OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
}

function ClearStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
}

function AddStorageDeviceChangeDelegate(delegate<OnStorageDeviceChange> StorageDeviceChangeDelegate)
{
}

delegate OnStorageDeviceChange()
{
}

function ENATType GetNATType()
{
}

function ClearConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
}

function AddConnectionStatusChangeDelegate(delegate<OnConnectionStatusChange> ConnectionStatusDelegate)
{
}

delegate OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
}

function bool IsControllerConnected(int ControllerId)
{
}

function ClearControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
}

function AddControllerChangeDelegate(delegate<OnControllerChange> ControllerChangeDelegate)
{
}

delegate OnControllerChange(int ControllerId, bool bIsConnected)
{
}

function SetNetworkNotificationPosition(ENetworkNotificationPosition NewPos)
{
}

function ENetworkNotificationPosition GetNetworkNotificationPosition()
{
}

function ClearExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
}

function AddExternalUIChangeDelegate(delegate<OnExternalUIChange> ExternalUIDelegate)
{
}

delegate OnExternalUIChange(bool bIsOpening)
{
}

function ClearLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
}

function AddLinkStatusChangeDelegate(delegate<OnLinkStatusChange> LinkStatusDelegate)
{
}

delegate OnLinkStatusChange(bool bIsConnected)
{
}

function bool HasLinkConnection()
{
}

defaultproperties
{
}
