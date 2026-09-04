/*
	Author: Mallen

	Description:
		Stores players inventory in currentInventory

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the loadout is grabbed from

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_saveCurrentInventory;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveToCurrentInventory ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested save to current inventory with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested save to current inventory with UID that does not point to a unit")};


_inventoryToStore = getUnitLoadout _requestedUIDUnit;

//get players profile
_allPlayerProfiles = macp_currentCampaignData get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;

_currentInventory = _playerProfile set ["currentInventory", _inventoryToStore];

saveProfileNamespace;
