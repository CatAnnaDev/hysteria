class ActorFactory extends Object
    abstract
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var class<Actor> GameplayActorClass;
var string MenuName;
var config int MenuPriority;
var deprecated int AlternateMenuPriority;
var class<Actor> NewActorClass;
var bool bPlaceable;

simulated event PostCreateActor(Actor NewActor)
{
}

defaultproperties
{
    MenuName="Add Actor"
    MenuPriority=10
    NewActorClass="Actor"
    bPlaceable=True
}
