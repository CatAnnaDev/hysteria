class Mutator extends Info
    abstract
    native
    notplaceable
    hidecategories(Navigation,Movement,Collision);

var Mutator NextMutator;
var() array<string> GroupNames;
var bool bUserAdded;

function NetDamage(int OriginalDamage, out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    if (NextMutator != none)
    {
        NextMutator.NetDamage(OriginalDamage, Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    }
}

function ScoreKill(Controller Killer, Controller Killed)
{
    if (NextMutator != none)
    {
        NextMutator.ScoreKill(Killer, Killed);
    }
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    if (NextMutator != none)
    {
        NextMutator.ScoreObjective(Scorer, Score);
    }
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, Vector HitLocation)
{
    return NextMutator != none && NextMutator.PreventDeath(Killed, Killer, DamageType, HitLocation);
}

function bool OverridePickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup, out byte bAllowPickup)
{
    return NextMutator != none && NextMutator.OverridePickupQuery(Other, ItemClass, Pickup, bAllowPickup);
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return NextMutator == none || NextMutator.CheckEndGame(Winner, Reason);
}

function bool HandleRestartGame()
{
    return NextMutator != none && NextMutator.HandleRestartGame();
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    if (NextMutator != none)
    {
        return NextMutator.FindPlayerStart(Player, InTeam, IncomingName);
    }
    else
    {
        return none;
    }
}

function GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    if (bToEntry)
    {
        ActorList[ActorList.Length] = self;
    }
    if (NextMutator != none)
    {
        NextMutator.GetSeamlessTravelActorList(bToEntry, ActorList);
    }
}

function InitMutator(string Options, out string ErrorMessage)
{
    if (NextMutator != none)
    {
        NextMutator.InitMutator(Options, ErrorMessage);
    }
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != none)
    {
        NextMutator.DriverLeftVehicle(V, P);
    }
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != none)
    {
        return NextMutator.CanLeaveVehicle(V, P);
    }
    return true;
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    if (NextMutator != none)
    {
        NextMutator.DriverEnteredVehicle(V, P);
    }
}

function NotifyLogin(Controller NewPlayer)
{
    if (NextMutator != none)
    {
        NextMutator.NotifyLogin(NewPlayer);
    }
}

function NotifyLogout(Controller Exiting)
{
    if (NextMutator != none)
    {
        NextMutator.NotifyLogout(Exiting);
    }
}

function string ParseChatPercVar(Controller Who, string Cmd)
{
    if (NextMutator != none)
    {
        Cmd = NextMutator.ParseChatPercVar(Who, Cmd);
    }
    return Cmd;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    local int I;
    
    I = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = I + 1;
    ServerState.ServerInfo[I].Key = "Mutator";
    ServerState.ServerInfo[I].Value = GetHumanReadableName();
}

function bool CheckReplacement(Actor Other)
{
    return true;
}

function bool CheckRelevance(Actor Other)
{
    local bool bResult;
    
    if (AlwaysKeep(Other))
    {
        return true;
    }
    bResult = IsRelevant(Other);
    return bResult;
}

function bool IsRelevant(Actor Other)
{
    local bool bResult;
    
    bResult = CheckReplacement(Other);
    if (bResult && NextMutator != none)
    {
        bResult = NextMutator.IsRelevant(Other);
    }
    return bResult;
}

function bool AlwaysKeep(Actor Other)
{
    if (NextMutator != none)
    {
        return NextMutator.AlwaysKeep(Other);
    }
    return false;
}

function AddMutator(Mutator M)
{
    if (NextMutator == none)
    {
        NextMutator = M;
    }
    else
    {
        NextMutator.AddMutator(M);
    }
}

function ModifyPlayer(Pawn Other)
{
    if (NextMutator != none)
    {
        NextMutator.ModifyPlayer(Other);
    }
}

function ModifyLogin(out string Portal, out string Options)
{
    if (NextMutator != none)
    {
        NextMutator.ModifyLogin(Portal, Options);
    }
}

function Mutate(string MutateString, PlayerController Sender)
{
    if (NextMutator != none)
    {
        NextMutator.Mutate(MutateString, Sender);
    }
}

event Destroyed()
{
    WorldInfo.Game.RemoveMutator(self);
    Destroyed();
}

function bool MutatorIsAllowed()
{
    return !WorldInfo.IsDemoBuild();
}

event PreBeginPlay()
{
    if (!MutatorIsAllowed())
    {
        Destroy();
    }
}

defaultproperties
{
    Components(0)="Default__Mutator.Sprite"
}
