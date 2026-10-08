/*
	Author: Mallen

	Description:
		checks if player has a profile, if not, creates the players profile with the default kit set as their current loadout and name set

	Parameter(s):
		0: STRING - UID of player requesting

	Returns:
		None

	Examples:
		[player] call macp_core_fnc_createPlayerProfile;
*/
params [["_requestedUID", "NOTSUPPLIED", [""]]];

//always on server
if (not isServer) exitWith {diag_log (text "MACP - ERROR: macp_core_fnc_createPlayerProfile ran on client, not server")};

//need a UID to work with
if (_requestedUID isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Requested create player profile with no supplied UID")};

//get the unit for the UID
_requestedUIDUnit = _requestedUID call BIS_fnc_getUnitByUID;

//get the players hashmap, if player already has a profile leave
_allPlayerProfiles = macp_currentCampaignDataServer get "players";
if (_requestedUID in _allPlayerProfiles) exitWith {};

_defaultEngineerLevel = macp_currentCampaignDataServer get "defaultEngineerLevel";
_defaultMedicalLevel = macp_currentCampaignDataServer get "defaultMedicalLevel";
_defaultEODStatus = macp_currentCampaignDataServer get "defaultEODStatus";

if (not macp_setEngineerLevel) then
{
	_defaultEngineerLevel = _requestedUIDUnit getVariable ["ace_isEngineer", parseNumber (_requestedUIDUnit getUnitTrait "engineer")];
};
if (not macp_setMedicalLevel) then
{
	_defaultMedicalLevel = _requestedUIDUnit getVariable ["ace_medical_medicClass", parseNumber (_requestedUIDUnit getUnitTrait "medic")];
};
if (not macp_setEOD) then
{
	_defaultEODStatus = [_requestedUIDUnit] call ace_common_fnc_isEOD;
};

_defaultKit = macp_currentCampaignDataServer get "defaultKit";

//if we are not using default kits simply get the current unit loadout
if (not macp_defaultKit) then
{
	_defaultKit = getUnitLoadout _requestedUIDUnit;
};

//define what the player profile looks like
_defaultPlayerProfileArray = [
	["lastUsedName", "NONEFOUND"],
	["currentInventory", _defaultKit],
	["previousInventorys", createHashMap],
	["personalVault", [[],[],[],[]]],
	["playerEngineerLevel", _defaultEngineerLevel],
	["playerMedicalLevel", _defaultMedicalLevel],
	["playerEODStatus", _defaultEODStatus],
	["medicalStatus", "{""ace_medical_openwounds"": {}, ""ace_medical_bloodpressure"": [80, 120], ""ace_medical_ivbags"": null, ""ace_medical_inpain"": false, ""ace_medical_medications"": [], ""ace_medical_tourniquets"": [0, 0, 0, 0, 0, 0], ""ace_medical_heartrate"": 80, ""ace_medical_pain"": 0, ""ace_medical_bloodvolume"": 6, ""ace_medical_stitchedwounds"": {}, ""ace_medical_fractures"": [0, 0, 0, 0, 0, 0], ""ace_medical_triagelevel"": 0, ""ace_medical_bodypartdamage"": [0, 0, 0, 0, 0, 0], ""ace_medical_hemorrhage"": 0, ""ace_medical_occludedmedications"": null, ""ace_medical_triagecard"": [], ""ace_medical_bandagedwounds"": {}, ""ace_medical_peripheralresistance"": 100, ""ace_medical_painsuppress"": 0, ""ace_medical_statemachinestate"": ""Default""}"]
];
_playerProfile = createHashMapFromArray _defaultPlayerProfileArray;

//if no unit assigned to UID throw warning, otherwise get the players name
if (isNull _requestedUIDUnit) then
{
	diag_log (text "MACP - Warning: Requested new player profile without a player object, name will not be correct")
} else {
	_playerProfile set ["lastUsedName", name _requestedUIDUnit];
};

//save the new player profile
_allPlayerProfiles set [_requestedUID, _playerProfile];
