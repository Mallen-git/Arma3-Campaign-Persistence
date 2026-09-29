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

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_accessPersonalVault ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault access with no supplied UID")};

//get the vault of the requested player
_vault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];

//if no vault then attempt to init it
if (isNull _vault) then
{
	[_requestedUID] call macp_core_fnc_initPersonalVault;
	_vault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];
};

//get the unit trying to open the vault
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;
_requestedUIDUnitForError = _requestedUIDUnit;

//override if needed (ie admin checking vault)
if (not isNull _overideUnit) then
{
	_requestedUIDUnit = _overideUnit;
};

//need a unit to open the vault for
if (isNull _requestedUIDUnit) exitWith {diag_log (text "MACP - ERROR: Requested personal vault access with UID that does not point to a unit")};

//check if vault is already opened by someone else
if (not (isNull attachedTo _vault)) exitWith
{
	if (_requestedUIDUnitForError isEqualTo _requestedUIDUnit) then
	{
		["Your personnal vault is already opened by an admin, please ask them to close it before you can access it"] remoteExec ["hint", _requestedUIDUnit];
	} else {
		["Personnal vault is already opened by the player that owns it, please ask them to close it before you can access it"] remoteExec ["hint", _requestedUIDUnit];
	};
	diag_log (text "MACP - ERROR: Requested personal vault is already open by another player")
};

if (not (isNull objectParent _requestedUIDUnit)) exitWith {["Cannot access personal vault inside of a vehicle"] remoteExec ["hint", _requestedUIDUnit];};

//grab the vault from storage and attach it to player
_vault enableSimulationGlobal true;
_vault setVehiclePosition [getPos _requestedUIDUnit, [], 0, "CAN_COLLIDE"];
_vault attachTo [_requestedUIDUnit];

//tell player the vault is ready to open
[[_vault], macp_core_fnc_clientToldToOpenPersonalVault] remoteExec ["call", _requestedUIDUnit];
