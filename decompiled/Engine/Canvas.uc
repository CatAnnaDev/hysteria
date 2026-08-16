class Canvas extends Object
    native
    notplaceable
    transient;

struct native FontRenderInfo
{
    var bool bClipText;
    var bool bEnableShadow;
    var DepthFieldGlowInfo GlowInfo;
};

struct native DepthFieldGlowInfo
{
    var bool bEnableGlow;
    var LinearColor GlowColor;
    var Vector2D GlowOuterRadius;
    var Vector2D GlowInnerRadius;
};

struct native CanvasIcon
{
    var Texture Texture;
    var float U;
    var float V;
    var float UL;
    var float VL;
};

var Font Font;
var float OrgX;
var float OrgY;
var float ClipX;
var float ClipY;
var float CurX;
var float CurY;
var float CurZ;
var float CurYL;
var Color DrawColor;
var bool bCenter;
var bool bNoSmooth;
var const int SizeX;
var const int SizeY;
var const native Pointer Canvas;
var const native Pointer SceneView;
var Plane ColorModulate;
var Texture2D DefaultTexture;

function DrawDebugGraph(coerce string Title, float ValueX, float ValueY, float UL_X, float UL_Y, float W, float H, Vector2D RangeX, Vector2D RangeY)
{
    local int X, Y;
    
    SetDrawColor(255, 255, 255, 255);
    SetPos(UL_X, UL_Y);
    DrawBox(W, H);
    SetDrawColor(255, 255, 0, 255);
    X = int(UL_X + GetRangePctByValue(RangeX, ValueX) * W - float(8 / 2));
    Y = int(UL_Y + GetRangePctByValue(RangeY, ValueY) * H - float(8 / 2));
    SetPos(float(X), float(Y));
    DrawRect(8.0, 8.0);
    SetDrawColor(128, 128, 0, 128);
    Draw2DLine(UL_X, float(Y), UL_X + W, float(Y), DrawColor);
    Draw2DLine(float(X), UL_Y, float(X), UL_Y + H, DrawColor);
    SetDrawColor(255, 255, 0, 255);
    SetPos(float(X), UL_Y + H + float(16));
    DrawText(string(ValueX));
    SetPos(UL_X + W + float(8), float(Y));
    DrawText(string(ValueY));
    if (Title != "")
    {
        SetPos(UL_X, UL_Y - float(16));
        DrawText(Title);
    }
}

native final function DrawTextureDoubleLine(Vector StartPoint, Vector EndPoint, float Perc, float Spacing, float Width, Color LineColor, Color AltLineColor, Texture Tex, float U, float V, float UL, float VL)
{
    StartPoint;
    EndPoint;
    Perc;
    Spacing;
    Width;
    LineColor;
    AltLineColor;
    Tex;
    U;
    V;
    UL;
    VL;
}

native final function DrawTextureLine(Vector StartPoint, Vector EndPoint, float Perc, float Width, Color LineColor, Texture LineTexture, float U, float V, float UL, float VL)
{
    StartPoint;
    EndPoint;
    Perc;
    Width;
    LineColor;
    LineTexture;
    U;
    V;
    UL;
    VL;
}

native final function Draw2DLine(float X1, float Y1, float X2, float Y2, Color LineColor)
{
    X1;
    Y1;
    X2;
    Y2;
    LineColor;
}

native final function SetDrawColor(byte R, byte G, byte B, optional byte A = 255)
{
    R;
    G;
    B;
    A;
}

final simulated function DrawBox(float Width, float Height)
{
    local int X, Y;
    
    X = int(CurX);
    Y = int(CurY);
    SetPos(float(X), float(Y));
    DrawRect(2.0, Height);
    SetPos(float(X) + Width - float(2), float(Y));
    DrawRect(2.0, Height);
    SetPos(float(X + 2), float(Y));
    DrawRect(Width - float(4), 2.0);
    SetPos(float(X + 2), float(Y) + Height - float(2));
    DrawRect(Width - float(4), 2.0);
    SetPos(float(X), float(Y));
}

