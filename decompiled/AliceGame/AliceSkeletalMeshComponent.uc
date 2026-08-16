class AliceSkeletalMeshComponent extends SkeletalMeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() const float FOV;
var bool bForceLoadTextures;
var float ClearStreamingTime;

native final function SetFOV(float NewFOV)
{
    NewFOV;
}

simulated event PreloadTextures(bool bForcePreload, float ClearTime)
{
    local int Idx;
    
    bForceLoadTextures = bForcePreload;
    ClearStreamingTime = ClearTime;
    for (Idx = 0; Idx < Materials.Length; Idx++)
    {
        if (Materials[Idx] != none)
        {
            Materials[Idx].SetForceMipLevelsToBeResident(true, bForcePreload, -1.0);
        }
    }
}

defaultproperties
{
    ReplacementPrimitive="None"
}
