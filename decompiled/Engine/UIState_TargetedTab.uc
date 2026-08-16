class UIState_TargetedTab extends UIState
    native
    notplaceable
    editinlinenew
    hidecategories(Object,UIRoot);

event bool IsWidgetClassSupported(class<UIScreenObject> WidgetClass)
{
    return WidgetClass.ClassIsChildOf(WidgetClass, class'UITabButton');
}

defaultproperties
{
    StackPriority=11
}
