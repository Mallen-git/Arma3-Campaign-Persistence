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

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_initPersonalVault ran on client, not server")};

if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault init with no supplied UID")};

_existingVault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];

if (not isNull _existingVault) exitWith {};

_defaultKit = macp_currentCampaignData getOrDefault ["defaultKit", [[],[],[],[],[],[],"","",[],["","","","","",""]], true];

//get players profile
_allPlayerProfiles = macp_currentCampaignData getOrDefault ["players", createHashMap, true];
_playerProfile = _allPlayerProfiles getOrDefault [_requestedUID, createHashMapFromArray [["currentInventory", _defaultKit], ["previousInventorys", createHashMap], ["personalVault", [[],[],[],[]]]], true];
_personalVault = _playerProfile getOrDefault ["personalVault", [[],[],[],[]], true];

_personalVault params ["_containers", "_weapons", "_mags", "_items"];

_vault = createVehicle ["VirtualReammoBox_F", [10,0,0], [], 0, "CAN_COLLIDE"];
_vault hideObjectGlobal true;
_vault allowDamage false;


//_containers = [["B_Bergen_mcamo_F", [[/*weapons*/], [/*mags*/], [/*items*/]]],    ["B_Bergen_mcamo_F", [[/*weapons*/], [/*mags*/], [/*items*/]]]];
//_weapons = [["arifle_ARX_blk_F","ACE_muzzle_mzls_H","ACE_DBAL_A3_Green","optic_DMS",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],"bipod_02_F_arid"], ["arifle_ARX_blk_F","ACE_muzzle_mzls_H","ACE_DBAL_A3_Green","optic_DMS",["30Rnd_65x39_caseless_green",30],["10Rnd_50BW_Mag_F",10],"bipod_02_F_arid"]];
//_mags = [["30Rnd_65x39_caseless_mag",30],  ["30Rnd_65x39_caseless_mag",30],  ["Chemlight_green",1]];
//_items = ["ItemGPS","ItemRadio","ItemCompass"];
//fill vault


{
	_container = _x select 0;
	_vault addBackpackCargoGlobal [_container, 1];
	_vault addItemCargoGlobal [_container, 1];
} forEach _containers;

_containerObjects = everyContainer _vault;

{
	_classname = _x select 0;
	_containerObject = _x select 1;
	_containerInventory = _containers select _forEachIndex select 1;

	_containerInventory params ["_containerWeapons", "_containerMags", "_containerItems"];
	{
		_containerObject addWeaponWithAttachmentsCargoGlobal [_x, 1];
	} forEach _containerWeapons;

	{
		_containerObject addMagazineAmmoCargo [_x select 0, 1, _x select 1]
	} forEach _containerMags;

	{
		_containerObject addItemCargoGlobal [_x, 1];
		_containerObject addBackpackCargoGlobal [_x, 1];
	} forEach _containerItems;

} forEach _containerObjects;

{
	_vault addWeaponWithAttachmentsCargoGlobal [_x, 1];
} forEach _weapons;

{
	_vault addMagazineAmmoCargo [_x select 0, 1, _x select 1]
} forEach _mags;

{
	_vault addItemCargoGlobal [_x, 1];
} forEach _items;

_vault enableSimulationGlobal false;

//vault is full, set for later
macp_personalVaultLists set [_requestedUID, _vault];

//clean up and save any defaults that were set
_allPlayerProfiles set [_requestedUID, _playerProfile];
macp_currentCampaignData set ["players", _allPlayerProfiles];
[] call macp_core_fnc_saveCampaign;
