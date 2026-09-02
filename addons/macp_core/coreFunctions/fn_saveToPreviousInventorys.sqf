/*
	Author: Mallen

	Description:
		Stores players inventory in previousInventorys for admin tracking

	Parameter(s):
		0: STRING - UID of player requesting
		1: STRING - (Optional, default "DEATH") the reason we are saving the inventory
		2: OBJECT - (Optional, default objNull) Overide the unit the loadout is grabbed from

	Returns:
		None

	Examples:
		["123456789", "DEATH"] call macp_core_fnc_saveToPreviousInventorys;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_storageReason", "DEATH", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveToPreviousInventorys ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested save to previous inventorys with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested save to previous inventorys with UID that does not point to a unit")};


_inventoryToStore = getUnitLoadout _requestedUIDUnit;

_defaultKit = macp_currentCampaignData getOrDefault ["defaultKit", [[],[],[],[],[],[],"","",[],["","","","","",""]], true];

//get players profile
_allPlayerProfiles = macp_currentCampaignData getOrDefault ["players", createHashMap, true];
_playerProfile = _allPlayerProfiles getOrDefault [_requestedUID, createHashMapFromArray [["currentInventory", _defaultKit], ["previousInventorys", createHashMap], ["personalVault", [[],[],[],[]]]], true];

//store corpse loadout in previous deaths
_currentTimestamp = systemTimeUTC;
_previousInventorys = _playerProfile getOrDefault ["previousInventorys", createHashMap];
_previousInventorys set [_currentTimestamp, [_storageReason, _inventoryToStore]];

//clean up and save any defaults that were set
_playerProfile set ["previousInventorys", _previousInventorys];
_allPlayerProfiles set [_requestedUID, _playerProfile];
macp_currentCampaignData set ["players", _allPlayerProfiles];
[] call macp_core_fnc_saveCampaign;

