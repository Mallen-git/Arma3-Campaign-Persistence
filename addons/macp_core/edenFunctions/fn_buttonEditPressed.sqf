/*
	Author: Mallen

	Description:
		Handles what happens when the Edit button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonEditPressed;
*/
params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

_listBox = _display displayCtrl 1500;

//get what was selected
_selIndx = lbCurSel _listBox;

if (_selIndx isEqualTo -1) exitWith {};

_selData = _listBox lbData _selIndx;

//get current folder
_filePath = _display getVariable ['macp_filePath', []];
_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;

{
	_workingHashmap = _workingHashmap get _x;
} forEach _filePath;

_arsenalItems = ["currentInventory", "defaultKit"];

if (_selData in _arsenalItems) then
{
	macp_arsenalClosed = false;
	ignore3DENHistory {
		macp_dummy = create3DENEntity ["Object", "B_Soldier_F", [0,0,100000]];
	};
	_value = _workingHashmap get _selData;

	[_display, _value] spawn
	{
		params ["_display", "_value"];

		_display closeDisplay 1;

		waitUntil {not (isNull (findDisplay 313))};

		macp_dummy setUnitLoadout _value;

		ignore3DENHistory {
			set3DENSelected [macp_dummy];
		};

		[macp_dummy, macp_dummy, true] call ace_arsenal_fnc_openBox;
	};

	_ehID = ["ace_arsenal_displayClosed", {macp_arsenalClosed = true;}] call CBA_fnc_addEventHandler;

	[_ehID, _value] spawn
	{
		params["_ehID"];

		waitUntil {macp_arsenalClosed};

		test = getUnitLoadout macp_dummy;

		ignore3DENHistory {
			delete3DENEntities [macp_dummy];
		};

		["ace_arsenal_displayClosed", _ehID] call CBA_fnc_removeEventHandler;
		macp_arsenalClosed = nil;
		macp_dummy = nil;
	};

} else {
	_value = _workingHashmap get _selData;

	//if its a hashmap we just want to go to its folder structure
	if (typeName _value isEqualTo "HASHMAP") exitWith
	{
		_filePath pushBack _selData;
		_display setVariable ['macp_filePath', _filePath];
		[_display] call macp_core_fnc_updateFileBrowser;
	};

	//if they are changing campaign key?
	if (_selData isEqualTo "key") then
	{
		_popUpDisplay = _display createDisplay "macp_campaignManagerSingleValuePopup";
		_title = _popUpDisplay displayCtrl 5340;
		_text = _popUpDisplay displayCtrl 5341;
		_txtValue = _popUpDisplay displayCtrl 5342;

		_title ctrlSetText "MACP Edit Campaign Key";
		_text ctrlSetText "New campaign key?";
		_txtValue ctrlSetText _value;

		macp_globalExitCode = "NOTSET";
		macp_globalValue = "";
		_popUpDisplay displayAddEventHandler ["Unload",
		{
			params ["_display", "_exitCode"];
			_txtValue = _display displayCtrl 5342;
			_value = ctrlText _txtValue;
			macp_globalExitCode = _exitCode;
			macp_globalValue = _value;
		}];

		[_value, _workingHashmap, _display] spawn {
			params ["_value", "_workingHashmap", "_display"];

			waitUntil {macp_globalExitCode isNotEqualTo "NOTSET"};

			if (macp_globalExitCode isNotEqualTo 1) exitWith {};

			_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];

			_allCampaignData set [macp_globalValue, _workingHashmap];
			_workingHashmap set ["key", macp_globalValue];
			_allCampaignData deleteAt _value;

			macp_globalExitCode = nil;
			macp_globalValue = nil;
			saveProfileNamespace;

			//update the folder view
			_display setVariable ['macp_filePath', []];
			[_display] call macp_core_fnc_updateFileBrowser;
		};
	} else {
		//change a value? no examples atm to use
	};
};
