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

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveToCurrentInventory ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested save to current inventory with no supplied UID")};

//get the unit for the UID
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//if we are overriding the unit to save the current loadout from then do so
if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

//cant save the loadout of someone without a unit, because they have no loadout
if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested save to current inventory with UID that does not point to a unit")};

//get players inventory
_inventoryToStore = getUnitLoadout _requestedUIDUnit;

//get players profile
_playerProfile = macp_currentCampaignDataServer get "players" get _requestedUID;

_currentInventory = _playerProfile set ["currentInventory", _inventoryToStore];

saveProfileNamespace;
