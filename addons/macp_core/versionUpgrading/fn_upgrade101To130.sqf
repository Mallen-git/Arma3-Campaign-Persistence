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
params[["_saveFile", createHashMap, [createHashMap]]];

_playerList = _saveFile getOrDefault ["players", "NONEFOUND"];
if (_playerList isEqualTo "NONEFOUND") exitWith {};
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
	_y set ["playerEODStatus", false];
	_y set ["medicalStatus", "{""ace_medical_openwounds"": {}, ""ace_medical_bloodpressure"": [80, 120], ""ace_medical_ivbags"": null, ""ace_medical_inpain"": false, ""ace_medical_medications"": [], ""ace_medical_tourniquets"": [0, 0, 0, 0, 0, 0], ""ace_medical_heartrate"": 80, ""ace_medical_pain"": 0, ""ace_medical_bloodvolume"": 6, ""ace_medical_stitchedwounds"": {}, ""ace_medical_fractures"": [0, 0, 0, 0, 0, 0], ""ace_medical_triagelevel"": 0, ""ace_medical_bodypartdamage"": [0, 0, 0, 0, 0, 0], ""ace_medical_hemorrhage"": 0, ""ace_medical_occludedmedications"": null, ""ace_medical_triagecard"": [], ""ace_medical_bandagedwounds"": {}, ""ace_medical_peripheralresistance"": 100, ""ace_medical_painsuppress"": 0, ""ace_medical_statemachinestate"": ""Default""}"];
} forEach _playerList;

_saveFile set ["ver", [1,3,0]];
_saveFile set ["defaultEngineerLevel", 0];
_saveFile set ["defaultMedicalLevel", 0];
_saveFile set ["defaultEODStatus", false];
