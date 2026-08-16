class GFxGameViewportClient extends GameViewportClient
    native
    notplaceable
    transient
    config(Game)
    within Engine;

var class<GFxInteraction> GFxUIControllerClass;
var GFxInteraction GFxUIController;

event bool Init(out string OutError)
{
    local int oldlen;
    
    oldlen = GlobalInteractions.Length;
    if (!Init(OutError))
    {
        return false;
    }
    GFxUIController = new(self) GFxUIControllerClass;
    if (InsertInteraction(GFxUIController, oldlen + 1) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(GFxUIController);
        return false;
    }
    return true;
}

defaultproperties
{
    GFxUIControllerClass="GFxInteraction"
}
