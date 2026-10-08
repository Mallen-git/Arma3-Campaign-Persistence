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

//no display? how did we get here...
if (isNull _display) exitWith {};

_listBox = _display displayCtrl 1500;

//get what was selected
_selIndx = lbCurSel _listBox;

//if nothing selected exit
if (_selIndx isEqualTo -1) exitWith {};

_selData = _listBox lbData _selIndx;

//get current folder
_filePath = _display getVariable ["macp_filePath", []];
_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;

{
	_workingHashmap = _workingHashmap get _x;
} forEach _filePath;

//these items can be opened in the ace arsenal for editing
_arsenalItems = ["currentInventory", "defaultKit", "previousInventory"];

//if the selected data is an aresnal item
if (_selData in _arsenalItems) then
{
	//global variable to detect when the aresenal is closed
	macp_arsenalClosed = false;

	//dont show were creating the dummy unit to aresenal on to
	ignore3DENHistory {
		macp_dummy = create3DENEntity ["Object", "B_Soldier_F", [0,0,100000]];
	};

	//get the current kit assigned to the key
	_value = _workingHashmap get _selData;

	[_display, _value] spawn
	{
		params ["_display", "_value"];
		//close the UI
		_display closeDisplay 1;

		//wait until we are back in the eden interface
		waitUntil {not (isNull (findDisplay 313))};

		//set the dummys loadout to the current value
		macp_dummy setUnitLoadout _value;

		//set the dummy as selected for ace to save the kit to after editing
		ignore3DENHistory {
			set3DENSelected [macp_dummy];
		};

		//open the aresenal for the dummy
		[macp_dummy, macp_dummy, true] call ace_arsenal_fnc_openBox;
	};

	//detect when the aresenal is closed
	_ehID = ["ace_arsenal_displayClosed", {macp_arsenalClosed = true;}] call CBA_fnc_addEventHandler;

	[_ehID, _workingHashmap, _selData, _filePath] spawn
	{
		params["_ehID", "_workingHashmap", "_selData", "_filePath"];

		waitUntil {macp_arsenalClosed};

		//get the loadout saved to the dummy and save it to the key
		_unitLoadout = getUnitLoadout macp_dummy;
		_workingHashMap set [_selData, _unitLoadout];

		//delete the dummy
		ignore3DENHistory {
			delete3DENEntities [macp_dummy];
		};

		//remove the event handeler and clean up global variables
		["ace_arsenal_displayClosed", _ehID] call CBA_fnc_removeEventHandler;
		macp_arsenalClosed = nil;
		macp_dummy = nil;

		//open the campaign manager back to the place it was previously
		[_filePath] call macp_core_fnc_openCampaignManager;
	};

//selected data is NOT an aresenal item
} else {
	_value = _workingHashmap get _selData;

	//if its a hashmap we just want to go to its folder structure, not actually edit it
	if (typeName _value isEqualTo "HASHMAP") exitWith
	{
		_filePath pushBack _selData;
		_display setVariable ["macp_filePath", _filePath];
		[_display] call macp_core_fnc_updateFileBrowser;
	};

	//if they are changing campaign key handle it differently as many things need to happen
	if (_selData isEqualTo "key") then
	{
		//open the display to change a single value and fill in the needed text and default values
		_popUpDisplay = _display createDisplay "macp_campaignManagerSingleValuePopup";
		_title = _popUpDisplay displayCtrl 5340;
		_text = _popUpDisplay displayCtrl 5341;
		_txtValue = _popUpDisplay displayCtrl 5342;

		_title ctrlSetText "MACP Edit Campaign Key";
		_text ctrlSetText "New campaign key?";
		_txtValue ctrlSetText _value;

		//used to preserve locality, get the new value and exit code when pop-up closes
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

			//if we didnt confirm them leave
			if (macp_globalExitCode isNotEqualTo 1) exitWith {};

			//get all campaign data
			_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];

			//set the new key as needed, delete the old entry as no longer needed
			_allCampaignData set [macp_globalValue, _workingHashmap];
			_workingHashmap set ["key", macp_globalValue];
			_allCampaignData deleteAt _value;

			//cleanup global variables
			macp_globalExitCode = nil;
			macp_globalValue = nil;
			saveProfileNamespace;

			//update the folder view
			_display setVariable ["macp_filePath", []];
			[_display] call macp_core_fnc_updateFileBrowser;
		};
	};

	if (_selData in ["defaultEngineerLevel", "defaultMedicalLevel", "playerEngineerLevel", "playerMedicalLevel"]) then
	{
		//open the display to change a single value and fill in the needed text and default values
		_popUpDisplay = _display createDisplay "macp_campaignManagerSingleValuePopup";
		_title = _popUpDisplay displayCtrl 5340;
		_text = _popUpDisplay displayCtrl 5341;
		_txtValue = _popUpDisplay displayCtrl 5342;

		_title ctrlSetText "MACP Edit Engineer or Medical Value";
		_text ctrlSetText "New value? (must be 0, 1, or 2)";
		_txtValue ctrlSetText (str _value);

		//used to preserve locality, get the new value and exit code when pop-up closes
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

		[_selData, _workingHashmap, _display] spawn {
			params ["_selData", "_workingHashmap", "_display"];

			waitUntil {macp_globalExitCode isNotEqualTo "NOTSET"};

			//if we didnt confirm them leave
			if (macp_globalExitCode isNotEqualTo 1) exitWith {};

			//make sure number is either 0, 1, or 2 with nothing else in string
			_valid = macp_globalValue regexMatch "^\s*[0-2]\s*$";
			if (not _valid) exitWith {};

			//parse new value
			_usableValue = parseNumber macp_globalValue;

			//set new data
			_workingHashmap set [_selData, _usableValue];

			//cleanup global variables
			macp_globalExitCode = nil;
			macp_globalValue = nil;
			saveProfileNamespace;

			//update the folder view
			[_display] call macp_core_fnc_updateFileBrowser;
		};
	};
};
