/*
	Author: Mallen

	Description:
		Handles what happens when the Open Vault button is pressed

	Parameter(s):
		0: DISPLAY - The display used for the admin menu

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonOpenVaultPressed;
*/
params [["_display", displayNull, [displayNull]]];

//no display? how did we get here...
if (isNull _display) exitWith {};

_playerListBox = _display displayCtrl 1500;

if ((lbCurSel _playerListBox) isEqualTo -1) exitWith {};

_playerUID = _playerListBox lbData (lbCurSel _playerListBox);

if (_playerUID isEqualTo "NOSELECTION") exitWith {};

[[_playerUID, player], macp_core_fnc_accessPersonalVault] remoteExec ["call", 2];
