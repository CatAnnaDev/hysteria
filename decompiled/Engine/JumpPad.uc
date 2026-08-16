class JumpPad extends SphinxPathObject
    native
    notplaceable
    hidecategories(Navigation,Lighting,LightColor,Force);

var Vector JumpVelocity;
var() Actor JumpTarget;
var() SoundCue JumpSound;
var() float JumpTime;
var() float JumpAirControl;
var export editinline AudioComponent JumpAmbientSound;
var bool JumpPadForNpcOnly;
var(NPCJumpInfo) bool bEnableNpcPad;
var(NPCJumpInfo) const editconst name JumpStartAnimName;
var(NPCJumpInfo) int JumpStartAnimIndex;
var(NPCJumpInfo) const editconst name JumpLoopAnimName;
var(NPCJumpInfo) int JumpLoopAnimIndex;
var(NPCJumpInfo) const editconst name JumpEndAnimName;
var(NPCJumpInfo) int JumpEndAnimIndex;
var(NPCJumpInfo) const editconst name RootMotionJumpAnimName;
var(NPCJumpInfo) int RootMotionJumpAnimIndex;
var(NPCJumpInfo) Pawn SupportArchetype;
var array<Pawn> WaitJumpPawnList;

event bool IsJumpPadInUsing()
{
}

event NPCJumpPadLand(Actor JumpNpcPawn)
{
}

event NPCJumpPadLauch(Actor JumpNpcPawn)
{
}

event NPCJumpPadPreLauch(Actor JumpNpcPawn)
{
}

function TurnOffCollision()
{
}

function TurnOnCollision()
{
}

function Launch()
{
}

defaultproperties
{
    bEnableNpcPad=True
    JumpStartAnimIndex=-1
    JumpLoopAnimIndex=-1
    JumpEndAnimIndex=-1
    RootMotionJumpAnimIndex=-1
    bNotBased=True
    CylinderComponent="Default__JumpPad.CollisionCylinder"
    GoodSprite="Default__JumpPad.Sprite"
    BadSprite="Default__JumpPad.Sprite2"
    Components(0)="Default__JumpPad.Sprite"
    Components(1)="Default__JumpPad.Sprite2"
    Components(2)="Default__JumpPad.Arrow"
    Components(3)="Default__JumpPad.CollisionCylinder"
    Components(4)="Default__JumpPad.PathRenderer"
    CollisionComponent="Default__JumpPad.CollisionCylinder"
}