final function DrawRect(float RectX, float RectY, optional Texture Tex = DefaultTexture)
{
    DrawTile(Tex, RectX, RectY, 0.0, 0.0, Tex.GetSurfaceWidth(), Tex.GetSurfaceHeight());
}

final function DrawIconSection(CanvasIcon Icon, float X, float Y, float UStartPct, float VStartPct, float UEndPct, float VEndPct, optional float Scale)
{
    if (Icon.Texture != none)
    {
        if (Scale <= 0.0)
        {
            Scale = 1.0;
        }
        if (Icon.UL == 0.0)
        {
            Icon.UL = Icon.Texture.GetSurfaceWidth();
        }
        if (Icon.VL == 0.0)
        {
            Icon.VL = Icon.Texture.GetSurfaceHeight();
        }
        CurX = X + UStartPct * Icon.UL * Scale;
        CurY = Y + VStartPct * Icon.VL * Scale;
        DrawTile(Icon.Texture, Icon.UL * UEndPct * Scale, Icon.VL * VEndPct * Scale, Icon.U + UStartPct * Icon.UL, Icon.V + VStartPct * Icon.VL, Icon.UL * UEndPct, Icon.VL * VEndPct);
    }
}

final function DrawIcon(CanvasIcon Icon, float X, float Y, optional float Scale)
{
    if (Icon.Texture != none)
    {
        if (Scale <= 0.0)
        {
            Scale = 1.0;
        }
        if (Icon.UL == 0.0)
        {
            Icon.UL = Icon.Texture.GetSurfaceWidth();
        }
        if (Icon.VL == 0.0)
        {
            Icon.VL = Icon.Texture.GetSurfaceHeight();
        }
        CurX = X;
        CurY = Y;
        DrawTile(Icon.Texture, Abs(Icon.UL) * Scale, Abs(Icon.VL) * Scale, Icon.U, Icon.V, Icon.UL, Icon.VL);
    }
}

final function CanvasIcon MakeIcon(Texture Texture, optional float U, optional float V, optional float UL, optional float VL)
{
    local CanvasIcon Icon;
    
    if (Texture != none)
    {
        Icon.Texture = Texture;
        Icon.U = U;
        Icon.V = V;
        Icon.UL = (UL != 0.0 ? UL : Texture.GetSurfaceWidth());
        Icon.VL = (VL != 0.0 ? VL : Texture.GetSurfaceHeight());
    }
    return Icon;
}

final function DrawTexture(Texture Tex, float Scale)
{
    if (Tex != none)
    {
        DrawTile(Tex, Tex.GetSurfaceWidth() * Scale, Tex.GetSurfaceHeight() * Scale, 0.0, 0.0, Tex.GetSurfaceWidth(), Tex.GetSurfaceHeight());
    }
}

final function SetClip(float X, float Y)
{
    ClipX = X;
    ClipY = Y;
}

final function SetOrigin(float X, float Y)
{
    OrgX = X;
    OrgY = Y;
}

native final function SetPos(float PosX, float PosY, optional float PosZ = 1.0)
{
    PosX;
    PosY;
    PosZ;
}

event Reset(optional bool bKeepOrigin)
{
    Font = default.Font;
    if (!bKeepOrigin)
    {
        OrgX = default.OrgX;
        OrgY = default.OrgY;
    }
    CurX = default.CurX;
    CurY = default.CurY;
    DrawColor = default.DrawColor;
    CurYL = default.CurYL;
    bCenter = false;
    bNoSmooth = false;
}

native final function PopTransform()
{
}

native final function PushTranslationMatrix(Vector TranslationVector)
{
    TranslationVector;
}

native final function Matrix GetPerspectiveMatrix()
{
}

native final function Matrix GetViewMatrix()
{
}

native final function Matrix GetProjectionMatrix()
{
}

