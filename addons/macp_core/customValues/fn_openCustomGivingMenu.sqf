/*
	Author: Mallen

	Description:
		opens the menu to give a custom amount of a value to a player

	Parameter(s):
		0: OBJECT - Target we are giving the value to
		1: STRING - Name of the value we are giving

	Returns:
		None

	Examples:
		[_player, "Monopoly Money"] call macp_core_fnc_openCustomGivingMenu;
*/

params [["_target", objNull, [objNull]], ["_valueName", "NOTSUPPLIED", [""]]];

//only on client
if (not hasInterface) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_openCustomGivingMenu ran on server, not client")};

//need a target to work with
if (isNull _target) exitWith {diag_log (text "MACP - ERROR: Requested open custom giving menu with no target")};

//need a value name to work with
if (_valueName isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested open custom giving menu with no supplied value name")};

//open menu as dialog to force controls on it
_display = createDialog ["macp_customGivingMenu", true];
if (isNull _display) exitWith {diag_log (text "MACP - ERROR: Failed to create custom giving menu dialog")};

_title = _display displayCtrl 5340;
_text = _display displayCtrl 5341;
_txtValue = _display displayCtrl 5342;

//get player's current balance for this custom value
_playerUID = getPlayerUID player;
_myCurrentValue = macp_currentCampaignDataClient get "players" get _playerUID get "customValues" get _valueName get "value";

//populate dialog fields
_title ctrlSetText (format ["Give %1", _valueName]);
_text ctrlSetText (format ["Give %1 to %2 (Current balance: %3)", _valueName, name _target, _myCurrentValue]);
_txtValue ctrlSetText "0";

//used to preserve locality, get the new value and exit code when pop-up closes
macp_globalExitCode = "NOTSET";
macp_globalValue = "";
_display displayAddEventHandler ["Unload",
{
	params ["_display", "_exitCode"];
	_txtValue = _display displayCtrl 5342;
	_value = ctrlText _txtValue;
	macp_globalExitCode = _exitCode;
	macp_globalValue = _value;
}];

[{ macp_globalExitCode isNotEqualTo "NOTSET" }, {
	params ["_target", "_valueName", "_myCurrentValue", "_playerUID"];

	//if we didnt confirm then leave
	if (macp_globalExitCode isNotEqualTo 1) exitWith {
		macp_globalExitCode = nil;
		macp_globalValue = nil;
	};

	_inputString = macp_globalValue;
	macp_globalExitCode = nil;
	macp_globalValue = nil;

	//target must still be valid and alive
	if ((isNull _target) or (not (alive _target))) exitWith {};

	//make sure input is a valid positive number
	_valid = _inputString regexMatch "^\s*[0-9]+(\.[0-9]+)?\s*$";
	if (not _valid) exitWith {};

	_amountToGive = parseNumber _inputString;
	if (_amountToGive <= 0) exitWith {};

	//make sure player has enough to give
	if (_amountToGive > _myCurrentValue) exitWith {
		hint format ["You cannot give %1 %2, you only have %3.", _amountToGive, _valueName, _myCurrentValue];
	};

	//deduct from giver's balance and update locally and on server
	_myNewValue = _myCurrentValue - _amountToGive;
	[_playerUID, _valueName, _myNewValue] call macp_core_fnc_receiveModifyCustomValue;
	[[_playerUID, _valueName, _myNewValue], macp_core_fnc_receiveModifyCustomValue] remoteExec ["call", 2];

	//send new value for recipient through fn_receiveModifyCustomValue (adding to existing balance)
	_targetUID = getPlayerUID _target;
	[[_targetUID, _valueName, _amountToGive, true], macp_core_fnc_receiveModifyCustomValue] remoteExec ["call", 2];
	[[_targetUID, _valueName, _amountToGive, true], macp_core_fnc_receiveModifyCustomValue] remoteExec ["call", _target];

}, [_target, _valueName, _myCurrentValue, _playerUID]] call CBA_fnc_waitUntilAndExecute;
