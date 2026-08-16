class AliceGameCrowdAgent extends GameCrowdAgentSkeletal
    native
    placeable
    hidecategories(Navigation,Advanced,Attachment,Collision,Object);

var(Rendering) array<name> AttackAnimNames;
var(Behavior) ParticleSystem AgentDeathParticle;
var(Behavior) SoundCue AgentDeathSoundCue;
var Emitter AgentDeathParticleEmitter;
var bool bDead;
var bool bAttacking;
var float DeathTime;
var float playback;
var AlicePlayerController APC;
var int AgentDamage;
var int SlowFactor;
var int hitCount;

event Tick(float DeltaTime)
{
    if (bDead)
    {
        DeathTime += DeltaTime;
        if (DeathTime >= playback)
        {
            if (AgentDeathSoundCue != none)
            {
                PlaySound(AgentDeathSoundCue);
            }
            AgentDeathParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location, Rotation);
            if (AgentDeathParticleEmitter != none && AgentDeathParticle != none)
            {
                AgentDeathParticleEmitter.SetLocation(Location);
                AgentDeathParticleEmitter.SetRotation(Rotation);
                AgentDeathParticleEmitter.SetTemplate(AgentDeathParticle, true);
            }
            bDead = false;
        }
    }
}

function TakeDamage(int DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (Health <= 0)
    {
        return;
    }
    TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    if (Health <= 0)
    {
        CurrentDestination.ReachedDestination(self);
        PlayDeathAnimation();
    }
}

function bool PickBehaviorFrom(array<BehaviorEntry> BehaviorList, optional Vector BestCameraLoc = vect(0.0, 0.0, 0.0))
{
    local GameCrowdAgentBehavior SurBehavior;
    local PlayerController PC;
    
    SurBehavior = BehaviorList[0].BehaviorArchetype;
    if (SurBehavior.IsA('GameCrowdBehavior_Surrounder'))
    {
        PC = GetALocalPlayerController();
        APC = AlicePlayerController(PC);
        if (APC != none)
        {
            if (APC.MyAlicePawn.bInGiantMode == false)
            {
                return false;
            }
        }
    }
    return PickBehaviorFrom(BehaviorList, BestCameraLoc);
}

simulated event PlayDeathAnimation()
{
    local int Index;
    local AnimNodeSequence deathAnimSeq;
    
    deathAnimSeq = FullBodySlot.GetCustomAnimNodeSeq();
    SkeletalMeshComponent.RootMotionMode = 0;
    deathAnimSeq.SetRootBoneAxisOption(2, 2, 2);
    Index = Rand(DeathAnimNames.Length);
    playback = FullBodySlot.PlayCustomAnim(DeathAnimNames[Index], 1.0, 0.1, -1.0, false, false);
    DeadBodyDuration = float(Max(int(0.1), int(DeadBodyDuration)));
    LifeSpan = DeadBodyDuration + playback;
    bDead = true;
    bAttacking = false;
    DeathTime = 0.0;
}

simulated event PlayRunAnimation()
{
    FullBodySlot.PlayCustomAnim(RunAnimNames[Rand(RunAnimNames.Length)], 1.0, 0.1, 0.1, true, false);
    bAttacking = false;
}

simulated event PlayAttackAnimation()
{
    local AnimNodeSequence AttackAnimSeq;
    
    bAttacking = true;
    playback = FullBodySlot.PlayCustomAnim(AttackAnimNames[Rand(AttackAnimNames.Length)], 1.0, 0.1, 0.1, true, false);
    AttackAnimSeq = FullBodySlot.GetCustomAnimNodeSeq();
    if (AttackAnimSeq.CurrentTime >= playback * 0.98 && APC.MyAlicePawn.Health > 0 && !APC.MyAlicePawn.IsInState('Dead'))
    {
        hitCount++;
        if (hitCount >= 2)
        {
            hitCount = 0;
            APC.MyAlicePawn.CurrentDmgStrength = 1;
            APC.AgentDamage = AgentDamage;
        }
    }
}

simulated function InitializeAgent(Actor SpawnLoc, GameCrowdAgent AgentTemplate, GameCrowdGroup NewGroup, float AgentWarmupTime, bool bWarmupPosition, bool bCheckWarmupVisibility)
{
    InitializeAgent(SpawnLoc, AgentTemplate, NewGroup, AgentWarmupTime, bWarmupPosition, bCheckWarmupVisibility);
    APC = AlicePlayerController(GetALocalPlayerController());
    APC.AgentDamage = AgentDamage;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    SpeedBlendNode.SetBlendTarget(0.0, 0.2);
}

defaultproperties
{
    SkeletalMeshComponent="Default__AliceGameCrowdAgent.SkeletalMeshComponent0"
    LightEnvironment="Default__AliceGameCrowdAgent.MyLightEnvironment"
    Components(0)="Default__AliceGameCrowdAgent.MyLightEnvironment"
    Components(1)="Default__AliceGameCrowdAgent.SkeletalMeshComponent0"
}
