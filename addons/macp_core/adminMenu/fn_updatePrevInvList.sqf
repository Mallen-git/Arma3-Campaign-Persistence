/*
	Author: Mallen

	Description:
		Updates the previous inventories list based on player selected

	Parameter(s):
		0: DISPLAY - The display used for the admin menu

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_updatePrevInvList;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

_playerListBox = _display displayCtrl 1500;
_prevInvListBox = _display displayCtrl 1501;

//get player profile
_allPlayerProfiles = macp_currentCampaignDataClient get "players";
_ourPlayerProfile = _allPlayerProfiles getOrDefault [(_playerListBox lbData (lbCurSel _playerListBox)), "NONEFOUND"];

lbClear _prevInvListBox;

//if no valid profile found leave
if (_ourPlayerProfile isEqualTo "NONEFOUND") exitWith {};

//get previous inventories and show in list box
_prevInventories = _ourPlayerProfile get "previousInventorys";
{
	_lbAdd = _prevInvListBox lbAdd _x;
	_prevInvListBox lbSetData [_lbAdd, _x];
} forEach _prevInventories;
