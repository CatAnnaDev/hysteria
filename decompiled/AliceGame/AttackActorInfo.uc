class AttackActorInfo extends Object
    native
    notplaceable;

struct native AttackActorItem
{
    var Actor AttackActor;
    var int LeftTriggerCount;
    var float LeftRetriggerTime;
    var bool bShieldDamage;
};

var array<AttackActorItem> AttackActorList;
var array<AttackActorItem> AttackPawnList;

native function Reset()
{
}

native function RegistActorAttack(Actor DesiredActor, bool bShieldDamage, optional int MaxTriggerCount = 1, optional float RetriggerTime = 0.1)
{
    DesiredActor;
    bShieldDamage;
    MaxTriggerCount;
    RetriggerTime;
}

native function bool CanActorAttackBeRegistToOther(Actor DesiredActor)
{
    DesiredActor;
}

native function bool CanActorAttackBeRegistIn(Actor DesiredActor)
{
    DesiredActor;
}

defaultproperties
{
}
