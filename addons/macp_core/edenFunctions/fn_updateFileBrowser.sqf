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

if (isNull _display) exitWith {};

_displayNames = createHashMapFromArray [["key", "Campaign Key"], ["players", "Players"], ["defaultKit", "Default Kit"], ["ver", "Save Version"], ["previousInventorys", "Previous Inventorys"], ["previousInventory", "Previous Inventory"], ["storageReason", "Storage Reason"], ["currentInventory", "Current Inventory"], ["lastUsedName", "Last Used Name"], ["personalVault", "Personal Vault"]];

_listBox = _display displayCtrl 1500;
_filePathText = _display displayCtrl 1002;

_filePath = _display getVariable ['macp_filePath', []];

_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;

_outputText = "    Home >> ";
_playerUIDNext = false;
{
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

if (typeName _workingHashMap isNotEqualTo "HASHMAP") exitWith
{
	_filePath deleteAt [-1];
	_display setVariable ['macp_filePath', _filePath];
};

_filePathText ctrlSetText _outputText;

lbClear _listBox;

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

_listBox lbSetCurSel -1;

_allowNew = false;
if (_filePath isEqualTo []) then
{
	_allowNew = true;
};

_buttonDelete = _display displayCtrl 2402;
_buttonNew = _display displayCtrl 2403;
_buttonEdit = _display displayCtrl 2404;
_buttonExport = _display displayCtrl 2406;

_buttonDelete ctrlEnable false;
_buttonNew ctrlEnable _allowNew;
_buttonEdit ctrlEnable false;
_buttonExport ctrlEnable false;
