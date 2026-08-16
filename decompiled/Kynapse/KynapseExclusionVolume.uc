class KynapseExclusionVolume extends BlockingVolume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Actor,Advanced,Attachment,Brush,Collision,Volume);

simulated function bool StopsProjectile(Projectile P)
{
    return false;
}

defaultproperties
{
    bBlockCamera=False
    bBlockNPCOnly=True
    BrushColor=(B=85,G=135,R=255,A=255)
    bColored=True
    BrushComponent="Default__KynapseExclusionVolume.BrushComponent0"
    Components(0)="Default__KynapseExclusionVolume.BrushComponent0"
    CollisionComponent="Default__KynapseExclusionVolume.BrushComponent0"
}
