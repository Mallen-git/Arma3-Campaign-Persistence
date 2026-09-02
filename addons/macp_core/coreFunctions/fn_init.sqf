if (isServer) then {
	_allCampaignData = profileNamespace getVariable ["macp_allCampaignData", createHashMap];

	_currentCampaignKey = missionNamespace getVariable ["macp_campaignKey", "MACPDEFAULT"];
	_currentCampaignData = _allCampaignData getOrDefault [_currentCampaignKey, "NONEFOUND", false];

	if (_currentCampaignData isEqualTo "NONEFOUND") then
	{
		//new campaign! lets run setup to set default kit
		_currentCampaignData = createHashMapFromArray [
			["players", createHashMap],
			["defaultKit", [[],[],[],[],[],[],"","",[],["","","","","",""]]]
		];
	};

	macp_currentCampaignData = _currentCampaignData;

	macp_personalVaultLists = createHashMap;

	addMissionEventHandler ["Ended", {
		call macp_core_fnc_saveAllKitsAndVaults;
	}];

	addMissionEventHandler ["HandleDisconnect", {
		params ["_unit", "_id", "_uid", "_name"];
		[_uid, _unit] call macp_core_fnc_saveToCurrentInventory;
		[_uid, "DISCONNECT", _unit] call macp_core_fnc_saveToPreviousInventorys;
		false;
	}];

	//autosave every 30s
	[{call macp_core_fnc_saveAllKitsAndVaults;}, 30] call CBA_fnc_addPerFrameHandler;
};

//if not the server don't need to pickup loadouts
if (not hasInterface) exitWith {};

mcap_initialRespawn = false;

//request server to give me loadout i should have
[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ['call', 2];

//init personal vault
[[getPlayerUID player], macp_core_fnc_initPersonalVault] remoteExec ['call', 2];

//add ace interaction to open Personal Vault
_condition =
{
  ([_player, _target, []] call ace_common_fnc_canInteractWith) and (isNull objectParent player)
};
_statement =
{
  [[getPlayerUID player], macp_core_fnc_accessPersonalVault] remoteExec ['call', 2];
};
_action = ["openPersonalVault", "Open Personal Vault", "", _statement, _condition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

player addEventHandler ["Respawn", {
	params ["_unit", "_corpse"];
	if (mcap_initialRespawn) then
	{
		mcap_initialRespawn = false;
		[[getPlayerUID player], macp_core_fnc_provideCurrentLoadout] remoteExec ['call', 2];
	} else {
		[[getPlayerUID player], macp_core_fnc_provideDefaultLoadout] remoteExec ['call', 2];
	};
}];

player addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects", "_shot", "_real"];
	if (time > 2) then
	{
		[[getPlayerUID player, "DEATH"], macp_core_fnc_saveToPreviousInventorys] remoteExec ['call', 2];
	} else {
		mcap_initialRespawn = true;
	};
}];
