class OnlinePlaylistProvider extends UIResourceDataProvider
    notplaceable
    transient
    perobjectconfig
    config(Playlist)
    hidecategories(Object,UIRoot);

var config int PlaylistId;
var config array<name> PlaylistGameTypeNames;
var const config localized string DisplayName;
var config bool bIsArbitrated;
var config int Priority;

defaultproperties
{
}
