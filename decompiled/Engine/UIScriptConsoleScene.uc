class UIScriptConsoleScene extends UIScene
    notplaceable
    transient
    config(UI)
    hidecategories(Object,UIRoot,Object);

var UILabel BufferText;
var UIImage BufferBackground;
var ScriptConsoleEntry CommandRegion;

function OnCreateChild(UIObject CreatedWidget, UIScreenObject CreatorContainer)
{
    CreatedWidget.__OnCreate__Delegate = None;
}

event PostInitialize()
{
    PostInitialize();
    InsertChild(BufferBackground);
    InsertChild(BufferText);
    InsertChild(CommandRegion);
    BufferBackground.SetDockTarget(0, self, 0);
    BufferBackground.SetDockTarget(1, self, 1);
    BufferBackground.SetDockTarget(2, self, 2);
    BufferBackground.SetDockTarget(3, CommandRegion, 1);
    BufferBackground.SetWidgetStyleByName('Image Style', 'ConsoleBufferImageStyle');
    BufferText.SetWidgetStyleByName('String Style', 'ConsoleBufferStyle');
    BufferText.SetDockTarget(3, CommandRegion, 1);
    BufferText.StringRenderComponent.EnableAutoSizing(1);
    BufferText.StringRenderComponent.SetWrapMode(3);
}

defaultproperties
{
    BufferText="Default__UIScriptConsoleScene.BufferTextTemplate"
    BufferBackground="Default__UIScriptConsoleScene.BufferBackgroundTemplate"
    CommandRegion="Default__UIScriptConsoleScene.CommandRegionTemplate"
    SceneTag="ConsoleScene"
    Position=(Value[3]=0.75,ScaleType[2]="EVALPOS_PercentageViewport",ScaleType[3]="EVALPOS_PercentageViewport")
    EventProvider="Default__UIScriptConsoleScene.SceneEventComponent"
}
