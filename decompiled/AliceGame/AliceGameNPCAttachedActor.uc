class AliceGameNPCAttachedActor extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

enum ENPCAttachedActorState
{
    ENPCAAS_Idle,
    ENPCAAS_Damage,
    ENPCAAS_Die,
};

var ENPCAttachedActorState ActorState;
var transient EDamageStrengthType CurrentDmgStrength;
var float HitRangeDistance;
var transient int HP;
var transient int FullHP;
var float StopHitTime;
var float ReliefTime;
var float HitPerShot;
var AliceGameKynapsePawn HostActor;
var int ActorID;
var int LockOnSocketIndex;
var() PhysicsAsset CollisionPhysicsAsset;
var array<AliceGameAnimNode_BlendBase> AnimBlendNodes;
var() array<AnimationParaConfig> AnimationParaConfigs;
var() array<NPCTakeDamageAnimInfo> TakeDamageAnimArray;
var() array<NPCTakeDamageAnimInfo> DeathAnimArray;
var() bool bHideIndependent;
var bool bIsAwake;
var bool bHiddenBackup;

event TakeDamage(int DamageValue, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int percentprev, percentcur;
    
    percentprev = 100;
    percentcur = 100;
    if (FullHP > 0)
    {
        percentprev = 100 * HP / FullHP;
    }
    HP -= DamageValue;
    if (FullHP > 0)
    {
        percentcur = 100 * HP / FullHP;
    }
    if (HP > 0)
    {
        GotoState('Damage');
        if (HostActor != none && HostActor.Controller != none)
        {
            AliceGameKynapseAIController(HostActor.Controller).NotifyAttachedActorDamage(ActorID, percentprev, percentcur, DamageType);
        }
    }
    else
    {
        if (HostActor != none && HostActor.Controller != none)
        {
            AliceGameKynapseAIController(HostActor.Controller).NotifyAttachedActorDead(ActorID);
        }
        GotoState('Dying');
    }
}

simulated function CacheAnimNodes()
{
    local AliceGameAnimNode_BlendBase Node;
    local int I;
    
    for (I = 0; I < AnimBlendNodes.Length; I++)
    {
        AnimBlendNodes[I] = none;
    }
    foreach SkeletalMeshComponent.AllAnimNodes(class'AliceGameAnimNode_BlendBase', Node)
    {
        switch (Node.NodeName)
        {
            case 'Slot_FullBody_Main':
                AnimBlendNodes[0] = Node;
                continue;
            default:
                continue;
        }
    }
}

event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    if (ActorState == 2)
    {
        HostActor.WakeUpNPCAttachedActor(false, ActorID, -1);
        SetHidden(true);
    }
    if (ActorState != 0)
    {
        GotoState('Idle');
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    CacheAnimNodes();
    HP = -1;
}

native function bool CanTakeDamage()
{
}

native final function bool IsAwake()
{
}

native final function bool IsAlive()
{
}

native final function PlayConfigAnim(out const AnimationParaConfig AnimConfig, optional int configtype = -1)
{
    AnimConfig;
    configtype;
}

state Dying
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        local int AnimIndex;
        local AnimationParaConfig AnimConfig;
        
        ActorState = 2;
        if (CurrentDmgStrength >= 0 && int(CurrentDmgStrength) < DeathAnimArray.Length)
        {
            AnimIndex = DeathAnimArray[int(CurrentDmgStrength)].AnimIndex;
            if (AnimIndex >= 0 && AnimIndex < AnimationParaConfigs.Length)
            {
                AnimConfig = AnimationParaConfigs[AnimIndex];
                PlayConfigAnim(AnimConfig);
            }
        }
        HostActor.OnAttachedActorDie(self, ActorID);
    }
    
    Stop;
}

state Damage
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        local int AnimIndex;
        local AnimationParaConfig AnimConfig;
        
        ActorState = 1;
        if (CurrentDmgStrength >= 0 && int(CurrentDmgStrength) < TakeDamageAnimArray.Length)
        {
            AnimIndex = TakeDamageAnimArray[int(CurrentDmgStrength)].AnimIndex;
            if (AnimIndex >= 0 && AnimIndex < AnimationParaConfigs.Length)
            {
                AnimConfig = AnimationParaConfigs[AnimIndex];
                PlayConfigAnim(AnimConfig);
            }
        }
    }
    
    Stop;
}

state IdleState
{
    event EndState(name NextStateName)
    {
    }
    
    event BeginState(name PreviousStateName)
    {
        ActorState = 0;
    }
    
    Stop;
}

defaultproperties
{
    SkeletalMeshComponent="Default__AliceGameNPCAttachedActor.SkeletalMeshComponent0"
    LightEnvironment="Default__AliceGameNPCAttachedActor.MyLightEnvironment"
    FacialAudioComp="Default__AliceGameNPCAttachedActor.FaceAudioComponent"
    bNoDelete=False
    bCanBeDamaged=True
    Components(0)="Default__AliceGameNPCAttachedActor.MyLightEnvironment"
    Components(1)="Default__AliceGameNPCAttachedActor.SkeletalMeshComponent0"
    Components(2)="Default__AliceGameNPCAttachedActor.FaceAudioComponent"
    InitialState="IdleState"
    CollisionComponent="Default__AliceGameNPCAttachedActor.SkeletalMeshComponent0"
}
