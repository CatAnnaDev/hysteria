class DoomBarrierActor extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

enum EDoomBarrierState
{
    EDB_Idle,
    EDB_Action,
    EDB_Death,
};

var() name UISocketName;
var() name CollisionSocketName;
var() name CameraSocketName;
var Vector UISockectLoc;
var Vector CollisionSocketLoc;
var Vector CameraSocketLoc;
var Rotator UISockectRot;
var Rotator CollisionSocketRot;
var Rotator CameraSocketRot;
var() float Health;
var bool bHaveUISocket;
var bool bHaveCollisionSocket;
var bool bHaveCameraSocket;
var() SoundCue ActionSound;
var() SoundCue DeathSound;
var float MorphWeight;
var float MorphSpeed;
var float DamageGap;

simulated event PostBeginPlay()
{
    bHaveUISocket = false;
    bHaveCollisionSocket = false;
    bHaveCameraSocket = false;
    if (UISocketName != 'None')
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation(UISocketName, UISockectLoc, UISockectRot);
        bHaveUISocket = true;
    }
    if (CollisionSocketName != 'None')
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation(CollisionSocketName, CollisionSocketLoc, CollisionSocketRot);
        bHaveCollisionSocket = true;
    }
    if (CameraSocketName != 'None')
    {
        SkeletalMeshComponent.GetSocketWorldLocationAndRotation(CameraSocketName, CameraSocketLoc, CameraSocketRot);
        bHaveCameraSocket = true;
    }
}

function bool IsAliveAndWell()
{
    return Health > float(0) ? true : false;
}

simulated function OnToggle(SeqAct_Toggle Action)
{
    if (Action.InputLinks[0].bHasImpulse)
    {
        GotoState('IdleState');
    }
    else if (Action.InputLinks[1].bHasImpulse)
    {
        GotoState('VulnerableState');
    }
    else if (Action.InputLinks[2].bHasImpulse)
    {
        if (IsInState('IdleState'))
        {
            GotoState('VulnerableState');
        }
        else
        {
            GotoState('IdleState');
        }
    }
}

event TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (IsInState('IdleState') || !DamageCauser.IsA('TeapotCannonProjectile') || DamageGap > 0.0)
    {
        return;
    }
    Health -= TeapotCannonProjectile(DamageCauser).DamageCoreValue;
    if (Health <= float(0))
    {
        AlicePlayerController(EventInstigator).DestroyedDoomBarriers++;
        LogInternal("Barriesr add to " @ string(AlicePlayerController(EventInstigator).DestroyedDoomBarriers));
        if (AlicePlayerController(EventInstigator).DestroyedDoomBarriers >= 10)
        {
            ConsoleCommand("trophy unlock=34");
        }
    }
    DamageGap = 1.0;
}

function SetAnimation(EDoomBarrierState Anim)
{
    local AnimNodeBlendList AnimNode;
    
    AnimNode = AnimNodeBlendList(SkeletalMeshComponent.FindAnimNode('BlendList'));
    if (AnimNode != none)
    {
        AnimNode.SetActiveChild(int(Anim), 0.1);
    }
}

state FinishedState
{
    event Tick(float DeltaTime)
    {
        if (MorphWeight > float(0))
        {
            MorphWeight -= MorphSpeed * DeltaTime / 0.0166;
            MorphWeight = FClamp(MorphWeight, 0.0, 1.0);
            SkeletalMeshComponent.SetMorphWeight('SK_DoomBarrier_Open', MorphWeight);
        }
    }
    
    event EndState(name NextStateName)
    {
        local AlicePlayerController APC;
        
        APC = AlicePlayerController(WorldInfo.GetLocalPlayerPawn().Controller);
        if (APC != none && APC.TargetingActor == self)
        {
            APC.TargetingActor = none;
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SetAnimation(2);
        if (DeathSound != none)
        {
            PlaySound(DeathSound);
        }
        LifeSpan = 3.0;
    }
    
    Stop;
}

state VulnerableState
{
    event Tick(float DeltaTime)
    {
        if (DamageGap > float(0))
        {
            DamageGap -= DeltaTime;
        }
        if (MorphWeight < 1.0)
        {
            MorphWeight += MorphSpeed * DeltaTime / 0.0166;
            MorphWeight = FClamp(MorphWeight, 0.0, 1.0);
            SkeletalMeshComponent.SetMorphWeight('SK_DoomBarrier_Open', MorphWeight);
        }
        if (Health <= float(0))
        {
            GotoState('FinishedState');
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SetAnimation(1);
        if (ActionSound != none)
        {
            PlaySound(ActionSound);
        }
    }
    
    Stop;
}

state IdleState
{
    event Tick(float DeltaTime)
    {
        if (MorphWeight > float(0))
        {
            MorphWeight -= MorphSpeed * DeltaTime / 0.0166;
            MorphWeight = FClamp(MorphWeight, 0.0, 1.0);
            SkeletalMeshComponent.SetMorphWeight('SK_DoomBarrier_Open', MorphWeight);
        }
    }
    
    event BeginState(name PreviousStateName)
    {
        SetAnimation(0);
    }
    
    Stop;
}

defaultproperties
{
    Health=100.0
    MorphSpeed=0.05
    SkeletalMeshComponent="Default__DoomBarrierActor.SkeletalMeshComponent0"
    LightEnvironment="Default__DoomBarrierActor.MyLightEnvironment"
    FacialAudioComp="Default__DoomBarrierActor.FaceAudioComponent"
    bNoDelete=False
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    Components(0)="Default__DoomBarrierActor.MyLightEnvironment"
    Components(1)="Default__DoomBarrierActor.SkeletalMeshComponent0"
    Components(2)="Default__DoomBarrierActor.FaceAudioComponent"
    InitialState="IdleState"
    CollisionComponent="Default__DoomBarrierActor.SkeletalMeshComponent0"
}
