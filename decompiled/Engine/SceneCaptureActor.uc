class SceneCaptureActor extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() const export editinline SceneCaptureComponent SceneCapture;

simulated function OnToggle(SeqAct_Toggle Action)
{
    local bool bEnable;
    
    if (SceneCapture == none)
    {
        return;
    }
    if (Action.InputLinks[0].bHasImpulse)
    {
        bEnable = true;
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        bEnable = false;
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        bEnable = !SceneCapture.bEnabled;
    }
    SceneCapture.SetEnabled(bEnable);
}

defaultproperties
{
    bNoDelete=True
    Components(0)="Default__SceneCaptureActor.Sprite"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
}
