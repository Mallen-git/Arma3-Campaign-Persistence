/*
	Author: Mallen

	Description:
		access contents of personal vault on client side including inventory EHs

	Parameter(s):
		0: OBJECT - vault box to open

	Returns:
		None

	Examples:
		[_vault] call macp_core_fnc_clientToldToOpenPersonalVault;
*/

params [["_vault", objNull, [objNull]]];

//only on client
if (not hasInterface) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_clientToldToOpenPersonalVault ran on server, not client")};

//cannot open a vault that doesnt exist
if (isNull _vault) exitWith {diag_log (text "MACP - ERROR: Told to open personal vault which does not exist")};

//open the vault
player action ["Gear", _vault];

//when the player closes the vault let the server know and remove this EH
player addEventHandler ["InventoryClosed", {
	params ["_unit", "_container"];
	[[_container], macp_core_fnc_closePersonalVault] remoteExec ["call", 2];
	player removeEventHandler [_thisEvent, _thisEventHandler];
}];
