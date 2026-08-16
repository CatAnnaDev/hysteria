class UITabControl extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

enum EUITabAutosizeType
{
    TAST_Manual,
    TAST_Fill,
    TAST_Auto,
};

var() editconst editfixedsize editinline array<UITabPage> Pages;
var(ZDebug) transient editconst editinline UITabPage ActivePage;
var(ZDebug) transient editconst editinline UITabPage PendingPage;
var(Appearance) EUIWidgetFace TabDockFace;
var(Appearance) EUITabAutosizeType TabSizeMode;
var(Appearance) UIScreenValue_Extent TabButtonSize;
var(Appearance) UIScreenValue_Extent TabButtonPadding[2];
var UIStyleReference TabButtonBackgroundStyle;
var UIStyleReference TabButtonCaptionStyle;
var(Appearance) config bool bAllowPagePreviews;
var transient bool bUpdateLayout;
var(Sound) name ActivateTabCue;
var delegate<OnPageActivated> __OnPageActivated__Delegate;
var delegate<OnPageInserted> __OnPageInserted__Delegate;
var delegate<OnPageRemoved> __OnPageRemoved__Delegate;

function bool TabButtonClicked(UIScreenObject EventObject, int PlayerIndex)
{
    local UITabButton ClickedButton;
    local UITabPage PageToActivate;
    local bool bResult;
    
    ClickedButton = UITabButton(EventObject);
    if (ClickedButton != none)
    {
        PageToActivate = ClickedButton.GetTabPage();
        if (PageToActivate != none && Pages.Find(PageToActivate) != -1)
        {
            ActivatePage(PageToActivate, PlayerIndex, true);
            bResult = true;
        }
    }
    return bResult;
}

function bool ProcessInputKey(out const InputEventParameters EventParms)
{
    local bool bResult;
    local name PrevKey, NextKey;
    
    if (IsVisible() && bAllowPagePreviews && EventParms.EventType == 0 || EventParms.EventType == 2 && IsFocused(EventParms.PlayerIndex) && GetFocusedControl(false, EventParms.PlayerIndex) == none)
    {
        switch (TabDockFace)
        {
            case 1:
            case 3:
                PrevKey = 'Left';
                NextKey = 'Right';
                break;
            case 0:
            case 2:
                PrevKey = 'Up';
                NextKey = 'Down';
                break;
            default:
        }
        if (EventParms.InputKeyName == PrevKey)
        {
            ActivatePreviousPage(EventParms.PlayerIndex, false, true);
            bResult = true;
        }
        else if (EventParms.InputKeyName == NextKey)
        {
            ActivateNextPage(EventParms.PlayerIndex, false, true);
            bResult = true;
        }
    }
    return bResult;
}

function int FindPageIndexByPageRef(UITabPage SearchPage)
{
    local int PageIndex;
    
    PageIndex = -1;
    if (SearchPage != none)
    {
        for (PageIndex = Pages.Length - 1; PageIndex >= 0; PageIndex--)
        {
            if (Pages[PageIndex] == SearchPage)
            {
                break;
            }
        }
    }
    return PageIndex;
}

function int FindPageIndexByButton(UITabButton SearchButton)
{
    local int PageIndex;
    
    PageIndex = -1;
    if (SearchButton != none)
    {
        for (PageIndex = Pages.Length - 1; PageIndex >= 0; PageIndex--)
        {
            if (Pages[PageIndex] != none && Pages[PageIndex].GetTabButton() == SearchButton)
            {
                break;
            }
        }
    }
    return PageIndex;
}

