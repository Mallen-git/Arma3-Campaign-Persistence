/*
	Author: Mallen

	Description:
		Handles what happens when the Import button is pressed on the campaign manager

	Parameter(s):
		0: DISPLAY - The display used for the campaign manager

	Returns:
		None

	Examples:
		[_display] call macp_core_fnc_buttonImportPressed;
*/
params [["_display", displayNull, [displayNull]]];

if (isNull _display) exitWith {};

_display createDisplay "macp_campaignManagerImport";
