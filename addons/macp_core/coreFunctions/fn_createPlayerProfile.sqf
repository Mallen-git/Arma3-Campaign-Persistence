/*
	Author: Mallen

	Description:
		checks if player has a profile, if not, creates the players profile with the default kit set as their current loadout and name set

	Parameter(s):
		0: STRING - UID of player requesting

	Returns:
		None

	Examples:
		[player] call macp_core_fnc_createPlayerProfile;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_createPlayerProfile ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested create player profile with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

_allPlayerProfiles = macp_currentCampaignData get "players";

if (_requestedUID in _allPlayerProfiles) exitWith {};

_defaultKit = macp_currentCampaignData get "defaultKit";

if (not macp_defaultKit) then
{
	_defaultKit = getUnitLoadout player;
};

_defaultPlayerProfileArray = [
	["lastUsedName", "NONEFOUND"],
	["currentInventory", _defaultKit],
	["previousInventorys", createHashMap],
	["personalVault", [[],[],[],[]]]
];

_playerProfile = createHashMapFromArray _defaultPlayerProfileArray;

if (isNull _requestedUIDUnit) then
{
	diag_log (text "MACP - Warning: Requested new player profile without a player object, name will not be correct")
} else {
	_playerProfile set ["lastUsedName", name _requestedUIDUnit];
};

_allPlayerProfiles set [_requestedUID, _playerProfile];
