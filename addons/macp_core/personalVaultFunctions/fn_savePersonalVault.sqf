/*
	Author: Mallen

	Description:
		saves contents of personal vault

	Parameter(s):
		0: STRING - UID of player requesting

	Returns:
		None

	Examples:
		["123456789"] call macp_core_fnc_savePersonalVault;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_savePersonalVault ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested personal vault save with no supplied UID")};

//get requested vault to save, if none found just exit
_vault = macp_personalVaultLists getOrDefault [_requestedUID, objNull];
if (isNull _vault) exitWith {};

//get players profile
_allPlayerProfiles = macp_currentCampaignData get "players";
_playerProfile = _allPlayerProfiles get _requestedUID;

//check if sim is enabled on the vault, if its not, then enable it for inventory reading
_simAlreadyEnabled = false;
if (simulationEnabled _vault) then
{
	_simAlreadyEnabled = true;
} else {
	_vault enableSimulationGlobal true;
};


_containers = [];
_weapons = weaponsItemsCargo _vault;
_mags = magazinesAmmoCargo _vault;
_items = itemCargo _vault;

//containers, mags, and weapons show in _items as well as their own variables, this is used to track whats in the other variables and remove them from the _items
_classnamesToRemove = [];

{
	_classname = _x select 0;
	_containerObject = _x select 1;

	_containerWeapons = weaponsItemsCargo _containerObject;
	_containerMags = magazinesAmmoCargo _containerObject;
	_containerItems = itemCargo _containerObject;

	//same as the scope up, to remove duplicates
	_classnamesToRemoveContainer = [];
	{
		_classnamesToRemoveContainer pushBack (_x select 0);
	} forEach _containerWeapons;
	{
		_classnamesToRemoveContainer pushBack (_x select 0);
	} forEach _containerMags;

	//remove duplicate items
	{
		_index = _containerItems find _x;
		if (_index != -1) then
		{
			_containerItems deleteAt _index;
		};
	} forEach _classnamesToRemoveContainer;

	//add container to variable and duplicate list
	_containers pushBack [_classname, [_containerWeapons, _containerMags, _containerItems]];
	_classnamesToRemove pushBack _classname;

} forEach (everyContainer _vault);

{
	_classnamesToRemove pushBack (_x select 0);
} forEach _weapons;
{
	_classnamesToRemove pushBack (_x select 0);
} forEach _mags;

//remove duplicates
{
	_index = _items find _x;
	if (_index != -1) then
	{
		_Items deleteAt _index;
	};
} forEach _classnamesToRemove;

//maintain sim status from before saving
if (not _simAlreadyEnabled) then
{
	_vault enableSimulationGlobal false;
};

//update personal vault contents and save
_playerProfile set ["personalVault", [_containers, _weapons, _mags, _items]];
saveProfileNamespace;
