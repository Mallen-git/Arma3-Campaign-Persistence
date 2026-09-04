/*
	Author: Mallen

	Description:
		Provides the unit requested their current loadout based on the servers knowledge

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the loadout is put on

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_provideCurrentLoadout;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_provideCurrentLoadout ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested current loadout with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested current loadout with UID that does not point to a unit")};

//get players profile
_allPlayerProfiles = macp_currentCampaignData get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;
_currentInventory = _playerProfile get "currentInventory";

//set inventory
_requestedUIDUnit setUnitLoadout _currentInventory;

saveProfileNamespace;
