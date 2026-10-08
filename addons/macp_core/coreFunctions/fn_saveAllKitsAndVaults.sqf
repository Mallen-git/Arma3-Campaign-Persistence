/*
	Author: Mallen

	Description:
		saves all players kits and vaults, saves to profile namespace

	Parameter(s):
		None

	Returns:
		None

	Examples:
		call macp_core_fnc_saveAllKitsAndVaults;
*/

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_saveAllKitsAndVaults ran on client, not server")};

//get all current players profiles
_allPlayerProfiles = macp_currentCampaignDataServer get "players";

{
	_playerUID = _x;
	_playerProfile = _y;

	//save players vault (handles people not on server gracefully)
	[_playerUID] call macp_core_fnc_savePersonalVault;

	_playerUnit = _playerUID call BIS_fnc_getUnitByUID;

	//cannot save a units loadout if not on the server
	if (isNull _playerUnit) then {continue;};

	_playerLoadout = getUnitLoadout _playerUnit;

	_playerProfile set ["currentInventory", _playerLoadout];

	_engineerLevel = _playerUnit getVariable ["ace_isEngineer", parseNumber (_playerUnit getUnitTrait "engineer")];
	_medicLevel = _playerUnit getVariable ["ace_medical_medicClass", parseNumber (_playerUnit getUnitTrait "medic")];
	_eodStatus = [_playerUnit] call ace_common_fnc_isEOD;

	_playerProfile set ["playerEngineerLevel", _engineerLevel];
	_playerProfile set ["playerMedicalLevel", _engineerLevel];
	_playerProfile set ["playerEODStatus", _eodStatus];

} forEach _allPlayerProfiles;

saveProfileNamespace;
