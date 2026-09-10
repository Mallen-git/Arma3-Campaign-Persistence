/*
	Author: Mallen

	Description:
		Handles what happens when the New button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonNewPressed;
*/
params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

//get current folder
_filePath = _display getVariable ['macp_filePath', []];
_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_workingHashmap = _allCampaignData;
_workingDirName = "root";

{
	_workingHashmap = _workingHashmap get _x;
} forEach _filePath;

if (_filePath isNotEqualTo []) then
{
	_workingDirName = _filePath select -1;
};

//there are only 3 areas where we should be putting in new shit, root, players, and previous inventorys
switch (_workingDirName) do
{
	case "root":
	{
		_popUpDisplay = _display createDisplay "macp_campaignManagerSingleValuePopup";
		_title = _popUpDisplay displayCtrl 5340;
		_text = _popUpDisplay displayCtrl 5341;

		_title ctrlSetText "MACP New Campaign";
		_text ctrlSetText "New campaign key?";

		_popUpDisplay displayAddEventHandler ["Unload",
		{
			params ["_display", "_exitCode"];
			if (_exitCode isNotEqualTo 1) exitWith {};
			_text = _display displayCtrl 5342;
			_text = ctrlText _text;
			if (_text isEqualTo "") exitWith {};
			_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
			_allCampaignData set [_text, createHashMapFromArray [["key", _text], ["players", createHashMap], ["defaultKit", [[],[],[],[],[],[],"","",[],["","","","","",""]]]]];
			saveProfileNamespace;

			//update the folder view
			_displayParent = displayParent _display;
			[_displayParent] call macp_core_fnc_updateFileBrowser;
		}]
	};
	case "players":
	{
		//todo: this
	};
	case "previousInventorys":
	{
		//todo: this
	};
};