function int FindPageIndexByCaption(string PageCaption, optional bool bMarkupString)
{
    local int PageIndex;
    local UITabButton btn;
    
    PageIndex = -1;
    if (Len(PageCaption) > 0)
    {
        for (PageIndex = Pages.Length - 1; PageIndex >= 0; PageIndex--)
        {
            if (Pages[PageIndex] != none)
            {
                btn = Pages[PageIndex].GetTabButton();
                if (btn != none)
                {
                    if (bMarkupString)
                    {
                        if (btn.GetDataStoreBinding() ~= PageCaption)
                        {
                            break;
                        }
                        continue;
                    }
                    if (btn.GetCaption() ~= PageCaption)
                    {
                        break;
                    }
                }
            }
        }
    }
    return PageIndex;
}

function bool ActivateBestTab(int PlayerIndex, optional bool bFocusPage = true, optional int StartIndex = 0)
{
    local int PageIndex;
    local bool bResult;
    
    if (Pages.Length > 0)
    {
        if (StartIndex < 0 || StartIndex >= Pages.Length)
        {
            StartIndex = 0;
        }
        PageIndex = StartIndex;
        do
        {
            if (ActivatePage(Pages[PageIndex], PlayerIndex, bFocusPage))
            {
                bResult = true;
                break;
            }
            if (++PageIndex >= Pages.Length)
            {
                PageIndex = 0;
            }
        } until (PageIndex == StartIndex);
    }
    return bResult;
}

function bool ActivatePageByCaption(string PageCaption, int PlayerIndex, optional bool bFocusPage = true)
{
    local int PageIndex;
    local bool bResult;
    
    PageIndex = FindPageIndexByCaption(PageCaption);
    if (PageIndex != -1)
    {
        bResult = ActivatePage(Pages[PageIndex], PlayerIndex, bFocusPage);
    }
    return bResult;
}

event AddedChild(UIScreenObject WidgetOwner, UIObject NewChild)
{
    local UITabButton TabButton;
    
    AddedChild(WidgetOwner, NewChild);
    if (WidgetOwner == self)
    {
        TabButton = UITabButton(NewChild);
        if (TabButton != none)
        {
            TabButton.__OnClicked__Delegate = TabButtonClicked;
        }
    }
}

event PostInitialize()
{
    PostInitialize();
    ActivateBestTab(GetBestPlayerIndex());
}

event bool EnableTabPage(UITabPage PageToEnable, int PlayerIndex, optional bool bEnablePage = true, optional bool bActivatePage, optional bool bFocusPage = true)
{
    local bool bResult;
    local int PageIndex;
    
    if (PageToEnable != none)
    {
        if (bEnablePage)
        {
            if (PageToEnable.IsEnabled(PlayerIndex))
            {
                bResult = true;
                PageToEnable.GetTabButton().EnableWidget(PlayerIndex);
            }
            else if (PageToEnable.GetTabButton().EnableWidget(PlayerIndex))
            {
                bResult = PageToEnable.EnableWidget(PlayerIndex);
            }
            if (bResult && bActivatePage)
            {
                ActivatePage(PageToEnable, PlayerIndex, bFocusPage);
            }
        }
        else
        {
            PageToEnable.GetTabButton().DisableWidget(PlayerIndex);
            if (!PageToEnable.IsEnabled(PlayerIndex))
            {
                bResult = true;
            }
            else
            {
                PageIndex = FindPageIndexByPageRef(PageToEnable);
                if (PageToEnable == ActivePage)
                {
                    ActivePage = none;
                    PendingPage = none;
                    ActivateBestTab(PlayerIndex, PageToEnable.IsFocused(PlayerIndex), PageIndex);
                }
                bResult = PageToEnable.DisableWidget(PlayerIndex);
            }
        }
    }
    return bResult;
}

event bool ActivatePreviousPage(int PlayerIndex, optional bool bFocusPage = true, optional bool bAllowWrapping = true)
{
    local bool bResult;
    local int PageIndex, NumPages;
    local UITabPage PreviousPage;
    
    NumPages = GetPageCount();
    if (NumPages > 1)
    {
        PageIndex = FindPageIndexByPageRef(ActivePage);
        if (PageIndex > 0 && PageIndex < NumPages)
        {
            PageIndex--;
        }
        else if (ActivePage == none || bAllowWrapping)
        {
            PageIndex = NumPages - 1;
        }
        else
        {
            PageIndex = -1;
        }
        PreviousPage = GetPageAtIndex(PageIndex);
        bResult = ActivatePage(PreviousPage, PlayerIndex, bFocusPage);
    }
    return bResult;
}

