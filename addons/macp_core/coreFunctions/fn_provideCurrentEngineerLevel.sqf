/*
	Author: Mallen

	Description:
		Provides the unit requested their current engineer level based on the servers knowledge

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the level is put on

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_provideCurrentEngineerLevel;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_provideCurrentEngineerLevel ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested current engineer level with no supplied UID")};

//get the unit for the UID
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//if we are overriding the unit to give the current engineer level to then do so
if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

//cant give the engineer level to someone without a unit
if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested current engineer level with UID that does not point to a unit")};

//get current engineer level
_currentEngineerLevel = macp_currentCampaignDataServer get "players" get _requestedUID get "playerEngineerLevel";

//if allowed, set current engineer level on unit
if (macp_setEngineerLevel) then
{
	_requestedUIDUnit setVariable ["ace_isEngineer", _currentEngineerLevel, true];
};
