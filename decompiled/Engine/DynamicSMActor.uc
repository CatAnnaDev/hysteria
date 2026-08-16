class DynamicSMActor extends Actor
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() const export editconst editinline StaticMeshComponent StaticMeshComponent;
var() const export editconst editinline DynamicLightEnvironmentComponent LightEnvironment;
var transient repnotify StaticMesh ReplicatedMesh;
var repnotify MaterialInterface ReplicatedMaterial;
var repnotify bool bForceStaticDecals;
var() bool bPawnCanBaseOn;
var() bool bSafeBaseIfAsleep;
var(BalanceScales) bool bEnableWeight;
var repnotify Vector ReplicatedMeshTranslation;
var repnotify Rotator ReplicatedMeshRotation;
var repnotify Vector ReplicatedMeshScale3D;
var(BalanceScales) float Weight;

replication
{
    if (bNetDirty)
        ReplicatedMesh, ReplicatedMaterial, bForceStaticDecals, ReplicatedMeshTranslation, ReplicatedMeshRotation, ReplicatedMeshScale3D;
}

final simulated function SetLightEnvironmentToNotBeDynamic()
{
    if (LightEnvironment != none)
    {
        LightEnvironment.bDynamic = false;
    }
}

event Detach(Actor Other)
{
    local int Idx;
    local Pawn P, Test;
    local bool bResetPhysics;
    
    Detach(Other);
    P = Pawn(Other);
    if (P != none)
    {
        bResetPhysics = true;
        for (Idx = 0; Idx < Attached.Length; Idx++)
        {
            Test = Pawn(Attached[Idx]);
            if (Test != none && Test != P)
            {
                bResetPhysics = false;
                break;
            }
        }
        if (bResetPhysics)
        {
            SetPhysics(10);
        }
    }
}

event Attach(Actor Other)
{
    local Pawn P;
    
    Attach(Other);
    if (bSafeBaseIfAsleep)
    {
        P = Pawn(Other);
        if (P != none)
        {
            SetPhysics(0);
        }
    }
}

simulated function bool CanBasePawn(Pawn P)
{
    if (bPawnCanBaseOn || bSafeBaseIfAsleep && StaticMeshComponent != none && !StaticMeshComponent.RigidBodyIsAwake())
    {
        return true;
    }
    return false;
}

function SetStaticMesh(StaticMesh NewMesh, optional Vector NewTranslation, optional Rotator NewRotation, optional Vector NewScale3D)
{
    StaticMeshComponent.SetStaticMesh(NewMesh);
    StaticMeshComponent.SetTranslation(NewTranslation);
    StaticMeshComponent.SetRotation(NewRotation);
    if (!IsZero(NewScale3D))
    {
        StaticMeshComponent.SetScale3D(NewScale3D);
        ReplicatedMeshScale3D = NewScale3D;
    }
    ReplicatedMesh = NewMesh;
    ReplicatedMeshTranslation = NewTranslation;
    ReplicatedMeshRotation = NewRotation;
    ForceNetRelevant();
}

function OnSetMaterial(SeqAct_SetMaterial Action)
{
    StaticMeshComponent.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    if (Action.MaterialIndex == 0)
    {
        ReplicatedMaterial = Action.NewMaterial;
        ForceNetRelevant();
    }
}

function OnSetMesh(SeqAct_SetMesh Action)
{
    local bool bForce;
    
    if (Action.MeshType == 0)
    {
        bForce = Action.bIsAllowedToMove == StaticMeshComponent.bForceStaticDecals || Action.bAllowDecalsToReattach;
        if (Action.NewStaticMesh != none && Action.NewStaticMesh != StaticMeshComponent.StaticMesh || bForce)
        {
            LightEnvironment.bCastShadows = false;
            LightEnvironment.SetEnabled(true);
            bForceStaticDecals = !Action.bIsAllowedToMove;
            StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);
            StaticMeshComponent.bAllowDecalAutomaticReAttach = Action.bAllowDecalsToReattach;
            StaticMeshComponent.SetStaticMesh(Action.NewStaticMesh, Action.bAllowDecalsToReattach);
            StaticMeshComponent.bAllowDecalAutomaticReAttach = true;
            ReplicatedMesh = Action.NewStaticMesh;
            ForceNetRelevant();
        }
    }
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'ReplicatedMesh')
    {
        LightEnvironment.bCastShadows = false;
        LightEnvironment.SetEnabled(true);
        StaticMeshComponent.SetStaticMesh(ReplicatedMesh);
    }
    else if (VarName == 'ReplicatedMaterial')
    {
        StaticMeshComponent.SetMaterial(0, ReplicatedMaterial);
    }
    else if (VarName == 'ReplicatedMeshTranslation')
    {
        StaticMeshComponent.SetTranslation(ReplicatedMeshTranslation);
    }
    else if (VarName == 'ReplicatedMeshRotation')
    {
        StaticMeshComponent.SetRotation(ReplicatedMeshRotation);
    }
    else if (VarName == 'ReplicatedMeshScale3D')
    {
        StaticMeshComponent.SetScale3D(ReplicatedMeshScale3D);
    }
    else if (VarName == 'bForceStaticDecals')
    {
        StaticMeshComponent.SetForceStaticDecals(bForceStaticDecals);
    }
    else
    {
        ReplicatedEvent(VarName);
    }
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (StaticMeshComponent != none)
    {
        ReplicatedMesh = StaticMeshComponent.StaticMesh;
        bForceStaticDecals = StaticMeshComponent.bForceStaticDecals;
    }
    if (bEnableWeight)
    {
        SetCollision(true, true);
        bCollideWorld = true;
        SetCollisionType(2);
        SetPhysics(2);
    }
}

defaultproperties
{
    StaticMeshComponent="Default__DynamicSMActor.StaticMeshComponent0"
    LightEnvironment="Default__DynamicSMActor.MyLightEnvironment"
    bPawnCanBaseOn=True
    Weight=1.0
    bShadowParented=True
    bGameRelevant=True
    bEdShouldSnap=True
    bPathColliding=True
    Components(0)="Default__DynamicSMActor.MyLightEnvironment"
    Components(1)="Default__DynamicSMActor.StaticMeshComponent0"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__DynamicSMActor.StaticMeshComponent0"
}