event bool ActivateNextPage(int PlayerIndex, optional bool bFocusPage = true, optional bool bAllowWrapping = true)
{
    local bool bResult;
    local int PageIndex, NumPages;
    local UITabPage NextPage;
    
    NumPages = GetPageCount();
    if (NumPages > 1)
    {
        PageIndex = FindPageIndexByPageRef(ActivePage);
        if (PageIndex >= 0 && PageIndex < NumPages - 1)
        {
            PageIndex++;
        }
        else if (ActivePage == none || bAllowWrapping)
        {
            PageIndex = 0;
        }
        else
        {
            PageIndex = NumPages;
        }
        NextPage = GetPageAtIndex(PageIndex);
        bResult = ActivatePage(NextPage, PlayerIndex, bFocusPage);
    }
    return bResult;
}

event bool ActivatePage(UITabPage PageToActivate, int PlayerIndex, optional bool bFocusPage = true)
{
    local bool bResult;
    
    if (PageToActivate != none && PendingPage == none && PageToActivate.CanActivatePage(PlayerIndex))
    {
        if (PageToActivate != ActivePage)
        {
            PendingPage = PageToActivate;
            if (PendingPage.ActivatePage(PlayerIndex, true, bFocusPage))
            {
                PrivateActivatePage(PageToActivate, PlayerIndex);
                PlayUISound(ActivateTabCue);
                bResult = true;
            }
            else
            {
                PendingPage = none;
            }
        }
        else
        {
            bResult = ActivePage.ActivatePage(PlayerIndex, true, bFocusPage);
        }
    }
    return bResult;
}

event bool ReplacePage(UITabPage ExistingPage, UITabPage NewPage, int PlayerIndex, optional bool bFocusPage = true)
{
    local bool bResult;
    local int PageIndex;
    
    if (ExistingPage != none && NewPage != none)
    {
        PageIndex = FindPageIndexByPageRef(ExistingPage);
        if (PageIndex != -1)
        {
            if (InsertPage(NewPage, PlayerIndex, PageIndex, bFocusPage))
            {
                if (RemovePage(ExistingPage, PlayerIndex))
                {
                    bResult = true;
                    RequestLayoutUpdate();
                }
                else
                {
                    RemovePage(NewPage, PlayerIndex);
                }
            }
        }
    }
    return bResult;
}

event bool RemovePage(UITabPage PageToRemove, int PlayerIndex)
{
    local bool bResult;
    local int PageIndex;
    
    if (PageToRemove != none)
    {
        PageIndex = FindPageIndexByPageRef(PageToRemove);
        if (PageIndex >= 0 && PageIndex < Pages.Length)
        {
            Pages.Remove(PageIndex, 1);
            if (PageToRemove.GetTabButton() != none)
            {
                RemoveChild(PageToRemove.GetTabButton());
            }
            OnPageRemoved(self, PageToRemove, PlayerIndex);
            if (PageToRemove == ActivePage)
            {
                ActivePage = none;
                ActivateBestTab(PlayerIndex, true, PageIndex);
            }
            RequestLayoutUpdate();
            bResult = true;
        }
    }
    return bResult;
}

