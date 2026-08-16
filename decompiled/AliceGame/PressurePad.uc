class PressurePad extends InterpActor
    native
    placeable
    hidecategories(Navigation);

var() export editinline StaticMeshComponent MirrorPadFrame;
var() export editinline StaticMeshComponent MirrorPad;
var() const export editconst editinline CylinderComponent CylinderComponent;
var() SoundCue MoveDownSound;
var() SoundCue StopMoveSound;
var() SoundCue MoveUpSound;
var() float MoveTime;
var() float MoveDistance;
var float curTranslationZ;
var Emitter MoveParticleEmitter;
var() ParticleSystem MoveParticle;
var bool IsActived;
var bool IsTouched;
var bool IsActiveEventTrigged;
var() ClockBombContextActor ClockBombContextActor_Archetype;
var() Vector vOffsetToSpawnClockBombContextActor;
var transient ClockBombContextActor ClockBombTrigger;

event Tick(float DeltaTime)
{
    local Vector PadLoc;
    local StaticMeshComponent SMC, Pad;
    local int oldTrans;
    
    CheckActors();
    if (ClockBombTrigger == none && ClockBombContextActor_Archetype != none)
    {
        ClockBombTrigger = Spawn(class'ClockBombContextActor', self, , Location + vOffsetToSpawnClockBombContextActor, Rotation, ClockBombContextActor_Archetype, true);
    }
    if (IsActived)
    {
        if (curTranslationZ < MoveDistance)
        {
            foreach AllOwnedComponents(class'Engine.StaticMeshComponent', SMC)
            {
                if (SMC.StaticMesh.Name == 'MirrorPad')
                {
                    Pad = SMC;
                }
            }
            oldTrans = int(curTranslationZ);
            curTranslationZ += MoveDistance / MoveTime * DeltaTime;
            curTranslationZ = FClamp(curTranslationZ, 0.0, MoveDistance);
            if (float(oldTrans) < MoveDistance && curTranslationZ == MoveDistance)
            {
                PlaySound(StopMoveSound);
            }
            PadLoc.X = 0.0;
            PadLoc.Y = 0.0;
            PadLoc.Z = curTranslationZ * float(-1);
            Pad.SetTranslation(PadLoc);
            PlayFxEffect();
            if (curTranslationZ == MoveDistance && !IsActiveEventTrigged)
            {
                TriggerEventClass(class'SeqEvent_PadActivated', self);
                IsActiveEventTrigged = true;
            }
        }
    }
    else if (curTranslationZ > float(0))
    {
        foreach AllOwnedComponents(class'Engine.StaticMeshComponent', SMC)
        {
            if (SMC.StaticMesh.Name == 'MirrorPad')
            {
                Pad = SMC;
            }
        }
        curTranslationZ -= MoveDistance / MoveTime * DeltaTime;
        curTranslationZ = FClamp(curTranslationZ, 0.0, MoveDistance);
        PadLoc.X = 0.0;
        PadLoc.Y = 0.0;
        PadLoc.Z = curTranslationZ * float(-1);
        Pad.SetTranslation(PadLoc);
        PlayFxEffect();
        if (curTranslationZ == float(0) && IsActiveEventTrigged)
        {
            TriggerEventClass(class'SeqEvent_PadDeactivated', self);
            IsActiveEventTrigged = false;
        }
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    IsTouched = true;
}

function CheckActors()
{
    local int Count;
    local AlicePawn ap;
    local AliceClonePawn ACP;
    
    foreach BasedActors(class'AlicePawn', ap)
    {
        Count++;
    }
    foreach BasedActors(class'AliceClonePawn', ACP)
    {
        if (!ACP.IsInState('Dying'))
        {
            Count++;
        }
    }
    if (!IsActived && Count > 0 && IsTouched)
    {
        SetFrameCollision(false, false);
        IsActived = true;
        IsTouched = false;
        PlaySound(MoveDownSound);
    }
    else if (IsActived && Count == 0)
    {
        if (ClockBombTrigger != none)
        {
            if (ClockBombTrigger.Alice != none)
            {
                if (ClockBombTrigger.Alice.bIsDoingContextAction)
                {
                    return;
                }
            }
        }
        SetFrameCollision(true, true);
        IsActived = false;
        PlaySound(MoveUpSound);
    }
}

function PlayFxEffect()
{
    local Vector pos;
    
    MoveParticleEmitter = Spawn(class'Engine.EmitterSpawnable', self, , pos);
    if (MoveParticleEmitter != none && MoveParticle != none)
    {
        pos = Location;
        pos.Z -= curTranslationZ;
        MoveParticleEmitter.SetLocation(pos);
        MoveParticleEmitter.SetTemplate(MoveParticle, true);
    }
}

function SetFrameCollision(bool bCollideActor, bool bBlockRigidBody)
{
    local StaticMeshComponent SMC;
    
    foreach AllOwnedComponents(class'Engine.StaticMeshComponent', SMC)
    {
        if (SMC.StaticMesh.Name == 'MirrorPad_Frame')
        {
            SMC.SetActorCollision(bCollideActor, bBlockRigidBody);
        }
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

function bool ShouldSaveForCheckpoint()
{
    return false;
}

defaultproperties
{
    MirrorPadFrame="Default__PressurePad.StaticMeshComponent1"
    MirrorPad="Default__PressurePad.StaticMeshComponent0"
    CylinderComponent="Default__PressurePad.CollisionCylinder"
    MoveTime=1.0
    MoveDistance=12.0
    ClockBombContextActor_Archetype="LD_ContextActions.CTA_ClockBomb"
    StaticMeshComponent="Default__PressurePad.StaticMeshComponent0"
    LightEnvironment="Default__PressurePad.MyLightEnvironment"
    bCollideActors=True
    bCollideWorld=True
    bBlockActors=True
    Components(0)="Default__PressurePad.MyLightEnvironment"
    Components(1)="Default__PressurePad.StaticMeshComponent0"
    Components(2)="Default__PressurePad.CollisionCylinder"
    Components(3)="Default__PressurePad.StaticMeshComponent1"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__PressurePad.StaticMeshComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="Engine.SeqEvent_Mover"
    SupportedEvents(5)="SeqEvent_PadActivated"
    SupportedEvents(6)="SeqEvent_PadDeactivated"
}
