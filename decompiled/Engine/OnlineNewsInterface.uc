class OnlineNewsInterface extends Interface
    abstract
    notplaceable;

var delegate<OnReadNewsCompleted> __OnReadNewsCompleted__Delegate;

function string GetNews(byte LocalUserNum, EOnlineNewsType NewsType)
{
}

function ClearReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate)
{
}

function AddReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate)
{
}

delegate OnReadNewsCompleted(bool bWasSuccessful, EOnlineNewsType NewsType)
{
}

function bool ReadNews(byte LocalUserNum, EOnlineNewsType NewsType)
{
}

defaultproperties
{
}
