class ColorScaleVolume extends Volume
    placeable
    hidecategories(Navigation,Object,Movement,Display,Collision,Brush,Attachment,Volume);

var() Vector ColorScale;
var() float InterpTime;

event UnTouch(Actor Other)
{
    local Pawn P;
    local PlayerController PC;
    local Vector DesiredColorScale;
    local float DesiredInterpTime;
    local int Idx;
    local ColorScaleVolume CSV;
    
    UnTouch(Other);
    P = Pawn(Other);
    if (P != none)
    {
        PC = PlayerController(P.Controller);
        if (PC != none && PC.PlayerCamera != none)
        {
            DesiredColorScale = WorldInfo.DefaultColorScale;
            DesiredInterpTime = 1.0;
            for (Idx = P.Touching.Length; Idx >= 0; --Idx)
            {
                CSV = ColorScaleVolume(P.Touching[Idx]);
                if (CSV != none && CSV != self)
                {
                    DesiredColorScale = CSV.ColorScale;
                    DesiredInterpTime = CSV.InterpTime;
                    break;
                }
            }
            PC.PlayerCamera.SetDesiredColorScale(DesiredColorScale, DesiredInterpTime);
        }
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Pawn P;
    local PlayerController PC;
    
    Touch(Other, OtherComp, HitLocation, HitNormal);
    P = Pawn(Other);
    if (P != none)
    {
        PC = PlayerController(P.Controller);
        if (PC != none && PC.PlayerCamera != none)
        {
            PC.PlayerCamera.SetDesiredColorScale(ColorScale, InterpTime);
        }
    }
}

defaultproperties
{
    ColorScale=(X=1.0,Y=1.0,Z=1.0)
    InterpTime=1.0
    BrushComponent="Default__ColorScaleVolume.BrushComponent0"
    Components(0)="Default__ColorScaleVolume.BrushComponent0"
    CollisionComponent="Default__ColorScaleVolume.BrushComponent0"
}
