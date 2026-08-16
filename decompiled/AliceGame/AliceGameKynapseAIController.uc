class AliceGameKynapseAIController extends KynapseAIController
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var bool bPauseTick;

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local Color DrawColor;
    local Vector drawlocation, PawnToPlayer, CamLoc;
    local Rotator CamRot;
    
    Canvas = HUD.Canvas;
    if (HUD.ShouldDisplayDebug('AI'))
    {
        if (Pawn != none)
        {
            PawnToPlayer = Pawn.Location - WorldInfo.PlayerPawn.Location;
            PlayerController(WorldInfo.PlayerPawn.Controller).GetPlayerViewPoint(CamLoc, CamRot);
            if (PawnToPlayer Dot vector(CamRot) > float(0))
            {
                DrawColor.R = 0;
                DrawColor.G = 0;
                DrawColor.B = 255;
                drawlocation = Pawn.Location;
                drawlocation.Z -= float(25);
                Draw3Dtext(Canvas, drawlocation, " HP is " $ string(Pawn.Health), DrawColor);
                drawlocation.Z -= float(25);
                Draw3Dtext(Canvas, drawlocation, " NO: " $ string(AliceGameKynapsePawn(Pawn).AngleIndex), DrawColor);
                DrawColor.R = 255;
                DrawColor.G = 64;
                DrawColor.B = 0;
                drawlocation = Pawn.Location;
                Draw3Dtext(Canvas, drawlocation, " Angle : " $ string(AliceGameKynapsePawn(Pawn).fAngleToAlice), DrawColor);
            }
        }
    }
}

function Draw3Dtext(Canvas in_canvas, Vector TextLocation, string Text, Color TextColor)
{
    local Vector tempScreen;
    
    tempScreen = in_canvas.Project(TextLocation);
    if (tempScreen.X >= float(0) && tempScreen.X < in_canvas.ClipX && tempScreen.Y >= float(0) && tempScreen.Y < in_canvas.ClipY)
    {
        in_canvas.Font = class'Engine.Engine'.static.GetMediumFont();
        in_canvas.SetDrawColor(TextColor.R, TextColor.G, TextColor.B);
        in_canvas.SetPos(tempScreen.X, tempScreen.Y);
        in_canvas.DrawText(Text, true);
    }
}

native function RegisterSphinxEvent(SphinxMiscActionConditionType Type, optional int Info1 = 0, optional int Info2 = 0)
{
    Type;
    Info1;
    Info2;
}

native function Pawn GetLookatPawn()
{
}

function OnSphinxAIFollow(SeqAct_SphinxAIFollow Action)
{
    local SeqVar_Object ObjVar;
    
    taskDuration = Action.Duration;
    foreach Action.LinkedVariables(class'Engine.SeqVar_Object', ObjVar, "Follow Target")
    {
        followTarget = Actor(ObjVar.GetObjectValue());
    }
    if (followTarget != none)
    {
        KynapseSphinxFollow(followTarget);
    }
}

function NotifyBeginDying(Pawn inPawn)
{
    KynapsePawnDied(inPawn);
}

function PawnDied(Pawn inPawn)
{
    PawnDied(inPawn);
}

native function NotifyNPCLandedFromFalling()
{
}

native function NotifyAttachedActorDamage(int Index, int prevhp, int curhp, class<DamageType> DamageType)
{
    Index;
    prevhp;
    curhp;
    DamageType;
}

native function NotifyAttachedActorDead(int Index)
{
    Index;
}

native function NotifySpecialHit(int SpecialWeaponIndentify)
{
    SpecialWeaponIndentify;
}

native function NotifyShieldReact(int PackageIndex, bool CanBreakStrikBackPackage)
{
    PackageIndex;
    CanBreakStrikBackPackage;
}

native function NotifyEventBeLockOn()
{
}

native function ToggleNotifyTeammateFight(bool Set)
{
    Set;
}

native function NotifyKismetControll(bool Set)
{
    Set;
}

native function KynapseSphinxFollow(Actor inActor)
{
    inActor;
}

native function KynapsePawnDied(Pawn inPawn)
{
    inPawn;
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    KynapseTakeDamager(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
}

native function KynapseTakeDamager(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    InstigatedBy;
    HitLocation;
    Damage;
    DamageType;
    Momentum;
}

function OnSphinxSubConditionNotify(SeqAct_SphinxSubConditionNotify inAction)
{
    SphinxSubConditionNotify(inAction);
}

native final function SphinxSubConditionNotify(SeqAct_SphinxSubConditionNotify inAction)
{
    inAction;
}

function OnSphinxNotifyTeammateFight(SeqAct_SphinxNotifyTeammateFight inAction)
{
    ToggleNotifyTeammateFight(inAction.bNotifyTeammate);
}

function OnSphinxNotifyKismetControl(SeqAct_SphinxNotifyKismetControl inAction)
{
    NotifyKismetControll(inAction.bSetKismetControl);
}

function OnConfigSphinxAgent(SeqAct_ConfigSphinxAgent inAction)
{
    ConfigSphinxAgent(inAction);
}

native final function ConfigSphinxAgent(SeqAct_ConfigSphinxAgent inAction)
{
    inAction;
}

simulated event BreakByAI(EInterruptByAIType Type)
{
    if (AliceGameKynapsePawn(Pawn).ControlledInterp != none)
    {
        AliceGameKynapsePawn(Pawn).ControlledInterp.Stop();
    }
    BreakByAI(Type);
    if (IsInState('ScriptedMove'))
    {
        PoppedState();
    }
}

simulated event ActiveAIEventTrigger(EInterruptByAIType Type, optional int Info1 = 0, optional int Info2 = 0)
{
    switch (Type)
    {
        case 0:
            Pawn.TriggerEventClass(class'Engine.SeqEvent_AISeeEnemy', Pawn, -1);
            break;
        case 1:
            Pawn.TriggerEventClass(class'Engine.SeqEvent_AIHearNoise', Pawn, -1);
            break;
        case 2:
            Pawn.TriggerEventClass(class'Engine.SeqEvent_AICollidePlayer', Pawn, -1);
            RegisterSphinxEvent(8);
            break;
        case 3:
            Pawn.TriggerEventClass(class'Engine.SeqEvent_AITakeDamage', Pawn, -1);
            RegisterSphinxEvent(7, Info1);
            break;
        default:
    }
}

state NPCJumpPad
{
    event BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        AliceGameKynapsePawn(Pawn).bInJumpPad = true;
    }
    
    Stop;
}

state NPCNormal
{
    Stop;
}

state ScriptedMove
{
    event PushedState()
    {
        PushedState();
        NotifyKismetControll(true);
    }
    
    event PoppedState()
    {
        PoppedState();
        NotifyKismetControll(false);
    }
    
    Stop;
}

defaultproperties
{
    bPauseTick=True
    bSkipExtraLOSChecks=True
}
