class UIComp_DrawStringEditbox extends UIComp_DrawString
    native
    notplaceable
    editinlinenew
    config(UI)
    within UIEditBox
    hidecategories(Object);

struct native transient UIStringSelectionRegion
{
    var int SelectionStartCharIndex;
    var int SelectionEndCharIndex;
};

var transient string UserText;
var(Appearance) UIStringCaretParameters StringCaret;
var transient UIStringSelectionRegion SelectionRegion;
var config LinearColor SelectionTextColor;
var config LinearColor SelectionBackgroundColor;
var const native transient Pointer CaretNode;
var const transient int FirstCharacterPosition;
var const transient bool bRecalculateFirstCharacter;
var const transient float CaretOffset;

native final function string GetSelectedText()
{
}

native final function bool GetSelectionRange(out int out_StartIndex, out int out_EndIndex)
{
    out_StartIndex;
    out_EndIndex;
}

native final function bool ClearSelection()
{
}

native final function bool SetSelectionEnd(int EndIndex)
{
    EndIndex;
}

native final function bool SetSelectionStart(int StartIndex)
{
    StartIndex;
}

native final function bool SetSelectionRange(int StartIndex, int EndIndex)
{
    StartIndex;
    EndIndex;
}

native final function int GetUserTextLength()
{
}

native final function bool SetUserText(string NewValue)
{
    NewValue;
}

defaultproperties
{
    StringCaret=(bDisplayCaret=False,CaretType="UIPEN_White",CaretWidth=1.0,CaretStyle="DefaultCaretStyle",CaretPosition=0,CaretMaterial="None")
    SelectionRegion=(SelectionStartCharIndex=-1,SelectionEndCharIndex=-1)
    SelectionTextColor=(R=1.0,G=1.0,B=1.0,A=1.0)
    SelectionBackgroundColor=(R=0.0,G=0.0,B=1.0,A=0.6)
    StringClass="UIEditboxString"
    TextStyleCustomization=(ClipMode="CLIP_Normal",ClipAlignment="UIALIGN_Right",bOverrideClipMode=True,bOverrideClipAlignment=True)
    StringStyle=(DefaultStyleTag="DefaultEditboxStyle")
}
