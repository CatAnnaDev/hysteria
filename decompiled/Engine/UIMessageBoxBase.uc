class UIMessageBoxBase extends UIScene
    abstract
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var transient UILabel lblTitle;
var transient UILabel lblMessage;
var transient UILabel lblQuestion;
var transient UIImage imgQuestion;
var transient UICalloutButtonPanel btnbarChoices;
var() name TitleWidgetName;
var() name MessageWidgetName;
var() name QuestionWidgetName;
var() name ChoicesWidgetName;
var() name QuestionWidgetImageName;
var() name ButtonBarButtonBGStyleName;
var() name ButtonBarButtonTextStyleName;
var() bool bPerformAutomaticLayout;
var delegate<OnOptionSelected> __OnOptionSelected__Delegate;

function HandleSceneActivated(UIScene ActivatedScene, bool bInitialActivation)
{
    if (bInitialActivation)
    {
        lblTitle = UILabel(FindChild(TitleWidgetName, true));
        lblMessage = UILabel(FindChild(MessageWidgetName, true));
        lblQuestion = UILabel(FindChild(QuestionWidgetName, true));
        imgQuestion = UIImage(FindChild(QuestionWidgetImageName, true));
        btnbarChoices = UICalloutButtonPanel(FindChild(ChoicesWidgetName, true));
        LayoutControls();
    }
}

function bool OptionChosen(UIScreenObject EventObject, int PlayerIndex)
{
    local UICalloutButton SelectedButton;
    local GameUISceneClient GameSceneClient;
    
    SelectedButton = UICalloutButton(EventObject);
    if (SelectedButton != none && SelectedButton.InputAliasTag != 'None')
    {
        GameSceneClient = GetSceneClient();
        PlayUISound('Clicked');
        if (OnOptionSelected(self, SelectedButton.InputAliasTag, PlayerIndex))
        {
            __OnOptionSelected__Delegate = None;
            if (GameSceneClient != none && GameSceneClient.FindSceneIndex(self) != -1)
            {
                CloseScene();
            }
        }
    }
    return true;
}

function SetupDockingRelationships()
{
}

function LayoutControls()
{
    if (bPerformAutomaticLayout)
    {
        SetupDockingRelationships();
        lblTitle.StringRenderComponent.EnableAutoSizing(1, true);
        lblMessage.StringRenderComponent.EnableAutoSizing(1, true);
        lblTitle.StringRenderComponent.SetAlignment(0, 1);
        lblTitle.StringRenderComponent.SetAlignment(1, 0);
        lblMessage.StringRenderComponent.SetAlignment(0, 1);
        lblMessage.StringRenderComponent.SetAlignment(1, 0);
        lblTitle.StringRenderComponent.SetWrapMode(3);
        lblMessage.StringRenderComponent.SetWrapMode(3);
    }
}

function UICalloutButtonPanel GetButtonBar()
{
    return btnbarChoices;
}

function UILabel GetMessageLabel()
{
    return lblMessage;
}

function UILabel GetTitleLabel()
{
    return lblTitle;
}

function int FindButtonIndex(name ButtonAlias)
{
    if (btnbarChoices != none)
    {
        return btnbarChoices.FindButtonIndex(ButtonAlias);
    }
    return -1;
}

function bool HasButton(name ButtonAlias)
{
    return FindButtonIndex(ButtonAlias) != -1;
}

function bool RemoveButton(name ButtonAlias)
{
    local bool bResult;
    
    if (btnbarChoices != none)
    {
        bResult = btnbarChoices.RemoveButtonByAlias(ButtonAlias);
    }
    return bResult;
}

function bool AddButton(name ButtonAlias)
{
    local bool bResult;
    local UICalloutButton AddedButton;
    
    if (!HasButton(ButtonAlias) && btnbarChoices != none)
    {
        AddedButton = btnbarChoices.CreateCalloutButton(ButtonAlias, name("btn" $ string(ButtonAlias)));
        if (AddedButton != none)
        {
            SetButtonCallback(AddedButton);
            bResult = true;
        }
    }
    return bResult;
}

protected function SetButtonCallback(UICalloutButton TargetButton)
{
    TargetButton.SetWidgetStyleByName(TargetButton.BackgroundImageComponent.StyleResolverTag, ButtonBarButtonBGStyleName);
    TargetButton.SetWidgetStyleByName(TargetButton.StringRenderComponent.StyleResolverTag, ButtonBarButtonTextStyleName);
    btnbarChoices.SetButtonCallback(TargetButton.InputAliasTag, OptionChosen);
}

function SetQuestion(string NewMessageString)
{
    if (lblMessage != none)
    {
        if (NewMessageString == "")
        {
            lblQuestion.SetVisibility(false);
            imgQuestion.SetVisibility(false);
        }
        else
        {
            lblQuestion.SetVisibility(true);
            imgQuestion.SetVisibility(true);
            lblQuestion.SetDataStoreBinding(NewMessageString);
        }
    }
}

function SetMessage(string NewMessageString)
{
    if (lblMessage != none)
    {
        lblMessage.SetDataStoreBinding(NewMessageString);
    }
}

function SetTitle(string NewTitleString)
{
    if (lblTitle != none)
    {
        lblTitle.SetDataStoreBinding(NewTitleString);
    }
}

function SetupMessageBox(string Title, string Message, string Question, array<name> ButtonAliases, optional delegate<OnOptionSelected> SelectionCallback)
{
    local int ButtonIdx;
    
    SetTitle(Title);
    SetMessage(Message);
    SetQuestion(Question);
    if (btnbarChoices != none)
    {
        btnbarChoices.RemoveAllButtons();
        for (ButtonIdx = 0; ButtonIdx < ButtonAliases.Length; ButtonIdx++)
        {
            AddButton(ButtonAliases[ButtonIdx]);
        }
        if (SelectionCallback != none)
        {
            __OnOptionSelected__Delegate = SelectionCallback;
        }
    }
}

delegate bool OnOptionSelected(UIMessageBoxBase Sender, name SelectedInputAlias, int PlayerIndex)
{
    return true;
}

defaultproperties
{
    bRenderParentScenes=True
    bPauseGameWhileActive=False
    SceneRenderMode="SPLITRENDER_Fullscreen"
    __OnSceneActivated__Delegate="None"
    Position=(Value=0.25,Value[1]=0.25,Value[2]=0.75,Value[3]=0.75)
    EventProvider="Default__UIMessageBoxBase.SceneEventComponent"
}
