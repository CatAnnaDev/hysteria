class Goal_AtActor extends PathGoalEvaluator
    native
    notplaceable;

var Actor GoalActor;
var float GoalDist;
var bool bKeepPartial;

function Recycle()
{
    GoalActor = none;
    GoalDist = default.GoalDist;
    bKeepPartial = default.bKeepPartial;
    Recycle();
}

static function bool AtActor(Pawn P, Actor Goal, optional float Dist, optional bool bReturnPartial)
{
    local Goal_AtActor Eval;
    local Pawn GoalPawn;
    local Controller GoalController;
    local float AnchorDist;
    
    if (P != none)
    {
        GoalPawn = Pawn(Goal);
        GoalController = Controller(Goal);
        if (GoalController != none)
        {
            if (GoalController.Pawn != none)
            {
                GoalPawn = GoalController.Pawn;
            }
            else
            {
                Goal = none;
            }
        }
        if (GoalPawn != none)
        {
            if (GoalPawn.ValidAnchor() && GoalPawn.Anchor.IsUsableAnchorFor(P))
            {
                Goal = GoalPawn.Anchor;
            }
            else
            {
                Goal = P.GetBestAnchor(GoalPawn, GoalPawn.Location, false, false, AnchorDist);
            }
        }
        else if (NavigationPoint(Goal) == none)
        {
            Goal = P.GetBestAnchor(Goal, Goal.Location, false, false, AnchorDist);
            if (Goal == none)
            {
                LogInternal("PATHWARNING: Not pushing AtActor goal constraint because we couldn't find an anchor for goal!");
            }
        }
        if (Goal != none)
        {
            Eval = Goal_AtActor(P.CreatePathGoalEvaluator(default.Class));
            if (Eval != none)
            {
                Eval.GoalActor = Goal;
                Eval.GoalDist = Dist;
                Eval.bKeepPartial = bReturnPartial;
                P.AddGoalEvaluator(Eval);
                return true;
            }
        }
    }
    return false;
}

defaultproperties
{
    CacheIdx=0
}
