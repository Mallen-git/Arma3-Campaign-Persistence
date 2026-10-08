/*
	Author: Mallen

	Description:
		Upgrades campaign data of version 1.0.1 to 1.3.0

	Parameter(s):
		0: HASHMAP - Hashmap of campaign data

	Returns:
		None

	Examples:
		[_hashmap] call macp_core_fnc_upgrade101To130;
*/
params[["_saveFile", objNull, [createHashMap]]];

_playerList = _saveFile getOrDefault ["players", objNull];
if (isNull _playerList) exitWith {};
if (typeName _playerList isNotEqualTo "HASHMAP") exitWith {};

_anyNotHashmaps = false;
{
	if (typeName _y isNotEqualTo "HASHMAP") then
	{
		_anyNotHashmaps = true;
		break;
	};
} forEach _playerList;

if (_anyNotHashmaps) exitWith {};

{
	_y set ["playerEngineerLevel", 0];
	_y set ["playerMedicalLevel", 0];
} forEach _playerList;

_saveFile set ["ver", [1,3,0]];
_saveFile set ["defaultEngineerLevel", 0];
_saveFile set ["defaultMedicalLevel", 0];
