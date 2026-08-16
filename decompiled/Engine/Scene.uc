class Scene extends Object
    native
    notplaceable;

const SDPG_NumBits = 3;

enum EDetailMode
{
    DM_Low,
    DM_Medium,
    DM_High,
};

enum ESceneDepthPriorityGroup
{
    SDPG_UnrealEdBackground,
    SDPG_World,
    SDPG_Foreground,
    SDPG_MenuUI,
    SDPG_UnrealEdForeground,
    SDPG_PostProcess,
};

defaultproperties
{
}
