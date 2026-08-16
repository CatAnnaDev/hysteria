class AliceSonarManager extends Object
    notplaceable
    within AlicePlayerController;

var bool bActive;
var bool bSonarOn;
var float fSonarBeginTime;
var float fSonarEndTime;
var float fSonarDuration;
var float fSonarRadius;
var array<Actor> DetectedActors;

function checkLeftActors()
{
}

function TriggerTurnOffEffect(Actor SMActor)
{
}

function TriggerTurnOnEffect(Actor sonarActor)
{
}

function PostUpdate(float DeltaTime)
{
    local int I;
    local float MODDLCRate;
    
    MODDLCRate = 1.0;
    if (AlicePawn(Outer.Pawn) != none)
    {
        if (AlicePawn(Outer.Pawn).SonarVisibleTimeInc_Percent > 0.0)
        {
            MODDLCRate = 1.0 + AlicePawn(Outer.Pawn).SonarVisibleTimeInc_Percent;
        }
    }
    if (Outer.WorldInfo.TimeSeconds - fSonarEndTime > float(8) * MODDLCRate)
    {
        return;
    }
    for (I = 0; I < DetectedActors.Length; I++)
    {
        Outer.TickSonarOffEffect(DetectedActors[I], fSonarEndTime, DeltaTime);
    }
}

function Update(float DeltaTime)
{
    local int I;
    
    if (!bActive)
    {
        return;
    }
    if (bSonarOn)
    {
        for (I = 0; I < DetectedActors.Length; I++)
        {
            if (false && VSize(Outer.Pawn.Location - DetectedActors[I].Location) > fSonarRadius)
            {
                TriggerTurnOffEffect(DetectedActors[I]);
                DetectedActors.RemoveItem(DetectedActors[I]);
                continue;
            }
            Outer.TickSonarOnEffect(DetectedActors[I], fSonarBeginTime, DeltaTime);
        }
    }
}

function TurnOffSonar()
{
    local int I;
    
    bSonarOn = false;
    fSonarEndTime = Outer.WorldInfo.TimeSeconds;
    if (AlicePawn(Outer.Pawn).SonarCameraAnim != none)
    {
        AlicePawn(Outer.Pawn).AliceForceStopCameraAnim(AlicePawn(Outer.Pawn).SonarCameraAnim);
    }
    for (I = 0; I < DetectedActors.Length; I++)
    {
        TriggerTurnOffEffect(DetectedActors[I]);
    }
}

function setSonarActive(Actor sonarActor, bool bIsActive)
{
    local DecalActor DecalActor;
    local InterpActor InterpActor;
    local SkeletalMeshActor SkeletalMeshActor;
    
    DecalActor = DecalActor(sonarActor);
    InterpActor = InterpActor(sonarActor);
    SkeletalMeshActor = SkeletalMeshActor(sonarActor);
    if (DecalActor != none)
    {
        DecalActor.bSonarActive = bIsActive;
    }
    else if (InterpActor != none)
    {
        InterpActor.bSonarActive = bIsActive;
    }
    else if (SkeletalMeshActor != none)
    {
        SkeletalMeshActor.bSonarActive = bIsActive;
    }
}

static function bool isSonarActor(Actor sonarActor, optional out int iIsActive)
{
    local DecalActor DecalActor;
    local InterpActor InterpActor;
    local SkeletalMeshActor SkeletalMeshActor;
    local JumpPadPhysics jumppadActor;
    local AliceGameKynapsePawn npc;
    
    DecalActor = DecalActor(sonarActor);
    InterpActor = InterpActor(sonarActor);
    SkeletalMeshActor = SkeletalMeshActor(sonarActor);
    jumppadActor = JumpPadPhysics(sonarActor);
    npc = AliceGameKynapsePawn(sonarActor);
    if (DecalActor != none && DecalActor.bSonarActor)
    {
        iIsActive = (DecalActor.bSonarActive ? 1 : 0);
        return true;
    }
    else if (InterpActor != none && InterpActor.bSonarActor)
    {
        iIsActive = (InterpActor.bSonarActive ? 1 : 0);
        return true;
    }
    else if (SkeletalMeshActor != none && SkeletalMeshActor.bSonarActor)
    {
        iIsActive = (SkeletalMeshActor.bSonarActive ? 1 : 0);
        return true;
    }
    else if (jumppadActor != none && jumppadActor.bSonarActor)
    {
        iIsActive = 1;
        return true;
    }
    else if (npc != none && npc.bSonarActor)
    {
        iIsActive = 1;
        return true;
    }
    iIsActive = 0;
    return false;
}

function TurnOnSonar()
{
    bSonarOn = true;
    fSonarBeginTime = Outer.WorldInfo.TimeSeconds;
    if (AlicePawn(Outer.Pawn).SonarCameraAnim != none)
    {
        AlicePawn(Outer.Pawn).AliceStopCameraAnim();
        AlicePawn(Outer.Pawn).AliceForcePlayCameraAnim(AlicePawn(Outer.Pawn).SonarCameraAnim, true);
    }
}

function SetActive(bool _bActive)
{
    bActive = _bActive;
    bActive ? TurnOnSonar() : TurnOffSonar();
}

function Init()
{
    SetActive(false);
    fSonarDuration = AlicePawn(Outer.Pawn).SonarDuration;
    fSonarRadius = AlicePawn(Outer.Pawn).SonarRadius;
}

defaultproperties
{
    fSonarDuration=9999999.0
    fSonarRadius=9999999.0
}
