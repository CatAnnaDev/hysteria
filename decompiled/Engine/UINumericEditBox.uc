class UINumericEditBox extends UIEditBox
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var UIStyleReference IncrementStyle;
var UIStyleReference DecrementStyle;
var UINumericEditBoxButton IncrementButton;
var UINumericEditBoxButton DecrementButton;
var(Data) UIRangeData NumericValue;
var(Data) int DecimalPlaces;
var(Appearance) UIScreenValue_Bounds IncButton_Position;
var(Appearance) UIScreenValue_Bounds DecButton_Position;

native final function float GetNumericValue()
{
}

native final function bool SetNumericValue(float NewValue, optional bool bForceRefreshString = false)
{
    NewValue;
    bForceRefreshString;
}

event PostInitialize()
{
    PostInitialize();
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}

event Initialized()
{
    local int ModifierFlags;
    
    Initialized();
    IncrementButton.__OnPressed__Delegate = IncrementValue;
    IncrementButton.__OnPressRepeat__Delegate = IncrementValue;
    DecrementButton.__OnPressed__Delegate = DecrementValue;
    DecrementButton.__OnPressRepeat__Delegate = DecrementValue;
    ModifierFlags = 4 | 8 | 2 | 1 | 32;
    if (!IncrementButton.IsPrivateBehaviorSet(ModifierFlags))
    {
        IncrementButton.SetPrivateBehavior(ModifierFlags, true);
    }
    if (!DecrementButton.IsPrivateBehaviorSet(ModifierFlags))
    {
        DecrementButton.SetPrivateBehavior(ModifierFlags, true);
    }
}

native final function DecrementValue(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

native final function IncrementValue(UIScreenObject Sender, int PlayerIndex)
{
    Sender;
    PlayerIndex;
}

defaultproperties
{
    IncrementStyle=(DefaultStyleTag="ButtonBackground",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    DecrementStyle=(DefaultStyleTag="ButtonBackground",RequiredStyleClass="UIStyle_Image",AssignedStyleID=(A=0,B=0,C=0,D=0),ResolvedStyle="None")
    NumericValue=(CurrentValue=0.0,MinValue=0.0,MaxValue=100.0,NudgeValue=1.0,bIntRange=False)
    DecimalPlaces=4
    IncButton_Position=(Value=0.0,Value[1]=0.0,Value[2]=1.0,Value[3]=1.0,ScaleType="EVALPOS_PercentageOwner",ScaleType[1]="EVALPOS_PercentageOwner",ScaleType[2]="EVALPOS_PercentageOwner",ScaleType[3]="EVALPOS_PercentageOwner",bInvalidated=1,bInvalidated[1]=1,bInvalidated[2]=1,bInvalidated[3]=1,AspectRatioMode="UIASPECTRATIO_AdjustNone")
    DecButton_Position=(Value=0.0,Value[1]=0.0,Value[2]=1.0,Value[3]=1.0,ScaleType="EVALPOS_PercentageOwner",ScaleType[1]="EVALPOS_PercentageOwner",ScaleType[2]="EVALPOS_PercentageOwner",ScaleType[3]="EVALPOS_PercentageOwner",bInvalidated=1,bInvalidated[1]=1,bInvalidated[2]=1,bInvalidated[3]=1,AspectRatioMode="UIASPECTRATIO_AdjustNone")
    DataSource=(RequiredFieldType="DATATYPE_RangeProperty",MarkupString="Numeric Editbox Text")
    StringRenderComponent="Default__UINumericEditBox.EditboxStringRenderer"
    BackgroundImageComponent="Default__UINumericEditBox.EditboxBackgroundTemplate"
    CharacterSet="CHARSET_NumericOnly"
    PrivateFlags=1024
    EventProvider="Default__UINumericEditBox.WidgetEventComponent"
}
