class AlicePickupInventory extends AliceInventory
    notplaceable
    hidecategories(Navigation);

static function float BotDesireability(Actor PickupHolder, Pawn P, Controller C)
{
    local AliceItemPickupFactory F;
    local AliceDroppedItemPickup D;
    
    F = AliceItemPickupFactory(PickupHolder);
    if (F != none)
    {
        return F.BotDesireability(P, C);
    }
    else
    {
        D = AliceDroppedItemPickup(PickupHolder);
        if (D != none)
        {
            return D.BotDesireability(P, C);
        }
        else
        {
            return 0.0;
        }
    }
}

defaultproperties
{
    Components(0)="Default__AlicePickupInventory.Sprite"
}
