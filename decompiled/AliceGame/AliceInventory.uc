class AliceInventory extends Inventory
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var bool bDropOnDisrupt;

function DropFrom(Vector StartLocation, Vector StartVelocity)
{
    ClientLostItem();
    DropFrom(StartLocation, StartVelocity);
}

simulated event Destroyed()
{
    local Pawn P;
    
    P = Pawn(Owner);
    if (P != none && P.IsLocallyControlled() || P.DrivenVehicle != none && P.DrivenVehicle.IsLocallyControlled())
    {
        ClientLostItem();
    }
    Destroyed();
}

reliable client simulated function ClientLostItem()
{
    if (Role < 3)
    {
        SetOwner(none);
    }
}

defaultproperties
{
    bDropOnDisrupt=True
    Components(0)="Default__AliceInventory.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
