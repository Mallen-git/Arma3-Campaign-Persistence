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
