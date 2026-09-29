/*
	Author: Mallen

	Description:
		Sets the unit requested's loadout to the one supplied, applys to character if possible

	Parameter(s):
		0: STRING - UID of player requesting
		1: ARRAY - Loadout array to apply

	Returns:
		None

	Examples:
		["123456789", _loadout] call macp_core_fnc_setCurrentLoadout;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]], ["_loadout", "NOTSUPPLIED", [[]]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_setCurrentLoadout ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested set current loadout with no supplied UID")};

//need a loadout to work with
if (_loadout isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested set current loadout with no supplied loadout")};

//get players profile
_allPlayerProfiles = macp_currentCampaignDataServer get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;
_currentInventory = _playerProfile set ["currentInventory", _loadout];

//get the unit for the UID
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//check player is online before setting unit
if (not isNull _requestedUIDUnit) then
{
	//set inventory
	[_requestedUID] call macp_core_fnc_provideCurrentLoadout;
} else {
	//providing loadout should save on success, if we aren't setting loadout save here instead
	saveProfileNamespace;
};
