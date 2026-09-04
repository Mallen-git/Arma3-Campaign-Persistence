/*
	Author: Mallen

	Description:
		Provides the unit requested the default loadout based on the servers knowledge

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the loadout is put on

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_provideDefaultLoadout;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_provideDefaultLoadout ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested default loadout with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested default loadout with UID that does not point to a unit")};

//get default kit incase of new player
_defaultKit = macp_currentCampaignData get "defaultKit";

//get players profile
_allPlayerProfiles = macp_currentCampaignData get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;
_playerProfile set ["currentInventory", _defaultKit];

//set inventory
_requestedUIDUnit setUnitLoadout _defaultKit;

saveProfileNamespace;
