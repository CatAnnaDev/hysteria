class GameVehicle extends SVehicle
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    StayUprightConstraintSetup="Default__GameVehicle.MyStayUprightSetup"
    StayUprightConstraintInstance="Default__GameVehicle.MyStayUprightConstraintInstance"
    Mesh="Default__GameVehicle.SVehicleMesh"
    CylinderComponent="Default__GameVehicle.CollisionCylinder"
    bCanBeAdheredTo=True
    bCanBeFrictionedTo=True
    Components(0)="Default__GameVehicle.CollisionCylinder"
    Components(1)="Default__GameVehicle.SVehicleMesh"
    CollisionComponent="Default__GameVehicle.SVehicleMesh"
}
