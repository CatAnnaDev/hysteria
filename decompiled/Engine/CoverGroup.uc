class CoverGroup extends Info
    native
    placeable
    hidecategories(Navigation,Movement,Collision);

enum ECoverGroupFillAction
{
    CGFA_Overwrite,
    CGFA_Add,
    CGFA_Remove,
    CGFA_Clear,
    CGFA_Cylinder,
};

var() array<ActorReference> CoverLinkRefs;
var() float AutoSelectRadius;
var() float AutoSelectHeight;

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        EnableGroup();
    }
    if (Action.InputLinks[1].bHasImpulse)
    {
        DisableGroup();
    }
    if (Action.InputLinks[2].bHasImpulse)
    {
        ToggleGroup();
    }
}

native function ToggleGroup()
{
}

native function DisableGroup()
{
}

native function EnableGroup()
{
}

defaultproperties
{
    bStatic=True
    Components(0)="Default__CoverGroup.Sprite"
    Components(1)="Default__CoverGroup.CoverGroupRenderer"
}
