class Interface_NavMeshPathObstacle extends Interface
    abstract
    native
    notplaceable;

enum EEdgeHandlingStatus
{
    EHS_AddedBothDirs,
    EHS_Added0to1,
    EHS_Added1to0,
    EHS_AddedNone,
};

defaultproperties
{
}
