class SeqAct_GiveInventory extends SequenceAction
    notplaceable
    hidecategories(Object);

var() array<class<Inventory>> InventoryList;
var() bool bClearExisting;
var() bool bForceReplace;

defaultproperties
{
    ObjName="Give Inventory"
    ObjCategory="Pawn"
}
