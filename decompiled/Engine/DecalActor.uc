class DecalActor extends DecalActorBase
    native
    placeable
    hidecategories(Navigation);

var bool bSonarActive;
var bool bSonarActor;

simulated event Destroyed()
{
    Destroyed();
    if (bSonarActor)
    {
        WorldInfo.GetLocalPlayerPawn().Controller.RemoveSonarDetectedActor(self);
    }
}

function updateSonarMat(float DeltaTime)
{
}

event Tick(float DeltaTime)
{
    updateSonarMat(DeltaTime);
}

function setSonarActor(bool bIsSonar)
{
    bSonarActor = bIsSonar;
}

function CreateAndSetSonarMat()
{
    local MaterialInstanceConstant MatInst, newInstance;
    
    if (Decal == none)
    {
        return;
    }
    MatInst = MaterialInstanceConstant(Decal.GetDecalMaterial());
    if (MatInst != none && MatInst.bSonarMaterial)
    {
        newInstance = new(self) class'MaterialInstanceConstant';
        newInstance.SetParent(MatInst.Parent);
        newInstance.initSonarParam(MatInst);
        Decal.SetDecalMaterial(newInstance);
        setSonarActor(true);
        WorldInfo.GetLocalPlayerPawn().Controller.AddSonarDetectedActor(self);
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    CreateAndSetSonarMat();
}

defaultproperties
{
    bSonarActive=True
    Decal="Default__DecalActor.NewDecalComponent"
    Components(0)="Default__DecalActor.NewDecalComponent"
    Components(1)="Default__DecalActor.Sprite"
    Components(2)="Default__DecalActor.ArrowComponent0"
}
