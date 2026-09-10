/*
	Author: Mallen

	Description:
		Handles personal vault access locations

	Parameter(s):
		0: MODULE - The module logic

	Returns:
		None

	Examples:
		[_logic] call macp_core_fnc_restrictPersonalVaultModule;
*/

params ["_logic"];

if (isNil "macp_restrictPersonalVaultAreas") then
{
	macp_restrictPersonalVaultAreas = [];
};

macp_restrictPersonalVaultAreas pushBack _logic;
