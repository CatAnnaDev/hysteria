class VolumeTimer extends Info
    notplaceable
    hidecategories(Navigation,Movement,Collision);

var PhysicsVolume V;

event Timer()
{
    V.TimerPop(self);
}

event PostBeginPlay()
{
    PostBeginPlay();
    V = PhysicsVolume(Owner);
    SetTimer(V.PainInterval, true);
}

defaultproperties
{
    Components(0)="Default__VolumeTimer.Sprite"
}
