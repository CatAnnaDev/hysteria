class CombatGlobalConfig extends Object
    native
    notplaceable
    hidecategories(Object);

struct native KnockBackParameters
{
    var() float KnockBackScale;
    var() float KnockBackTotalTime;
    var() Rotator KnockBackRefAngle;
};

var(Weapon) array<KnockBackParameters> KnockBackParas;

defaultproperties
{
    KnockBackParas(0)=(KnockBackScale=-80.0,KnockBackTotalTime=0.4,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(1)=(KnockBackScale=-150.0,KnockBackTotalTime=0.5,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(2)=(KnockBackScale=-350.0,KnockBackTotalTime=0.4,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(3)=(KnockBackScale=-200.0,KnockBackTotalTime=0.4,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(4)=(KnockBackScale=-150.0,KnockBackTotalTime=0.7,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(5)=(KnockBackScale=-100.0,KnockBackTotalTime=0.7,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(6)=(KnockBackScale=-100.0,KnockBackTotalTime=0.2,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(7)=(KnockBackScale=-100.0,KnockBackTotalTime=0.2,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(8)=(KnockBackScale=-150.0,KnockBackTotalTime=0.25,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
    KnockBackParas(9)=(KnockBackScale=-300.0,KnockBackTotalTime=0.3,KnockBackRefAngle=(Pitch=0,Yaw=0,Roll=0))
}
