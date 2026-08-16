class ConsoleEntry extends UIObject
    native
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

const ConsolePromptText = "(> ";

var UILabel ConsolePromptLabel;
var UIImage ConsolePromptBackground;
var UIEditBox InputBox;
var UIImage LowerConsoleBorder;
var UIImage UpperConsoleBorder;
var transient int CursorPosition;
var() bool bRenderCursor;

function SetValue(string NewValue)
{
    if (InputBox != none)
    {
        InputBox.SetValue(NewValue);
    }
}

function SetupDockingLinks()
{
    SetDockTarget(3, GetScene(), 3);
    InputBox.SetDockTarget(0, ConsolePromptLabel, 2);
    InputBox.SetDockTarget(2, self, 2);
    InputBox.SetDockTarget(3, LowerConsoleBorder, 1);
    ConsolePromptBackground.SetDockTarget(0, ConsolePromptLabel, 0);
    ConsolePromptBackground.SetDockTarget(1, ConsolePromptLabel, 1);
    ConsolePromptBackground.SetDockTarget(2, ConsolePromptLabel, 2);
    ConsolePromptBackground.SetDockTarget(3, ConsolePromptLabel, 3);
    ConsolePromptLabel.SetDockTarget(0, self, 0);
    ConsolePromptLabel.SetDockTarget(1, InputBox, 1);
    ConsolePromptLabel.SetDockTarget(3, InputBox, 3);
    LowerConsoleBorder.SetDockParameters(1, self, 3, -2.0);
    LowerConsoleBorder.SetDockTarget(3, self, 3);
    UpperConsoleBorder.SetDockParameters(1, InputBox, 1, -2.0);
    UpperConsoleBorder.SetDockTarget(3, InputBox, 1);
}

event PostInitialize()
{
    PostInitialize();
    SetupDockingLinks();
}

event RemovedChild(UIScreenObject WidgetOwner, UIObject OldChild, optional array<UIObject> ExclusionSet)
{
    RemovedChild(WidgetOwner, OldChild, ExclusionSet);
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    AddedChild(WidgetOwner, NewChild);
}

defaultproperties
{
    ConsolePromptLabel="Default__ConsoleEntry.ConsolePromptTemplate"
    ConsolePromptBackground="Default__ConsoleEntry.ConsolePromptBackgroundTemplate"
    InputBox="Default__ConsoleEntry.InputBoxTemplate"
    LowerConsoleBorder="Default__ConsoleEntry.LowerConsoleBorderTemplate"
    UpperConsoleBorder="Default__ConsoleEntry.UpperConsoleBorderTemplate"
    WidgetTag="ConsoleEntry"
    PrimaryStyle=(DefaultStyleTag="ConsoleStyle")
    bSupportsPrimaryStyle=False
    Children(0)="Default__ConsoleEntry.InputBoxTemplate"
    Children(1)="Default__ConsoleEntry.ConsolePromptBackgroundTemplate"
    Children(2)="Default__ConsoleEntry.ConsolePromptTemplate"
    Children(3)="Default__ConsoleEntry.LowerConsoleBorderTemplate"
    Children(4)="Default__ConsoleEntry.UpperConsoleBorderTemplate"
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    EventProvider="Default__ConsoleEntry.WidgetEventComponent"
}
