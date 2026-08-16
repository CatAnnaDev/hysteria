class UIState_Disabled extends UIState
    native
    notplaceable
    editinlinenew
    hidecategories(Object,UIRoot);

event bool IsStateAllowed(UIScreenObject Target, UIState NewState, int PlayerIndex)
{
    if (IsStateAllowed(Target, NewState, PlayerIndex))
    {
        return NewState.Class == class'UIState_Enabled';
    }
    return false;
}

event bool ActivateState(UIScreenObject Target, int PlayerIndex)
{
    local int I, EnabledIndex;
    local bool bResult;
    
    bResult = ActivateState(Target, PlayerIndex);
    if (Target != none && bResult)
    {
        if (Target.HasActiveStateOfClass(class'UIState_Enabled', PlayerIndex, EnabledIndex))
        {
            for (I = Target.StateStack.Length - 1; I > EnabledIndex; I--)
            {
                if (!Target.DeactivateState(Target.StateStack[I], PlayerIndex))
                {
                    break;
                }
            }
        }
        bResult = true;
    }
    return bResult;
}

defaultproperties
{
    StackPriority=5
}
