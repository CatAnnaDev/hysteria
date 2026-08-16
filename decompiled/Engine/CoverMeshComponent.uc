class CoverMeshComponent extends StaticMeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native CoverMeshes
{
    var StaticMesh Base;
    var StaticMesh LeanLeft;
    var StaticMesh LeanRight;
    var StaticMesh Climb;
    var StaticMesh Mantle;
    var StaticMesh SlipLeft;
    var StaticMesh SlipRight;
    var StaticMesh SwatLeft;
    var StaticMesh SwatRight;
    var StaticMesh PopUp;
    var StaticMesh PlayerOnly;
};

var editoronly array<CoverMeshes> Meshes;
var Vector LocationOffset;
var editoronly StaticMesh AutoAdjustOn;
var editoronly StaticMesh AutoAdjustOff;
var editoronly StaticMesh Disabled;

defaultproperties
{
    Meshes(0)=(Base="NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL",LeanLeft="None",LeanRight="None",Climb="None",Mantle="None",SlipLeft="None",SlipRight="None",SwatLeft="None",SwatRight="None",PopUp="None",PlayerOnly="None")
    Meshes(1)=(Base="NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL",LeanLeft="NodeBuddies.3D_Icons.NodeBuddy_LeanLeftS",LeanRight="NodeBuddies.3D_Icons.NodeBuddy_LeanRightS",Climb="None",Mantle="None",SlipLeft="NodeBuddies.3D_Icons.NodeBuddy_CoverSlipLeft",SlipRight="NodeBuddies.3D_Icons.NodeBuddy_CoverSlipRight",SwatLeft="NodeBuddies.3D_Icons.NodeBuddy_SwatLeft",SwatRight="NodeBuddies.3D_Icons.NodeBuddy_SwatRight",PopUp="None",PlayerOnly="NodeBuddies.3D_Icons.NodeBuddy_PlayerOnlyS")
    Meshes(2)=(Base="NodeBuddies.3D_Icons.NodeBuddy__BASE_SHORT",LeanLeft="NodeBuddies.3D_Icons.NodeBuddy_LeanLeftM",LeanRight="NodeBuddies.3D_Icons.NodeBuddy_LeanRightM",Climb="NodeBuddies.3D_Icons.NodeBuddy_Climb",Mantle="NodeBuddies.3D_Icons.NodeBuddy_Mantle",SlipLeft="NodeBuddies.3D_Icons.NodeBuddy_CoverSlipLeft",SlipRight="NodeBuddies.3D_Icons.NodeBuddy_CoverSlipRight",SwatLeft="NodeBuddies.3D_Icons.NodeBuddy_SwatLeft",SwatRight="NodeBuddies.3D_Icons.NodeBuddy_SwatRight",PopUp="NodeBuddies.3D_Icons.NodeBuddy_PopUp",PlayerOnly="NodeBuddies.3D_Icons.NodeBuddy_PlayerOnlyM")
    LocationOffset=(X=0.0,Y=0.0,Z=-60.0)
    AutoAdjustOn="NodeBuddies.3D_Icons.NodeBuddy_AutoAdjust"
    AutoAdjustOff="NodeBuddies.3D_Icons.NodeBuddy_AutoAdjustOff"
    Disabled="NodeBuddies.3D_Icons.NodeBuddy_Enabled"
    StaticMesh="NodeBuddies.3D_Icons.NodeBuddy__BASE_TALL"
    ReplacementPrimitive="None"
    HiddenGame=True
    bAcceptsStaticDecals=False
    bAcceptsDynamicDecals=False
    CastShadow=False
    bAcceptsLights=False
    CollideActors=False
    BlockActors=False
    BlockZeroExtent=False
    BlockNonZeroExtent=False
    BlockRigidBody=False
    AlwaysLoadOnClient=False
    AlwaysLoadOnServer=False
}
