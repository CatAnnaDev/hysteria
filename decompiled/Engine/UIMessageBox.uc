class UIMessageBox extends UIMessageBoxBase
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

function SetupDockingRelationships()
{
    SetupDockingRelationships();
    lblTitle.SetDockTarget(0, self, 0);
    lblTitle.SetDockTarget(1, self, 1);
    lblTitle.SetDockTarget(2, self, 2);
    lblMessage.SetDockTarget(0, self, 0);
    lblMessage.SetDockTarget(1, lblTitle, 3);
    lblMessage.SetDockTarget(2, self, 2);
    btnbarChoices.SetDockTarget(0, self, 0);
    btnbarChoices.SetDockTarget(3, self, 3);
    btnbarChoices.SetDockTarget(2, self, 2);
}

defaultproperties
{
    lblTitle="Default__UIMessageBox.TitleLabelTemplate"
    lblMessage="Default__UIMessageBox.MessageLabelTemplate"
    btnbarChoices="Default__UIMessageBox.ButtonBarTemplate"
    Children(0)="Default__UIMessageBox.TitleLabelTemplate"
    Children(1)="Default__UIMessageBox.MessageLabelTemplate"
    Children(2)="Default__UIMessageBox.ButtonBarTemplate"
    EventProvider="Default__UIMessageBox.SceneEventComponent"
}
