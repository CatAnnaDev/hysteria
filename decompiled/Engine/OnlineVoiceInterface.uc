class OnlineVoiceInterface extends Interface
    abstract
    notplaceable;

var delegate<OnPlayerTalkingStateChange> __OnPlayerTalkingStateChange__Delegate;
var delegate<OnRecognitionComplete> __OnRecognitionComplete__Delegate;

function bool UnmuteAll(byte LocalUserNum)
{
}

function bool MuteAll(byte LocalUserNum, bool bAllowFriends)
{
}

function bool SetSpeechRecognitionObject(byte LocalUserNum, SpeechRecognition SpeechRecogObj)
{
}

function bool SelectVocabulary(byte LocalUserNum, int VocabularyId)
{
}

function ClearRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
}

function AddRecognitionCompleteDelegate(byte LocalUserNum, delegate<OnRecognitionComplete> RecognitionDelegate)
{
}

delegate OnRecognitionComplete()
{
}

function bool GetRecognitionResults(byte LocalUserNum, out array<SpeechRecognizedWord> Words)
{
}

function bool StopSpeechRecognition(byte LocalUserNum)
{
}

function bool StartSpeechRecognition(byte LocalUserNum)
{
}

function StopNetworkedVoice(byte LocalUserNum)
{
}

function StartNetworkedVoice(byte LocalUserNum)
{
}

function ClearPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
}

function AddPlayerTalkingDelegate(delegate<OnPlayerTalkingStateChange> TalkerDelegate)
{
}

delegate OnPlayerTalkingStateChange(UniqueNetId Player, bool bIsTalking)
{
}

function bool UnmuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool MuteRemoteTalker(byte LocalUserNum, UniqueNetId PlayerID)
{
}

function bool SetRemoteTalkerPriority(byte LocalUserNum, UniqueNetId PlayerID, int Priority)
{
}

function bool IsHeadsetPresent(byte LocalUserNum)
{
}

function bool IsRemotePlayerTalking(UniqueNetId PlayerID)
{
}

function bool IsLocalPlayerTalking(byte LocalUserNum)
{
}

function bool UnregisterRemoteTalker(UniqueNetId PlayerID)
{
}

function bool RegisterRemoteTalker(UniqueNetId PlayerID)
{
}

function bool UnregisterLocalTalker(byte LocalUserNum)
{
}

function bool RegisterLocalTalker(byte LocalUserNum)
{
}

defaultproperties
{
}
