class JumpPadMushroom extends JumpPad
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force,VehicleUsage);

enum EJumpState
{
    EJS_None,
    EJS_RaiseFromLand,
    EJS_FlyToJumpPad,
};

struct native JumpPadAnimation
{
    var() name Name;
    var() float Time;
    var() float Rate;
};

var EJumpState JumpState;
var AliceGamePawn P;
var(Light) const export editconst editinline LightEnvironmentComponent LightEnvironmentJumpPad;
var(Animation) export editinline SkeletalMeshComponent SkelMeshComp;
var(Animation) name SocketName;
var(Animation) JumpPadAnimation CompressAnimation;
var(Animation) JumpPadAnimation IdleCompressedAnimation;
var(Animation) JumpPadAnimation LaunchAnimation;
var(JumpPad) float AutomaticJumpTime;
var(JumpPad) bool bPressActionToLaunch;
var(JumpPad) bool bAutomaticToJumpPad;
var(JumpPad) bool bUseLoopCompressedAnim;
var bool bWaitingPressButton;
var(JumpPad) float Radius;
var Vector RaiseTargetLocation;
var AliceGameAnimNode_JumpPad JumpPadAnimNode;

function ShowRadius()
{
    DrawDebugCylinder(Location, Location, Radius, 100, 255, 255, 0, true);
}

function Launch()
{
    if (bPressActionToLaunch && bWaitingPressButton)
    {
        bWaitingPressButton = false;
        OnIdleCompressedAnimOverTimer();
    }
}

function OnPlayIdleAnimation()
{
    PlayAnim(IdleCompressedAnimation.Name, IdleCompressedAnimation.Rate, false);
}

function OnLaunchAnimOverTimer()
{
    JumpVelocity = CalculateJumpVelocity(P.Location, JumpTarget.Location);
    P.PendingVelocity.X = 1.0;
    P.PendingVelocity.Y = 1.0;
    P.PendingVelocity.Z = 1.0;
    P.SetPhysics(2);
    P.DoSpecialMove(49, true);
    SetCollisionType(1);
    P.Velocity = JumpVelocity;
    if (WorldInfo.WorldGravityZ != WorldInfo.DefaultGravityZ && P.GetGravityZ() == WorldInfo.WorldGravityZ)
    {
        P.Velocity *= Sqrt(P.GetGravityZ() / WorldInfo.DefaultGravityZ);
    }
    P.Acceleration = vect(0.0, 0.0, 0.0);
    if (JumpSound != none)
    {
        P.PlaySound(JumpSound);
    }
    if (SkelMeshComp != none)
    {
        SetTimer(1.0, false, 'OnPlayIdleAnimation');
    }
}

function OnIdleCompressedAnimOverTimer()
{
    local float animTime;
    
    if (!IsAnimationValid(LaunchAnimation))
    {
        OnLaunchAnimOverTimer();
    }
    else
    {
        PlayAnim(LaunchAnimation.Name, LaunchAnimation.Rate, false, 2);
        animTime = SkelMeshComp.GetAnimLength(LaunchAnimation.Name);
        SetTimer(animTime + LaunchAnimation.Time, false, 'OnLaunchAnimOverTimer');
    }
}

function OnCompressAnimOverTimer()
{
    local float animTime;
    
    if (!IsAnimationValid(LaunchAnimation))
    {
        OnIdleCompressedAnimOverTimer();
    }
    else if (!bUseLoopCompressedAnim)
    {
        PlayAnim(LaunchAnimation.Name, LaunchAnimation.Rate, false, 2);
        animTime = SkelMeshComp.GetAnimLength(LaunchAnimation.Name);
        SetTimer(animTime + LaunchAnimation.Time, false, 'OnLaunchAnimOverTimer');
    }
    else if (bPressActionToLaunch)
    {
        PlayAnim(IdleCompressedAnimation.Name, IdleCompressedAnimation.Rate, true, 1);
        bWaitingPressButton = true;
    }
    else
    {
        PlayAnim(IdleCompressedAnimation.Name, IdleCompressedAnimation.Rate, true, 1);
        SetTimer(IdleCompressedAnimation.Time, false, 'OnIdleCompressedAnimOverTimer');
    }
}

