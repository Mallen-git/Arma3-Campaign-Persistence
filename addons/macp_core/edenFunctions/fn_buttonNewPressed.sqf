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

//no display? how did we get here...
if (isNull _display) exitWith {};

//get current folder
_filePath = _display getVariable ["macp_filePath", []];
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
		//open the display to change a single value and fill in the needed text
		_popUpDisplay = _display createDisplay "macp_campaignManagerSingleValuePopup";
		_title = _popUpDisplay displayCtrl 5340;
		_text = _popUpDisplay displayCtrl 5341;

		_title ctrlSetText "MACP New Campaign";
		_text ctrlSetText "New campaign key?";

		//when the display is closed do some stuff
		_popUpDisplay displayAddEventHandler ["Unload",
		{
			params ["_display", "_exitCode"];

			//if not an acceptance then leave
			if (_exitCode isNotEqualTo 1) exitWith {};

			//get inputted key
			_text = _display displayCtrl 5342;
			_text = ctrlText _text;

			//if key is empty dont save this
			if (_text isEqualTo "") exitWith {};

			//create the blank campaign
			_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
			profileNamespace setVariable ["macp_clientAllCampaignData", _allCampaignData];
			_allCampaignData set [_text, createHashMapFromArray [["key", _text], ["players", createHashMap], ["defaultKit", [[],[],[],[],[],[],"","",[],["","","","","",""]]], ["ver", [1,0,1]]]];
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
