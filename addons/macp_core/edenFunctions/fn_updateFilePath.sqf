/*
	Author: Mallen

	Description:
		Updates the file path with the current file path

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager
		1: STRING - The currently selected item

	Returns:
		None

	Examples:
		[_display, "Current Inventory"] call macp_core_fnc_updateFilePath;
*/
params [["_display", displayNull, [displayNull]], ["_selectedItem", "", [""]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

//used to translate key values to readable names, probably should be replaced by a string table...
_displayNames = createHashMapFromArray [
	["key", "Campaign Key"],
	["players", "Players"],
	["defaultKit", "Default Kit"],
	["defaultEngineerLevel", "Default ACE Engineer Level"],
	["defaultMedicalLevel", "Default ACE Medic Level"],
	["defaultEODStatus", "Default EOD specialist status"],
	["ver", "Save Version"],
	["previousInventorys", "Previous Inventorys"],
	["previousInventory", "Previous Inventory"],
	["storageReason", "Storage Reason"],
	["currentInventory", "Current Inventory"],
	["lastUsedName", "Last Used Name"],
	["personalVault", "Personal Vault"],
	["playerEngineerLevel", "ACE Engineer Level"],
	["playerMedicalLevel", "ACE Medic Level"],
	["playerEODStatus", "EOD specialist status"]
];

//used to determine what buttons (New, Delete, Edit) are available per item selected
_availableOptionsPerItem = createHashMapFromArray [
	["key", [false, false, true]],
	["players", [false, false, true]],
	["defaultKit", [false, false, true]],
	["defaultEngineerLevel", [false, false, true]],
	["defaultMedicalLevel", [false, false, true]],
	["defaultEODStatus", [false, false, true]],
	["ver", [false, false, false]],
	["previousInventorys", [false, false, true]],
	["previousInventory", [false, false, true]],
	["storageReason", [false, false, true]],
	["currentInventory", [false, true, true]],
	["lastUsedName", [false, false, false]],
	["personalVault", [false, true, true]],
	["playerEngineerLevel", [false, false, true]],
	["playerMedicalLevel", [false, false, true]],
	["playerEODStatus", [false, false, true]]
];

//used to determine what buttons (New, Delete, Edit) are available per folder, for folders with unknowable item names
_availableOptionsPerFolder = createHashMapFromArray [
	["root", [true, true, true]],
	["players", [false, true, true]],
	["previousInventorys", [false, true, true]]
];

_listBox = _display displayCtrl 1500;
_filePathText = _display displayCtrl 1002;

//get the file path
_filePath = _display getVariable ["macp_filePath", []];

//get all the campaign data to traverse through
_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;

//used for filling out file browser text
_outputText = "    Home >> ";
_playerUIDNext = false;

//for each step in the file path
{
	//update the new folder we are working in
	_data = _workingHashmap get _x;
	_workingHashmap = _data;

	//get display name of folder
	_displayName = _displayNames getOrDefault [_x, _x];

	//if were expected the player UID make it look pretty to users organicaly
	if (_playerUIDNext) then
	{
		_displayName = (_workingHashMap get "lastUsedName") + " (" + _x + ")";
	};

	//add the >> to signify the next item
	_outputText = _outputText + _displayName + " >> ";

	//if the next folder is for players let the next iteration know
	if (_x isEqualTo "players") then {_playerUIDNext = true;} else {_playerUIDNext = false;};
} forEach _filePath;

//add the selected item as a non-folder at the end of the file path text
_outputText = _outputText + _selectedItem;
_filePathText ctrlSetText _outputText;



//show data on the right
_dataViewerText = _display displayCtrl 1003;

_data = "";

_selectedDataKey = "";

//get the data for the selected item
if ((lbCurSel _listBox) isNotEqualTo -1) then
{
	_selectedDataKey = _listBox lbData (lbCurSel _listBox);

	_data = _workingHashMap getOrDefault [_selectedDataKey, "No Data Found"];
};

//if the data is a hashmap dont show anything
if (typeName _data isEqualTo "HASHMAP") then
{
	_data = "";
};

//if data is not a string make it one
if (typeName _data isNotEqualTo "STRING") then
{
	_data = str _data;
};

_dataViewerText ctrlSetText _data;



//set button availability
_buttonDelete = _display displayCtrl 2402;
_buttonNew = _display displayCtrl 2403;
_buttonEdit = _display displayCtrl 2404;
_buttonExport = _display displayCtrl 2406;

_buttonOptions = _availableOptionsPerItem getOrDefault [_selectedDataKey, [false, false, false]];

//handle if root is the current folder
if (_filePath isEqualTo []) then
{
	_buttonOptions = _availableOptionsPerFolder get "root";
	_buttonExport ctrlEnable true;
} else {
	_buttonOptions = _availableOptionsPerFolder getOrDefault [(_filePath select -1), _buttonOptions];
};

_buttonOptions params ["_buttonNewEnable", "_buttonDeleteEnable", "_buttonEditEnable"];

_buttonDelete ctrlEnable _buttonDeleteEnable;
_buttonNew ctrlEnable _buttonNewEnable;
_buttonEdit ctrlEnable _buttonEditEnable;
