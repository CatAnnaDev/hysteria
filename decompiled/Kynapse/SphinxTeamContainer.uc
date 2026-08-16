class SphinxTeamContainer extends Actor
    native
    placeable
    hidecategories(Navigation);

enum ESphinxTeamContainerType
{
    ESTCT_NormalFightTeam,
    ESTCT_SwarmFightTeam,
};

var() name TeamName;
var() ESphinxTeamContainerType TeamType;

defaultproperties
{
    Components(0)="Default__SphinxTeamContainer.Sprite"
    CollisionType="COLLIDE_CustomDefault"
}