native final function DeProject(Vector2D ScreenPos, out Vector WorldOrigin, out Vector WorldDirection)
{
    ScreenPos;
    WorldOrigin;
    WorldDirection;
}

native final function Vector Project(Vector Location)
{
    Location;
}

final function DrawTextCentered(coerce string Text, optional bool CR = true, optional float XScale = 1.0, optional float YScale = 1.0, optional const FontRenderInfo RenderInfo = CreateFontRenderInfo(true, true))
{
    local float XL, YL;
    
    TextSize(Text, XL, YL);
    SetPos(CurX - XL / float(2), CurY);
    DrawText(Text, CR, XScale, YScale, RenderInfo);
}

native final function DrawText(coerce string Text, optional bool CR = true, optional float XScale = 1.0, optional float YScale = 1.0, optional out const FontRenderInfo RenderInfo)
{
    Text;
    CR;
    XScale;
    YScale;
    RenderInfo;
}

native final function TextSize(coerce string String, out float XL, out float YL)
{
    String;
    XL;
    YL;
}

native final function StrLen(coerce string String, out float XL, out float YL)
{
    String;
    XL;
    YL;
}

static final function FontRenderInfo CreateFontRenderInfo(optional bool bClipText, optional bool bEnableShadow, optional LinearColor GlowColor, optional Vector2D GlowOuterRadius, optional Vector2D GlowInnerRadius)
{
    local FontRenderInfo Result;
    
    Result.bClipText = bClipText;
    Result.bEnableShadow = bEnableShadow;
    Result.GlowInfo.bEnableGlow = GlowColor.A != 0.0;
    if (Result.GlowInfo.bEnableGlow)
    {
        Result.GlowInfo.GlowOuterRadius = GlowOuterRadius;
        Result.GlowInfo.GlowInnerRadius = GlowInnerRadius;
    }
    return Result;
}

native final function DrawTileStretched(Texture Tex, float XL, float YL, float U, float V, float UL, float VL, LinearColor LColor, optional bool bStretchHorizontally = true, optional bool bStretchVertically = true, optional float ScalingFactor = 1.0)
{
    Tex;
    XL;
    YL;
    U;
    V;
    UL;
    VL;
    LColor;
    bStretchHorizontally;
    bStretchVertically;
    ScalingFactor;
}

native final function DrawRotatedMaterialTile(MaterialInterface Mat, Rotator Rotation, float XL, float YL, optional float U = 0.0, optional float V = 0.0, optional float UL = 0.0, optional float VL = 0.0, optional float AnchorX = 0.5, optional float AnchorY = 0.5)
{
    Mat;
    Rotation;
    XL;
    YL;
    U;
    V;
    UL;
    VL;
    AnchorX;
    AnchorY;
}

native final function DrawRotatedTile(Texture Tex, Rotator Rotation, float XL, float YL, float U, float V, float UL, float VL, optional float AnchorX = 0.5, optional float AnchorY = 0.5)
{
    Tex;
    Rotation;
    XL;
    YL;
    U;
    V;
    UL;
    VL;
    AnchorX;
    AnchorY;
}

native final function DrawMaterialTile(MaterialInterface Mat, float XL, float YL, optional float U, optional float V, optional float UL, optional float VL, optional bool bClipTile)
{
    Mat;
    XL;
    YL;
    U;
    V;
    UL;
    VL;
    bClipTile;
}

native final function DrawTile(Texture Tex, float XL, float YL, float U, float V, float UL, float VL, optional LinearColor LColor, optional bool ClipTile)
{
    Tex;
    XL;
    YL;
    U;
    V;
    UL;
    VL;
    LColor;
    ClipTile;
}

defaultproperties
{
    Font="EngineFonts.SmallFont"
    DrawColor=(B=127,G=127,R=127,A=255)
    ColorModulate=(X=1.0,Y=1.0,Z=1.0,W=1.0)
    DefaultTexture="EngineResources.WhiteSquareTexture"
}
