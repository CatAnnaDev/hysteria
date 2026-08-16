class AliceRemoteSpeaker extends ReplicationInfo
    abstract
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

struct native RemoteSpeakerDelayedLine
{
    var Actor Addressee;
    var SoundCue Audio;
    var bool bSuppressSubtitle;
    var float DelayTime;
    var ESpeakLineBroadcastFilter MPBroadcastFilter;
    var string DebugText;
    var ESpeechPriority Priority;
};

var array<string> MasterGUDBankClassNames;
var transient int LoadedGUDBank;
var transient bool bSpeaking;
var bool bEnabled;
var transient bool bMuteGUDS;
var repnotify RemoteSpeakerDelayedLine DelayedLineParams;
var export editinline AudioComponent CurrentlySpeakingLine;
var int TeamIndex;

replication
{
    if (bNetDirty)
        DelayedLineParams;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnabled = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnabled = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnabled = !bEnabled;
    }
}

simulated event bool IsSameTeam(Pawn P)
{
    return int(P.GetTeamNum()) == TeamIndex ? true : false;
}

simulated event RemoteSpeakLineFinished()
{
    local RemoteSpeakerDelayedLine EmptyLine;
    
    AliceGameInfo(WorldInfo.Game).SpeechManager.NotifyDialogueFinish(self, CurrentlySpeakingLine.SoundCue);
    bSpeaking = false;
    CurrentlySpeakingLine = none;
    ClearTimer('RemoteSpeakLineFinished');
    DelayedLineParams = EmptyLine;
}

protected simulated function PlayQueuedSpeakLine()
{
    local PlayerController PC;
    local float SpeakTime;
    
    if (bEnabled)
    {
        if (CurrentlySpeakingLine != none)
        {
            CurrentlySpeakingLine.FadeOut(0.2, 0.0);
        }
        if (!ShouldFilterOutSpeech(DelayedLineParams.MPBroadcastFilter, DelayedLineParams.Addressee))
        {
            if (DelayedLineParams.Audio != none)
            {
                CurrentlySpeakingLine = CreateAudioComponent(DelayedLineParams.Audio, false, true);
                if (CurrentlySpeakingLine != none)
                {
                    CurrentlySpeakingLine.bAllowSpatialization = false;
                    CurrentlySpeakingLine.SubtitlePriority = 1.0;
                    CurrentlySpeakingLine.bSuppressSubtitles = DelayedLineParams.bSuppressSubtitle;
                    CurrentlySpeakingLine.bAutoDestroy = true;
                    AttachComponent(CurrentlySpeakingLine);
                    CurrentlySpeakingLine.Play();
                }
                SpeakTime = DelayedLineParams.Audio.GetCueDuration() + 0.2;
            }
            else
            {
                SpeakTime = 2.0;
            }
            if (DelayedLineParams.DebugText != "")
            {
                foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
                {
                    break;
                }
                PC.ClientMessage(string(self) @ ":" @ DelayedLineParams.DebugText);
            }
            ClearTimer('PlayQueuedSpeakLine');
            SetTimer(SpeakTime, false, 'RemoteSpeakLineFinished');
            bSpeaking = true;
        }
    }
    if (bSpeaking)
    {
        AliceGameInfo(WorldInfo.Game).SpeechManager.NotifyDialogueStart(self, DelayedLineParams.Addressee, DelayedLineParams.Audio, DelayedLineParams.Priority);
    }
}

final simulated function bool ShouldFilterOutSpeech(ESpeakLineBroadcastFilter Filter, Actor Addressee)
{
    local PlayerController PC;
    
    switch (Filter)
    {
        case 0:
            return false;
        case 2:
            foreach LocalPlayerControllers(class'Engine.PlayerController', PC)
            {
                if (int(PC.GetTeamNum()) == TeamIndex)
                {
                    return false;
                }
            }
            return true;
        case 1:
            return true;
        case 3:
            return false;
        default:
            return false;
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'DelayedLineParams')
    {
        if (DelayedLineParams.Audio != none)
        {
            if (DelayedLineParams.DelayTime > 0.0)
            {
                SetTimer(DelayedLineParams.DelayTime, false, 'PlayQueuedSpeakLine');
            }
            else
            {
                PlayQueuedSpeakLine();
            }
        }
    }
}

simulated event bool RemoteSpeakLine(Actor Addressee, SoundCue Audio, string DebugText, optional float DelaySec, optional bool bSuppressSubtitle, optional ESpeakLineBroadcastFilter MPBroadcastFilter, optional ESpeechPriority Priority)
{
    if (bEnabled && !bSpeaking)
    {
        DelayedLineParams.Addressee = Addressee;
        DelayedLineParams.Audio = Audio;
        DelayedLineParams.DebugText = DebugText;
        DelayedLineParams.bSuppressSubtitle = bSuppressSubtitle;
        DelayedLineParams.DelayTime = DelaySec;
        DelayedLineParams.MPBroadcastFilter = MPBroadcastFilter;
        DelayedLineParams.Priority = Priority;
        if (DelaySec > 0.0)
        {
            SetTimer(DelaySec, false, 'PlayQueuedSpeakLine');
        }
        else
        {
            PlayQueuedSpeakLine();
        }
        bNetDirty = true;
        bForceNetUpdate = true;
        return true;
    }
    return false;
}

defaultproperties
{
    bEnabled=True
    TeamIndex=255
    TickGroup="TG_DuringAsyncWork"
    NetUpdateFrequency=1.0
}
