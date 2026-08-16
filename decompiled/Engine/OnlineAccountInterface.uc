class OnlineAccountInterface extends Interface
    abstract
    notplaceable;

var delegate<OnCreateOnlineAccountCompleted> __OnCreateOnlineAccountCompleted__Delegate;

function bool GetLocalAccountNames(out array<string> Accounts)
{
}

function bool DeleteLocalAccount(string UserName, optional string Password)
{
}

function bool RenameLocalAccount(string NewUserName, string OldUserName, optional string Password)
{
}

function bool CreateLocalAccount(string UserName, optional string Password)
{
}

function ClearCreateOnlineAccountCompletedDelegate(delegate<OnCreateOnlineAccountCompleted> AccountCreateDelegate)
{
}

function AddCreateOnlineAccountCompletedDelegate(delegate<OnCreateOnlineAccountCompleted> AccountCreateDelegate)
{
}

delegate OnCreateOnlineAccountCompleted(EOnlineAccountCreateStatus ErrorStatus)
{
}

function bool CreateOnlineAccount(string UserName, string Password, string EmailAddress, optional string ProductKey)
{
}

defaultproperties
{
}
