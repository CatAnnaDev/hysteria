class UIState_Focused extends UIState
    native
    notplaceable
    editinlinenew
    hidedropdown
    hidecategories(Object,UIRoot);

event bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    local bool bResult;
    
    bResult = ActivateState(Target, PlayerIndex);
    if (Target != none)
    {
        bResult = Target.HasActiveStateOfClass(class'UIState_Enabled', PlayerIndex);
    }
    return bResult;
}

defaultproperties
{
    StackPriority=10
}
