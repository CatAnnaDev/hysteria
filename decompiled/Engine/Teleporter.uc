class Teleporter extends NavigationPoint
    native
    placeable
    hidecategories(Navigation,Lighting,LightColor,Force);

var() repretry string URL;
var() name ProductRequired;
var() repretry bool bChangesVelocity;
var() repretry bool bChangesYaw;
var() repretry bool bReversesX;
var() repretry bool bReversesY;
var() repretry bool bReversesZ;
var() repretry bool bEnabled;
var() bool bCanTeleportVehicles;
var() repretry Vector TargetVelocity;
var float LastFired;

replication
{
    if (Role == 3)
        URL, bEnabled;
    if (bNetInitial && Role == 3)
        bChangesVelocity, bChangesYaw, bReversesX, bReversesY, bReversesZ, TargetVelocity;
}

event Actor SpecialHandling(Pawn Other)
{
    if (bEnabled && Other.Controller.RouteCache.Length > 1 && Teleporter(Other.Controller.RouteCache[1]) != none && string(Other.Controller.RouteCache[1].Tag) ~= URL)
    {
        if (IsOverlapping(Other))
        {
            PostTouch(Other);
        }
        return self;
    }
    return none;
}

simulated event PostTouch(Actor Other)
{
    local Teleporter D, Dest[16];
    local int I;
    
    if (InStr(URL, "/") >= 0 || InStr(URL, "#") >= 0)
    {
        if (Role == 3 && Pawn(Other) != none && Pawn(Other).IsHumanControlled())
        {
            WorldInfo.Game.SendPlayer(PlayerController(Pawn(Other).Controller), URL);
        }
    }
    else
    {
        foreach AllActors(class'Teleporter', D)
        {
            if (string(D.Tag) ~= URL && D != self)
            {
                Dest[I] = D;
                I++;
                if (I > 16)
                {
                    break;
                }
            }
        }
        I = Rand(I);
        if (Dest[I] != none)
        {
            if (Other.IsA('Pawn'))
            {
                Other.PlayTeleportEffect(true, true);
            }
            Dest[I].Accept(Other, self);
        }
    }
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (!bEnabled || Other == none)
    {
        return;
    }
    if (CanTeleport(Other) && !Other.PreTeleport(self))
    {
        PendingTouch = Other.PendingTouch;
        Other.PendingTouch = self;
    }
}

simulated event bool Accept(Actor Incoming, Actor Source)
{
    local Rotator NewRot, oldRot;
    local float Mag;
    local Vector oldDir;
    local Controller C;
    
    if (Incoming == none)
    {
        return false;
    }
    Disable('Touch');
    NewRot = Incoming.Rotation;
    if (bChangesYaw)
    {
        oldRot = Incoming.Rotation;
        NewRot.Yaw = Rotation.Yaw;
        if (Source != none)
        {
            NewRot.Yaw += 32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw;
        }
    }
    if (Pawn(Incoming) != none)
    {
        if (Role == 3)
        {
            foreach WorldInfo.AllControllers(class'Controller', C)
            {
                if (C.Enemy == Incoming)
                {
                    C.EnemyJustTeleported();
                }
            }
        }
        if (!Pawn(Incoming).SetLocation(Location))
        {
            LogInternal(string(self) $ " Teleport failed for " $ string(Incoming));
            return false;
        }
        if (Role == 3 || WorldInfo.TimeSeconds - LastFired > 0.5)
        {
            NewRot.Roll = 0;
            Pawn(Incoming).SetRotation(NewRot);
            Pawn(Incoming).SetViewRotation(NewRot);
            Pawn(Incoming).ClientSetRotation(NewRot);
            LastFired = WorldInfo.TimeSeconds;
        }
        if (Pawn(Incoming).Controller != none)
        {
            Pawn(Incoming).Controller.MoveTimer = -1.0;
            Pawn(Incoming).SetAnchor(self);
            Pawn(Incoming).SetMoveTarget(self);
        }
        Incoming.PlayTeleportEffect(false, true);
    }
    else
    {
        if (!Incoming.SetLocation(Location))
        {
            Enable('Touch');
            return false;
        }
        if (bChangesYaw)
        {
            Incoming.SetRotation(NewRot);
        }
    }
    Enable('Touch');
    if (bChangesVelocity)
    {
        Incoming.Velocity = TargetVelocity;
    }
    else
    {
        if (bChangesYaw)
        {
            if (Incoming.Physics == 1)
            {
                oldRot.Pitch = 0;
            }
            oldDir = vector(oldRot);
            Mag = Incoming.Velocity Dot oldDir;
            Incoming.Velocity = Incoming.Velocity - Mag * oldDir + Mag * vector(Incoming.Rotation);
        }
        if (bReversesX)
        {
            Incoming.Velocity.X *= -1.0;
        }
        if (bReversesY)
        {
            Incoming.Velocity.Y *= -1.0;
        }
        if (bReversesZ)
        {
            Incoming.Velocity.Z *= -1.0;
        }
    }
    Incoming.PostTeleport(self);
    return true;
}

event PostBeginPlay()
{
    if (URL ~= "")
    {
        SetCollision(false, false);
    }
    PostBeginPlay();
}

native function bool CanTeleport(Actor A)
{
    A;
}

defaultproperties
{
    bChangesYaw=True
    bEnabled=True
    CylinderComponent="Default__Teleporter.CollisionCylinder"
    GoodSprite="Default__Teleporter.Sprite"
    BadSprite="Default__Teleporter.Sprite2"
    bCollideActors=True
    Components(0)="Default__Teleporter.Sprite"
    Components(1)="Default__Teleporter.Sprite2"
    Components(2)="Default__Teleporter.Arrow"
    Components(3)="Default__Teleporter.CollisionCylinder"
    Components(4)="Default__Teleporter.PathRenderer"
    RemoteRole="ROLE_SimulatedProxy"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Teleporter.CollisionCylinder"
}
