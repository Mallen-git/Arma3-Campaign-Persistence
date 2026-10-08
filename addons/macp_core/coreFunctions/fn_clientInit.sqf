/*
	Author: Mallen

	Description:
		Starts up client services etc as needed

	Parameter(s):
		0: HASHMAP - All current campaign data

	Returns:
		None

	Examples:
		[macp_currentCampaignDataServer] call macp_core_fnc_clientInit;
*/
params [["_recievedData", "NOTSUPPLIED", [createHashMap]]];

//if not a dedi server dont need to pickup loadouts
if (not hasInterface) exitWith {};

//if no campaign data is sent from server something is wrong, lets wait it out
if (_recievedData isEqualTo "NOTSUPPLIED") exitWith {diag_log (text "MACP - ERROR: Client init started with no campaign data sent")};

//save data to global variable on local
macp_currentCampaignDataClient = _recievedData;

//used to check if player is respawning on start (dont give default kit)
mcap_initialRespawn = false;

//create player profile if it doesnt exist
[[getPlayerUID player], macp_core_fnc_createPlayerProfile] remoteExec ["call", 2];

//request server to give me loadout i should have
[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ["call", 2];

//request server to give me engineer and medic levels i should have
[[getPlayerUID player], macp_core_fnc_provideCurrentEngineerLevel] remoteExec ["call", 2];
[[getPlayerUID player], macp_core_fnc_provideCurrentMedicalLevel] remoteExec ["call", 2];
[[getPlayerUID player], macp_core_fnc_provideCurrentEODStatus] remoteExec ["call", 2];

//init personal vault
[[getPlayerUID player], macp_core_fnc_initPersonalVault] remoteExec ["call", 2];

//if admin, show admin menu
if (((call BIS_fnc_admin) > 0) or isServer) then
{
	[] call macp_core_fnc_showAdminMenu;
};

//add ace interaction to open Personal Vault
_condition =
{
	_result = false;
	if (isNil "macp_restrictPersonalVaultAreas") then
	{
		_result = true;
	} else {
		{
			_area = _x getVariable ["objectArea",[0,0,0,false,0]];
			//x,y,rot,whether its a rectangle,z

			_areaPos = getPosASL _x;
			_areaPos = ASLToAGL _areaPos;

			_playerPos = getPosASL _player;
			_playerPos = ASLToAGL _playerPos;
			_arguments = [_areaPos];
			_arguments append _area;
			if (_playerPos inArea _arguments) then
			{
				_result = true;
			}
		} forEach macp_restrictPersonalVaultAreas;
	};
	([_player, _target, []] call ace_common_fnc_canInteractWith) and (isNull objectParent _player) and (_result)
};
_statement =
{
	[[getPlayerUID player], macp_core_fnc_accessPersonalVault] remoteExec ["call", 2];
};
_action = ["openPersonalVault", "Open Personal Vault", "\a3\ui_f\data\igui\cfg\simpletasks\types\Container_ca.paa", _statement, _condition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

//set kit to default on respawn
player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	if (mcap_initialRespawn) then
	{
		mcap_initialRespawn = false;
		[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ["call", 2];
		[[getPlayerUID player], macp_core_fnc_provideCurrentEngineerLevel] remoteExec ["call", 2];
		[[getPlayerUID player], macp_core_fnc_provideCurrentMedicalLevel] remoteExec ["call", 2];
		[[getPlayerUID player], macp_core_fnc_provideCurrentEODStatus] remoteExec ["call", 2];
	} else {
		if (macp_defaultKit) then
		{
			[[getPlayerUID player], macp_core_fnc_provideDefaultLoadout] remoteExec ["call", 2];
		};
		if (macp_setDefaultEngineerLevel) then
		{
			[[getPlayerUID player], macp_core_fnc_provideDefaultEngineerLevel] remoteExec ["call", 2];
		} else {
			[[getPlayerUID player], macp_core_fnc_provideCurrentEngineerLevel] remoteExec ["call", 2];
		};
		if (macp_setDefaultMedicalLevel) then
		{
			[[getPlayerUID player], macp_core_fnc_provideDefaultMedicalLevel] remoteExec ["call", 2];
		} else {
			[[getPlayerUID player], macp_core_fnc_provideCurrentMedicalLevel] remoteExec ["call", 2];
		};
		if (macp_setDefaultEOD) then
		{
			[[getPlayerUID player], macp_core_fnc_provideDefaultEODStatus] remoteExec ["call", 2];
		} else {
			[[getPlayerUID player], macp_core_fnc_provideCurrentEODStatus] remoteExec ["call", 2];
		};
	};
}];

//save kit to previous inventorys when killed
player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects", "_shot", "_real"];
	if (time > 2) then
	{
		[{
			params ["_unit"];
			[[getPlayerUID player, "DEATH", _unit], macp_core_fnc_saveToPreviousInventorys] remoteExec ["call", 2];
		}, [_unit], 0.1] call CBA_fnc_waitAndExecute;
	} else {
		mcap_initialRespawn = true;
	};
}];

//setup client to ask for data on autosave +/- 2 seconds to space out saves between players
[{
	if (not ([] call macp_core_fnc_canSaveCampaignData)) exitWith {};
	[[true], macp_core_fnc_askForUpdatedData] remoteExec ['call', 2];
}, (macp_autoSaveTime - 2 + (random 4))] call CBA_fnc_addPerFrameHandler;

//client should ask to save data at end of mission
addMissionEventHandler ["Ended", {
	if (not ([] call macp_core_fnc_canSaveCampaignData)) exitWith {};
	[[true], macp_core_fnc_askForUpdatedData] remoteExec ['call', 2];
}];
