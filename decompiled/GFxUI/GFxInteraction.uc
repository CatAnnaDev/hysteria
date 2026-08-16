class GFxInteraction extends Interaction
    native
    notplaceable
    transient
    hidecategories(Object,UIRoot);

var const native noexport Pointer VfTable_FCallbackEventDevice;

native function NotifyGameSessionEnded()
{
}

native function GFxMovie GetFocusMovie()
{
}

native function bool SetFocusMovie(string MovieName, bool captureInput)
{
    MovieName;
    captureInput;
}

defaultproperties
{
}
