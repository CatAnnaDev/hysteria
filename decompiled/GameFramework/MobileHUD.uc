class MobileHUD extends GameHUD
    native
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

enum EZoneState
{
    ZoneState_Inactive,
    ZoneState_Activating,
    ZoneState_Active,
    ZoneState_Deactivating,
};

enum EZoneType
{
    ZoneType_Button,
    ZoneType_Joystick,
    ZoneType_Trackball,
    ZoneType_Tilt,
};

struct native MobileInputZone
{
    var name InputKey;
    var name HorizontalInputKey;
    var name TapInputKey;
    var string Desc;
    var int Config;
    var int X;
    var int Y;
    var int SizeX;
    var int SizeY;
    var int Border;
    var bool bIsInvisible;
    var EZoneType Type;
    var EZoneState State;
    var float VertMultiplier;
    var float HorizMultiplier;
    var int CurX;
    var int CurY;
    var int CurCenterX;
    var int CurCenterY;
};

var config bool bShowGameHUD;
var globalconfig bool bForceMobileHUD;
var Texture2D ZoneBackgroundOn;
var Texture2D ZoneBackgroundSmallOn;
var Texture2D ZoneBackgroundTinyOn;
var Texture2D FireZoneBackground;
var Texture2D MoveZoneBackground;
var Texture2D SteerZoneBackground;
var Color ZoneTileColor;
var Color ZoneTextColor;
var Texture2D AnalogHat;
var config array<MobileInputZone> MobileInputZones;
var int MobileInputConfig;
var int MobileInputConfigMAX;

exec function ResetMobileInputConfig()
{
    MobileInputConfig = 0;
    bShowHUD = false;
}

exec function NextMobileInputConfig()
{
    MobileInputConfig = (MobileInputConfig + 1) % MobileInputConfigMAX;
    if (MobileInputConfig == 0)
    {
        MobileInputConfig++;
    }
    bShowHUD = true;
    LogInternal("MobileInputConfig=" $ string(MobileInputConfig));
}