function bool IsAnimationValid(JumpPadAnimation Animation)
{
    if (SkelMeshComp == none || Animation.Name == 'None' || SkelMeshComp.FindAnimSequence(Animation.Name) == none)
    {
        return false;
    }
    else
    {
        return true;
    }
}

function OrientToucherToTarget(optional Vector ToucherLoc = Location, optional Vector TargetLoc = JumpTarget.Location)
{
    local Vector TargetDir;
    local Rotator R;
    
    return;
    TargetDir = TargetLoc - ToucherLoc;
    R = rotator(TargetDir);
    R.Pitch = 0;
    P.SetRotation(R);
}

function PlayAnim(name AnimName, optional float Rate, optional bool bLoop, optional int nActiveNumber, optional bool bRestartIfAlreadyPlaying = true)
{
    local AnimNodeSequence AnimNode;
    local AnimNodeBlendList AnimNBL;
    
    AnimNode = AnimNodeSequence(SkelMeshComp.Animations);
    if (AnimNode == none && SkelMeshComp.Animations.IsA('AnimTree'))
    {
        AnimNode = AnimNodeSequence(AnimTree(SkelMeshComp.Animations).Children[0].Anim);
    }
    if (AnimNode == none)
    {
        AnimNBL = AnimNodeBlendList(AnimTree(SkelMeshComp.Animations).Children[0].Anim);
        if (AnimNBL != none)
        {
            AnimNode = AnimNodeSequence(AnimNBL.Children[0].Anim);
            AnimNBL.SetActiveChild(nActiveNumber, 0.8);
        }
    }
    if (AnimNode == none)
    {
        WarnInternal("Base animation node is not an AnimNodeSequence (Owner:" @ string(Owner) $ ")");
    }
    else if (AnimNode.AnimSeq != none && AnimNode.AnimSeq.SequenceName == AnimName)
    {
        Rate = (Rate > 0.0 ? Rate : 1.0);
        if (bRestartIfAlreadyPlaying || !AnimNode.bPlaying)
        {
            AnimNode.PlayAnim(bLoop, Rate);
            AnimNode.bCauseActorAnimEnd = true;
            AnimNode.bCauseActorAnimPlay = true;
        }
        else
        {
            AnimNode.Rate = Rate;
            AnimNode.bLooping = bLoop;
        }
    }
    else
    {
        AnimNode.SetAnim(AnimName);
        if (AnimNode.AnimSeq != none)
        {
            Rate = (Rate > 0.0 ? Rate : 1.0);
            AnimNode.PlayAnim(bLoop, Rate);
        }
    }
}

function Vector CalculateJumpVelocity(Vector StartLoc, Vector EndLoc, optional float Time = JumpTime)
{
    local Vector Flight, GravityV, FlyVelocity;
    
    Flight = EndLoc - StartLoc;
    GravityV.X = 0.0;
    GravityV.Y = 0.0;
    GravityV.Z = GetGravityZ();
    FlyVelocity = Flight / Time - GravityV * Time;
    return FlyVelocity;
}

function OnDelayLaunch()
{
    P.JumpPad = self;
    P.Controller.GotoState('PlayerJumpPad');
    OrientToucherToTarget();
    OnLaunchAnimOverTimer();
}

