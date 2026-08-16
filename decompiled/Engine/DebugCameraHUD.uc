class DebugCameraHUD extends HUD
    notplaceable
    transient
    config(Game)
    hidecategories(Navigation);

event PostRender()
{
    local DebugCameraController DCC;
    local float XL, YL, X, Y;
    local string MyText;
    local Vector CamLoc, ZeroVec;
    local Rotator CamRot;
    local TraceHitInfo HitInfo;
    local Actor HitActor;
    local MeshComponent MeshComp;
    local Vector HitLoc, HitNormal;
    local bool bFoundMaterial;
    
    PostRender();
    DCC = DebugCameraController(PlayerOwner);
    if (DCC != none)
    {
        Canvas.SetDrawColor(0, 0, 255, 255);
        MyText = "DebugCameraHUD";
        Canvas.Font = class'Engine'.static.GetSmallFont();
        Canvas.StrLen(MyText, XL, YL);
        X = float(Canvas.SizeX) * 0.05;
        Y = YL;
        YL += float(2) * Y;
        Canvas.SetPos(X, YL);
        Canvas.DrawText(MyText, true);
        Canvas.SetDrawColor(128, 128, 128, 255);
        CamLoc = DCC.PlayerCamera.CameraCache.POV.Location;
        CamRot = DCC.PlayerCamera.CameraCache.POV.Rotation;
        YL += Y;
        Canvas.SetPos(X, YL);
        Canvas.DrawText("CamLoc:" $ string(CamLoc) @ "CamRot:" $ string(CamRot));
        HitActor = Trace(HitLoc, HitNormal, vector(CamRot) * float(5000) * float(20) + CamLoc, CamLoc, true, ZeroVec, HitInfo);
        if (HitActor != none)
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("HitLoc:" $ string(HitLoc) @ "HitNorm:" $ string(HitNormal));
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("HitActor: '" $ string(HitActor.Name) $ "'");
            bFoundMaterial = false;
            if (HitInfo.Material != none)
            {
                YL += Y;
                Canvas.SetPos(X + Y, YL);
                Canvas.DrawText("Material:" $ string(HitInfo.Material.Name));
                bFoundMaterial = true;
            }
            else if (HitInfo.HitComponent != none)
            {
                bFoundMaterial = DisplayMaterials(X, YL, Y, MeshComponent(HitInfo.HitComponent));
            }
            else
            {
                foreach HitActor.AllOwnedComponents(class'MeshComponent', MeshComp)
                {
                    bFoundMaterial = bFoundMaterial || DisplayMaterials(X, YL, Y, MeshComp);
                }
            }
            if (bFoundMaterial == false)
            {
                YL += Y;
                Canvas.SetPos(X + Y, YL);
                Canvas.DrawText("Material: NONE");
            }
            DrawDebugLine(HitLoc, HitLoc + HitNormal * float(30), 255, 255, 231);
        }
        else
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("Not trace hit");
        }
        if (DCC.bShowSelectedInfo == true && DCC.SelectedActor != none)
        {
            YL += Y;
            Canvas.SetPos(X, YL);
            Canvas.DrawText("Selected actor: '" $ string(DCC.SelectedActor.Name) $ "'");
            DisplayMaterials(X, YL, Y, MeshComponent(DCC.SelectedComponent));
        }
    }
}

function bool DisplayMaterials(float X, out float Y, float DY, MeshComponent MeshComp)
{
    local int MaterialIndex;
    local bool bDisplayedMaterial;
    local MaterialInterface Material;
    
    bDisplayedMaterial = false;
    if (MeshComp != none)
    {
        for (MaterialIndex = 0; MaterialIndex < MeshComp.GetNumElements(); ++MaterialIndex)
        {
            Material = MeshComp.GetMaterial(MaterialIndex);
            if (Material != none)
            {
                Y += DY;
                Canvas.SetPos(X + DY, Y);
                Canvas.DrawText("Material: '" $ string(Material.Name) $ "'");
                bDisplayedMaterial = true;
            }
        }
    }
    return bDisplayedMaterial;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    bHidden=False
}
