class SeqAct_ControlMovieTexture extends SequenceAction
    notplaceable
    hidecategories(Object);

enum EMovieControlType
{
    MCT_Play,
    MCT_Stop,
    MCT_Pause,
};

var() TextureMovie MovieTexture;

event Activated()
{
    local PlayerController PC;
    local EMovieControlType Mode;
    
    if (MovieTexture != none)
    {
        if (InputLinks[0].bHasImpulse)
        {
            Mode = 0;
        }
        else if (InputLinks[1].bHasImpulse)
        {
            Mode = 1;
        }
        else if (InputLinks[2].bHasImpulse)
        {
            Mode = 2;
        }
        foreach GetWorldInfo().AllControllers(class'PlayerController', PC)
        {
            if (LocalPlayer(PC.Player) != none && PC.IsPrimaryPlayer() || NetConnection(PC.Player) != none && ChildConnection(PC.Player) == none)
            {
                PC.ClientControlMovieTexture(MovieTexture, Mode);
            }
        }
    }
}

defaultproperties
{
    bCallHandler=False
    InputLinks(0)=(LinkDesc="Play",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(1)=(LinkDesc="Stop",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    InputLinks(2)=(LinkDesc="Pause",bHasImpulse=False,QueuedActivations=0,bDisabled=False,bDisabledPIE=False,bDisabledPIG=False,LinkedOp="None",DrawY=0,bHidden=False,ActivateDelay=0.0)
    ObjName="Control Movie Texture"
    ObjCategory="Cinematic"
}
