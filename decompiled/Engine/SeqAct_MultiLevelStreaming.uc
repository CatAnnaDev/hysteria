class SeqAct_MultiLevelStreaming extends SeqAct_LevelStreamingBase
    native
    notplaceable
    hidecategories(Object);

struct native LevelStreamingNameCombo
{
    var const LevelStreaming Level;
    var() const name LevelName;
};

var() array<LevelStreamingNameCombo> Levels;
var() bool bUnloadAllOtherLevels;
var transient bool bStatusIsOk;

defaultproperties
{
    ObjName="Stream Levels"
}
