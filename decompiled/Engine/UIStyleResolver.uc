class UIStyleResolver extends Interface
    abstract
    native
    notplaceable;

native function bool NotifyResolveStyle(UISkin ActiveSkin, bool bClearExistingValue, optional UIState CurrentMenuState, optional const name StylePropertyName)
{
    ActiveSkin;
    bClearExistingValue;
    CurrentMenuState;
    StylePropertyName;
}

native function bool SetStyleResolverTag(name NewResolverTag)
{
    NewResolverTag;
}

native function name GetStyleResolverTag()
{
}

defaultproperties
{
}
