/*
	Author: Mallen

	Description:
		edits the custom value for the given UID

	Parameter(s):
		0: STRING - UID of player requesting
		1: STRING - a list of all actions to be created
		2: NUMBER - the new value to be assigned to the data

	Returns:
		None

	Examples:
		["123456789", "Money", 1234] call macp_core_fnc_receiveCustomValues;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_valueName", "NOTSUPPLIED", [""]], ["_newValue", "NOTSUPPLIED", [0]]];

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no supplied UID")};

//need a value name to work with
if (_valueName isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no supplied value name")};

//need a new value to work with
if (_newValue isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no new value")};

if (isServer) then
{
	macp_currentCampaignDataServer get "players" get _requestedUID get "customValues" get _valueName set ["value", _newValue];
};

if (hasInterface) then
{
	macp_currentCampaignDataClient get "players" get _requestedUID get "customValues" get _valueName set ["value", _newValue];
};
