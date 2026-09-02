/*
	Author: Mallen

	Description:
		saves all players kits annd vaults, saves to profile namespace

	Parameter(s):
		None

	Returns:
		None

	Examples:
		call macp_core_fnc_saveAllKitsAndVaults;
*/

if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveAllKitsAndVaults ran on client, not server")};

_allPlayerProfiles = macp_currentCampaignData getOrDefault ["players", createHashMap, true];

{
	_playerUID = _x;
	_playerProfile = _y;

	[_playerUID] call macp_core_fnc_savePersonalVault;

	_playerUnit = _playerUID call BIS_fnc_getUnitByUID;

	if (isNull _playerUnit) then {continue;};

	_playerLoadout = getUnitLoadout _playerUnit;

	_playerProfile set ["currentInventory", _playerLoadout];

	_allPlayerProfiles set [_x, _playerProfile];

} forEach _allPlayerProfiles;

macp_currentCampaignData set ["players", _allPlayerProfiles];
[] call macp_core_fnc_saveCampaign;
