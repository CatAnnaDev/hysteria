class Input extends Interaction
    native
    notplaceable
    transient
    config(Input)
    hidecategories(Object,UIRoot);

struct native KeyBind
{
    var config name Name;
    var config string Command;
    var config bool Control;
    var config bool Shift;
    var config bool Alt;
    var config bool bIgnoreCtrl;
    var config bool bIgnoreShift;
    var config bool bIgnoreAlt;
};

var config array<KeyBind> Bindings;
var const array<name> PressedKeys;
var const EInputEvent CurrentEvent;
var const float CurrentDelta;
var const float CurrentDeltaTime;
var const native map<int, int> NameToPtr;
var const native array<Pointer> AxisArray;
var native array<byte> ButtonArray;

event int GetKeyFromBind(string Command, out name KeyName, optional int nStartID = -1)
{
    local int BindIndex, LastIndex;
    
    LastIndex = (nStartID < 0 ? Bindings.Length - 1 : nStartID);
    for (BindIndex = LastIndex; BindIndex >= 0; BindIndex--)
    {
        if (InStr(Bindings[BindIndex].Command, Command) != -1)
        {
            KeyName = Bindings[BindIndex].Name;
            return BindIndex;
        }
    }
    KeyName = 'None';
    return -1;
}

event RebindCommand(name BindName, string Command, out array<name> IgnoreBindNames, optional bool bOverwriteCommand = false)
{
    local KeyBind NewBind;
    local int BindIndex, Index;
    local bool bNewBind, bIgnore;
    
    LogInternal("AliceKeySettings : {{{ RebindCommand KeyName = " @ string(BindName) @ " for '" @ Command @ "'");
    if (Left(Command, 1) == "\"" && Right(Command, 1) == "\"")
    {
        Command = Mid(Command, 1, Len(Command) - 2);
    }
    bNewBind = true;
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            if (bOverwriteCommand)
            {
                Bindings[BindIndex].Command = Command;
                bNewBind = false;
                LogInternal("AliceKeySettings : Rebind(Overwrite) = '" @ string(BindName) @ "' for '" @ Command @ "' Now '" @ Bindings[BindIndex].Command @ "'");
            }
            else if (InStr(Bindings[BindIndex].Command, Command) == -1)
            {
                Bindings[BindIndex].Command @= "|";
                Bindings[BindIndex].Command @= Command;
                bNewBind = false;
                LogInternal("AliceKeySettings : Rebind = '" @ string(BindName) @ "' for '" @ Command @ "' Now '" @ Bindings[BindIndex].Command @ "'");
            }
            continue;
        }
        bIgnore = false;
        for (Index = 0; Index < IgnoreBindNames.Length; Index++)
        {
            if (Bindings[BindIndex].Name == IgnoreBindNames[Index])
            {
                bIgnore = true;
                break;
            }
        }
        if (InStr(string(Bindings[BindIndex].Name), "XboxTypeS") != -1 || InStr(string(Bindings[BindIndex].Name), "Gamepad") != -1 || InStr(string(Bindings[BindIndex].Name), "SIXAXIS") != -1 || bIgnore)
        {
            continue;
        }
        if (InStr(Bindings[BindIndex].Command, Command) != -1)
        {
            Bindings[BindIndex].Command -= Command;
            LogInternal("AliceKeySettings : Remove Bind = '" @ string(Bindings[BindIndex].Name) @ "' for '" @ Command @ "' Now '" @ Bindings[BindIndex].Command @ "'");
        }
    }
    if (bNewBind && BindName != 'None')
    {
        NewBind.Name = BindName;
        NewBind.Command = Command;
        Bindings[Bindings.Length] = NewBind;
        LogInternal("AliceKeySettings : NewBind = '" @ string(BindName) @ "' for '" @ Command @ "'");
    }
    LogInternal("AliceKeySettings : RebindCommand() }}}");
}

event RemoveBind(name BindName, string Command)
{
    local int BindIndex;
    
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            if (InStr(Bindings[BindIndex].Command, Command) != -1)
            {
                Bindings[BindIndex].Command -= Command;
                return;
            }
        }
    }
}

exec function SetBind(out const name BindName, string Command)
{
    local KeyBind NewBind;
    local int BindIndex;
    
    if (Left(Command, 1) == "\"" && Right(Command, 1) == "\"")
    {
        Command = Mid(Command, 1, Len(Command) - 2);
    }
    for (BindIndex = Bindings.Length - 1; BindIndex >= 0; BindIndex--)
    {
        if (Bindings[BindIndex].Name == BindName)
        {
            Bindings[BindIndex].Command = Command;
            SaveConfig();
            return;
        }
    }
    NewBind.Name = BindName;
    NewBind.Command = Command;
    Bindings[Bindings.Length] = NewBind;
    SaveConfig();
}

native function string GetBind(out const name Key)
{
    Key;
}

native function ResetInput()
{
}

native function EnableInputCommands(bool bEnabled)
{
    bEnabled;
}

defaultproperties
{
}
