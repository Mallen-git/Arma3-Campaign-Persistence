/*
	Author: Mallen

	Description:
		close a personal vault and send back to storage

	Parameter(s):
		0: OBJECT - vault box to open

	Returns:
		None

	Examples:
		[_vault] call macp_core_fnc_closePersonalVault;
*/

params [["_vault", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_closePersonalVault ran on client, not server")};

if (isNull _vault) exitWith {diag_log (text "MACP - ERROR: Requested personal vault closing with no supplied vault")};

_ownerUID = "NOTSUPPLIED";
{
	if (_y isEqualTo _vault) then
	{
		_ownerUID = _x;
	};
} forEach macp_personalVaultLists;

if (_ownerUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault closing on a vault without an owner (or not a vault at all)")};

detach _vault;
_vault enableSimulationGlobal false;
_vault setVehiclePosition [[10,0,0], [], 0, "CAN_COLLIDE"];

[_ownerUID] call macp_core_fnc_savePersonalVault;
