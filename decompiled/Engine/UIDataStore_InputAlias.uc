class UIDataStore_InputAlias extends UIDataStore_StringBase
    native
    notplaceable
    transient
    config(Input)
    hidecategories(Object,UIRoot);

struct native UIDataStoreInputAlias
{
    var config name AliasName;
    var config UIInputKeyData PlatformInputKeys[3];
};

struct native UIInputKeyData
{
    var config RawInputKeyEventData InputKeyData;
    var config string ButtonFontMarkupString;
};

var config array<UIDataStoreInputAlias> InputAliases;
var const native transient map<int, int> InputAliasLookupMap;

native final function bool HasAliasMappingForPlatform(name DesiredAlias, EInputPlatformType DesiredPlatform)
{
    DesiredAlias;
    DesiredPlatform;
}

native final function int FindInputAliasIndex(name DesiredAlias)
{
    DesiredAlias;
}

native final function bool GetAliasInputKeyDataByIndex(out RawInputKeyEventData out_InputKeyData, int AliasIndex, optional EInputPlatformType OverridePlatform = 3)
{
    out_InputKeyData;
    AliasIndex;
    OverridePlatform;
}

native final function bool GetAliasInputKeyData(out RawInputKeyEventData out_InputKeyData, name DesiredAlias, optional EInputPlatformType OverridePlatform = 3)
{
    out_InputKeyData;
    DesiredAlias;
    OverridePlatform;
}

native final function name GetAliasInputKeyNameByIndex(int AliasIndex, optional EInputPlatformType OverridePlatform = 3)
{
    AliasIndex;
    OverridePlatform;
}

native final function name GetAliasInputKeyName(name DesiredAlias, optional EInputPlatformType OverridePlatform = 3)
{
    DesiredAlias;
    OverridePlatform;
}

native final function string GetAliasFontMarkupByIndex(int AliasIndex, optional EInputPlatformType OverridePlatform = 3)
{
    AliasIndex;
    OverridePlatform;
}

native final function string GetAliasFontMarkup(name DesiredAlias, optional EInputPlatformType OverridePlatform = 3)
{
    DesiredAlias;
    OverridePlatform;
}

defaultproperties
{
    InputAliases(0)=(AliasName="Term_Controller",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString="GAMEPAD"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString="GAMEPAD_360"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString="GAMEPAD_PS3"))
    InputAliases(1)=(AliasName="Term_GamerCard",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString="X BUTTON"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(2)=(AliasName="CycleLeft",PlatformInputKeys=(InputKeyData=(InputKeyName="XboxTypeS_LeftShoulder",ModifierKeyFlags=56),ButtonFontMarkupString="LEFT SHOULDER"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(3)=(AliasName="CycleRight",PlatformInputKeys=(InputKeyData=(InputKeyName="XboxTypeS_RightShoulder",ModifierKeyFlags=56),ButtonFontMarkupString="RIGHT SHOULDER"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(4)=(AliasName="AnyKey",PlatformInputKeys=(InputKeyData=(InputKeyName="*",ModifierKeyFlags=56),ButtonFontMarkupString="ANY KEY"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(5)=(AliasName="Accept",PlatformInputKeys=(InputKeyData=(InputKeyName="Enter",ModifierKeyFlags=56),ButtonFontMarkupString="ACCEPT"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(6)=(AliasName="Cancel",PlatformInputKeys=(InputKeyData=(InputKeyName="Escape",ModifierKeyFlags=56),ButtonFontMarkupString="CANCEL"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(7)=(AliasName="Conditional1",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_X",ModifierKeyFlags=56),ButtonFontMarkupString="X BUTTON"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(8)=(AliasName="Conditional2",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_Y",ModifierKeyFlags=56),ButtonFontMarkupString="Y BUTTON"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(9)=(AliasName="Start",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_Start",ModifierKeyFlags=56),ButtonFontMarkupString="START"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(10)=(AliasName="back",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_Back",ModifierKeyFlags=56),ButtonFontMarkupString="BACK"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(11)=(AliasName="ShiftUp",PlatformInputKeys=(InputKeyData=(InputKeyName="Subtract",ModifierKeyFlags=56),ButtonFontMarkupString="SUBTRACT"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(12)=(AliasName="ShiftDown",PlatformInputKeys=(InputKeyData=(InputKeyName="Add",ModifierKeyFlags=56),ButtonFontMarkupString="ADD"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(13)=(AliasName="ShiftUpPage",PlatformInputKeys=(InputKeyData=(InputKeyName="PageUp",ModifierKeyFlags=56),ButtonFontMarkupString="PAGEUP"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(14)=(AliasName="ShiftDownPage",PlatformInputKeys=(InputKeyData=(InputKeyName="PageDown",ModifierKeyFlags=56),ButtonFontMarkupString="PAGEDOWN"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(15)=(AliasName="MouseLeft",PlatformInputKeys=(InputKeyData=(InputKeyName="LeftMouseButton",ModifierKeyFlags=56),ButtonFontMarkupString="LEFT MOUSE"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(16)=(AliasName="MouseRight",PlatformInputKeys=(InputKeyData=(InputKeyName="RightMouseButton",ModifierKeyFlags=56),ButtonFontMarkupString="RIGHT MOUSE"),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(17)=(AliasName="ClickLeft",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_LeftThumbstick",ModifierKeyFlags=56),ButtonFontMarkupString="CLICK LEFT STICK"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    InputAliases(18)=(AliasName="ClickRight",PlatformInputKeys=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""),PlatformInputKeys[1]=(InputKeyData=(InputKeyName="XboxTypeS_RightThumbstick",ModifierKeyFlags=56),ButtonFontMarkupString="CLICK RIGHT STICK"),PlatformInputKeys[2]=(InputKeyData=(InputKeyName="None",ModifierKeyFlags=56),ButtonFontMarkupString=""))
    Tag="ButtonCallouts"
}
