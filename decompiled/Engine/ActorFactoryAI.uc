class ActorFactoryAI extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() class<AIController> ControllerClass;
var() class<Pawn> PawnClass;
var() string PawnName;
var() bool bGiveDefaultInventory;
var() array<class<Inventory>> InventoryList;
var() int TeamIndex;

defaultproperties
{
    ControllerClass="AIController"
    TeamIndex=255
    bPlaceable=False
}
