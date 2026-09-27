/*
	Author: Mallen

	Description:
		Handles what happens when the Import button is pressed on the import manager

	Parameter(s):
		0: DISPLAY - The display used for the Import tool

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonImportActualPressed;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

_textCtrl = _display displayCtrl 1006;
_errorCtrl = _display displayCtrl 1007;

//get input text
_text = ctrlText _textCtrl;

//check the import is valid campaign data
_output = [_text] call macp_core_fnc_validateStringInput;

//if it is a string then its not valid data and in fact an error, show to user
if ((typeName _output) isEqualTo "STRING") exitWith {_errorCtrl ctrlSetText ("*** ERROR *** " + _output);};

_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];

_key = _output get "key";
_workingKey = _key;
_errorSet = false;

//if key is already in the data then the imported is a duplicate, handle this
if (_key in _allCampaignData) then
{
	//keep going through copy numbers until an unused one is found
	_counter = 1;
	while { _workingKey in _allCampaignData } do
	{
		_workingKey = (_key + ".copy." + str(_counter));
		_counter = _counter + 1;
	};
	_errorCtrl ctrlSetText ('*** WARNING *** Campaign with this key already exists, saved as "' + _workingKey + '"');
	_output set ["key", _workingKey];
} else {
	_errorCtrl ctrlSetText ('Campaign imported and saved as "' + _workingKey + '"');
};

_allCampaignData set [_workingKey, _output];
saveProfileNamespace;

//update the folder view
_displayParent = displayParent _display;
[_displayParent] call macp_core_fnc_updateFileBrowser;
