class ScriptConsoleEntry extends UIPanel
    notplaceable
    config(UI)
    hidecategories(Object,UIRoot,Object);

const CONSOLE_PROMPT_TEXT = "(> ";

var UIEditBox InputBox;
var UIImage UpperConsoleBorder;
var UIImage LowerConsoleBorder;

function OnCreateChild(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
    CreatedWidget.__OnCreate__Delegate = None;
}

function SetValue(string NewValue)
{
    InputBox.SetValue("(> " $ NewValue);
}

event PostInitialize()
{
    PostInitialize();
    assert(InputBox.Outer == self);
    assert(UpperConsoleBorder.Outer == self);
    assert(LowerConsoleBorder.Outer == self);
    InsertChild(InputBox);
    InsertChild(UpperConsoleBorder);
    InsertChild(LowerConsoleBorder);
    InputBox.SetWidgetStyleByName('String Style', 'ConsoleStyle');
    InputBox.StringRenderComponent.bIgnoreMarkup = true;
    InputBox.StringRenderComponent.EnableAutoSizing(1);
    InputBox.StringRenderComponent.SetWrapMode(3);
    InputBox.StringRenderComponent.StringCaret.bDisplayCaret = true;
    LowerConsoleBorder.SetDockTarget(3, self, 3);
    LowerConsoleBorder.SetWidgetStyleByName('Image Style', 'ConsoleImageStyle');
    InputBox.SetDockTarget(0, self, 0);
    InputBox.SetDockParameters(3, LowerConsoleBorder, 3, -3.0);
    InputBox.SetDockTarget(2, self, 2);
    UpperConsoleBorder.SetDockParameters(3, InputBox, 1, -2.0);
    UpperConsoleBorder.SetWidgetStyleByName('Image Style', 'ConsoleImageStyle');
    SetDockTarget(0, GetParent(), 0);
    SetDockTarget(2, GetParent(), 2);
    SetDockTarget(3, GetParent(), 3);
    SetDockTarget(1, UpperConsoleBorder, 1);
}

defaultproperties
{
    InputBox="Default__ScriptConsoleEntry.ConsoleInputTemplate"
    UpperConsoleBorder="Default__ScriptConsoleEntry.UpperBorderTemplate"
    LowerConsoleBorder="Default__ScriptConsoleEntry.LowerBorderTemplate"
    BackgroundImageComponent="Default__ScriptConsoleEntry.PanelBackgroundTemplate"
    WidgetTag="ConsoleInputBox"
    PrimaryStyle=(DefaultStyleTag="ConsoleStyle",RequiredStyleClass="UIStyle_Combo")
    EventProvider="Default__ScriptConsoleEntry.WidgetEventComponent"
}
