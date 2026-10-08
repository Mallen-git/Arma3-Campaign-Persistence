/*
	Author: Mallen

	Description:
		Provides the unit requested the default medical level based on the servers knowledge

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the level is put on

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_provideDefaultMedicalLevel;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_provideDefaultMedicalLevel ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested default medical level with no supplied UID")};

//get the unit for the UID
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//if we are overriding the unit to give the medical level to then do so
if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

//cant give the medical level to someone without a unit
if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested default medical level with UID that does not point to a unit")};

//get default medical level
_defaultMedicalLevel = macp_currentCampaignDataServer get "defaultMedicalLevel";

//set medical level in data
macp_currentCampaignDataServer get "players" get _requestedUID set ["playerMedicalLevel", _defaultMedicalLevel];

//if allowed, set medical level on unit
if (macp_setMedicalLevel) then
{
	_requestedUIDUnit setVariable ["ace_medical_medicClass", _defaultMedicalLevel, true];
};
