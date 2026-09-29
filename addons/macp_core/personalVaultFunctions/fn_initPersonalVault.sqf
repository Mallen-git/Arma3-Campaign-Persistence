/*
	Author: Mallen

	Description:
		Creates personal vault for future use by player if required

	Parameter(s):
		0: STRING - UID of player requesting

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_initPersonalVault;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_initPersonalVault ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault init with no supplied UID")};

//check if vault has already been created, if yes then exit
_existingVault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];
if (not isNull _existingVault) exitWith {};

//get players profile
_personalVault = macp_currentCampaignDataServer get "players" get _requestedUID get "personalVault";

//get item types in the vault
_personalVault params ["_containers", "_weapons", "_mags", "_items"];

//create the actual vault, hide it, and put it in storage
_vault = createVehicle ["VirtualReammoBox_F", [10,0,0], [], 0, "CAN_COLLIDE"];
_vault hideObjectGlobal true;
_vault allowDamage false;

//fill vault with containers
{
	_container = _x select 0;
	//adds backpack if backpack, otherwise adds as item
	_vault addBackpackCargoGlobal [_container, 1];
	_vault addItemCargoGlobal [_container, 1];
} forEach _containers;

//get every container just added to vault
_containerObjects = everyContainer _vault;

{
	_classname = _x select 0;
	_containerObject = _x select 1;

	//get the contents that should be in the container
	_containerInventory = _containers select _forEachIndex select 1;

	_containerInventory params ["_containerWeapons", "_containerMags", "_containerItems"];

	//add weapons
	{
		_containerObject addWeaponWithAttachmentsCargoGlobal [_x, 1];
	} forEach _containerWeapons;

	//add mags
	{
		_containerObject addMagazineAmmoCargo [_x select 0, 1, _x select 1]
	} forEach _containerMags;

	//add general items or more backpacks (recursion limited to one just like inventorys)
	{
		_containerObject addItemCargoGlobal [_x, 1];
		_containerObject addBackpackCargoGlobal [_x, 1];
	} forEach _containerItems;

} forEach _containerObjects;

//add weapons
{
	_vault addWeaponWithAttachmentsCargoGlobal [_x, 1];
} forEach _weapons;

//add mags
{
	_vault addMagazineAmmoCargo [_x select 0, 1, _x select 1]
} forEach _mags;

//add other items
{
	_vault addItemCargoGlobal [_x, 1];
} forEach _items;

//disable its imulation to keep performance high
_vault enableSimulationGlobal false;

//vault is full, set for later
macp_personalVaultLists set [_requestedUID, _vault];
