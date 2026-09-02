/*
	Author: Mallen

	Description:
		access contents of personal vault

	Parameter(s):
		0: STRING - UID of player requesting
		1: OBJECT - (Optional, default objNull) Overide the unit the vault is shown to

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_accessPersonalVault;
*/

params [["_requestedUID", "NOTSUPPLIED", [""]], ["_overideUnit", objNull, [objNull]]];

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_accessPersonalVault ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault access with no supplied UID")};

_vault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];

if (isNull _vault) exitWith {};

_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested personal vault access with UID that does not point to a unit")};



_vault enableSimulationGlobal true;
_vault setVehiclePosition [getPos _requestedUIDUnit, [], 0, "CAN_COLLIDE"];
_vault attachTo [_requestedUIDUnit];

[[_vault], macp_core_fnc_clientToldToOpenPersonalVault] remoteExec ['call', _requestedUIDUnit];
