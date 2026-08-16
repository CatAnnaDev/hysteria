class OnlineNewsInterfaceMcp extends MCPBase
    native
    notplaceable
    config(Engine)
    implements(OnlineNewsInterface);

struct native NewsCacheEntry
{
    var const string NewsUrl;
    var EOnlineEnumerationReadState ReadState;
    var const EOnlineNewsType NewsType;
    var string NewsItem;
    var const float TimeOut;
    var const bool bIsUnicode;
    var const native Pointer HttpDownloader;
};

var config array<NewsCacheEntry> NewsItems;
var array<delegate<OnReadNewsCompleted>> ReadNewsDelegates;
var transient bool bNeedsTicking;
var delegate<OnReadNewsCompleted> __OnReadNewsCompleted__Delegate;

function string GetNews(byte LocalUserNum, EOnlineNewsType NewsType)
{
    local int NewsIndex;
    
    for (NewsIndex = 0; NewsIndex < NewsItems.Length; NewsIndex++)
    {
        if (NewsItems[NewsIndex].NewsType == NewsType)
        {
            return NewsItems[NewsIndex].NewsItem;
        }
    }
    return "";
}

function ClearReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadGameNewsDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ReadNewsDelegates.Find(ReadGameNewsDelegate);
    if (RemoveIndex != -1)
    {
        ReadNewsDelegates.Remove(RemoveIndex, 1);
    }
}

function AddReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate)
{
    if (ReadNewsDelegates.Find(ReadNewsDelegate) == -1)
    {
        ReadNewsDelegates[ReadNewsDelegates.Length] = ReadNewsDelegate;
    }
}

delegate OnReadNewsCompleted(bool bWasSuccessful, EOnlineNewsType NewsType)
{
}

native function bool ReadNews(byte LocalUserNum, EOnlineNewsType NewsType)
{
    LocalUserNum;
    NewsType;
}

defaultproperties
{
}
