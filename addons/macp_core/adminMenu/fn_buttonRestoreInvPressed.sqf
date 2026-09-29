/*
	Author: Mallen

	Description:
		Handles what happens when the Restore Inventory button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the admin menu

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonRestoreInvPressed;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

_playerListBox = _display displayCtrl 1500;
_prevInvListBox = _display displayCtrl 1501;

if ((lbCurSel _playerListBox) isEqualTo -1) exitWith {};

if ((lbCurSel _prevInvListBox) isEqualTo -1) exitWith {};

_playerUID = _playerListBox lbData (lbCurSel _playerListBox);

if (_playerUID isEqualTo "NOSELECTION") exitWith {};

_prevInventoryKey = _prevInvListBox lbData (lbCurSel _prevInvListBox);

_loadout = macp_currentCampaignDataClient get "players" get _playerUID get "previousInventorys" get _prevInventoryKey get "previousInventory";

[[_playerUID, _loadout], macp_core_fnc_setCurrentLoadout] remoteExec ["call", 2];