event bool InsertPage(UITabPage PageToInsert, int PlayerIndex, optional int InsertIndex = -1, optional bool bActivateImmediately = true)
{
    local bool bResult;
    local UITabButton NewTab;
    local int ChildInsertIndex;
    
    if (PageToInsert != none && Pages.Find(PageToInsert) == -1)
    {
        bActivateImmediately = bActivateImmediately || Pages.Length == 1 && IsVisible();
        NewTab = PageToInsert.GetTabButton(self);
        if (NewTab != none)
        {
            if (InsertIndex < 0 || InsertIndex >= Pages.Length)
            {
                InsertIndex = Pages.Length;
            }
            if (InsertIndex > 0)
            {
                assert(Pages[InsertIndex - 1] != none);
                assert(Pages[InsertIndex - 1].GetTabButton() != none);
                ChildInsertIndex = Children.Find(Pages[InsertIndex - 1].GetTabButton());
                assert(ChildInsertIndex != -1);
                ChildInsertIndex++;
            }
            else
            {
                ChildInsertIndex = InsertIndex;
            }
            PageToInsert.LinkToTabButton(NewTab, self);
            if (InsertChild(NewTab, ChildInsertIndex, false) != -1)
            {
                Pages.Insert(InsertIndex, 1);
                Pages[InsertIndex] = PageToInsert;
                NewTab.TabIndex = ChildInsertIndex;
                PageToInsert.AddedToTabControl(self);
                OnPageInserted(self, PageToInsert, PlayerIndex);
                if (!bActivateImmediately || !ActivatePage(PageToInsert, PlayerIndex, true))
                {
                    PageToInsert.SetVisibility(false);
                }
                RequestLayoutUpdate();
                bResult = true;
            }
        }
    }
    return bResult;
}

protected event PrivateActivatePage(UITabPage PageToActivate, int PlayerIndex)
{
    if (ActivePage != none && PageToActivate != ActivePage)
    {
        ActivePage.ActivatePage(PlayerIndex, false);
    }
    PendingPage = none;
    ActivePage = PageToActivate;
    OnPageActivated(self, ActivePage, PlayerIndex);
}

native function UITabPage CreateTabPage(class<UITabPage> TabPageClass, optional UITabPage PagePrefab)
{
    TabPageClass;
    PagePrefab;
}

native final function UITabButton FindTargetedTab(int PlayerIndex)
{
    PlayerIndex;
}

native final function UITabPage GetPageAtIndex(int PageIndex)
{
    PageIndex;
}

native final function int GetPageCount()
{
}

native final function RequestLayoutUpdate()
{
}

delegate OnPageRemoved(UITabControl Sender, UITabPage OldPage, int PlayerIndex)
{
}

delegate OnPageInserted(UITabControl Sender, UITabPage NewPage, int PlayerIndex)
{
}

delegate OnPageActivated(UITabControl Sender, UITabPage NewlyActivePage, int PlayerIndex)
{
}

defaultproperties
{
    TabDockFace="UIFACE_Top"
    TabSizeMode="TAST_Auto"
    TabButtonSize=(Value=0.02,ScaleType="UIEXTENTEVAL_PercentOwner",Orientation="UIORIENT_Vertical")
    TabButtonPadding=(Value=0.02,ScaleType="UIEXTENTEVAL_PercentOwner",Orientation="UIORIENT_Horizontal")
    TabButtonPadding[1]=(Value=0.02,ScaleType="UIEXTENTEVAL_PercentOwner",Orientation="UIORIENT_Vertical")
    TabButtonBackgroundStyle=(DefaultStyleTag="TabButtonBackgroundStyle",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    TabButtonCaptionStyle=(DefaultStyleTag="DefaultTabButtonStringStyle",RequiredStyleClass="UIStyle_Combo",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    bAllowPagePreviews=True
    bUpdateLayout=True
    bSupportsPrimaryStyle=False
    DefaultStates(0)="UIState_Enabled"
    DefaultStates(1)="UIState_Disabled"
    DefaultStates(2)="UIState_Focused"
    DefaultStates(3)="UIState_Pressed"
    DefaultStates(4)="UIState_Active"
    EventProvider="Default__UITabControl.WidgetEventComponent"
    __OnRawInputKey__Delegate="None"
}
