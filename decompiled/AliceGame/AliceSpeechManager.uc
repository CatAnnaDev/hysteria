class AliceSpeechManager extends Actor
    native
    notplaceable
    hidecategories(Navigation);

struct native ActiveDialogueLine
{
    var Actor Speaker;
    var Actor Addressee;
    var SoundCue Audio;
    var ESpeechPriority Priority;
};

var transient float LastUpdateTime;
var const float TimeBetweenUpdates;
var array<ActiveDialogueLine> DialogueStack;
var transient bool bTrackDialogue;

simulated function bool IsSpeechActive(ESpeechPriority PriFilter)
{
    local int Idx;
    
    if (PriFilter > 0)
    {
        for (Idx = 0; Idx < DialogueStack.Length; ++Idx)
        {
            if (DialogueStack[Idx].Priority == PriFilter)
            {
                return true;
            }
        }
        return false;
    }
    else
    {
        return DialogueStack.Length > 0;
    }
}

final function NotifyDialogueFinish(Actor Speaker, SoundCue Audio)
{
    local ActiveDialogueLine Line;
    local int Idx;
    local bool bRemove;
    
    if (bTrackDialogue)
    {
        foreach DialogueStack(Line, Idx)
        {
            if (Line.Speaker == Speaker && Line.Audio == Audio)
            {
                bRemove = true;
                break;
            }
        }
        if (bRemove)
        {
            DialogueStack.Remove(Idx, 1);
        }
    }
}

event NotifyDialogueStart(Actor Speaker, Actor Addressee, SoundCue Audio, ESpeechPriority PRI)
{
    local ActiveDialogueLine Line;
    
    if (bTrackDialogue)
    {
        Line.Speaker = Speaker;
        Line.Addressee = Addressee;
        Line.Audio = Audio;
        Line.Priority = PRI;
        DialogueStack[DialogueStack.Length] = Line;
    }
}

function EndDialogueTracking()
{
}

function BeginDialogueTracking()
{
}

defaultproperties
{
    TimeBetweenUpdates=3.0
    bTrackDialogue=True
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}
