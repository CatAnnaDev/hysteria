class TargetPoint extends Keypoint
    native
    placeable
    hidecategories(Navigation);

var transient editoronly Texture2D SpawnSpriteTexture;
var transient int SpawnRefCount;

defaultproperties
{
    SpawnSpriteTexture="EditorMaterials.TargetIconSpawn"
    SpriteComp="Default__TargetPoint.Sprite"
    bStatic=False
    bNoDelete=True
    Components(0)="Default__TargetPoint.Sprite"
    Components(1)="Default__TargetPoint.Arrow"
}