function DrawInputOverlays()
{
    local int ZoneIndex;
    local float TextX, TextY;
    local MobileInputZone Zone;
    local int ZoneAdjustedX, ZoneAdjustedY, ZoneAdjustedSizeX, ZoneAdjustedSizeY;
    local float ClampedX, ClampedY, Scale;
    local Texture2D BackgroundTexture;
    local Color LineColor;
    
    Canvas.Reset();
    Canvas.ClipX = float(Canvas.SizeX);
    Canvas.ClipY = float(Canvas.SizeY);
    for (ZoneIndex = 0; ZoneIndex < MobileInputZones.Length; ZoneIndex++)
    {
        Zone = MobileInputZones[ZoneIndex];
        if (Zone.Config != MobileInputConfig)
        {
            continue;
        }
        ZoneAdjustedX = Zone.X;
        if (Zone.X < 0)
        {
            ZoneAdjustedX += Canvas.SizeX;
        }
        ZoneAdjustedY = Zone.Y;
        if (Zone.Y < 0)
        {
            ZoneAdjustedY += Canvas.SizeY;
        }
        ZoneAdjustedSizeX = Zone.SizeX;
        if (Zone.SizeX < 0)
        {
            ZoneAdjustedSizeX += Canvas.SizeX;
        }
        ZoneAdjustedSizeY = Zone.SizeY;
        if (Zone.SizeY < 0)
        {
            ZoneAdjustedSizeY += Canvas.SizeY;
        }
        if (!Zone.bIsInvisible)
        {
            Canvas.DrawColor = ZoneTileColor;
            if (Zone.Type == 1)
            {
                if (MobileInputConfig == 1 || MobileInputConfig == 2)
                {
                    BackgroundTexture = SteerZoneBackground;
                }
                else
                {
                    BackgroundTexture = MoveZoneBackground;
                }
                Canvas.DrawColor.A = 255;
            }
            else if (Zone.InputKey == 'MOBILE_Fire')
            {
                BackgroundTexture = FireZoneBackground;
            }
            else if (ZoneAdjustedSizeX > 64)
            {
                BackgroundTexture = ZoneBackgroundOn;
            }
            else if (ZoneAdjustedSizeX > 32)
            {
                BackgroundTexture = ZoneBackgroundSmallOn;
            }
            else
            {
                BackgroundTexture = ZoneBackgroundTinyOn;
            }
            if ((Zone.Type == 0 || Zone.Type == 3) && Zone.State == 2 || Zone.State == 1)
            {
                Canvas.DrawColor.A = 255;
            }
            Canvas.SetPos(float(ZoneAdjustedX), float(ZoneAdjustedY));
            Canvas.DrawTile(BackgroundTexture, float(ZoneAdjustedSizeX - 1), float(ZoneAdjustedSizeY - 1), 0.0, 0.0, float(BackgroundTexture.OriginalSizeX - 1), float(BackgroundTexture.OriginalSizeY - 1));
            Canvas.StrLen(Zone.Desc, TextX, TextY);
            Canvas.DrawColor = ZoneTextColor;
            Canvas.SetPos(float(ZoneAdjustedX) + (float(ZoneAdjustedSizeX) - TextX) / float(2), float(ZoneAdjustedY) + (float(ZoneAdjustedSizeY) - TextY) / float(2));
            Canvas.DrawText(Zone.Desc);
        }
        if ((Zone.Type == 1 || Zone.Type == 2) && Zone.State == 2)
        {
            ClampedX = float(Zone.CurX - Zone.CurCenterX);
            ClampedY = float(Zone.CurY - Zone.CurCenterY);
            Scale = 1.0;
            if (ClampedX != float(0) || ClampedY != float(0))
            {
                Scale = float(Min(ZoneAdjustedSizeX, ZoneAdjustedSizeY)) / (2.0 * Sqrt(ClampedX * ClampedX + ClampedY * ClampedY));
                Scale = FMin(1.0, Scale);
            }
            ClampedX = ClampedX * Scale + float(Zone.CurCenterX);
            ClampedY = ClampedY * Scale + float(Zone.CurCenterY);
            Canvas.DrawColor = WhiteColor;
            Canvas.DrawColor.A = 64;
            if (Zone.Type != 2)
            {
                LineColor.R = 128;
                LineColor.G = 128;
                LineColor.B = 128;
                Canvas.Draw2DLine(float(Zone.CurCenterX), float(Zone.CurCenterY), ClampedX, ClampedY, LineColor);
            }
            Canvas.SetPos(ClampedX - float(AnalogHat.SizeX / 2), ClampedY - float(AnalogHat.SizeY / 2));
            Canvas.DrawTile(AnalogHat, float(AnalogHat.SizeX), float(AnalogHat.SizeY), 0.0, 0.0, float(AnalogHat.SizeX), float(AnalogHat.SizeY));
        }
        if (Zone.Type == 3)
        {
            ClampedX = float(Zone.CurX - Zone.CurCenterX);
            ClampedY = float(Zone.CurY - Zone.CurCenterY);
            Scale = 1.0;
            if (ClampedX != float(0) || ClampedY != float(0))
            {
                Scale = float(Min(ZoneAdjustedSizeX, ZoneAdjustedSizeY)) / (2.0 * Sqrt(ClampedX * ClampedX + ClampedY * ClampedY));
                Scale = FMin(1.0, Scale);
            }
            ClampedX = ClampedX * Scale + float(Zone.CurCenterX);
            ClampedY = ClampedY * Scale + float(Zone.CurCenterY);
            Canvas.DrawColor = WhiteColor;
            Canvas.Draw2DLine(float(Zone.CurCenterX), float(Zone.CurCenterY), ClampedX, ClampedY, Canvas.DrawColor);
        }
    }
}

function PostRender()
{
    PostRender();
    if (MobileInputZones.Length > 0)
    {
        DrawInputOverlays();
    }
}

simulated function PostBeginPlay()
{
    local int ZoneIndex;
    
    PostBeginPlay();
    if (WorldInfo.IsConsoleBuild(4) || bForceMobileHUD)
    {
        bShowHUD = false;
        bShowGameHUD = false;
        MobileInputConfigMAX = MobileInputZones[0].Config;
        for (ZoneIndex = 1; ZoneIndex < MobileInputZones.Length; ZoneIndex++)
        {
            if (MobileInputConfigMAX < MobileInputZones[ZoneIndex].Config)
            {
                MobileInputConfigMAX = MobileInputZones[ZoneIndex].Config;
            }
        }
        MobileInputConfigMAX++;
    }
    else
    {
        MobileInputZones.Length = 0;
    }
}

defaultproperties
{
    ZoneBackgroundOn="MobileResources.HUD.MobileHUDButton2_on"
    ZoneBackgroundSmallOn="MobileResources.HUD.MobileHUDButton1_on"
    ZoneBackgroundTinyOn="MobileResources.HUD.MobileHUDButton3"
    FireZoneBackground="MobileResources.HUD.MobileHUDButtonFire"
    MoveZoneBackground="MobileResources.HUD.MobileHUDDirectionPad2"
    SteerZoneBackground="MobileResources.HUD.MobileHUDDirectionPad3"
    ZoneTileColor=(B=255,G=255,R=255,A=128)
    ZoneTextColor=(B=11,G=183,R=255,A=255)
    AnalogHat="MobileResources.HUD.MobileHUDDirectionStick"
}
