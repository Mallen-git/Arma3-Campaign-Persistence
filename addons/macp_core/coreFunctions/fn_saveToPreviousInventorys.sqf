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

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_storageReason", "UNKNOWN", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveToPreviousInventorys ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested save to previous inventorys with no supplied UID")};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested save to previous inventorys with UID that does not point to a unit")};


_inventoryToStore = getUnitLoadout _requestedUIDUnit;

//get players weapons that fly off them on death
if (_storageReason isEqualTo "DEATH") then
{
	_weaponHolders = getCorpseWeaponholders _requestedUIDUnit;
	_weaponHolders params ["_primaryWeaponHolder", "_secondaryWeaponHolder"];
	if (not isNull _primaryWeaponHolder) then
	{
		_primaryWeaponHolderWeapons = weaponsItemsCargo _primaryWeaponHolder;
		_inventoryToStore set [0, (_primaryWeaponHolderWeapons select 0)];
	};
	if (not isNull _secondaryWeaponHolder) then
	{
		_secondaryWeaponHolderWeapons = weaponsItemsCargo _secondaryWeaponHolder;
		_inventoryToStore set [1, (_secondaryWeaponHolderWeapons select 0)];
	};
};

//get players profile
_allPlayerProfiles = macp_currentCampaignData get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;

//store corpse loadout in previous deaths
_data = ["%4:%5:%6, %3-%2-%1"];
_data append systemTimeUTC;

_currentTimestamp = format _data;
_previousInventorys = _playerProfile get "previousInventorys";
_previousInventorys set [_currentTimestamp, createHashMapFromArray [["storageReason", _storageReason], ["previousInventory", _inventoryToStore]]];

saveProfileNamespace;

