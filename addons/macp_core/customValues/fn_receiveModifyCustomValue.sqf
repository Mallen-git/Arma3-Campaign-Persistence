/*
	Author: Mallen

	Description:
		edits the custom value for the given UID

	Parameter(s):
		0: STRING - UID of player requesting
		1: STRING - Name of the value to modify
		2: NUMBER - the new value to be assigned to the data (or amount to add if _addToExisting is true)
		3: BOOL - (Optional, default false) Whether to add the value to the existing balance instead of overwriting

	Returns:
		None

	Examples:
		["123456789", "Money", 1234] call macp_core_fnc_receiveModifyCustomValue;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_valueName", "NOTSUPPLIED", [""]], ["_newValue", "NOTSUPPLIED", [0]], ["_addToExisting", false, [false]]];

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no supplied UID")};

//need a value name to work with
if (_valueName isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no supplied value name")};

//need a new value to work with
if (_newValue isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested modify custom value with no new value")};

if (isServer) then
{
	_valueHashmap = macp_currentCampaignDataServer get "players" get _requestedUID get "customValues" get _valueName;
	if (_addToExisting) then
	{
		_currentValue = _valueHashmap getOrDefault ["value", 0];
		_valueHashmap set ["value", (_currentValue + _newValue)];
	} else {
		_valueHashmap set ["value", _newValue];
	};
};

if (hasInterface) then
{
	_valueHashmap = macp_currentCampaignDataClient get "players" get _requestedUID get "customValues" get _valueName;
	if (_addToExisting) then
	{
		_currentValue = _valueHashmap getOrDefault ["value", 0];
		_valueHashmap set ["value", (_currentValue + _newValue)];
	} else {
		_valueHashmap set ["value", _newValue];
	};
};
