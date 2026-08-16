class KynapseLadderVolume extends LadderVolume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() Rotator KynapseWallDir;

simulated event PostBeginPlay()
{
    local Ladder L, M;
    local Vector Dir;
    
    PostBeginPlay();
    WallDir = KynapseWallDir;
    LookDir = vector(WallDir);
    if (!bAutoPath && LookDir.Z != float(0))
    {
        ClimbDir = vect(0.0, 0.0, 1.0);
        L = LadderList;
        while (L != none)
        {
            M = LadderList;
            while (M != none)
            {
                if (M != L)
                {
                    Dir = Normal(M.Location - L.Location);
                    if (Dir Dot ClimbDir < float(0))
                    {
                        Dir *= float(-1);
                    }
                    ClimbDir += Dir;
                }
                M = M.LadderList;
            }
            L = L.LadderList;
        }
        ClimbDir = Normal(ClimbDir);
        if (ClimbDir Dot vect(0.0, 0.0, 1.0) < float(0))
        {
            ClimbDir *= float(-1);
        }
    }
}

defaultproperties
{
    WallDirArrow="Default__KynapseLadderVolume.Arrow"
    BrushComponent="Default__KynapseLadderVolume.BrushComponent0"
    Components(0)="Default__KynapseLadderVolume.BrushComponent0"
    Components(1)="Default__KynapseLadderVolume.Arrow"
    CollisionComponent="Default__KynapseLadderVolume.BrushComponent0"
}
