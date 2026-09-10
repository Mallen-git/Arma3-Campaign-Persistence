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
if (isNull _display) exitWith {};

_displayNames = createHashMapFromArray [["key", "Campaign Key"], ["players", "Players"], ["defaultKit", "Default Kit"], ["previousInventorys", "Previous Inventorys"], ["previousInventory", "Previous Inventory"], ["storageReason", "Storage Reason"], ["currentInventory", "Current Inventory"], ["lastUsedName", "Last Used Name"], ["personalVault", "Personal Vault"]];
_availableOptionsPerItem = createHashMapFromArray [["key", [false, false, true]], ["players", [false, false, true]], ["defaultKit", [false, false, true]], ["previousInventorys", [false, false, true]], ["previousInventory", [false, false, true]], ["storageReason", [false, false, true]], ["currentInventory", [false, true, true]], ["lastUsedName", [false, false, false]], ["personalVault", [false, true, true]]];
_availableOptionsPerFolder = createHashMapFromArray [["root", [true, true, true]], ["players", [false, true, true]], ["previousInventorys", [false, true, true]]];

_listBox = _display displayCtrl 1500;
_filePathText = _display displayCtrl 1002;

_filePath = _display getVariable ['macp_filePath', []];

_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;

_outputText = "    Home >> ";
_playerUIDNext = false;
{
	_prevHashmap = _workingHashMap;

	_data = _workingHashmap get _x;
	_workingHashmap = _data;

	_displayName = _displayNames getOrDefault [_x, _x];

	if (_playerUIDNext) then
	{
		_displayName = (_workingHashMap get "lastUsedName") + " (" + _x + ")";
	};

	_outputText = _outputText + _displayName + ' >> ';

	if (_x isEqualTo "players") then {_playerUIDNext = true;} else {_playerUIDNext = false;};
} forEach _filePath;

_outputText = _outputText + _selectedItem;
_filePathText ctrlSetText _outputText;



//show data on the right
_dataViewerText = _display displayCtrl 1003;

_data = "";

_selectedDataKey = "";

if ((lbCurSel _listBox) isNotEqualTo -1) then
{
	_selectedDataKey = _listBox lbData (lbCurSel _listBox);

	_data = _workingHashMap getOrDefault [_selectedDataKey, "No Data Found"];
};

if (typeName _data isEqualTo "HASHMAP") then
{
	_data = "";
};

if (typeName _data isNotEqualTo "STRING") then
{
	_data = str _data;
};

_dataViewerText ctrlSetText _data;



//set button availability
_buttonDelete = _display displayCtrl 2402;
_buttonNew = _display displayCtrl 2403;
_buttonEdit = _display displayCtrl 2404;

_buttonOptions = _availableOptionsPerItem getOrDefault [_selectedDataKey, [false, false, false]];
if (_filePath isEqualTo []) then
{
	_buttonOptions = _availableOptionsPerFolder get "root";
} else {
	_buttonOptions = _availableOptionsPerFolder getOrDefault [(_filePath select -1), _buttonOptions];
};

_buttonOptions params ["_buttonNewEnable", "_buttonDeleteEnable", "_buttonEditEnable"];

_buttonDelete ctrlEnable _buttonDeleteEnable;
_buttonNew ctrlEnable _buttonNewEnable;
_buttonEdit ctrlEnable _buttonEditEnable;
