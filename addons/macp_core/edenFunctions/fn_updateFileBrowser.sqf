/*
	Author: Mallen

	Description:
		Updates the file browser with the current file path

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_updateFileBrowser;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

//used to translate key values to readable names, probably should be replaced by a string table...
_displayNames = createHashMapFromArray [
	["key", "Campaign Key"],
	["players", "Players"],
	["defaultKit", "Default Kit"],
	["ver", "Save Version"],
	["previousInventorys", "Previous Inventorys"],
	["previousInventory", "Previous Inventory"],
	["storageReason", "Storage Reason"],
	["currentInventory", "Current Inventory"],
	["lastUsedName", "Last Used Name"],
	["personalVault", "Personal Vault"]
];

_listBox = _display displayCtrl 1500;
_filePathText = _display displayCtrl 1002;

//get the file path
_filePath = _display getVariable ['macp_filePath', []];

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

	//if we're expected the player UID make it look pretty to users organicaly
	if (_playerUIDNext) then
	{
		_displayName = (_workingHashMap get "lastUsedName") + " (" + _x + ")";
	};

	//add the >> to signify the next item
	_outputText = _outputText + _displayName + ' >> ';

	//if the next folder is for players let the next iteration know
	if (_x isEqualTo "players") then {_playerUIDNext = true;} else {_playerUIDNext = false;};
} forEach _filePath;

//if the last value in the file path is not a hashmap then delete it from the file path and save
if (typeName _workingHashMap isNotEqualTo "HASHMAP") exitWith
{
	_filePath deleteAt [-1];
	_display setVariable ['macp_filePath', _filePath];
};

_filePathText ctrlSetText _outputText;

//clear everything in the folder
lbClear _listBox;

//add everything in the new folder with display names to look pretty and "..." for folders
{
	_displayName = _displayNames getOrDefault [_x, _x];

	if (_playerUIDNext) then
	{
		_displayName = (_y get "lastUsedName") + " (" + _x + ")";
	};

	if (typeName _y isEqualTo "HASHMAP") then
	{
		_displayName = _displayName + "...";
	};

	_added = _listBox lbAdd _displayName;
	_listBox lbSetData [_added, _x];
} forEach _workingHashmap;

//make sure nothing is selected
_listBox lbSetCurSel -1;

//if we are at the root then make sure the new button is allowed
_allowNew = false;
if (_filePath isEqualTo []) then
{
	_allowNew = true;
};

//disable all buttons until something is selected
_buttonDelete = _display displayCtrl 2402;
_buttonNew = _display displayCtrl 2403;
_buttonEdit = _display displayCtrl 2404;
_buttonExport = _display displayCtrl 2406;

_buttonDelete ctrlEnable false;
_buttonNew ctrlEnable _allowNew;
_buttonEdit ctrlEnable false;
_buttonExport ctrlEnable false;
