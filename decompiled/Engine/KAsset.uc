class KAsset extends Actor
    native
    nativereplication
    placeable
    hidecategories(Navigation);

var() const export editconst editinline SkeletalMeshComponent SkeletalMeshComponent;
var() bool bDamageAppliesImpulse;
var() bool bWakeOnLevelStart;
var() bool bBlockPawns;
var transient repnotify SkeletalMesh ReplicatedMesh;
var transient repnotify PhysicsAsset ReplicatedPhysAsset;

replication
{
    if (Role == 3)
        ReplicatedMesh, ReplicatedPhysAsset;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    Attachment.SetBase(self, , SkeletalMeshComponent, Action.BoneName);
}

simulated function OnTeleport(SeqAct_Teleport inAction)
{
    local Actor destActor;
    
    destActor = Actor(SeqVar_Object(inAction.VariableLinks[1].LinkedVariables[0]).GetObjectValue());
    if (destActor != none)
    {
        SkeletalMeshComponent.SetRBPosition(destActor.Location);
    }
    else
    {
        inAction.ScriptLog("No Destination for" @ string(inAction) @ "on" @ string(self));
    }
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0)
{
    if (bDamageAppliesImpulse && DamageType.default.default.RadialDamageImpulse > float(0) && Role == 3)
    {
        CollisionComponent.AddRadialImpulse(HurtOrigin, DamageRadius, DamageType.default.default.RadialDamageImpulse, 1, DamageType.default.default.bRadialDamageVelChange);
    }
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector ApplyImpulse;
    
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (bDamageAppliesImpulse && DamageType.default.default.KDamageImpulse > float(0))
    {
        if (VSize(Momentum) < 0.001)
        {
            LogInternal("Zero momentum to KActor.TakeDamage");
            return;
        }
        CheckHitInfo(HitInfo, SkeletalMeshComponent, Normal(Momentum), HitLocation);
        ApplyImpulse = Normal(Momentum) * DamageType.default.default.KDamageImpulse;
        if (HitInfo.HitComponent != none)
        {
            HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
        }
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        SkeletalMeshComponent.SetSkeletalMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedPhysAsset')
    {
        SkeletalMeshComponent.SetPhysicsAsset(ReplicatedPhysAsset);
    }
}

final function SetMeshAndPhysAsset(SkeletalMesh NewMesh, PhysicsAsset NewPhysAsset)
{
    SkeletalMeshComponent.SetSkeletalMesh(NewMesh);
    ReplicatedMesh = NewMesh;
    SkeletalMeshComponent.SetPhysicsAsset(NewPhysAsset);
    ReplicatedPhysAsset = NewPhysAsset;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    if (bWakeOnLevelStart)
    {
        SkeletalMeshComponent.WakeRigidBody();
    }
    ReplicatedMesh = SkeletalMeshComponent.SkeletalMesh;
    ReplicatedPhysAsset = SkeletalMeshComponent.PhysicsAsset;
}

defaultproperties
{
    SkeletalMeshComponent="Default__KAsset.KAssetSkelMeshComponent"
    bDamageAppliesImpulse=True
    bNoDelete=True
    bAlwaysRelevant=True
    bUpdateSimulatedPosition=True
    bNetInitialRotation=True
    bCollideActors=True
    bBlockActors=True
    bProjTarget=True
    bEdShouldSnap=True
    Components(0)="Default__KAsset.MyLightEnvironment"
    Components(1)="Default__KAsset.KAssetSkelMeshComponent"
    Physics="PHYS_RigidBody"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    TickGroup="TG_PostAsyncWork"
    CollisionComponent="Default__KAsset.KAssetSkelMeshComponent"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_Destroyed"
    SupportedEvents(2)="SeqEvent_TakeDamage"
    SupportedEvents(3)="SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_ConstraintBroken"
    SupportedEvents(5)="SeqEvent_RigidBodyCollision"
}
