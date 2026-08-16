class AIController extends Controller
    native
    notplaceable
    hidecategories(Navigation);

var bool bAdjustFromWalls;
var bool bReverseScriptedRoute;
var float Skill;
var Actor ScriptedMoveTarget;
var Route ScriptedRoute;
var int ScriptedRouteIndex;
var Actor ScriptedFocus;

function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
    return true;
}

function bool ShouldRefire()
{
}

function NotifyWeaponFinishedFiring(Weapon W, byte FireMode)
{
}

function NotifyWeaponFired(Weapon W, byte FireMode)
{
}

function OnAIMoveToActor(SeqAct_AIMoveToActor Action)
{
    local Actor destActor;
    local SeqVar_Object ObjVar;
    
    ClearLatentAction(class'SeqAct_AIMoveToActor', true, Action);
    destActor = Action.PickDestination(Pawn);
    if (destActor != none)
    {
        ScriptedRoute = Route(destActor);
        if (ScriptedRoute != none)
        {
            if (ScriptedRoute.RouteList.Length == 0)
            {
                WarnInternal("Invalid route with empty MoveList for scripted move");
            }
            else
            {
                ScriptedRouteIndex = 0;
                if (!IsInState('ScriptedRouteMove'))
                {
                    PushState('ScriptedRouteMove');
                }
            }
        }
        else
        {
            ScriptedMoveTarget = destActor;
            if (!IsInState('ScriptedMove'))
            {
                PushState('ScriptedMove');
            }
        }
        ScriptedFocus = none;
        foreach Action.LinkedVariables(class'SeqVar_Object', ObjVar, "Look At")
        {
            ScriptedFocus = Actor(ObjVar.GetObjectValue());
            if (ScriptedFocus != none)
            {
                break;
            }
        }
    }
    else
    {
        WarnInternal("Invalid destination for scripted move");
    }
}

simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    if (Pawn != none)
    {
        out_Location = Pawn.Location;
        out_Rotation = Pawn.Rotation;
    }
    else
    {
        GetPlayerViewPoint(out_Location, out_Rotation);
    }
}

event SetTeam(int inTeamIdx)
{
    WorldInfo.Game.ChangeTeam(self, inTeamIdx, true);
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local int I;
    local string T;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    DisplayDebug(HUD, out_YL, out_YPos);
    if (HUD.ShouldDisplayDebug('AI'))
    {
        Canvas.DrawColor.B = 255;
        if (Pawn != none && MoveTarget != none && Pawn.ReachedDestination(MoveTarget))
        {
            Canvas.DrawText("     Skill " $ string(Skill) $ " NAVIGATION MoveTarget " $ GetItemName(string(MoveTarget)) $ "(REACHED) MoveTimer " $ string(MoveTimer), false);
        }
        else
        {
            Canvas.DrawText("     Skill " $ string(Skill) $ " NAVIGATION MoveTarget " $ GetItemName(string(MoveTarget)) $ " MoveTimer " $ string(MoveTimer), false);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("      Destination " $ string(GetDestinationPosition()) $ " Focus " $ GetItemName(string(Focus)) $ " Preparing Move " $ string(bPreparingMove), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        Canvas.DrawText("     RouteGoal " $ GetItemName(string(RouteGoal)) $ " RouteDist " $ string(RouteDist), false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
        for (I = 0; I < RouteCache.Length; I++)
        {
            if (RouteCache[I] == none)
            {
                if (I > 5)
                {
                    T = T $ "--" $ GetItemName(string(RouteCache[I - 1]));
                }
                break;
                continue;
            }
            if (I < 5)
            {
                T = T $ GetItemName(string(RouteCache[I])) $ "-";
            }
        }
        Canvas.DrawText("     RouteCache: " $ T, false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0, out_YPos);
    }
}

function Reset()
{
    Reset();
}

event PreBeginPlay()
{
    PreBeginPlay();
    if (bDeleteMe)
    {
        return;
    }
    if (WorldInfo.Game != none)
    {
        Skill += WorldInfo.Game.GameDifficulty;
    }
    Skill = FClamp(Skill, 0.0, 3.0);
}

state ScriptedRouteMove
{
    event PoppedState()
    {
        ClearLatentAction(class'SeqAct_AIMoveToActor', ScriptedRoute == none);
        ScriptedRoute = none;
    }
    
    Begin:
    if (Pawn != none && ScriptedRoute != none && ScriptedRouteIndex < ScriptedRoute.RouteList.Length && ScriptedRouteIndex >= 0)
    {
        ScriptedMoveTarget = ScriptedRoute.RouteList[ScriptedRouteIndex].Actor;
        if (ScriptedMoveTarget != none)
        {
            PushState('ScriptedMove');
        }
        if (Pawn != none && Pawn.ReachedDestination(ScriptedRoute.RouteList[ScriptedRouteIndex].Actor))
        {
            if (bReverseScriptedRoute)
            {
                ScriptedRouteIndex--;
            }
            else
            {
                ScriptedRouteIndex++;
            }
        }
        else
        {
            WarnInternal("Aborting scripted route");
            ScriptedRoute = none;
            PopState();
        }
        goto Begin;
    }
    if (Pawn != none && ScriptedRoute != none && ScriptedRoute.RouteList.Length > 0)
    {
        switch (ScriptedRoute.RouteType)
        {
            case 0:
                PopState();
                break;
            case 1:
                bReverseScriptedRoute = !bReverseScriptedRoute;
                if (bReverseScriptedRoute)
                {
                    ScriptedRouteIndex--;
                }
                else
                {
                    ScriptedRouteIndex++;
                }
                goto 'Begin';
                break;
            case 2:
                ScriptedRouteIndex = 0;
                goto 'Begin';
                break;
            default:
                WarnInternal("Unknown route type");
                ScriptedRoute = none;
                PopState();
                break;
        }
    }
    else
    {
        ScriptedRoute = none;
        PopState();
    }
    WarnInternal("Reached end of state execution");
    ScriptedRoute = none;
    PopState();
    Stop;
}

state ScriptedMove
{
    event PushedState()
    {
        if (Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
    }
    
    event PoppedState()
    {
        if (ScriptedRoute == none)
        {
            ClearLatentAction(class'SeqAct_AIMoveToActor', ScriptedMoveTarget == none);
        }
        ScriptedMoveTarget = none;
    }
    
    Begin:
    if (Pawn != none && ScriptedMoveTarget != none && !Pawn.ReachedDestination(ScriptedMoveTarget))
    {
        if (ActorReachable(ScriptedMoveTarget))
        {
            MoveToward(ScriptedMoveTarget, ScriptedFocus);
        }
        else
        {
            MoveTarget = FindPathToward(ScriptedMoveTarget);
            if (MoveTarget != none)
            {
                MoveToward(MoveTarget, ScriptedFocus);
            }
            else
            {
                WarnInternal("Failed to find path to" @ string(ScriptedMoveTarget));
                ScriptedMoveTarget = none;
            }
        }
        goto Begin;
    }
    PopState();
    Stop;
}

defaultproperties
{
    bAdjustFromWalls=True
    bCanDoSpecial=True
    MinHitWall=-0.5
}