function AliceJumpToJumpPad()
{
    local Vector Aliceloc;
    local float Distance;
    local Vector Loc;
    
    if (!bAutomaticToJumpPad)
    {
        return;
    }
    if (P == none)
    {
        P = AliceGamePawn(WorldInfo.GetLocalPlayerPawn());
    }
    Aliceloc = WorldInfo.GetLocalPlayerPawn().Location;
    Distance = VSize(Location - Aliceloc);
    if (Distance < Radius)
    {
        if (P.Physics == 1 && JumpState == 0)
        {
            RaiseTargetLocation = P.Location;
            RaiseTargetLocation.Z += CylinderComponent.CollisionHeight + P.CylinderComponent.CollisionHeight;
            RaiseTargetLocation.Z += Location.Z - P.Location.Z;
            P.JumpPad = self;
            P.Controller.GotoState('PlayerJumpPad');
            P.SetPhysics(2);
            P.PendingVelocity.X = 0.0;
            P.PendingVelocity.Y = 0.0;
            P.PendingVelocity.Z = 0.0;
            JumpState = 1;
            AlicePlayerController(P.Controller).bPressedJump = true;
            P.DoSpecialMove(3, true);
            Loc = Aliceloc;
            Loc.Z = RaiseTargetLocation.Z + float(20);
            P.Velocity = CalculateJumpVelocity(Aliceloc, Loc, AutomaticJumpTime);
        }
    }
    if (JumpState == 1 && P.Location.Z >= RaiseTargetLocation.Z - float(10))
    {
        P.PendingVelocity.X = 0.0;
        P.PendingVelocity.Y = 0.0;
        P.PendingVelocity.Z = 0.0;
        JumpState = 2;
        Loc = Location;
        Loc.Z = RaiseTargetLocation.Z;
        P.Velocity = CalculateJumpVelocity(Aliceloc, Loc, AutomaticJumpTime);
    }
}

event Detach(Actor Other)
{
    Detach(Other);
    JumpState = 0;
}

event Attach(Actor Other)
{
    Attach(Other);
    P = AliceGamePawn(Other);
    if (P == none || P.Physics == 0 || P.DrivenVehicle != none || P.SpecialMove == 49)
    {
        return;
    }
    Disable('Attach');
    P.JumpPad = self;
    P.Controller.GotoState('PlayerJumpPad');
    OrientToucherToTarget();
    OnCompressAnimOverTimer();
}

event Tick(float DeltaTime)
{
    AliceJumpToJumpPad();
    Tick(DeltaTime);
}

event PostBeginPlay()
{
    PostBeginPlay();
    if (bAutomaticToJumpPad)
    {
        Enable('Tick');
    }
    else
    {
        Disable('Tick');
    }
}

defaultproperties
{
    LightEnvironmentJumpPad="Default__JumpPadMushroom.MyLightEnvironment"
    SkelMeshComp="Default__JumpPadMushroom.SkeletalMeshComponent1"
    SocketName="LidSocket"
    CompressAnimation=(Name="GloryJumpPad_ready",Time=0.0,Rate=1.0)
    IdleCompressedAnimation=(Name="GloryJumpPad_ready",Time=2.0,Rate=1.0)
    LaunchAnimation=(Name="GloryJumpPad_Launch",Time=-0.8,Rate=1.0)
    AutomaticJumpTime=0.9
    bAutomaticToJumpPad=True
    Radius=220.0
    JumpTime=2.0
    bSpecialMove=True
    bDestinationOnly=True
    bBlockedForVehicles=True
    CylinderComponent="Default__JumpPadMushroom.CollisionCylinder"
    GoodSprite="Default__JumpPadMushroom.Sprite"
    BadSprite="Default__JumpPadMushroom.Sprite2"
    bStatic=False
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    Components(0)="Default__JumpPadMushroom.Sprite"
    Components(1)="Default__JumpPadMushroom.Sprite2"
    Components(2)="Default__JumpPadMushroom.Arrow"
    Components(3)="Default__JumpPadMushroom.CollisionCylinder"
    Components(4)="Default__JumpPadMushroom.PathRenderer"
    Components(5)="Default__JumpPadMushroom.MyLightEnvironment"
    Components(6)="Default__JumpPadMushroom.SkeletalMeshComponent1"
    CollisionType="COLLIDE_BlockAll"
    CollisionComponent="Default__JumpPadMushroom.CollisionCylinder"
}
