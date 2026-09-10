/*
	Author: Mallen

	Description:
		Handles what happens when the Delete button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonDeletePressed;
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

_popUpDisplay = _display createDisplay "macp_campaignManagerConfirmDelete";
_text = _popUpDisplay displayCtrl 5341;

_text ctrlSetText ("Are you sure you want to delete " + _selData + "?");

macp_globalExitCode = "NOTSET";

_popUpDisplay displayAddEventHandler ["Unload",
{
	params ["_display", "_exitCode"];
	macp_globalExitCode = _exitCode;
}];

[_selData, _workingHashmap, _display] spawn {
	params ["_selData", "_workingHashmap", "_display"];

	waitUntil {macp_globalExitCode isNotEqualTo "NOTSET";};

	if (macp_globalExitCode isNotEqualTo 1) exitWith {};

	_itemDeleteOptions = ["currentInventory", "personalVault"];

	//delete data
	if (_selData in _itemDeleteOptions) then
	{
		switch (_selData) do
		{
			case "currentInventory":
			{
				//set players inventory to empty
				_workingHashmap set [_selData, [[],[],[],[],[],[],"","",[],["","","","","",""]]];
			};
			case "personalVault":
			{
				//set players vault to empty
				_workingHashmap set [_selData, [[],[],[],[]]];
			};
		};
	} else {
		_workingHashmap deleteAt _selData;
	};
	macp_globalExitCode = nil;
	saveProfileNamespace;

	//update the folder view
	[_display] call macp_core_fnc_updateFileBrowser;
};
