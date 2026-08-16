class LensFlareSource extends Actor
    native
    placeable
    hidecategories(Navigation);

var() const export editconst editinline LensFlareComponent LensFlareComp;
var repnotify bool bCurrentlyActive;

replication
{
    if (bNoDelete)
        bCurrentlyActive;
}

simulated function SetActorParameter(name ParameterName, Actor Param)
{
}

simulated function SetExtColorParameter(name ParameterName, float Red, float Green, float Blue, float Alpha)
{
}

simulated function SetColorParameter(name ParameterName, LinearColor Param)
{
}

simulated function SetVectorParameter(name ParameterName, Vector Param)
{
}

simulated function SetFloatParameter(name ParameterName, float Param)
{
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        LensFlareComp.SetIsActive(true);
        bCurrentlyActive = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        LensFlareComp.SetIsActive(false);
        bCurrentlyActive = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (bCurrentlyActive == false)
        {
            LensFlareComp.SetIsActive(true);
            bCurrentlyActive = true;
        }
        else
        {
            LensFlareComp.SetIsActive(false);
            bCurrentlyActive = false;
        }
    }
    LensFlareComp.LastRenderTime = WorldInfo.TimeSeconds;
    ForceNetRelevant();
}

native final function SetTemplate(LensFlare NewTemplate)
{
    NewTemplate;
}

defaultproperties
{
    LensFlareComp="Default__LensFlareSource.LensFlareComponent0"
    bNoDelete=True
    bHardAttach=True
    bGameRelevant=True
    bEdShouldSnap=True
    Components(0)="Default__LensFlareSource.Sprite"
    Components(1)="Default__LensFlareSource.DrawInnerCone0"
    Components(2)="Default__LensFlareSource.DrawOuterCone0"
    Components(3)="Default__LensFlareSource.DrawRadius0"
    Components(4)="Default__LensFlareSource.LensFlareComponent0"
    Components(5)="Default__LensFlareSource.ArrowComponent0"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_DuringAsyncWork"
}
