class AliceBlockPiece extends StaticMeshActor
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var float DrawScale;
    var Vector DrawScale3D;
};

var() int Id;
var int CurLoc;
var() bool bNeedCollect;
var bool bIsReady;
var bool bIsLocated;
var bool bStartFadeOut;
var bool bAfterPress;
var bool bNormalUse;
var float fFadeOut;
var() float FadeOutDuration;
var() float TouchRadius;
var() Vector TrailOffset;
var MaterialInstanceConstant BaseMatInst;
var() ParticleSystem DisappearPS;
var export editinline ParticleSystemComponent PSC;
var ParticleSystem TrailPS;
var Emitter TrailEmitter;
var AliceBlockPuzzleBoard myBoard;

function OnTrailFinish()
{
    DetachComponent(PSC);
}

function StopMovingEffect()
{
    if (bNormalUse)
    {
        TrailEmitter.ParticleSystemComponent.DeactivateSystem();
    }
    else
    {
        OnTrailFinish();
    }
}

function TriggerMovingEffect()
{
    if (bNormalUse)
    {
        if (TrailEmitter == none)
        {
            TrailEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
            if (TrailEmitter != none && TrailPS != none)
            {
                TrailEmitter.SetTemplate(TrailPS);
            }
        }
        TrailEmitter.ParticleSystemComponent.ActivateSystem();
    }
    else
    {
        PSC = new(self) class'Engine.ParticleSystemComponent';
        PSC.SetTemplate(TrailPS);
        AttachComponent(PSC);
        PSC.ActivateSystem();
    }
}

function bool CanShowUI()
{
    return !bAfterPress;
}

function playDisappearPS()
{
    local Emitter disappearEmitter;
    
    disappearEmitter = Spawn(class'Engine.EmitterSpawnable', self, , Location);
    if (disappearEmitter != none && DisappearPS != none)
    {
        disappearEmitter.SetTemplate(DisappearPS, true);
    }
}

function ResetFade()
{
    if (BaseMatInst != none)
    {
        BaseMatInst.SetScalarParameterValue('FadeOut', 0.0);
    }
}

function assembleSelf()
{
    bIsReady = true;
    if (myBoard != none)
    {
        myBoard.AssemblePiece(self);
    }
}

function OnFadeOutEnd()
{
    fFadeOut = 0.0;
    bStartFadeOut = false;
    assembleSelf();
    TriggerEventClass(class'SeqEvent_BlockFound', self);
}

event Tick(float DeltaTime)
{
    if (bStartFadeOut)
    {
        if (fFadeOut > FadeOutDuration)
        {
            OnFadeOutEnd();
        }
        else
        {
            fFadeOut += DeltaTime;
            if (BaseMatInst != none)
            {
                BaseMatInst.SetScalarParameterValue('FadeOut', fFadeOut);
            }
        }
    }
    if (TrailEmitter != none)
    {
        TrailEmitter.SetLocation(Location + TrailOffset);
    }
}

function startFadeOut()
{
    bStartFadeOut = true;
    playDisappearPS();
}

function OnCanBeCollect(bool bOn)
{
    if (BaseMatInst != none)
    {
        BaseMatInst.SetScalarParameterValue('Selected', bOn ? 1.0 : 0.0);
    }
}

function setLocMat()
{
    if (!myBoard.bNeedLocalize)
    {
        return;
    }
    StaticMeshComponent.SetMaterial(0, myBoard.getPieceLocMat());
}

function Init(AliceBlockPuzzleBoard board)
{
    bAfterPress = false;
    myBoard = board;
    if (BaseMatInst == none)
    {
        setLocMat();
        BaseMatInst = StaticMeshComponent.CreateAndSetMaterialInstanceConstant(0);
        LogInternal("========AliceBlockPiece Init() ==============");
    }
}

function ApplyCheckpointRecord(out const CheckpointRecord Record)
{
    SetLocation(Record.Location);
    SetRotation(Record.Rotation);
    SetDrawScale(Record.DrawScale);
    SetDrawScale3D(Record.DrawScale3D);
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.DrawScale = DrawScale;
    Record.DrawScale3D = DrawScale3D;
}

defaultproperties
{
    Id=1
    bNormalUse=True
    FadeOutDuration=2.0
    TouchRadius=350.0
    DisappearPS="EmoWater.EmoWater_Disappear_P"
    TrailPS="EmoWater.EmoWaterMove_Trail_P"
    StaticMeshComponent="Default__AliceBlockPiece.StaticMeshComponent0"
    bStatic=False
    bMovable=True
    Components(0)="Default__AliceBlockPiece.StaticMeshComponent0"
    CollisionComponent="Default__AliceBlockPiece.StaticMeshComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_Destroyed"
    SupportedEvents(2)="Engine.SeqEvent_TakeDamage"
    SupportedEvents(3)="Engine.SeqEvent_HitWall"
    SupportedEvents(4)="SeqEvent_BlockFound"
}
