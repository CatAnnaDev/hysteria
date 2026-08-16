class PotentialClimbWatcher extends Info
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

simulated event Tick(float DeltaTime)
{
    local Rotator PawnRot;
    local LadderVolume L;
    local bool bFound;
    
    if (Owner == none || Owner.bDeleteMe || !Pawn(Owner).CanGrabLadder())
    {
        Destroy();
        return;
    }
    PawnRot = Owner.Rotation;
    PawnRot.Pitch = 0;
    foreach Owner.TouchingActors(class'LadderVolume', L)
    {
        if (L.Encompasses(Owner))
        {
            if (vector(PawnRot) Dot L.LookDir > 0.9)
            {
                Pawn(Owner).ClimbLadder(L);
                Destroy();
                return;
                continue;
            }
            bFound = true;
        }
    }
    if (!bFound)
    {
        Destroy();
    }
}

defaultproperties
{
    Components(0)="Default__PotentialClimbWatcher.Sprite"
}
