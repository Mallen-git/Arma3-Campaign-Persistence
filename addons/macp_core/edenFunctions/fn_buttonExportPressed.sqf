/*
	Author: Mallen

	Description:
		Handles what happens when the Export button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonExportPressed;
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

//get which campaign has been selected
_allCampaignData = profileNamespace getVariable ["macp_clientAllCampaignData", createHashMap];
_dataToExtract = _allCampaignData get _selData;

//open 3dens inbuilt copy display and show to user for them to copy
uiNamespace setVariable ["display3DENCopy_data", [(_selData + " Campaign Export"), str(_dataToExtract)]];
_display createDisplay "display3denCopy";
